read_settings <- function(currentDirs) {
  # This function reads the setting files.
  # There are three levels: default settings, world settings, network settings.
  # They are read in this order and later settings override older ones.
  # The default settings valid for all worlds is in the directory above the error worlds.
  # If there is no default settings file, a file from this working directory will be copied 
  # into the error world directory. 
  # The world and network settings are in the subdirectories of the error worlds.
  # If they do not have a setting file a file from the error world directory of this code directory
  # will be copied to the one of the data directory.
  
  # TODO: The part for network specific settings is not implemented yet.
  
  # Initialise
  source("put_settings.R")
  
  settingsDir <- currentDirs$errorWorldDir   # Directory of the current error world.
  defaultSettingsDir <- dirname(settingsDir) # Directory above the current error world, with all error worlds.

  # Read default settings file.
  settingsDirFileName <- paste(defaultSettingsDir, "default_settings.txt", sep="/")
  if(file.exists(settingsDirFileName) == FALSE) {
    # If no default setting file exists yet, copy one from the working director of this procesing software
    if(file.exists("default_default_settings.txt") == TRUE) {
      file.copy(from="default_default_settings.txt", to=settingsDirFileName)
    } else {
      stop('No setting file found. Processing aborted in read_settings.R')
    }
  }
  settingsRead <- read.table(settingsDirFileName, col.names=c("settingName", "settingValue"), as.is=TRUE) 
  settings <- put_settings(settingsRead) # Put values read in a structure with the names read.

  # Read world settings file.
  settingsDirFileName <- paste(settingsDir, "world_settings.txt", sep="/")
  if(file.exists(settingsDirFileName) ) {
    settingsRead <- read.table(settingsDirFileName, col.names=c("settingName", "settingValue"), as.is=TRUE) 
    settings <- put_settings(settingsRead, settings) # Put values read in a structure with the names read, overwriting defaults if double.
  }

  # Read network settings file.
  # TODO

  return(settings)
}

