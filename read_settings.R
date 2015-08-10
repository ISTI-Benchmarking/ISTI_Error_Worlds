read_settings <- function(currentDirs) {
  # This function reads the setting files.
  # There are three levels: default settings, world settings, network settings.
  # They are read in this order and later settings override older ones.
  # The default settings valid for all worlds is in the directory above the clean worlds.
  # The world and network settings are in the subdirectories of the clean worlds.

  # TODO: The part for network specific settings is not implemented yet.
  
  # Initialise
  source("put_settings.R")
  
  settingsDir <- currentDirs$cleanDir
  defaultSettingsDir <- dirname(settingsDir)

  # Read default settings file.
  settingsDirFileName <- paste(defaultSettingsDir, "default_settings.txt", sep="/")
  if(file.exists(settingsDirFileName) == FALSE) {
    # If no default settings file exists yet, make one with default values
    if(file.exists("default_default_settings.txt") == TRUE) {
      file.copy(from="default_default_settings.txt", to=settingsDirFileName)
    } else {
      stop('No settingfile found. Processing aborted in read_settings.R')
    }
  }
  settingsRead <- read.table(settingsDirFileName, col.names=c("settingName", "settingValue")) 
  settings <- put_settings(settingsRead) # Put values read in a structure with the names read.

  # Read world settings file.
  settingsDirFileName <- paste(settingsDir, "world_settings.txt", sep="/")
  if(file.exists(settingsDirFileName) ) {
    settingsRead <- read.table(settingsDirFileName, col.names=c("settingName", "settingValue")) 
    settings <- put_settings(settingsRead, settings) # Put values read in a structure with the names read, overwriting defaults if double.
  }

  # Read network settings file.
  # TODO

  return(settings)
}


## Wastebin
#     settingsStr = c("# This file contains the default settings for all error worlds.",
#                  "# These settings can be overrided by more detailed settings in the subdirectories.",
#                  "# Comments can be added by starting the line with the pound sign, like this header.",
#                  "# You can edit this file to update the settings. Any white space between name and value works.",
#                  "# If you delete it, it will be replaced by the defaults mentioned in the function read_settings().",
#                  "globalBreakFrequency 5",
#                  "networkBreakFrequencyStd 1",
#                  "stationBreakFrequencyStd 1", 
#                  "globalBreakSize 0.6",
#                  "networkBreakSizeStd 0.2",
#                  "stationBreakFrequencyStd 0")
#     write(settingsStr, file = settingsDirFileName)
