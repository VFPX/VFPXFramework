# VFPX Framework Documentation

*** TODO: discuss others: Format, FoxCryptoNG, OOP Menu

## Base classes
VFPXBaseLibrary.vcx contains subclasses of most VFP base classes.  Common changes are (not all changes are applicable to all classes):

* Anchor (VFPXBaseContainer, VFPXBaseEditBox, VFPXBaseGrid, VFPXBasePageframe): 15 (resize horizontally and vertically)

* AutoSize: .T.

* BackStyle: 0-Transparent

* BorderWidth (VFPXBaseContainer and VFXBaseOptionGroup): 0

* BoundTo and ItemTips (VFPXBaseComboBox and VFPXBaseListBox): .T.

* Builder: the name of a builder (specified as *BuilderName.prg* or *BuilderLibrary,BuilderClass*) to use for the class.

* BuilderCode: code for a self-container builder; see the notes in the method for instructions to use.
    
* Enabled_Assign (VFPXBaseContainer and VFPXBasePage): sets the Enabled property of all contained controls to the same value.

* FontName: Segoe UI

* InteractiveChange and ProgrammaticChange: call UpdateControlSource to write the control's value to its control source, then call AnyChange. Put code in AnyChange that should be called on any change (programmatic or interactive) to the control's value.

* IntegralHeight: (VFPXBaseEditBox and VFPXBaseListBox): .T.

* KeyPress: prevent Ctrl-0 from inserting a null value and backspace from leaving the control.

