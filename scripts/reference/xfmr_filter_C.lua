-- BEGIN DESCRIPTION
--   File Name    : xfmr_z_BtoC.lua 
--   Version      : WindMil 8.1
--   Input        : Selection set
--   Return       : Number of elements modified
--   Description  : sets impedance C to same as impedance B.
--   Customer     : None
-- END DESCRIPTION

local changeCount = 0
PushDrawingEnabled( false )
local t = Model.getCurrentSelectionSet()

FilterCurrentSelectionSet( 'Type', 0, 'Transformer' )
FilterCurrentSelectionSet( 'Is Center Tap', 0, 'Phase C' )

PopDrawingEnabled()

