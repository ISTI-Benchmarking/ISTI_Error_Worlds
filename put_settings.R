put_settings <- function(settingsRead, oldSettings) {
  # This function accepts the two column character list settingsRead and puts these values
  # in the structure settings.
  # The first column of settingsRead is the variableName, the second the variableValue.
  # setting looks like: settings$variableName = variableValue
  
  if(missing(oldSettings)) {
    # Initialise settings list
    noSettings = length(settingsRead$settingName)
    settings = vector("list", length=noSettings)
    for(iSet in 1:noSettings) {
      settings[iSet] <- settingsRead$settingValue[iSet]
      names(settings)[iSet] <- as.character(settingsRead$settingName[iSet])
    }
  } else {
    print("oldSettings present")
    
  }
   
   
  return(settings)
 }