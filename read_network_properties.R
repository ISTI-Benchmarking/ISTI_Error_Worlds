read_network_properties <- function (worlds, settings) {
  # This function reads the clean data to get the stations IDs.
  # It reads the corresponding data from the ISTI dataset to get the missing data maps.
  # Later it will also read the urbanization files used for the gradual inhomogeneities and match them to the IDs.
  # Later it will also climate classifications used for the seasonal cycel and match them to the IDs.
  
  ## Initialise
  network = list()
  
# The next part is probably not necessary. The clean data is read line by line in the function generate_errors_stations(), which then gives the mask and we have the ID from the urban file.
#   ## Read clean data
#   # Create file name for an Rdata file. If it exists, it is read. If it does not exist, it is generated after reading large ASCII file with the masked clean world data.
#   IDsMaskDirFileName <- paste(settings$cleanDataDir, "stationID_mask.dat", sep="/")
#   if(!file.exists(IDsMaskDirFileName)) {
#     # Read ASCII clean world data, first column station ID, rest monthly temps, every row a station.
#     cleanDataDirFileName = paste(settings$cleanDataDir, settings$cleanDataFileName, sep="/")
#     ######## Only scan first column? read.col, read.table
#     ######## rm(), gc()
#     cleanData <- scan(file=cleanDataDirFileName, what="character", nlines=-1)
#     
#     # Reformat the cleanData vector to a matrix.
#     noMonths =(settings$endYearClean - settings$beginYearClean + 1) * 12 # Number of columns with data (file contains one more column with station ID)    
#     noCols = noMonths + 1;
#     noStations = length(cleanData)/noCols
#     dim(cleanData) <- c(noMonths+1, noStations)
#   
#     # Separate the first column with IDs and convert cleanData to missing data matrix, which is all the information we need for now.
#     stationIDs = cleanData[1,]
#    ###### Maks not needed
# #     mask = cleanData[2:noCols,] != "-99.99"
#     remove(cleanData) #
#     gc()
# 
#     save("stationIDs", "mask", file=IDsMaskDirFileName)
#   } else {
#     load(file=IDsMaskDirFileName)
#   }
#   network$stationIDs = stationIDs
#   network$mask = mask

    
  ## Read urbanization
  urbanDirFileName = paste(settings$externalDir, settings$landUseDataFileName, sep = "/")
  # urban = read.fwf(file = urbanDirFileName, width = c(11,           10,        10,        31,            27,         6,             12,          9,9,9, rep(8, 9)), 
  #                                       col.names = c("stationIDs", "lat",     "lon",     "stationName", "country", "landuseclass", "urbanBool", rep("dummy",   12)), 
  #                                       colClasses= c("character",  "numeric", "numeric", "character",   "factor",  "numeric",      "numeric",   rep("numeric", 12)), 
  #                                       comment.char = "", skip=8, strip.white = TRUE,  na.strings = "--")
  urban = read.table(file = urbanDirFileName,  
                   col.names = c("stationIDs", "lat",     "lon",     "stationName", "country", "landuseclass", "urbanBool", rep("dummy",   12)), 
                   colClasses= c("character",  "numeric", "numeric", "character",   "factor",  "numeric",      "numeric",   rep("NULL", 12)), 
                   comment.char = "", skip=10, strip.white = TRUE,  na.strings = "--") # , nrows=10)
  #                    comment.char = "", skip=10+16284-11, strip.white = TRUE,  na.strings = "--", nrows=10)    
  # urban = read.table(file = urbanDirFileName,  
  #                    col.names = c("stationIDs", "lat",     "lon",     "stationName", "country", "landuseclass", "urbanBool", rep("dummy",   12)), 
  #                    colClasses= c("character",  "numeric", "numeric", "character",   "factor",  "numeric",      "numeric",   rep("NULL", 12)), 
  #                    comment.char = "", skip=10+16284-11, strip.white = TRUE,  na.strings = "--", nrows=10)  
  network$stationIDs = urban$stationIDs
  
#   if(length(which(data$stationIDs != network$stationIDs)) > 0) {
#     stop("Function read_network_properties expects the rows/station IDs to match between clean worlds and urbanization/landuse metadata file.")
#   } 
  
  # Determine network membership using the first two characters of the stationID, for large countries the third character for subnetworks is used as well.
  netIDs = substr(network$stationIDs[], start=1, stop=2)
  uniqueIDs = unique(netIDs)
  noUnique = length(uniqueIDs)
  indices = vector("list", noUnique)
  for(iID in 1:noUnique) {
    indices[[iID]] = which(netIDs == uniqueIDs[iID])
  }  
  # TODO split up large networks by using the 3 charchacter for the subnets

  network$stationIDs = urban$stationIDs
  network$lat = urban$lat
  network$lon = urban$lon
  # network$countryName = urban$country
  network$urban = urban$urbanBool
  network$netIDs = netIDs
  network$netIndices = indices
  network$noNetworks = noUnique
  
  ## Read climate classification files

  return(network)
}


## Wastebin

#   data = read.table(file = dataDirFileName, skip=10) # , 
#                      col.names = c("stationIDs", "lat",     "lon",     "stationName", "country", "landuseclass", "urbanBool", rep("dummy",   12)),
#                      colClasses= c("character",  "numeric", "numeric", "character",   "factor",  "integer",       "integer",  rep("integer", 12)) )

#   data = read.table(file = dataDirFileName, skip=10, comment.char = "") # , 
#                        col.names = c("stationIDs", "lat",     "lon",     "stationName", "country", "landuseclass", "urbanBool", rep("dummy",   12)),
#                        colClasses= c("character",  "numeric", "numeric", "character",   "factor",  "integer",       "integer",  rep("integer", 12)) )



