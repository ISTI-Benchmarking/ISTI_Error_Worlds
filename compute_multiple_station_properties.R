compute_multiple_station_properties <- function(settings, network) {
# This function computes statistical properties of inhomogeneities that are valid for multiple stations.
# Such as network-wide inhomogeneities or variations in station quality from network to network.

  # Initialise
#   str(settings)
  station <- list()
  noStations <- length(network$stationIDs)
  noNetworks <- length(network$netIndices)
  
  # Determine break frequency
  networkPerturbation <- settings$networkBreakFrequencyStd * rnorm(noNetworks)
  stationPerturbation <- vector("numeric", length=noStations)
  for(iNet in 1:noNetworks) {
    stationPerturbation[network$netIndices[[iNet]]] = networkPerturbation[iNet]
  }
  stationPerturbation <- stationPerturbation + settings$stationBreakFrequencyStd * rnorm(noStations)
  station$breakFrequency <- settings$globalBreakFrequency + stationPerturbation
  station$breakFrequency[station$breakFrequency<0] <- 0
  
  # Determine break sizes  
  networkPerturbation <- settings$networkBreakSizeStd * rnorm(noNetworks)
  stationPerturbation <- vector("numeric", length=noStations)
  for(iNet in 1:noNetworks) {
    stationPerturbation[network$netIndices[[iNet]]] = networkPerturbation[iNet]
  }
  stationPerturbation <- stationPerturbation + settings$stationBreakSizeStd * rnorm(noStations)
  station$breakSize <- settings$globalBreakSize + stationPerturbation

  return(station)
}