*==============================================================================
* Program:			VFPXGridBuilder
* Purpose:			Uses the format string on the clipboard to set up a grid's
*						columns
* Author:			Doug Hennig
* Last Revision:	10/25/2024
* Parameters:		tP1 - passed by Builder.app (ignored)
*					tP2 - passed by Builder.app (ignored)
* Returns:			none
* Environment in:	Either _cliptext or a custom GridDefinition method of the
*						selected grid contains a definition of the grid's
*						columns. Here's an example:
*
*					local lcFormat
*					text to lcFormat noshow
*					Field		|Width	|Caption	|Alignment	|InputMask	|Format	|ReadOnly	|Control
*					Invnum		|70		|Invoice #	|			|			|		|.T.		|
*					Date		|70		|Date		|			|			|		|.T.		|
*					Name		|*		|Project	|			|			|		|.T.		|
*					Amount		|60		|Amount		|R			|99,999.99	|		|.T.		|
*					Paid		|70		|Paid		|			|			|		|			|Checkbox
*					DatePaid	|70		|Date Paid	|			|			|		|			|
*					Received	|60		|Received	|R			|99,999.99	|		|			|
*					endtext
*					return lcFormat
*
*					- The format settings must have a header row like in the
*						example but the order of the settings is unimportant
*						and all but Field and Caption are optional (the setting
*						names are read from the header)
*					- Separate columns with tabs or spaces and a pipe
*					- Use an empty setting for an unspecified value
*					- Use "*" for Width to "auto-size" a column; that is, size
*						it to the rest of the space after the other columns are
*						sized
*					- Alignment can be specified as 0 or L for left, 1 or R for
*						right, and 2 or C for center
*					- Currently only Checkbox, CommandButton, and Combobox are
*						supported for Control
* Environment out:	the selected grid has been formatted
*==============================================================================

#define ccTAB chr(9)

lparameters tP1, tP2
local laObjects[1], ;
	lnObjects, ;
	lnI, ;
	loObject, ;
	lcCode, ;
	lcFormat

* Format the first grid we find with the specified format.

