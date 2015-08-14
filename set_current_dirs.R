set_current_dirs <- function(worlds, iWorld) {
    
  currentDirs = list()
  currentDirs$errorWorldDir = worlds$errorWorldDirs[iWorld]
  currentDirs$subDir        = worlds$subDirs[iWorld]
  
  return(currentDirs)
}

