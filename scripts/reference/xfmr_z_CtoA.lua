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
	local secName = e:getElementField( 'Transformer Impedance C' )
	local mapName = e:getElementField( 'Transformer Impedance A' )
	if not mapName then -- map points have a nil 'Map Name'
		if prompt then
			local result = MultipleChoice( 'Transformer Impedance A will be set to '..
						secName..'.', {'Change', 'Skip', 'Change All', 'Skip All'} )
			if result == 3 then
				prompt = false
			elseif result == 4 then
				break
			end
			if result ~= 2 then
				e:setElementField( 'Transformer Impedance A', secName )
				changeCount = changeCount+1
			end
		else
			e:setElementField( 'Transformer Impedance A', secName )
			changeCount = changeCount+1
		end
    elseif not secName then -- map points have a nil 'Map Name'
		if prompt then
			local result = MultipleChoice( 'Transformer Impedance C will be set to '..
						mapName..'.', {'Change', 'Skip', 'Change All', 'Skip All'} )
			if result == 3 then
				prompt = false
			elseif result == 4 then
				break
			end
			if result ~= 2 then
				e:setElementField( 'Transformer Impedance C', mapName )
				changeCount = changeCount+1
			end
		else
			e:setElementField( 'Transformer Impedance C', mapName )
			changeCount = changeCount+1
		end
	end
end
local p = ' elements '
if changeCount == 1 then p = ' element ' end
Alert( 'The names of '..changeCount..p..'were swapped.' )
PopDrawingEnabled()

-- dynamic descriptions must be placed at the end of file
function dynamic_description()
	local description = 'This utility will set Tranformer Impedance C to ' ..
        'Transformer Impedance B if Transformer Impedance C is nil.  ONLY PERFORM THIS OPERATION IF YOU '..
		'ARE SURE THE MAP NAME OF EACH SELECTED SECTION IS UNIQUE!!!!!'
	return description
end
