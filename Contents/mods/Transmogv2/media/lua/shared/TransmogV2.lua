require "Utils"

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
        local isCosmetic = item:isCosmetic()
        if isClothing and isNotTransmogged and isWorldRender and not isCosmetic then
            local itemName    = item:getModuleName() .. '_' .. item:getName()
            local displayName = item:getDisplayName()
            local iconName    = item:getIcon()
            -- I might not need a worldStaticItem
            write(GenerateTmogItem(itemName, displayName, item:getBodyLocation(), iconName))
            write(GenerateTmogItemRecipe(displayName, item:getFullName(), itemName))
            write(GenerateTmogHideRecipe(displayName, item:getFullName(), item:getBodyLocation()))
        end
    end

    local group = BodyLocations.getGroup("Human")
    local allLoc = group:getAllLocations();
    local allLocSize = allLoc:size() - 1

    print('-------START Generate BodyLocations--------')

    write('\n\t\t/* Hide BodyLocations */\n\n')

    for i = 0, allLocSize do
        local ID = allLoc:get(i):getId()
        group:getOrCreateLocation("Hide_" .. ID)
        group:setHideModel("Hide_" .. ID, ID)
        group:getOrCreateLocation("Transmog_" .. ID);

        write(GenerateHideBodyLocation(ID))
    end

    write('}\n')
    fsWriter:close()
end

generateTransmog(getScriptManager())
