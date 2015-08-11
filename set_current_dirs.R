set_current_dirs <- function(worlds, iWorld) {
    
  currentDirs = list()
  currentDirs$benchmarkDir = worlds$benchmarkDirs[iWorld]
  currentDirs$subDir       = worlds$subDirs[iWorld]
  
  return(currentDirs)
}

