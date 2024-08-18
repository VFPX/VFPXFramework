# VFPX Framework

VFPX Framework provides base UI classes and commonly used functions for any project.

## Releases

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
