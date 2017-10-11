compute_period <- function(data) {
  # This function takes one station and computes the position of the first and last data point.
  
  # Initialise
  period <- list()

  # Compute indices
  indicesData <- which(is.na(data) == FALSE)
  period$beginIndex = indicesData[1]       # First index with data
  noValues = length(indicesData) 
  period$endIndex = indicesData[noValues]  # Last index with data
  
  # In the last 24 months there should not be any inhomogeneities. 
  # This index points to the last index where inhomogenieties can be set.
  if(noValues > 24) {
    period$endInhomIndex = indicesData[noValues-24]
  } else {
    period$endInhomIndex = period$beginIndex
  }
  
  return(period)
}