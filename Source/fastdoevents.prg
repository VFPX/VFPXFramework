*==============================================================================
* Function:			FastDoEvents
* Purpose:			Performs a DOEVENTS after creating an event so it performs
*						faster
* Author:			Doug Hennig, from ideas publish by David Frankenbach
* Last revision:	07/15/2002
* Parameters:		none
* Returns:			.T.
* Environment in:	none
* Environment out:	DOEVENTS has been performed
*==============================================================================

local lcWindow, ;
	lnRow, ;
	lnCol, ;
	lnRowVFP, ;
	lnColVFP
lcWindow = wontop()
lnRow    = mrow(lcWindow)
lnCol    = mcol(lcWindow)
lnRowVFP = mrow('')
lnColVFP = mcol('')
do case

* If the mouse is over a window, keep it there.

*** Problem: issuing mouse events makes mouse jerky during a long loop
***	case not empty(lcWindow) and lnRow > 0 and lnCol > 0
***		mouse at lnRow, lnCol window (lcWindow)

* If the mouse is over the VFP window, keep it there.

***	case lnRowVFP > 0 and lnColVFP > 0
***		mouse at lnRowVFP, lnColVFP

* Generate a keyboard event.

	otherwise
		keyboard ' '
		inkey()
***inkey(0.001, 'H')
endcase

* Issue the DOEVENTS.

doevents

* VFP 7 and later seem to need this.

inkey(0.001, 'H')
