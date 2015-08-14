read_structure_world_directories <- function(dataExtDir = "../data/external_data", 
                                             errorWorldDir = "../data/error_worlds") {
  # This function will read the basic structure of the worlds, its directories and the number of directories.
  # 
  # There are two main data directories.
  # 1. errorWorldDir: Will contain subdirectories with the newly generated errors worlds: inhomogeneous station data.
  #                  They have to be created in advance and will contain the settings files that are specific for this world or for specific networks.
  # 2. dataExtDir:   Contains data files that are needed to generate the error wolds. 
  #                  For example, information on the degree of urbanization of the stations or their climate classification.
  # The names of these directories are hard coded because the setting files are not read yet.
  
  # Section 1.1. errorWorldDir
  errorWorldFullDirs <- dir(path = errorWorldDir, full.names= TRUE) # Also lists files, which are removed in next line
  errorWorldFullDirs = errorWorldFullDirs[file.info(errorWorldFullDirs)$isdir]
  noWorlds <- length(errorWorldFullDirs)
  subDirs = basename(errorWorldFullDirs)
  
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

#   # Section 1.3. dataOutDir
#   dataOutWorldDir <- vector(mode = "character", length=noWorlds)
#   for(iDir in 1:noWorlds) {
#     dataOutWorldDir[iDir] <- paste(dataOutDir, subDirs[iDir], sep="/")
#     if(file.exists(dataOutWorldDir[iDir]) == FALSE) {
#       dir.create(dataOutWorldDir)
#     }
#   }

  # Put information in structure called worlds
#   for(iWorld in 1:noWorlds) {
#     world[iWorld] = list()
#     world[iWorld]$noWorlds  = noWorlds
#     world[iWorld]$cleanDirs = errorWorldFullDirs 
#     world[iWorld]$subDirs = subDirs
#     world[iWorld]$urbanDirFileName   = urbanDirFileName
#     world[iWorld]$climateDirFileName = climateDirFileName
#     world[iWorld]$errorDirs = dataOutWorldDir

  worlds <- list()
  worlds$noWorlds  <- noWorlds
  worlds$errorWorldDirs <- errorWorldFullDirs
  worlds$subDirs <- subDirs
  worlds$urbanDirFileName   <- urbanDirFileName
  worlds$climateDirFileName <- climateDirFileName
  
  return(worlds)
#   worlds <- list(noWorlds, errorWorldFullDirs, urbanDirFileName, climateDirFileName)
#   names(settings) = c("noWorlds", "cleanDirs", "urbanDirFileName", "climateDirFileName")
#   a=0
}
