put_settings <- function(settingsRead, settings) {
  # This function accepts the two column character list settingsRead and puts these values
  # in the structure settings.
  # The first column of settingsRead is the variableName, the second the variableValue.
  # setting looks like: settings$variableName = variableValue
  
<<<<<<< HEAD
  # Initialise
  noSettings <- length(settingsRead$settingName)
  
  # Put settingsRed in the settings structure
  if(missing(settings)) {
    # Initialise settings list (with the default settings)
=======
  noSettings <- length(settingsRead$settingName)
  if(missing(settings)) {
    # Initialise settings list
>>>>>>> 3a9dcf8082c941af33af865031b1d2955e3120d3
    settings <- vector("list", length=noSettings)
    for(iSet in 1:noSettings) {
      settings[iSet] <- settingsRead$settingValue[iSet]
      names(settings)[iSet] <- as.character(settingsRead$settingName[iSet])
    }
  } else {
<<<<<<< HEAD
    # (Default) settings present. Update the settings for a specific world with those that are new.
=======
    # Settings present. Update the settings with those who are new.
>>>>>>> 3a9dcf8082c941af33af865031b1d2955e3120d3
    for(iSet in 1:noSettings) {
      index <- which( names(settings) == as.character(settingsRead$settingName[iSet]) )
      settings[[index]] <- settingsRead$settingValue[iSet]
    }
  }
<<<<<<< HEAD
  
=======
>>>>>>> 3a9dcf8082c941af33af865031b1d2955e3120d3
  return(settings)
 }