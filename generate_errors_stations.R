generate_errors_stations <- function (setting, network, stations) {
  # This function implements the inhomogeneities for single stations while looping over all stations.
  # It does not produce output, but reads the clean data and directly writes the inhomogeneous data and the perturbations to a file.
  
  # Initialisation
  noStations <- length(network$stationIDs)
  cleanDataDirFileName   <- paste(settings$cleanDataDir, settings$cleanDataFileName, sep="/")
  perturbDataDirFileName <- paste(settings$cleanDataDir, settings$cleanDataFileName, sep="/")
  inhomDataDirFileName   <- paste(settings$cleanDataDir, settings$cleanDataFileName, sep="/")
  metaDataDirFileName    <- paste(settings$cleanDataDir, settings$cleanDataFileName, sep="/")
  
  # Open files 'connections'
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
    brk$index = vector("integer", length=2024)
    
    # Positions of breaks in gaps
    # Read ASCII clean world data, first column station ID, rest monthly temps, every row a station.    
    cleanData <- scan(file=conClean, what="character", nlines=1, na.strings = "-99.99")  
    stationID <- cleanData[1]
    cleanData <- numeric(cleanData[2:length(cleanData)])
    
    # Determine gaps, which have a higher break frequency
    gaps <- compute_gaps(cleanData)
    gaps$length[gaps$length > 12] <- 12 # Gaps longer than a year, are set to one year
    temp = 12 * settings$breakProbabilityGap
    for(iGap in 1:gaps$noGaps) {
      if( runif(1) * temp < gaps$length[iGap]) {
        iBreak = iBreak + 1
        brk$index[iBreak] = gaps$indices[iGap]
      }
    }
    
    # Positions of clustered breaks 
    
    
    # Positions of breaks with random positions
    
    
    ## Compute properties of gradual inhomogeneities
    
    
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

