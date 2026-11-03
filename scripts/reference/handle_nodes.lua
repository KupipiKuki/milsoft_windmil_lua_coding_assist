-- BEGIN DESCRIPTION
--   File Name    : handle_nodes.lua 
--   Version      : WindMil 8.1
--   Input        : Selection set
--   Return       : Number of elements modified
--   Description  : Handles fake nodes created due to open delta transformers.
--   Customer     : None
-- END DESCRIPTION

local changeCount = 0
PushDrawingEnabled( false )

FilterCurrentSelectionSet( 'Type', 0, 'Node' )

local t = Model.getCurrentSelectionSet()

local prompt = GetGridEditPromptStatus()
local parentName = ''
local xfmrName = ''
local ODxfmrName = ''
local children = {}
local enProcess = false
local nodeProcess = false

for _, e in ipairs( t ) do
    if prompt then
        enProcess=false
        local result = MultipleChoice( e:name()..' Parents', {'Change', 'Skip', 'Change All', 'Skip All'} )
        if result == 3 then
            prompt = false
        elseif result == 4 then
            break
        end
        if result ~= 2 then
            enProcess=true
        end
    end
    if enProcess then
        
        tb = {'Multi-Parent A','Multi-Parent B','Multi-Parent C'}
        for i = 1,3 do
            parentName = e:getElementField( tb[i] )
            if string.find(parentName, 'tran_') then
                xfmrName=parentName
                nodeProcess = true
                -- children=e:getElementField( 'Children' )
                children=e:children()
            else
                ODxfmrName = parentName
            end
        end
        if nodeProcess then
            print('\n',e:name(),'\n')
            print(ODxfmrName,'\n')
            print(xfmrName,'\n')
            et = Model.getElementFromName( ODxfmrName )
            edt = Model.getElementFromName( xfmrName )
            for _,c in ipairs(children) do
                if c then
                    print(c:name())
                    c:open()
                    c:connect(et)
                end
            end
            e:delete()
            edt:delete()
            children = {}
            nodeProcess = false
        end
        parentName = ''
        xfmrName=''
        ODxfmrName=''
    end
    enProcess = true
end
local p = ' elements '
if changeCount == 1 then p = ' element ' end
Alert( 'The configuration of '..changeCount..p..'were changed.' )
PopDrawingEnabled()

-- dynamic descriptions must be placed at the end of file
function dynamic_description()
	local description = 'This utility will set Tranformer Input Config to AC' ..
        'ONLY PERFORM THIS OPERATION IF YOU '..
		'ARE SURE THE MAP NAME OF EACH SELECTED SECTION IS UNIQUE!!!!!'
	return description
end
