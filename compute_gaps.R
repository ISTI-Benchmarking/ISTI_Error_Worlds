compute_gaps <- function(data) {
  # This function takes one station, ignores missings data at the beginning and ending and 
  # computes the length and the position (index) of the gaps.
  
  # Initialise
  gaps <- list()
  gaps$length <- vector("integer", length=length(data))
  gaps$index  <- vector("integer", length=length(data))
  gaps$indexBeginGap <- vector("integer", length=length(data))
  
  # Combine missing values into coherent gaps
  indicesMissing <- which(is.na(data))
  noValMissing <- length(indicesMissing)
  iGap <- 0
  indexBeginGap <- indicesMissing[1]
  for(i in 2:noValMissing) { 
    if(indicesMissing[i-1] + 1 < indicesMissing[i]) {         # If the gap is interupted
      if(indexBeginGap != 1) {                                # Ignore any missing data at beginning of series (missing data at the end it automatically ignored).
        iGap <- iGap + 1
        # The index points to the highest index of the gap, the most recent date.
        gaps$index[iGap]  <- indicesMissing[i-1]                     # Then previous missing value was end of gap
        gaps$length[iGap] <- indicesMissing[i-1] - indexBeginGap + 1 # Then difference between previous begin of gap and previous missing value is the lenght of the continuous gap 
        gaps$indexBeginGap[iGap] <- indexBeginGap
      }
      indexBeginGap <- indicesMissing[i]                           # Then the new value is beginning of new gap
    }
  }
  
  gaps$length <- gaps$length[1:iGap]
  gaps$index  <- gaps$index[1:iGap]
  gaps$indexBeginGap <- gaps$indexBeginGap[1:iGap]
  gaps$noGaps <- iGap
  
  return(gaps)
}