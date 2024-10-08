# VFPX Framework

VFPX Framework provides base UI classes and commonly used functions for any project.

## Releases

### 2024-08-30

* ExecuteCommand.prg now accepts a tlNoWait parameter (if .T., it returns immediately rather than waiting for the command to finish execution) and handles output redirection (specifying ">" followed by a path) in the command line.

* Fixed an issue with GetFileName.prg not setting the initial directory properly if a fully-qualified path isn't passed for the filename.

* Fixed an issue with VFPXFile not setting the default filename.

### 2024-08-25

* VFPXInternet.prg now handles "https://" in the server name.

* Added BuildZip.prg to create FoxGet\Source.zip.

### 2024-08-18

* Removed Thor Check for Update related files since VFPX Framework is better installed with [FoxGet](https://github.com/doughennig/foxget).

### 2024-07-27

* Added GetFilesInFolder.prg

* Added TRY to api_apprun.prg to prevent an error with INKEY.

### 2024-07-21

* Added System.app since it's required by SFGDIMeasureString.prg, which is used by VFPXFile and VFPXDirectory, although those classes now work properly if System.app isn't present.

* Fixed bugs in SFGDIMeasureString.prg, SFMonitors.prg.

* Removed code in ShortcutMenu from base classes that don't need it.

* Removed SetupGrid method from VFPXBaseGrid since the builder handles that behavior.

* Added AnyChange and shortcut menu to VFXXBaseOptionGroup.

### 2024-01-30

* Initial release.
