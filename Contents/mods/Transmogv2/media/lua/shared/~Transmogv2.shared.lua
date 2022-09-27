local function generateItemHeadText(Name, DisplayName)
    -- Cosmetic = TRUE Disables the tooltip for insulation and shit
    return string.format([[
        item %s
        {
            Type = Clothing,
            Cosmetic = TRUE,
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
    local fsWriter = getModFileWriter('TransmogV2', 'media/scripts/TransmogItems.txt', false, false)
    local function write(content)
        fsWriter:write(content)
    end
    write('/* THIS FILE IS PROGRAMATICALLY GENERATED, MANUAL CHANGES WILL BE OVERWRITTEN */\n')
    write('/* Thank you to OliPro for allowing me to base this code of his work */\n')
    write('module TransmogV2 {\n\timports { Base }\n\n')
    local allItems = sm:getAllItems()
    local size = allItems:size() - 1;
    print('-------START Generate LogTransmogV2--------')
    for i = 0, size do
        local item = allItems:get(i);
        -- I need to use tostring, getType returns a Java Enum  
        local isClothing = tostring(item:getType()) == "Clothing"
        local isNotTransmogged = item:getModuleName() ~= "TransmogV2"
        local isWorldRender = item:isWorldRender()
        if isClothing and isNotTransmogged and isWorldRender then
            local itemName = item:getName()..'_'..item:getModuleName()
            local displayName  = 'Cosmetic '..item:getDisplayName()
            local itemType = 'Clothing'
            local iconName = item:getIcon()
            local clothingItem = item:getClothingItem()
            -- I might not need a worldStaticItem
            local newItem = not sm:FindItem('TransmogV2.' .. itemName) and createNewScriptItem('TransmogV2', itemName, displayName, itemType, iconName)
            -- Write after find
            local header = generateItemHeadText(itemName, displayName)
            write(header)
            write(DoParamAndStr(newItem, 'ClothingItem = ' .. clothingItem))
            write(DoParamAndStr(newItem, 'BodyLocation = Transmog_'..item:getBodyLocation()))
            write(DoParamAndStr(newItem, 'Icon = ' .. iconName))
            write(DoParamAndStr(newItem, 'Weight = 0'))
            -- local worldStaticItem = item:InstanceItem(nil):getWorldStaticItem()
            -- write(DoParamAndStr(newItem, 'WorldStaticModel = ' .. tostring(worldStaticItem)))
            write('\t\t}\n\n')
        end
    end
    write('}\n')
	fsWriter:close()
end

generateTransmog(getScriptManager())
