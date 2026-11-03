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

local prompt = GetGridEditPromptStatus()
for _, e in ipairs( t ) do
    if prompt then
        local result = MultipleChoice( e:name()..' Input COnfiguration will be set to BC', {'Change', 'Skip', 'Change All', 'Skip All'} )
        if result == 3 then
            prompt = false
        elseif result == 4 then
            break
        end
        if result ~= 2 then
            e:setElementField( 'Transformer Input Config', 'BC' )
            changeCount = changeCount+1
        end
    else
        e:setElementField( 'Transformer Input Config', 'BC' )
        changeCount = changeCount+1
    end
end
local p = ' elements '
if changeCount == 1 then p = ' element ' end
Alert( 'The configuration of '..changeCount..p..'were changed.' )
PopDrawingEnabled()

-- dynamic descriptions must be placed at the end of file
function dynamic_description()
	local description = 'This utility will set Tranformer Input Config to BC' ..
        'ONLY PERFORM THIS OPERATION IF YOU '..
		'ARE SURE THE MAP NAME OF EACH SELECTED SECTION IS UNIQUE!!!!!'
	return description
end
