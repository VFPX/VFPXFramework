set path to Source
lnFiles = adir(laFiles, 'Source\*.*')
lcFiles = ''
for lnI = 1 to lnFiles
	lcFile = laFiles[lnI, 1]
	lcExt  = upper(justext(lcFile))
	if not inlist(lcExt, 'FXP', 'VC2')
		lcFiles = lcFiles + lcFile + ','
	endif not inlist(lcExt, 'FXP', 'VC2')
next lnI
loZIP = newobject('VFPXZip', 'VFPXZip.prg')
loZIP.Zip(lcFiles, 'FoxGet\Source.zip', .T.)
messagebox('Source.zip created')