* RightClick: calls This.ShowMenu, which instantiates an SFMenuShortcutMenu object into the oMenu property (this requires the VFPX [OOPMenu project](https://github.com/VFPX/OOPMenu) be installed, which is automatically done if you use [FoxGet](https://github.com/DougHennig/FoxGet) to install VFPX Framework) and calls ShortcutMenu to populate the shortcut menu. See the code in  VFPXBaseTextBox.ShortcutMenu for an example of how to populate a shortcut menu.

* RowSource and RowSourceType (VFPXBaseComboBox and VFPXBaseListBox): This.aItems and 5-Array, respectively. If the lRequeryOnInit property is .T. (the default), populate the This.aItems array in Init and then call DODEFAULT() to requery the control.

* SelectOnEntry: .T.

* lSaveAnchor: set this to .T. before programmatically changing the Top, Left, Height, or Width properties of the control to ensure anchoring is handled properly, then set it to .F. afterward.

Changes in specific classes:

* VFPXBaseComboBox:

    * Style: 2-Dropdown List
    
    * lAddNewItemToList: if .T., Style is 1-Dropdown Combo, RowSourceType is 5-Array, and RowSource is This.aItems, values entered by the user that don't exist in the array are automatically added to it by the Valid method.

* VFPXBaseForm:

    * AllowOutput: .F.
    
    * AutoCenter: .T.
    
    * BackColor: 255,255,255 (white)
    
    * Desktop: .T.
    
    * KeyPress: close the form on Esc.
    
    * KeyPreview: .T.
    
    * Load: set the environment (e.g. SET DELETED ON) for forms with a private datasession
    
    * MaxButton and MinButton: .F.
    
    * ShowTips: .T.
    
    * ShowWindow: 1-In Top-Level Form

* VFPXBaseGrid:

    * Builder: VFPXGridBuilder.prg; see comments in that PRG for instructions to use.
    
    * BuilderCode: calls SetupGrid, passing _cliptext.
    
    * SetupGrid: sets up the grid using the specified column definitions; see comments in that method for instructions to use.

* VFPXBaseOptionGroup:

    * MemberClass and MemberClassLibrary: VFPXBaseOptionButton in VFPXBaseLibrary.vcx

* VFPXBasePageFrame:

    * MemberClass and MemberClassLibrary: VFPXBasePage in VFPXBaseLibrary.vcx
    
    * PageCount: 1
    
    * TabStyle: 1-Justified

* VFPXBasePage:

    * Activate: calls This.Refresh.

* VFPXBaseShape:

    * SpecialEffect: 0-3D

## VFPXBaseLibrary.h

VFPXBaseLibrary.h contains some commonly used constants.

## Specialty classes

### Persistent form
Users appreciate a form that opens in the same position and size as it was last time it was open. VFPXPersistentForm in VFPXPersistentForm.vcx provides this ability. Create a form based on VFPXPersistentForm and set the cRegistry property to the Windows Registry location in HKEY_CURRENT_USER to save the window settings (for example, "Software\MyApp") in either the Properties window or in the Load or Init methods (in the case of Init, set it prior to calling DODEFAULT()). VFPXPersistentForm uses both VFPXPersist and SFMonitors.prg (discussed below) to size and position the form properly, including ensuring it fits on the correct monitor (for example, if the user has two monitors, the form was opened on the second monitor before, but now only one monitor is available, the form is opened on the correct monitor and sized and positioned appropriately).

### Button with dropdown menu
VFPXDropDownMenuButton in VFPXDropDownMenuButton.vcx provides a button with a dropdown menu, sometimes called a "split" button. Drop one on a form, set Picture property of the cmdMain button as desired, fill in the ShortcutMenu method of the VFPXDropDownMenuButton object as necessary, and put code into the ButtonClicked method that executes when the user clicks the button.

For example, [DeployFox](https://github.com/DougHennig/DeployFox) has a VFPXDropDownMenuButton allowing you to either click the button to open a project or select from a dropdown list of previously opened projects.

![](vfpxdropdownmenubutton.png)

*** TODO: show sample code

## Running an executable
While the VFP RUN command runs an executable, it provides little control. API_AppRun.prg by the late Ed Rauh provides a much better way to run an executable:

* It can either run the EXE and wait for it to terminate or run it and return immediately.

* It can return a value indicating whether the EXE succeeded or not.

* It can display the EXE run in a normaly, minimized, or maximized window or display no window at all.

ExecuteCommand.prg is a wrapper for API_AppRun. Pass it up to three parameters:

* The command line to execute (required). Use double quotes around the EXE path and any parameters if they contain a space or other illegal command line character.

* The folder to set as the current folder for the EXE (it doesn't change the current folder for your VFP app). Optional: if it isn't specified, the current folder is used.

* The window mode: NOR (normal), MIN (minimized), Max (maximized), or HID (hidden). Optional: HID is used if not specified.

It runs the EXE and waits until it terminates, then returns a blank string if the EXE succeeded or an error message if not (not all EXEs support reporting an error code).

*** TODO: show sample code

## File and folder operations

### Move, copy, delete, or rename files and folders
VFP has commands to do all of these operations but:

* No dialog is displayed if there are a lot of files (or large files) to move or copy.
* The VFP RD command throws an error if the folder isn't empty.

FileOperation.prg, adapted from code written by Sergey Berezniker, is a better way to perform these operations. Pass it up to six parameters:

* Source: the file or folder to copy, move, delete, or rename. Required.

* Destination: the file or folder to copy or move the source to. Optional for a delete operation, required for the others.

* Operation: the action to perform: "move", "copy", "delete", or "rename". Required.

* UserCanceled: optionally passed a variable by reference; upon return, it contains .T. if the user canceled the operation.

* Files only: optionally pass .T. to process file not folders.

* Quiet: optionally pass .T. to not display a dialog.

FileOperation returns .T. if the operation succeeded or the user canceled. It uses ClsHeap.prg.

*** TODO: show sample code

### Opening a file
OpenFile.prg is a wrapper for the Windows API ShellExecute function. Pass it the path to the file to open and it'll open the file using the appropriate application (for example, a DOCX file is opened in Microsoft Word and a URL is opened in the default browser).

*** TODO: show sample code

### File and path case
Some VFP functions, such as FULLPATH(), uppercase the specified path. That's fine if it isn't displayed to the user or used to create a file, but it looks odd otherwise. Call GetProperFileCase.prg, passing it the path and optionally .T. if the path is a folder rather than a file, and it'll return the case of the file or folder as it actually is or lowercase if it doesn't exist. This uses the Windows Scripting.FileSystemObject so that has to be enabled (it is by default).

*** TODO: show sample code

## File dialogs
The VFP GETFILE() and PUTFILE() functions have a *lot* of shortcomings. Here are just a few:

* They return the path in uppercase.
* They don't support multi-file selection.
* They are older dialogs that don't support all of the features of newer ones.
* They don't support a default folder.

The VFPXCommonDialog class in VFPXCommonDialog.vcx is a customized version of the _ComDlg class in the FFC _system.vcx (for example, it's easier to call because you don't have to pass parameters by reference). Because it uses the standard Windows file dialog, the dialog's appearance and behavior always matches the version of Windows it's running on. It has a lot of properties that allow you to customize the appearance and behavior; see the "Common Dialog Box Foundation Class" topic in VFP help for information about them.

GetFileName.prg is a wrapper for VFPXCommonDialog. Pass it up to five parameters:

* File extensions: the same value as the extensions parameter for GETFILE(). Optional: if it isn't specified, all file types are allowed.

* Default file path: optional. If passed the folder for the file is used as the default folder and the filename textbox in the dialog is filled in with the filename.

* Dialog title caption: optional; if not specified, the caption is "Open" or "Save", depending on the value of the next parameter.

* .T. for a Save dialog, .F. or not specified for an Open dialog.

* .T. to allow multiple files to be selected, .F. or not specified for a single file.

It returns a comma-separated list of files the user chose or blank if they clicked Cancel.

*** TODO: show sample code

### File and folder controls
VFPXGetFile and VFPXGetFolder are button classes in VFPXFileCtrls.vcx.

Drop a VFPXGetFile on a form, set its properties, and when the user clicks the button, a file dialog appears. Specify the control source for the control in the cResult property. If you want a method or function to execute after file selection, specify its name in the cAfterDone property. VFPXGetFile uses GetFileName.prg and VFPXCommonDialog.vcx.

VFPXGetDir is similar but it displays a folder selection dialog using GETDIR().

VFPXFile and VFPXDirectory combine a label, a textbox, and a VFPXGetFile or VFXGetDir button into a container. Both have builders (VFPXFileBuilder.prg and VFPXDirectoryBuilder.prg, but also self-contained code fired by double-clicking the Builder property in PEM Editor) that prompt for the caption of the label and adjust the position and size of the textbox and button. Both classes use SFMonitors.prg (discussed below).

## Reading from and writing to INI files
*** TODO: ReadINI.prg and WriteINI.prg

## Reading from and writing to the Windows Registry
*** TODO: VFPXRegistry.vcx and h and VFPXBaseLibrary.h
*** TODO: why better than FFC _Registry.vcx

## Uploading and downloading files
*** TODO: VFPXInternet.prg

## Zipping and unzipping files
*** TODO: VFPXZip.prg: why not VFPCompression.fll

## Others
*** TODO: SFMonitors.prg
