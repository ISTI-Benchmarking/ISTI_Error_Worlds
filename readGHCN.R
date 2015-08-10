readGHCN <- function() {
  
  baseDirname     = "C:/data/GHCNv3"
  baseDataFilestr = "C:/data/GHCNv3/baseDataGHCN.RData"
  filenameDataRaw = "ghcnm.tavg.v3.2.2.20141219.qcu.dat"
  filenameMetaRaw = "ghcnm.tavg.v3.2.2.20141219.qcu.inv"
  filenameDataHom = "ghcnm.tavg.v3.2.2.20141219.qca.dat"
  filenameMetaHom = "ghcnm.tavg.v3.2.2.20141219.qca.inv"
  filenameRef     = "ghcnmv2.corr.20141219.tavg"
  outputMonthly   = FALSE
  outputAnnual    = TRUE
  
  
  
  print("Start")

  # Read files indicating which reference stations were used to homogenize a certain candidate
  dirFilename = paste(baseDirname, filenameRef, sep="/")
  references  = readRef(dirFilename)
  
  # Read meta data files (inventory)
  dirFilename = paste(baseDirname, filenameMetaRaw, sep="/")
  metaRaw = readMeta(dirFilename)
  dirFilename = paste(baseDirname, filenameMetaHom, sep="/")
  metaHom = readMeta(dirFilename)
  a=0 

  # Read data files
  dirFilename = paste(baseDirname, filenameDataRaw, sep="/")
  dataRaw = readData(dirFilename)
  dirFilename = paste(baseDirname, filenameDataHom, sep="/")
  dataHom = readData(dirFilename)
  a=0  
  
  # Combine datasets for which there is a station in dataHom
  uniqueStat = unique(dataHom$stationNo) # Should not be necessary, but just to be sure.
  noStations = length(uniqueStat)
  minYear = min(dataHom$year)
  maxYear = max(dataHom$year)
  year = minYear:maxYear
  noYears = length(year)

  if(file.exists(baseDataFilestr)==TRUE) {
    load(baseDataFilestr)
    iBegin = iStat+1
#     noStations = length(stationNo)
#     noYears = length(year)
  } else {
    iBegin = 1  
    
    stationNo  = uniqueStat
    annualRaw  = matrix(NA,  noStations, noYears)
    annualHom  = matrix(NA,  noStations, noYears)
    refStations = matrix("", noStations, 39)
    lat = array(NA, noStations)
    lon = array(NA, noStations)
  #   monthlyRaw = array(NA, c(noStations, noYears, 12))
  #   DMFLagRaw  = array("", c(noStations, noYears, 12))
  #   QCFlagRaw  = array("", c(noStations, noYears, 12))
  #   DSFlagRaw  = array("", c(noStations, noYears, 12))
  #   monthlyHom = array(NA, c(noStations, noYears, 12))  
  #   DMFLagHom  = array("", c(noStations, noYears, 12))
  #   QCFlagHom  = array("", c(noStations, noYears, 12))
  #   DSFlagHom  = array("", c(noStations, noYears, 12))  
  
    # Only use temp values that are not flagged
    index = which(dataHom$QCFlag!=" ") 
    dataHom$temp[index] = NA
    index = which(dataRaw$QCFlag!=" ")
    dataRaw$temp[index] = NA  
  } # If baseDateFile is present
  
#   iBegin = 1
#   noStations=10  
  
# 
  for(iStat in iBegin:noStations) {    
    print(paste(iStat, noStations), quote=FALSE)    
    indexStat = which(dataRaw$stationNo==stationNo[iStat])
    yearRawStat = dataRaw$year[indexStat]
    tempRawStat = dataRaw$temp[indexStat,]    
    indexStat = which(dataHom$stationNo==stationNo[iStat])
    yearHomStat = dataHom$year[indexStat]
    tempHomStat = dataHom$temp[indexStat,]
    
    monthlyRawStat = matrix(NA, noYears, 12) # A matrix for the data for one station
    monthlyHomStat = matrix(NA, noYears, 12)
    for(iYear in 1:noYears) {    
#       index = which(dataRaw$stationNo==stationNo[iStat] & dataRaw$year==year[iYear])
#       index = which(dataRaw$year==year[iYear])
      index = which(yearRawStat==year[iYear])
      if(length(index) > 0) {
        #  monthlyRaw[iStat, iYear,] = dataRaw$temp[index, ]
#         monthlyTemp = dataRaw$temp[index, ]        
        monthlyTemp = tempRawStat[index, ]        
        monthlyRawStat[iYear, ] = monthlyTemp
#         annualRaw [iStat, iYear]  = mean(monthlyTemp)
        # DMFLagRaw [iStat, iYear,] = dataRaw$DMFlag[index, ]
        # QCFlagRaw [iStat, iYear,] = dataRaw$QCFlag[index, ]
        # DSFlagRaw [iStat, iYear,] = dataRaw$DSFlag[index, ]
      } # If this year and station contains data      

#       index = which(dataHom$stationNo==stationNo[iStat] & dataHom$year==year[iYear])
      index = which(yearHomStat==year[iYear])
      if(length(index) > 0) {        
        # monthlyHom[iStat, iYear,] = dataHom$temp[index, ]        
#         annualHom [iStat, iYear]  = mean(dataHom$temp[index, ])
        monthlyTemp = tempHomStat[index, ] 
        monthlyHomStat[iYear, ] = monthlyTemp
#         annualHom [iStat, iYear]  = mean(monthlyTemp)
        # DMFLagHom [iStat, iYear,] = dataHom$DMFlag[index, ]
        # QCFlagHom [iStat, iYear,] = dataHom$QCFlag[index, ]
        # DSFlagHom [iStat, iYear,] = dataHom$DSFlag[index, ]
      } # If this year and station contains data      
    } # For iYear
    annualRaw[iStat,] = compute_anomalies(monthlyRawStat)
    annualHom[iStat,] = compute_anomalies(monthlyHomStat)

    index = which(references[,1]==stationNo[iStat])
    refStations[iStat,] = references[index, 2:40]
    index = which(metaHom$ID==stationNo[iStat])
    lat[iStat] = metaHom$lat[index]
    lon[iStat] = metaHom$lon[index]
    if(iStat %% 10 == 0 | iStat == noStations) {
      save(annualRaw, annualHom, refStations, lat, lon, year, stationNo, iStat, file = baseDataFilestr)  
    }
  } # For iStat, loop over all stations
  
  annualDiff = annualRaw - annualHom
  
  print("Ready") 
  
} # End of function




# # Wastebin

#   baseDirname     = "c:/data/GHCNv3", 
#   filenameDataRaw = "ghcnm.tavg.v3.2.2.20141219.qcu.dat", 
#   filenameMetaRaw = "ghcnm.tavg.v3.2.2.20141219.qcu.inv", 
#   filenameDataHom = "ghcnm.tavg.v3.2.2.20141219.qca.dat", 
#   filenameMetaHom = "ghcnm.tavg.v3.2.2.20141219.qca.inv",
#   filenameRef     = "ghcnmv2.corr.20141219.tavg",
#   outputMonthly   = FALSE,
#   outputAnnual    = TRUE


#   data
#   return(data)


