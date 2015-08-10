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
#   cleanFullDirs3 <- list.dirs(path = dataInDir, full.names= TRUE) # Also lists main directory, not just sub-directoreis
  cleanFullDirs <- dir(path = dataInDir, full.names= TRUE) # Also lists files, which are removed in next line
  cleanFullDirs = cleanFullDirs[file.info(cleanFullDirs)$isdir]
  noWorlds <- length(cleanFullDirs)
  subDirs = basename(cleanFullDirs)

#   pathBlind = c(dataInDir, "blind_")
#   cleanBlindDirs = list.dirs(path = pathBlind)
  
  # Section 1.2. dataExtDir
  urbanDirFileName <- paste(dataExtDir, "urban.txt", sep="/")
  if(file.exists(urbanDirFileName) == FALSE) {
    urbanDirFileName <- "dummy"  
    warning("No urban file found. In Section 1.2 or function create_or_read_worlds(). Will use dummy instead.")
  }
  climateDirFileName <- paste(dataExtDir, "climate.txt", sep="/")
  if(file.exists(climateDirFileName) == FALSE) {
    climateDirFileName <- "dummy"  
    warning("No climate file found. In Section 1.2 or function create_or_read_worlds(). Will use dummy instead.")
  }

  # Section 1.3. dataOutDir
  dataOutWorldDir <- vector(mode = "character", length=noWorlds)
  for(iDir in 1:noWorlds) {
    dataOutWorldDir[iDir] <- paste(dataOutDir, subDirs[iDir], sep="/")
    if(file.exists(dataOutWorldDir[iDir]) == FALSE) {
      dir.create(dataOutWorldDir)
    }
  }

  # Put information in structure called worlds
#   for(iWorld in 1:noWorlds) {
#     world[iWorld] = list()
#     world[iWorld]$noWorlds  = noWorlds
#     world[iWorld]$cleanDirs = cleanFullDirs 
#     world[iWorld]$subDirs = subDirs
#     world[iWorld]$urbanDirFileName   = urbanDirFileName
#     world[iWorld]$climateDirFileName = climateDirFileName
#     world[iWorld]$errorDirs = dataOutWorldDir

  worlds <- list()
  worlds$noWorlds  <- noWorlds
  worlds$cleanDirs <- cleanFullDirs
  worlds$subDirs <- subDirs
  worlds$urbanDirFileName   <- urbanDirFileName
  worlds$climateDirFileName <- climateDirFileName
  worlds$errorDirs <- dataOutWorldDir
  
  return(worlds)
#   worlds <- list(noWorlds, cleanFullDirs, urbanDirFileName, climateDirFileName)
#   names(settings) = c("noWorlds", "cleanDirs", "urbanDirFileName", "climateDirFileName")
#   a=0
}

