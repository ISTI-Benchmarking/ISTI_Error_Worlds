put_settings <- function(settingsRead, settings) {
  # This function accepts the two column character list settingsRead and puts these values
  # in the structure settings.
  # The first column of settingsRead is the variableName, the second the variableValue.
  # setting looks like: settings$variableName = variableValue
  
  # Initialise
  noSettings <- length(settingsRead$settingName)
  
  # Put settingsRead in the settings structure
  if(missing(settings)) {
    # Initialise settings list (with the default settings)
    settings <- vector("list", length=noSettings)
    for(iSet in 1:noSettings) {
      settings[[iSet]] <- settingsRead$settingValue[iSet]
      names(settings)[iSet] <- as.character(settingsRead$settingName[iSet])
    }
  } else {
    # (Default) settings present. Update the settings for a specific world with those that are new.
    for(iSet in 1:noSettings) {
      index <- which( names(settings) == as.character(settingsRead$settingName[iSet]) )
      settings[[index]] <- settingsRead$settingValue[iSet]
    }
  }
  
  noSettings <- length(settings)
  for(iSet in 1:noSettings) {
    # If it is possible to convert settingValue to a numerical value, do so.
    if(!is.na(suppressWarnings(as.numeric(settings[[iSet]])))) {
      settings[[iSet]] = as.numeric(settings[[iSet]])
    }
    # If it is possible to convert settingValue to TRUE, do so.
    if(settings[[iSet]] == "TRUE") {
      settings[[iSet]] <- TRUE
    }
    # If it is possible to convert settingValue to FALSE, do so.
    if(settings[[iSet]] == "FALSE") {
      settings[[iSet]] <- FALSE
    }
  }

  return(settings)
 }