lnObjects = aselobj(laObjects)
for lnI = 1 to lnObjects
	loObject = laObjects[lnI]
	if lower(loObject.BaseClass) = 'grid'
		if pemstatus(loObject, 'GridDefinition', 5)
			lcCode = loObject.ReadMethod('GridDefinition')
			if '|' $ lcCode
				lcFormat = execscript(lcCode)
			else
				lcFormat = ''
			endif '|' $ lcCode
		else
			lcFormat = _cliptext
		endif pemstatus(loObject ...
		if not '|' $ lcFormat
			messagebox('Please put the format on the clipboard.', 0 + 16, ;
				'Grid Builder')
			return
		endif not '|' $ lcFormat
		SetupGrid(loObject, lcFormat)
		exit
	endif lower(loObject.BaseClass) = 'grid'
next lnI

procedure SetupGrid(toGrid, tcColumns)
local laColumns[1], ;
	lnColumns, ;
	lnI, ;
	laSettings[1], ;
	lnSettings, ;
	lnFieldColumn, ;
	lnWidthColumn, ;
	lnCaptionColumn, ;
	lnAlignmentColumn, ;
	lnInputMaskColumn, ;
	lnFormatColumn, ;
	lnReadOnlyColumn, ;
	lnControlColumn, ;
	lcSetting, ;
	lcAlias, ;
	lcFontName, ;
	lnFontSize, ;
	lnWidth, ;
	lnJ, ;
	loColumn, ;
	lcAlignment, ;
	loObject, ;
	loHeader, ;
	lcControl, ;
	lcWidth, ;
	loAutoSize, ;
	lnNewWidth

* First, strip any leading *.

lnColumns = alines(laColumns, strtran(tcColumns, ccTAB))
for lnI = 1 to lnColumns
	if left(laColumns[lnI], 1) = '*'
		laColumns[lnI] = substr(laColumns[lnI], 2)
	endif left(laColumns[lnI], 1) = '*'
next lnI
lnColumns = lnColumns - 1

* Get the property names from the header row then remove it.

lnSettings = alines(laSettings, laColumns[1], 0, '|')
store 0 to lnFieldColumn, lnWidthColumn, lnCaptionColumn, lnAlignmentColumn, ;
	lnInputMaskColumn, lnFormatColumn, lnReadOnlyColumn, lnControlColumn
for lnI = 1 to lnSettings
	lcSetting = upper(alltrim(laSettings[lnI]))
	do case
		case lcSetting = 'FIELD'
			lnFieldColumn = lnI
		case lcSetting = 'WIDTH'
			lnWidthColumn = lnI
		case lcSetting = 'CAPTION'
			lnCaptionColumn = lnI
		case lcSetting = 'ALIGNMENT'
			lnAlignmentColumn = lnI
		case lcSetting = 'INPUTMASK'
			lnInputMaskColumn = lnI
		case lcSetting = 'FORMAT'
			lnFormatColumn = lnI
		case lcSetting = 'READONLY'
			lnReadOnlyColumn = lnI
		case lcSetting = 'CONTROL'
			lnControlColumn = lnI
	endcase
next lnI
if lnFieldColumn > 0 and lnCaptionColumn > 0
	adel(laColumns, 1)
	dimension laColumns[lnColumns]

* Process each row in the definition.

	with toGrid
		.ColumnCount = 0
			&& remove exist columns
		.ColumnCount = lnColumns
		lcAlias      = iif(empty(.RecordSource), '', .RecordSource + '.')
		lcFontName   = .FontName
		lnFontSize   = .FontSize
		lnWidth      = 0
		for lnI = 1 to lnColumns
			lnSettings = alines(laSettings, laColumns[lnI], 2, '|')
			for lnJ = 1 to lnSettings
				laSettings[lnJ] = alltrim(laSettings[lnJ])
			next lnI
			loColumn = .Columns[lnI]
			with loColumn
				.ControlSource = lcAlias + laSettings[lnFieldColumn]
				.FontName      = lcFontName
				.FontSize      = lnFontSize
				if lnInputMaskColumn > 0
					.InputMask = laSettings[lnInputMaskColumn]
				endif lnInputMaskColumn > 0
				if lnFormatColumn > 0
					.Format = laSettings[lnFormatColumn]
				endif lnFormatColumn > 0
				if lnReadOnlyColumn > 0
					.ReadOnly = laSettings[lnReadOnlyColumn] = '.T.'
				endif lnReadOnlyColumn > 0
				if lnAlignmentColumn > 0
					lcAlignment = laSettings[lnAlignmentColumn]
					do case
						case lcAlignment = '0' or lcAlignment = 'L' or ;
							empty(lcAlignment)
							.Alignment = 0
						case lcAlignment = '1' or lcAlignment = 'R'
							.Alignment = 1
						case lcAlignment = '2' or lcAlignment = 'C'
							.Alignment = 2
					endcase
				endif lnAlignmentColumn > 0

* Find the header and set its properties.

				if lnCaptionColumn > 0
					for each loObject in loColumn.Controls foxobject
						if upper(loObject.BaseClass) = 'HEADER'
							loHeader = loObject
							exit
						endif upper(loObject.BaseClass) = 'HEADER'
					next loObject
					loHeader.Caption   = laSettings[lnCaptionColumn]
					loHeader.FontName  = lcFontName
					loHeader.FontSize  = lnFontSize
					loHeader.Alignment = .Alignment
				endif lnCaptionColumn > 0

* Handle a custom control.

				if lnControlColumn > 0
					lcControl = upper(laSettings[lnControlColumn])
					do case
						case empty(lcControl)
						case upper(lcControl) = 'CHECKBOX' and ;
							type('.Checkbox1') <> 'O'
							&& Only add it the first time
							.AddObject('Checkbox1', 'Checkbox')
							.CurrentControl    = 'Checkbox1'
							.Sparse            = .F.
							.Checkbox1.Visible = .T.
							.Checkbox1.Caption = ''
							if .Alignment = 2	&& centered
								.Checkbox1.Alignment = 2
								.Checkbox1.Centered  = .T.
							endif .Alignment = 2
						case upper(lcControl) = 'COMMANDBUTTON' and ;
							type('.Command1') <> 'O'
							&& Only add it the first time
							.AddObject('Command1', 'CommandButton')
							.CurrentControl    = 'Command1'
							.Sparse            = .F.
							.Command1.Visible = .T.
							.Command1.Caption = alltrim(laSettings[lnCaptionColumn])
							if .Alignment = 2	&& centered
								.Command1.Alignment = 2
							endif .Alignment = 2
						case upper(lcControl) = 'COMBOBOX' and ;
							type('.Combo1') <> 'O'
							&& Only add it the first time
							.AddObject('Combo1', 'ComboBox')
							.CurrentControl = 'Combo1'
							.Sparse         = .F.
							.Combo1.Visible = .T.
* Note: other classes could be handled here
					endcase
				endif lnControlColumn > 0

* If the width is "*", we'll auto-size this column.

				if lnWidthColumn > 0
					lcWidth = laSettings[lnWidthColumn]
					if lcWidth = '*'
						loAutoSize = loColumn
					else
						.Width  = val(lcWidth)
						lnWidth = lnWidth + .Width
					endif lcWidth = '*'
				endif lnWidthColumn > 0
			endwith
		next lnI

* Set the width for an auto-width column.

		if vartype(loAutoSize) = 'O'
			lnNewWidth = .Width - lnWidth - .ColumnCount - 1 - ;
				iif(.ScrollBars > 1, sysmetric(5), 0) - ;
				iif(.RecordMark, 10, 0) - ;
				iif(.DeleteMark, 10, 2)
			if lnNewWidth > 0
				loAutoSize.Width = lnNewWidth
			endif lnNewWidth > 0
		endif vartype(loAutoSize) = 'O'
	endwith
else
	messagebox('The format string for the grid is invalid.', 0 + 16, ;
		'Grid Builder')
endif lnFieldColumn > 0 ...
