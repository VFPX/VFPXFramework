*==============================================================================
* Function:			GetFilesInFolder
* Purpose:			Fills an array with the filenames in the specified folder
*						and all subdirectories
* Author:			Doug Hennig
* Last revision:	11/05/2024
* Parameters:		taFiles  - an array to contain the filenames (passed by
*						reference)
*					tcFolder - the folder to get the files in
* Returns:			the number of files
* Environment in:	GetProperFileCase is available to be called
* Environment out:	see GetProperFileCase
*==============================================================================

lparameters taFiles, ;
	tcFolder
local lcFolder, ;
	laFiles[1], ;
	lnFiles, ;
	lnExisting, ;
	lnI, ;
	laFolders[1], ;
	lnFolders, ;
	lcCurrFolder
lcFolder   = GetProperFileCase(addbs(tcFolder))
lnFiles    = adir(laFiles, lcFolder + '*.*', '', 1)
lnExisting = alen(taFiles)
lnExisting = iif(lnExisting = 1, 0, lnExisting)
if lnExisting + lnFiles > 0
	dimension taFiles[lnExisting + lnFiles]
	for lnI = 1 to lnFiles
		taFiles[lnExisting + lnI] = lcFolder + laFiles[lnI, 1]
	next lnI
endif lnExisting + lnFiles > 0
lnFolders = adir(laFolders, lcFolder + '*.*', 'D', 1)
for lnI = 1 to lnFolders
	lcCurrFolder = laFolders[lnI, 1]
	if 'D' $ laFolders[lnI, 5] and left(lcCurrFolder, 1) <> '.'
		GetFilesInFolder(@taFiles, lcFolder + lcCurrFolder)
	endif 'D' $ laFolders[lnI, 5] ...
next lnI
return alen(taFiles, 1)
