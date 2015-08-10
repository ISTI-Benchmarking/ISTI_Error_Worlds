read_settings <- function(currentDirs) {
  # This function reads the setting files.
  # There are three levels: default settings, world settings, network settings.
  # They are read in this order and later settings override older ones.
  # The default settings valid for all worlds is in the directory above the clean worlds.
  # The world and network settings are in the subdirectories of the clean worlds.

  # TODO: The part for network specific settings is not implemented yet.
  
  settingsDir <- currentDirs$cleanDir
  defaultSettingsDir <- dirname(settingsDir)
#   str(settingsDir)
#   str(defaultSettingsDir)

  # Read default settings file.
  settingsDirFileName = paste(defaultSettingsDir, "default_settings.txt", sep="/")
  if(file.exists(settingsDirFileName) == FALSE) {
    # If no default settings file exists yet, make one with default values
#     settingName  = c("globalBreakFrequency", "networkBreakFrequencyStd", "stationBreakFrequencyStd")
#     settingValue = c(5,                       1,                          1)
#     df = data.frame(settingName, settingValue)
#     write(df, file = settingsDirFileName)
#     settingName  = c("globalBreakSize", "networkBreakSizeStd", "stationBreakFrequencyStd")
#     settingValue = c(0.6,               0.2,                   0)
#     df = data.frame(settingName, settingValue)
#     write(df, file = settingsDirFileName, append = TRUE)    
    
    settingsStr = c("# This file contains the default settings for all error worlds.",
                 "# These settings can be overrided by more detailed settings in the subdirectories.",
                 "# Comments can be added by starting the line with the pound sign, like this header.",
                 "# You can edit this file to update the settings. Any white space between name and value works.",
                 "# If you delete it, it will be replaced by the defaults mentioned in the function read_settings().",
                 "globalBreakFrequency 5",
                 "networkBreakFrequencyStd 1",
                 "stationBreakFrequencyStd 1", 
                 "globalBreakSize 0.6",
                 "networkBreakSizeStd 0.2",
                 "stationBreakFrequencyStd 0")
    write(settingsStr, file = settingsDirFileName)
  }
  settingsRead = read.table(settingsDirFileName, col.names=c("settingName", "settingValue")) #  colClasses=c("character"))
  settings = put_settings(settingsRead)

  # Read world settings file.


  # Read network settings file.


  settings = 0
  return(settings)
}