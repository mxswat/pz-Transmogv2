require "Utils"

function GenerateTransmog(modID)
    local sm = getScriptManager()
    local fsWriter = getModFileWriter(modID, 'media/scripts/TransmogItems.txt', false, false)
    local function write(content)
        fsWriter:write(content)
    end

    write('/* THIS FILE IS PROGRAMATICALLY GENERATED, MANUAL CHANGES WILL BE OVERWRITTEN */\n')
    write('/* Thank you to OliPro for allowing me to base this code of his work */\n')
    write('module TransmogV2 {\n\timports { Base }\n\n')
    local allItems = sm:getAllItems()
    local size = allItems:size() - 1;
    print('-------START Generation of TransmogItems.txt for mod ' .. modID .. '--------')
    for i = 0, size do
        local item = allItems:get(i);
        -- I need to use tostring, getType returns a Java Enum
        local isClothing = tostring(item:getType()) == "Clothing"
        local isNotTransmogged = item:getModuleName() ~= "TransmogV2"
        local isWorldRender = item:isWorldRender()
        if isClothing and isNotTransmogged and isWorldRender and not IsBannedBodyLocation(item:getBodyLocation()) then
            local itemName = item:getModuleName() .. '_' .. item:getName()
            local iconName = item:getIcon()
            write(GenerateTmogItem(itemName, itemName, item:getBodyLocation(), iconName))
        end
    end

    print('-------START Generate BodyLocations--------')

    write('\n\t\t/* Hide BodyLocations */\n\n')

    local group = BodyLocations.getGroup("Human")
    local allLoc = group:getAllLocations();
    local allLocSize = allLoc:size() - 1
    group:getOrCreateLocation("Hide_Everything")

    for i = 0, allLocSize do
        local bodyLocID = allLoc:get(i):getId()
        if not IsBannedBodyLocation(bodyLocID) then
            group:getOrCreateLocation("Hide_" .. bodyLocID)
            group:setHideModel("Hide_" .. bodyLocID, bodyLocID)
            group:setHideModel("Hide_Everything", bodyLocID)
            group:getOrCreateLocation("Transmog_" .. bodyLocID);

            write(GenerateHideBodyLocation(bodyLocID))
        end
    end

    write('}\n')
    fsWriter:close()

    print('-------END TransmogV2 Done--------')
end
