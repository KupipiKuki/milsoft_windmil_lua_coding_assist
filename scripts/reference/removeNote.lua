-- BEGIN DESCRIPTION
--   File Name    : Add Grid Name in Map Field.lua
--   Version      : WindMil 8.2
--   Input        : None
--   Return       : Prints the number of changes and/or errors
--   Description  : Puts the map grid name in map field
--   Customer     : ---
-- END DESCRIPTION

--[[----------------------------------------------------------------------------------------------
		GLOBAL VARIABLES
--]]----------------------------------------------------------------------------------------------

-- EDIT THESE TO CUSTOMIZE HOW YOUR SCRIPT WORKS
local NAME_UNIQUE_LENGTH = 4    -- length of name 'uniqueness', will be removed from mapName
local CURRENT_SELECTION = true -- select all elements (false) or use current selection set (true)
local RESTRICT_TYPES = false    -- set map field for all elements (false) or only set for ALLOWED_TYPEs (true)
local ALLOWED_TYPE =            -- a table of element types to generate map fields for
	{                           -- commented out types (those with -- in front) will not be set
		'Overhead',
		'Underground',
		'Consumer',
		'Transformer',
		'Device',
		'Node',
		'Motor',
		'Generator',
		'Capacitor',
		'Switch',
		'Regulator',
		'Source'
	}
-- EDIT THESE TO CUSTOMIZE HOW YOUR SCRIPT WORKS

-- Other variables used by the script
local changeCount = 0
local errCount = 0

--[[----------------------------------------------------------------------------------------------
		HELPER FUNCTIONS
--]]----------------------------------------------------------------------------------------------

function allowableType( e )
	local eType = e:elementType()
	for i=1, #ALLOWED_TYPE do
		if ALLOWED_TYPE[i] == eType then return true end
	end
	return false    
end

function updateMapField( e )
	if RESTRICT_TYPES and not allowableType( e ) then return end
	local noteName = ''
	if noteName ~= e:getElementField( 'User Data Box Template' ) then
        if e:getElementField( 'User Data Box Visible') ~= "False" then e:setElementField( 'User Data Box Visible', false ) end
		local result = e:setElementField( 'User Data Box Template', '' )
		if result == noteName then changeCount = changeCount+1
		else errCount = errCount+1 end
	end
end

--[[----------------------------------------------------------------------------------------------
		MAIN SCRIPT
--]]----------------------------------------------------------------------------------------------

PushDrawingEnabled( false )
if not CURRENT_SELECTION then SelectAll() end
local t = Model.getCurrentSelectionSetSections()
if not CURRENT_SELECTION then DeselectAll() end

local runCommand = true

if #( t ) > 1 then
    if not PromptYesNo( string.format("%d Elements selected, ould you like to continue?",#( t )) )
      then
        runCommand = false
      end
end
if runCommand then 
    for _, e in ipairs( t ) do
        updateMapField( e )
    end
end

-- GENERAL OUTPUT INFORMATION
local elemsChange = 'elements were'
local elemsError = 'elements'
if changeCount == 1 then elemsChange = 'element was' end
if errCount == 1 then elemsError = 'element' end
if changeCount == 0 and errCount == 0 then
	Alert( 'No elements needed to be changed.\n' )
--else
--  Alert ( changeCount..' '..elemsChange..' changed.\n'..errCount..' '..elemsError..' could not be changed.\n' )
end
PopDrawingEnabled()
