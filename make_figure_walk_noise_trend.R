# make_figure_walk_noise_trend

source("generate_walk.R")
source("generate_noise.R")

# Settings
noRep <- 10
noYears <- 150
noValSeries <- noYears 
jumpSize = 0.7

years = seq(from=2001-noYears, to=2000)
minVal = Inf
maxVal = -Inf
inhomWalk  = vector("list", noRep)
inhomNoise = vector("list", noRep)
inhomTrend = vector("list", noRep)
for(iRep in 1:noRep) {
  # Break positions
  temp <- 100 / 6 # globalBreakFrequency is in breaks per century
  breakIndex <- which(runif(noValSeries) * temp < 1)
  
  biased <- vector("logical", length=length(breakIndex))
  biasPerBiasedBreak <- 0
  inhomWalk[[iRep]]  <- generate_walk(breakIndex,  biased, noValSeries, jumpSize, biasPerBiasedBreak)
  
  trendBiasInhom <- 0
  inhomNoise[[iRep]]  <- generate_noise(breakIndex,  biased, noValSeries, jumpSize, trendBiasInhom)

  trendBiasInhom <- 1 * 12 # Function expects monthly data, so must be 12 times larger.
  biased[] <- TRUE
  inhomTrend[[iRep]]  <- generate_noise(breakIndex,  biased, noValSeries, jumpSize, trendBiasInhom)
  
  minVal = min(c(minVal, min(inhomWalk[[iRep]]), min(inhomNoise[[iRep]]), min(inhomTrend[[iRep]])) )
  maxVal = max(c(maxVal, max(inhomWalk[[iRep]]), max(inhomNoise[[iRep]]), max(inhomTrend[[iRep]])) )
}

fileName = paste0("fig1_walk_noise_bias_", noYears, "a.png")
png(file=fileName, 1200, 700, type="cairo")
par(mfrow = c(3,1))
par(mar=c(2,5,1,2)+0.1)
fontSize = 2

yLabStr = expression(Break~signal~(degree*C))
for(iRep in 1:noRep) {
  if(iRep == 1) {
    plot(years, inhomWalk[[iRep]],  col="darkblue", lwd=2, cex=fontSize, cex.lab=fontSize, cex.axis=fontSize, 
         cex.main=fontSize, xlab="Year", ylab=yLabStr, type="l", ylim=c(minVal, maxVal))
  } else {
    lines(years, inhomWalk[[iRep]],  col="darkblue", lwd=2, cex=fontSize) 
  }
}
abline(0,0)
grid()
for(iRep in 1:noRep) {
  if(iRep == 1) {
    plot(years, inhomNoise[[iRep]],  col="darkred", lwd=2, cex=fontSize, cex.lab=fontSize, cex.axis=fontSize,
         cex.main=fontSize, xlab="Year", ylab=yLabStr, type="l", ylim=c(minVal, maxVal))
  } else {
    lines(years, inhomNoise[[iRep]], col="darkred",  lwd=2, cex=fontSize)
  }
}
grid()
abline(0,0)
for(iRep in 1:noRep) {
  if(iRep == 1) {
    plot(years, inhomTrend[[iRep]],  col="darkgreen", lwd=2, cex=fontSize, cex.lab=fontSize, cex.axis=fontSize,
         cex.main=fontSize, xlab="Year", ylab=yLabStr, type="l", ylim=c(minVal, maxVal))
  } else {
    lines(years, inhomTrend[[iRep]], col="darkgreen",  lwd=2, cex=fontSize)
  }
}
grid()
abline(0,0)

dev.off()

## Wastebin

# biasPerBiasedBreak <- settings$trendBiasInhom / settings$globalBiasedBreakFrequency
# brk$walk[] <- FALSE
# indexWalk <- which(runif(noBreaks) * 100 < settings$percentageRandomWalkBreaks)
# brk$walk[indexWalk] <- TRUE
# # print(brk$biased[indexWalk])
# biasPerBiasedBreak <- settings$trendBiasInhom / settings$globalBiasedBreakFrequency

# Plot data itself

# xPos = year[[iCase]][1]
# if(iFile == 1){
#   yPos = max(temp[[iCase]], na.rm=TRUE) - (max(temp[[iCase]], na.rm=TRUE) - min(temp[[iCase]], na.rm=TRUE))*0.05
# } else {
#   yPos = min(temp[[iCase]], na.rm=TRUE) + (max(temp[[iCase]], na.rm=TRUE) - min(temp[[iCase]], na.rm=TRUE))*0.05
# }
# text(xPos, yPos, sprintf("%s %d-%d", varStr[[iCase]], year[[iCase]][1], year[[iCase]][noYears]), adj=c(0,0), cex=2, col="darkred")


# # Plot LOESS smoothed data
# temp.lo = loess(temp[[iCase]] ~ year[[iCase]], span = 50/noYears)
# tempSmooth = predict(temp.lo, year[[iCase]])
# lines(year[[iCase]], tempSmooth, col="darkblue", lwd=4, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)          

# a=0
# plot(years, inhomWalk, col="blue")
# lines(years, inhomNoise, col="red")

# # Breaks as noisy deviations
# indexNoise <- which(brk$walk == FALSE)
# inhomNoise <- generate_noise(breakIndex, brk$biased[indexNoise], noValSeries, stations$jumpSize[iStat], settings$trendBiasInhom)
# inhom <- inhomWalk + inhomNoise # + inhomGradual
# a <- 0
