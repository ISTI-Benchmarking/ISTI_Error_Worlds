set_current_dirs <- function(worlds, iWorld) {
    
  currentDirs = list()
  currentDirs$cleanDir = worlds$cleanDirs[iWorld]
  currentDirs$subDir   = worlds$subDirs[iWorld]
  currentDirs$errorDir = worlds$errorDirs[iWorld]
  
  return(currentDirs)
}

