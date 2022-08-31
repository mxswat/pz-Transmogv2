local function generateItemHeadText(Name, DisplayName)
    return string.format([[
        item %s
        {
            Type = Clothing,
            DisplayName = %s,
            DisplayCategory = Clothing,]], 
        Name,
        DisplayName
    )..'\n';
end

local function DoParamAndStr(item, param)
	if item then
		item:DoParam(param)
	end
	return '\t\t\t' .. param .. ',\n'
end

local function generateTransmog(sm)
    local fsWriter = getModFileWriter('Transmogv2', 'media/scripts/TransmogItems.txt', false, false)
    local function write(content)
        fsWriter:write(content)
    end
    write('/* THIS FILE IS PROGRAMATICALLY GENERATED, MANUAL CHANGES WILL BE OVERWRITTEN */\n')
    write('/* Thank you to OliPro for allowing me to base this code of his work */\n')
    write('module Transmogv2 {\n\timports { Base }\n\n')
    local allItems = sm:getAllItems()
    for i = 0, allItems:size() - 1 do
        local item = allItems:get(i);
        -- I need to use tostring, getType returns a Java Enum  
        local isClothing = tostring(item:getType()) == "Clothing"
        local isNotTransmogged = item:getModuleName() ~= "Transmogv2"
        local isWorldRender = item:isWorldRender()
        if isClothing and isNotTransmogged and isWorldRender then
            print('LogTransmogv2'..item:getFullName())
            local itemName = item:getFullName()
            local displayName  = 'Transmogged '..item:getDisplayName()
            local itemType = 'Clothing'
            local iconName = item:getIcon()
            local clothingItem = item:getClothingItem()
            -- I might not need a worldStaticItem
            local worldStaticItem = item:InstanceItem(nil):getWorldStaticItem()
            local newItem = not sm:FindItem('Transmogv2.' .. itemName) and createNewScriptItem('Transmogv2', itemName, displayName, itemType, iconName)
            -- Write after find
            local header = generateItemHeadText(itemName, displayName)
            write(header)
            write(DoParamAndStr(newItem, 'ClothingItem = ' .. clothingItem))
            write(DoParamAndStr(newItem, 'BodyLocation = Underwear'))
            write(DoParamAndStr(newItem, 'Icon = ' .. iconName))
            write(DoParamAndStr(newItem, 'Weight = 0'))
            write(DoParamAndStr(newItem, 'WorldStaticModel = ' .. tostring(worldStaticItem)))
            write('\t\t}\n\n')
        end
    end
    write('}\n')
	fsWriter:close()
end

generateTransmog(getScriptManager())
