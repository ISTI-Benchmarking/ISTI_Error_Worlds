generate_walk <- function(positions, biased, noValSeries, jumpSize, biasPerBiasedBreak) {

  breakSignal <- vector("numeric", length=noValSeries) * 0
  
  if(length(positions)>0) {
    # positions <- brk$index[indexWalk]
    temp <- sort(positions, index.return=TRUE, decreasing=TRUE)
    positions <- temp$x
    indices   <- temp$ix
    biased    <- biased[indices]
    noBreaks  <- length(positions)
    positions <- c(positions, 1)
      
    randomNumber = 0
    breakSignal[positions[1]:noValSeries] <- randomNumber
    for(iBreak in 1:noBreaks) {
      randomNumber <- randomNumber + rnorm(1) * jumpSize
      if(biased[iBreak]) {
        randomNumber <- randomNumber + biasPerBiasedBreak
      }
      breakSignal[positions[iBreak]:positions[iBreak+1]] <- randomNumber
    }
  }
  
  return(breakSignal)
}