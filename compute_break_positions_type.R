compute_break_positions_type <- function(stations, iStat, settings, noValSeries, cleanData) {
## Compute positions of break inhomogeneities for gap breaks, clustered breaks and randomly positioned breaks
  
  source("compute_gaps.R")
  source("compute_period.R")
  
  # Initialise
  iBrk <- 0 # A break is abbreviated as brk because break is a reserved word in Rstat
  brk <- list()
  # maxLength <- (settings$endYearClean - settings$beginYearClean + 1) * 12
  maxBreaks  <- settings$noYearsClean # A very high upper limit for the number of breaks, one per year. 
  brk$index  <- vector("integer", length=maxBreaks) * NA # Index of the break
  brk$biased <- vector("logical", length=maxBreaks) * NA # Does the break have a non-zero mean (also clustered in space)
  brk$walk   <- vector("logical", length=maxBreaks) * NA # Is the break a random walk or a noise deviation.
  
  
  # Positions of clustered breaks 
  noBreaks <- nrow(stations$biasedBreakIndex)
  for(iBreak in 1:noBreaks) {
    if(is.na(stations$biasedBreakIndex[iBreak, iStat]) == FALSE) {
      iBrk <- iBrk + 1
      brk$index[iBrk] <- stations$biasedBreakIndex[iBreak, iStat]
      brk$biased[iBrk] <- TRUE
    }
  }
  
  # Positions of breaks with random positions
  temp <- 12 * 100 / stations$breakFrequency[iStat] # globalBreakFrequency is in breaks per century
  breakIndex <- which(runif(noValSeries) * temp < 1)
  if(length(breakIndex)>0) {
    bi <- iBrk + 1
    ei <- iBrk + length(breakIndex)
    brk$index[bi:ei] <- breakIndex
    brk$biased[bi:ei] <- FALSE
    iBrk = iBrk + length(breakIndex)
  }
  
  # Determine gaps, which have a higher break frequency. Gaps longer than a year have a probability of settings$breakProbabilityGap.
  # If the gap is shorter we linearly reduce the probability to zero for no gap.
  gaps <- compute_gaps(cleanData) # gaps$index is the most recent date of a gap, i.e. the highest index.
  if(gaps$noGaps > 0) {
    for(iGap in 1:gaps$noGaps) {
      # index  = which(brk$index > gaps$index[iGap]-gaps$length[iGap] & brk$index <= gaps$index[iGap])
      index = which(brk$index >= gaps$indexBeginGap[iGap]           & brk$index <= gaps$index[iGap])
      noBreaksGap <- length(index)
      if(noBreaksGap == 0) { # If no breaks were set in this gap, add additional gap breaks with a certain probabiity
        breakProbabilityGap <- stations$breakFrequency[iStat] * settings$breakProbabilityGapFactor
        temp <- 12 * 100 / breakProbabilityGap # globalBreakFrequency is in breaks per century
        lengthGapForProb <- min(c(gaps$length[iGap], 12)) # Gaps longer than a year, are set to one year
        if(runif(1) * temp < lengthGapForProb) {
          iBrk <- iBrk + 1
          brk$index[iBrk] <- gaps$index[iGap]
          brk$biased[iBrk] <- FALSE
        }
      } else { # If there are one or multiple breaks in a gap, reduce this to one break at the beginning. If at least one break is biased, make this break at the beginning a biased one.
        # print(noBreaksGap)
        brk$index[index] <- NA
        brk$index[index[1]] <- gaps$index[iGap]
        noBiased = length(which(brk$biased[index] == TRUE))
        brk$biased[index] <- NA
        if(noBiased > 0) {
          brk$biased[index[1]] <- TRUE
        } else {
          brk$biased[index[1]] <- FALSE
        }
        iBrk <- iBrk - noBreaksGap + 1
      } # If there are breaks in current gap
    } # Loop over all gaps
  } # If series contains gaps
  
  # Remove breaks outside of data period
  # Also remove breaks in the last 24 months to have a reference period: use period$endInhomIndex
  period <- compute_period(cleanData)
  index <- which(brk$index < period$beginIndex | brk$index > period$endInhomIndex)
  brk$index[index] <- NA
  
  # Clean up brk 
  index <- which(!is.na(brk$index))
  brk$index  <- brk$index[index]
  brk$biased <- brk$biased[index]
  brk$walk   <- brk$walk[index]
  
  return(brk)
}