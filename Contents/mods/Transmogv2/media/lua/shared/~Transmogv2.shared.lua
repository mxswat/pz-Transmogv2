local function generateHideBodyLocation(bodyLocation)
    return string.format([[
        item Hide_%s
        {
            Type = Clothing,
            Cosmetic = TRUE,
            DisplayName = Hide %s,
            DisplayCategory = Clothing,
            ClothingItem = Belt,
            BodyLocation = Hide_%s,
            Icon = NoseRing_Gold,
            Weight = 0,
        }]],
        bodyLocation,
        bodyLocation,
        bodyLocation
    ) .. '\n\n';
end

local function generateTmogItem(name, displayname, bodylocation, iconName)
    return string.format([[
        item %s
        {
            Type = Clothing,
            Cosmetic = TRUE,
            DisplayName = Cosmetic %s,
            DisplayCategory = Clothing,
            ClothingItem = Belt,
            BodyLocation = Transmog_%s,
            Icon = %s,
            Weight = 0,
        }]],
        name,
        displayname,
        bodylocation,
        iconName
    ) .. '\n\n';
end

local function generateTmogItemRecipe(displayName, fullName, newFullName)
    return string.format([[
        recipe Get Cosmetic %s
        {
            keep %s,

            Result:TransmogV2.%s,
            Time:30.0,
            Category:Transmog,
        }]],
        displayName,
        fullName,
        newFullName
    ) .. '\n\n';
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
        local isCosmetic = item:isCosmetic()
        if isClothing and isNotTransmogged and isWorldRender and not isCosmetic then
            local itemName    = item:getModuleName() .. '_' .. item:getName()
            local displayName = item:getDisplayName()
            local iconName    = item:getIcon()
            -- I might not need a worldStaticItem
            write(generateTmogItem(itemName, displayName, item:getBodyLocation(), iconName))
            write(generateTmogItemRecipe(displayName, item:getFullName(), itemName))
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

        write(generateHideBodyLocation(ID))
    end

    write('}\n')
    fsWriter:close()
end

generateTransmog(getScriptManager())

function ApplyItemsFix()
    local sm = getScriptManager();
    local allItems = sm:getAllItems()
    local size = allItems:size() - 1;
    print('-------START ApplyItemsFix--------')
    for i = 0, size do
        local item = allItems:get(i);
        -- I need to use tostring, getType returns a Java Enum
        local isTransmogged = item:getModuleName() == "TransmogV2"
        local nameToFind = string.gsub(item:getName(), "_", ".", 1) .. ''
        local originalItem = sm:FindItem(nameToFind)
        if isTransmogged and originalItem then
            print('nameToFind'..nameToFind)
            item:setClothingItemAsset(originalItem:getClothingItemAsset())
        end
    end

    local player = getPlayer();
    player:resetModelNextFrame();
end

Events.OnLoad.Add(ApplyItemsFix);
