generate_errors_stations <- function (setting, network, stations, currentDirs) {
  # This function implements the inhomogeneities for single stations while looping over all stations.
  # It does not produce output, but reads the clean data and directly writes the inhomogeneous data and the perturbations to a file.
  
  # Initialisation
  noStations <- length(network$stationIDs)
  cleanDataDirFileName   <- paste(settings$cleanDataDir, settings$cleanDataFileName, sep="/")
  perturbDataDirFileName <- paste(currentDirs$errorWorldDir, settings$perturbationDataFileName, sep="/") 
  inhomDataDirFileName   <- paste(currentDirs$errorWorldDir, settings$inhomogeneitiesDataFileName, sep="/")
  metaDataDirFileName    <- paste(currentDirs$errorWorldDir, settings$metaDataFileName, sep="/")
  
  # Open files 'connections' currentDirs$errorWorldDir
  conClean   <- file(cleanDataDirFileName,   "rt") # Clean data for reading
  conPerturb <- file(perturbDataDirFileName, "wt") # The computed perturbations for writing
  conInhom   <- file(inhomDataDirFileName,   "wt") # The inhomogeneous data (clean + perturbations)
  conMeta    <- file(metaDataDirFileName,    "wt") # File recording properties of inserted inhomogeneities
  
  for(iStat in 1:noStations) {
    ## Compute properties of break inhomogeneities
    ## Compute positions of break inhomogeneities for gap breaks, clustered breaks and randomly positioned breaks
    # Initialise
    iBrk <- 0 # A break is abbreviated as brk because break is a reserved word in Rstat
    brk = list()
    maxLength = (settings$endYearClean - settings$beginYearClean + 1) * 12
    brk$index = vector("integer", length=maxLength) 
    
    # Positions of breaks in gaps
    # Read ASCII clean world data, first column station ID, rest monthly temps, every row a station.    
    cleanData <- scan(file=conClean, what="character", nlines=1, na.strings = "-99.99")  
    stationID <- cleanData[1]
    cleanData <- numeric(cleanData[2:length(cleanData)])
    
#     if(length(which(data$stationIDs != network$stationIDs)) > 0) {
#       stop("Function read_network_properties expects the rows/station IDs to match between clean worlds and urbanization/landuse metadata file.")
#     } 
    
    # Determine gaps, which have a higher break frequency. Gaps longer than a year have a probability of settings$breakProbabilityGap.
    # If the gap is shorter we linearly reduce the probability to zero for no gap.
    gaps <- compute_gaps(cleanData)
    gaps$length[gaps$length > 12] <- 12 # Gaps longer than a year, are set to one year
    temp = 12 * settings$breakProbabilityGap
    for(iGap in 1:gaps$noGaps) {
      if( runif(1) * temp < gaps$length[iGap]) {
        iBrk = iBrk + 1
        brk$index[iBreak] = gaps$indices[iGap]
      }
    }
    
    # Positions of clustered breaks 
    
    
    # Positions of breaks with random positions
    ###### Remove too many breaks? 
    #remove breaks at same location
    
    
    
    ## Compute properties of gradual inhomogeneities
    # No seasonal cycle
    
    ## Implement inhomogeneities
    # Bias as random walk
    
    # Stochastic component
    
    # Seasonal cycle
    
  }  
  
  # Close files
  close(conClean)
  close(conPerturb)
  close(conInhom)
  close(conMeta)
}

