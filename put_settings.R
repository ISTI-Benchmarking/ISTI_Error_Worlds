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
      settings[iSet] <- settingsRead$settingValue[iSet]
      names(settings)[iSet] <- as.character(settingsRead$settingName[iSet])
    }
  } else {
    # (Default) settings present. Update the settings for a specific world with those that are new.
    for(iSet in 1:noSettings) {
      index <- which( names(settings) == as.character(settingsRead$settingName[iSet]) )
      settings[[index]] <- settingsRead$settingValue[iSet]
    }
  }
  
  return(settings)
 }