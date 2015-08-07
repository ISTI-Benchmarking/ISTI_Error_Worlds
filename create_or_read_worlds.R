create_or_read_worlds <- function(dataInDir  = "../data/temperature_stations", 
                                  dataExtDir = "../data/external_data", 
                                  dataOutDir = "../data/benchmark") {
  # This function will read the basic structure of the worlds, its directories and the number of directories.
  # 
  # There are thre main data directories.
  # 1. dataInDir:  Contains subdirectories with the clean worlds: the homogeneous temperature station data.
  #                Will contain files with information on the inhomogeneities inserted.
  # 2. dataExtDir: Contains data files that are needed to generate the error wolds. 
  #                For example, information on the degree of urbanization of the stations or their climate classification.
  # 3. dataOutDir: Will contain subdirectories with the newly generated errors worlds: inhomogeneous station data.
  #                If these directories do not exist yet, they will be created, mirroring the structure of dataInDir.
  
  # Section 1.1. dataInDir
  cleanFullDirs = dir(path = dataInDir, full.names= TRUE)
  noWorlds = length(cleanFullDirs)
  cleanSubDirs = dir(path = dataInDir, full.names= FALSE)
  noWorlds2 = length(cleanSubDirs)
  if(noWorlds != noWorlds2) {
    stop("Error in Function create_or_read_worlds(), Section 1.1. Number of subdirs not the same.")
  }
#   pathBlind = c(dataInDir, "blind_")
#   cleanBlindDirs = list.dirs(path = pathBlind)
  
  # Section 1.2. dataExtDir
  urbanDirFileName = paste(dataExtDir, "urban.txt", sep="/")
  if(file.exists(urbanDirFileName) == FALSE) {
    urbanDirFileName = "dummy"  
    warning("No urban file found. In Section 1.2 or function create_or_read_worlds(). Will use dummy instead.")
  }
  climateDirFileName = paste(dataExtDir, "climate.txt", sep="/")
  if(file.exists(climateDirFileName) == FALSE) {
    climateDirFileName = "dummy"  
    warning("No climate file found. In Section 1.2 or function create_or_read_worlds(). Will use dummy instead.")
  }

  # Section 1.3. dataOutDir
  for(iDir in 1:noWorlds) {
    dataOutWorldDir = paste(dataOutDir, cleanSubDirs[iDir], sep="/")
    if(file.exists(dataOutWorldDir) == FALSE) {
      dir.create(dataOutWorldDir)
    }
  }


  # Put information in structure called worlds
  worlds = list()
  worlds$noWorlds  = noWorlds
  worlds$cleanDirs = cleanFullDirs
  worlds$cleanSubDirs = cleanSubDirs
  worlds$urbanDirFileName   = urbanDirFileName
  worlds$climateDirFileName = climateDirFileName
  
  return(worlds)
#   worlds <- list(noWorlds, cleanFullDirs, urbanDirFileName, climateDirFileName)
#   names(settings) = c("noWorlds", "cleanDirs", "urbanDirFileName", "climateDirFileName")
#   a=0
}

