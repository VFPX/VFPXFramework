# VFPX Framework

VFPX Framework provides base UI classes and commonly used functions for any project.

## Releases

### 2026-08-10

- The new VFPXSplitter provides horizontal and vertical splitter controls.

- The new VFPXStatusBar provides a status bar.

- VFPXGridBuilder.prg now supports BackColor and Forecolor settings and sets the Tag property of an auto-size column so it's resized when the grid is. It also handle phantom Column[1] columns.

- VFPXBaseGrid has a SetupGrid method that uses the format returned by GridDefinition to set up the grid columns. This essentially does what VFPXGridBuilder.prg does but at runtime rather than (or in addition to) design time. The Init method calls SetupGrid but you can also call it anytime, such as after recreating a cursor used as the RecordSource for the grid.

- A bug in VFPXSortGrid that prevented reversing the sort of a column by clicking it a second time was fixed.

- Added a missing constant to ReadINI.prg.

- VFPXDirectory and VFPXFile (in VFPXFileCtrls.vcx) no longer automatically add SFGDIMeasureString.prg to a project. Add that PRG and deploy System.app with your app if you want to have the controls adjust dynamically to the value of the cLabelCaption property. Otherwise, use the builder for these controls to set the label caption at design time.

### 2024-11-10

- A new VFPXSortGrid class in VFPXSortGrid.vcx provides clicking the column header to sort on a column. Thanks to Tore Bleken for providing this class.

- VFPXPersist now has its own cRegistryKey property you can set rather than requiring one belonging to the form (the form's is used if it exists; otherwise, the VFPXPersist object's is used).

- VFPXPersist now supports persisting other settings in addition to size and position using the aPersist array; see the [documentation](Doc/Documentation.md) for details.

- VFPXInternet.prg now ignores certificate revocation checks when they fail due to missing/offline distribution points for the revocation check lists, which causes error 35 when downloading files. This was done by adding "--ssl-revoke-best-effort" to the CURL command line. Thanks to Christof Wollenhaupt for the fix.

- OpenFile.prg no longer opens files in the background on Windows 10 machines. Thanks to Joel Leach for the fix.

- VFPXGridBuilder.prg now supports spaces in addition to tabs between pipes, and it supports putting the format text into a custom GridDefinition method of the grid, which was added to VFPXBaseGrid.

- Fixed bugs in ReadINI.prg and GetFilesInFolder.prg.

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
