read_network_properties <- function (worlds, settings) {
  # This function reads the clean data to get the stations IDs.
  # It reads the corresponding data from the ISTI dataset to get the missing data maps.
  # Later it will also read the urbanization files used for the gradual inhomogeneities and match them to the IDs.
  # Later it will also climate classifications used for the seasonal cycel and match them to the IDs.
  
  ## Initialise
  network = list()
  
  ## Read clean data
  # Create file name for an Rdata file. If it exists, it is read. If it does not exist, it is generated after reading large ASCII file with the masked clean world data.
  IDsMaskDirFileName <- paste(settings$cleanDataDir, "stationID_mask.dat", sep="/")
  if(!file.exists(IDsMaskDirFileName)) {
    # Read ASCII clean world data, first column station ID, rest monthly temps, every row a station.
    cleanDataDirFileName = paste(settings$cleanDataDir, settings$cleanDataFileName, sep="/")
    cleanData <- scan(file=cleanDataDirFileName, what="character", nlines=-1)
    
    # Reformat the cleanData vector to a matrix.
    noMonths =(settings$endYearClean - settings$beginYearClean + 1) * 12 # Number of columns with data (file contains one more column with station ID)    
    noCols = noMonths + 1;
    noStations = length(cleanData)/noCols
    dim(cleanData) <- c(noMonths+1, noStations)
  
    # Separate the first column with IDs and convert cleanData to missing data matrix, which is all the information we need for now.
    stationIDs = cleanData[1,]
    mask = cleanData[2:noCols,] != "-99.99"
    remove(cleanData)

    save("stationIDs", "mask", file=IDsMaskDirFileName)
  } else {
    load(file=IDsMaskDirFileName)
  }
  network$stationIDs = stationIDs
  network$mask = mask

    
  ## Read urbanization and climate classification files
  dataDirFileName = paste(settings$externalDir, settings$landUseDataFileName, sep="/")
  data = read.fwf(file= dataDirFileName, width = c(12,           12,        10,        32,            28,         6,             12,          9,9,9, rep(8, 9)), 
                                     col.names = c("stationIDs", "lat",     "lon",     "stationName", "country", "landuseclass", "urbanBool", rep("dummy",   12)), 
                  comment.char = "", skip=10)

  # TODO. Match these IDs with previous ones and put variables in network structure. 
  
  return(network)
}

## Wastebin

#   data = read.table(file = dataDirFileName, skip=10) # , 
#                      col.names = c("stationIDs", "lat",     "lon",     "stationName", "country", "landuseclass", "urbanBool", rep("dummy",   12)),
#                      colClasses= c("character",  "numeric", "numeric", "character",   "factor",  "integer",       "integer",  rep("integer", 12)) )

