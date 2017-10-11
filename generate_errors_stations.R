generate_errors_stations <- function (settings, network, stations, currentDirs) {
  # This function implements the inhomogeneities for single stations while looping over all stations.
  # It does not produce output, but reads the clean data and directly writes the inhomogeneous data 
  # and the perturbations to a file.

  ## Section 0. Settings and initialisations
  source("compute_break_positions_type.R")
  source("generate_walk.R")
  source("generate_noise.R")
  
  # Initialisation
  noStations <- length(network$stationIDs)
  cleanDataDirFileName   <- paste(settings$cleanDataDir,     settings$cleanDataFileName,         sep="/")
  perturbDataDirFileName <- paste(currentDirs$errorWorldDir, settings$perturbationDataFileName,  sep="/") 
  inhomDataDirFileName   <- paste(currentDirs$errorWorldDir, settings$inhomogeneousDataFileName, sep="/")
  metaDataDirFileName    <- paste(currentDirs$errorWorldDir, settings$metaDataFileName,          sep="/")
  
  # Open files 'connections' currentDirs$errorWorldDir
  conClean   <- file(cleanDataDirFileName,   "rt") # Clean data for reading
  # Writing not needed yet.
  # conPerturb <- file(perturbDataDirFileName, "wt") # Write a file with the computed perturbations
  # conInhom   <- file(inhomDataDirFileName,   "wt") # The inhomogeneous data (clean + perturbations)
  # conMeta    <- file(metaDataDirFileName,    "wt") # File recording properties of inserted inhomogeneities
  
  
  ## Section 1. Loop over all stations, compute and insert inhomogeneities
  # for(iStat in 1:noStations) {
  warning("Number of stations is reduced to speed up development, change at the end.")
  for(iStat in 1:1e2) {
    ## Compute properties of break inhomogeneities

    # Read ASCII clean world data, first column station ID, rest monthly temps, every row a station.    
    cleanData <- scan(file=conClean, what="character", nlines=1, na.strings="-99.99", quiet=TRUE)  
    if(length(cleanData) > 0) {
      stationID   <- cleanData[1]
      noValSeries <- length(cleanData)
      cleanData   <- cleanData[2:noValSeries]
      cleanData   <- as.numeric(cleanData)
      noValSeries <- noValSeries - 1 # Number of monthly values in one station
      
  #     if(length(which(data$stationIDs != network$stationIDs)) > 0) {
  #       stop("Function read_network_properties expects the rows/station IDs to match between clean worlds and urbanization/landuse metadata file.")
  #     } 
  
      brk <- compute_break_positions_type(stations, iStat, settings, noValSeries, cleanData)
      noBreaks   <- length(brk$index)
      
      ## Compute properties of gradual inhomogeneities
      # gradual inhomogeneities have no seasonal cycle
      # inhomGradual <- 
        
      ## Implement inhomogeneities
      if(noBreaks > 0) {
        # Breaks as random walk
        biasPerBiasedBreak <- settings$trendBiasInhom / settings$globalBiasedBreakFrequency
        brk$walk[] <- FALSE
        indexWalk <- which(runif(noBreaks) * 100 < settings$percentageRandomWalkBreaks)
        brk$walk[indexWalk] <- TRUE
        # print(brk$biased[indexWalk])
        inhomWalk  <- generate_walk(brk$index[indexWalk],  brk$biased[indexWalk], noValSeries, stations$jumpSize[iStat], biasPerBiasedBreak)
  
        # Breaks as noisy deviations
        indexNoise <- which(brk$walk == FALSE)
        inhomNoise <- generate_noise(brk$index[indexNoise], brk$biased[indexNoise], noValSeries, stations$jumpSize[iStat], settings$trendBiasInhom)
        inhom <- inhomWalk + inhomNoise # + inhomGradual
        a <- 0


      # Stochastic component
      
      # Seasonal cycle
        
      } else {
        inhom = cleanData * 0
      } # If no breaks    
    } else { # If data in line
      warning("Emptpy line found in clean data file.")
    }
    
  } # Loop over all lines/stations
  
  ## Section 2. Close files
  
  close(conClean)
  # close(conPerturb)
  # close(conInhom)
  # close(conMeta)
}


## Wastebin

# a = vector("numeric", length = 1e5)
# for(i in 1:1e5) {
#   iBrk <- 0
#   for(iGap in 1:gaps$noGaps) {
#     if( runif(1) * temp < gaps$length[iGap]) {
#       iBrk <- iBrk + 1
#       brk$index[iBrk] <- gaps$indices[iGap]
#     }
#   }
#   a[i] = iBrk
# }
# mean(a)


# a = vector("numeric", length = 1e5)
# for(i in 1:1e5) {
#   a[i] = length(which(runif(noValSeries) * temp < 1))*100/159
# }
# mean(a)   


#     globalRandomBreakFrequency 
#     globalBreakFrequency

# Remove breaks in the last 24 months. 
# subset(brk, brk$index >= period$beginIndex  & brk$index <= period$endIndex)

# Remove breaks at same location, or in the same gap. 
# Random breaks are also placed in gaps because otherwise long gaps would have a lower break frequency.

# stations$breakFrequency # which is a vector("numeric", length=noStations)
