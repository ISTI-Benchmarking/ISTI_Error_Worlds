error_worlds_main <- function() {
  # This is the main function that introduces the inhomogeneities to the ISTI clean worlds
  #
  # Version 0.01: Victor Venema
  # 
  
  ## Section 0. Settings and initialisations
  source("create_or_read_worlds.R")
  source("set_current_dirs.R")
  source("read_settings.R")
  
  ## Section 1. Set up all Worlds
  worlds <- create_or_read_worlds()
  
  for(iWorld in 1:worlds$noWorlds) {
    currentDirs <- set_current_dirs(worlds, iWorld)
    cat("working on world number: ", iWorld, "; named: ", currentDirs$subDir, ".\n", sep="")
    
  ## Section 2. Network. Read the network properties (no. Stations, position, country, network they belong to)
  #  network <- read_network_properties(worlds[iWorld])
  
  ## Section 3. Settings for one World 
  settings <- read_settings(currentDirs)
  
  ## Section 4. Properties. Compute properties of errors that affect multiple stations
  #  stations <- compute_multiple_station_properties(settings, network)
  
  ## Section 5. Inhomogeneities. Read stations, insert inhomogeneities in single stations and save them
  #  generate_errors_stations(setting, network, stations)
  }
}

