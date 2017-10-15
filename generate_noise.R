generate_noise <- function(positions, biased, noValSeries, jumpSize, trendBiasInhom) {
  
  breakSignal <- vector("numeric", length=noValSeries) * 0
  
  if(length(positions)>0) {
    temp <- sort(positions, index.return=TRUE, decreasing=TRUE)
    positions <- temp$x
    indices   <- temp$ix
    biased    <- biased[indices]
    noBreaks  <- length(positions)
    positions <- c(positions, 1)
    
    noiseLevel <- jumpSize*sqrt(2) # The jump sizes are determined by the levels of two homogeneous subperiods, the noise for one period thus needs to be smaller. Variances are additive.
    factor <- 1/(12*100)
    # randomNumber <- 0
    biasLevel <- 0
    breakSignal[positions[1]:noValSeries] <- 0
    for(iBreak in 1:noBreaks) {
      randomNumber <- rnorm(1) * noiseLevel
      if(biased[iBreak]) {
        posFromEnd  <- noValSeries - positions[iBreak]
        yearFromEnd <- posFromEnd * factor
        biasLevel   <- trendBiasInhom * yearFromEnd
      }
      randomNumber <- randomNumber + biasLevel
      breakSignal[positions[iBreak]:positions[iBreak+1]] <- randomNumber
    }
  }
  
  return(breakSignal)
}