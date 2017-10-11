compute_multiple_station_properties <- function(settings, network) {
# This function computes statistical properties of inhomogeneities that are valid for multiple stations.
# Such as network-wide inhomogeneities or variations in station quality from network to network.

  ## Initialise
#   str(settings)
  stations <- list()
  noStations <- length(network$stationIDs)
  noNetworks <- length(network$netIndices)
  
  
  ## Section 1. Determine break frequency
  networkPerturbation <- settings$networkBreakFrequencyStd * rnorm(noNetworks)
  stationPerturbation <- vector("numeric", length=noStations)
  for(iNet in 1:noNetworks) {
    stationPerturbation[network$netIndices[[iNet]]] <- networkPerturbation[iNet]
  }
  stationPerturbation <- stationPerturbation + settings$stationBreakFrequencyStd * rnorm(noStations)
  stations$breakFrequency <- settings$globalRandomBreakFrequency + stationPerturbation
  stations$breakFrequency[stations$breakFrequency<0] <- 0
  
  
  ## Section 2. Determine break sizes  
  networkPerturbation <- settings$networkJumpSizeStd * rnorm(noNetworks)
  stationPerturbation <- vector("numeric", length=noStations)
  for(iNet in 1:noNetworks) {
    stationPerturbation[network$netIndices[[iNet]]] <- networkPerturbation[iNet]
  }
  stationPerturbation <- stationPerturbation + settings$stationJumpSizeStd * rnorm(noStations)
  stations$jumpSize <- settings$globalJumpSize + stationPerturbation

  
  ## Section 3. Network-wide biased breaks
  # These breaks are always present, what varies is their year.
  # First determine the years (running from 1 to noYearsClean) in which these breaks take place globally.
  HomogeneousSubPeriod <- 100 / settings$globalBiasedBreakFrequency
  globalFirstBreak <- -1 * HomogeneousSubPeriod * runif(1)
  noBreaks <- ceiling(2 + settings$noYearsClean / HomogeneousSubPeriod)
  # globalBreakPositions <- seq(from=globalFirstBreak, to=settings$noYearsClean+HomogeneousSubPeriod, by=HomogeneousSubPeriod)
  globalBreakPositions <- seq(from=globalFirstBreak, to=settings$noYearsClean+HomogeneousSubPeriod, length.out=noBreaks)
  globalBreakPositions <- globalBreakPositions +  rnorm(noBreaks) * settings$globalBiasedBreakFrequencyStd 
  
  # Determine the years these breaks take place in a network
  stationPositions      <- matrix(data = NA, nrow = noBreaks, ncol = noStations)
  stationPerturbation   <- vector("numeric", length=noStations)
  for(iBreak in 1:noBreaks) {
    for(iNet in 1:noNetworks) {
      networkPerturbation   <- settings$networkBiasedBreakFrequencyStd * rnorm(1)
      networkBreakPositions <- globalBreakPositions[iBreak] + networkPerturbation
      
      noStationsNetwork    <- length(network$netIndices[[iNet]])
      stationPerturbations <-  settings$stationBiasedBreakFrequencyStd * rnorm(noStationsNetwork)
      stationPositions[iBreak, network$netIndices[[iNet]]] <- networkBreakPositions + stationPerturbations
    }
  }
  stationPositions = round(stationPositions * 12) # Convert from year to month
  maxVal <- settings$noYearsClean * 12
  stationPositions[stationPositions < 1 | stationPositions > maxVal] = NA 
  stations$biasedBreakIndex = stationPositions
  
  
  return(stations)
}