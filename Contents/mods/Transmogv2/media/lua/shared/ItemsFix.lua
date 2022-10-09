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
            -- Needed because I need to add a dummy clothing asset
            -- Otherwise zombies will spawn with cosmetics, this is a PZ limitation of the loot tables
            item:setClothingItemAsset(originalItem:getClothingItemAsset())
        end
    end

    -- Good old trick to force the refresh
    local player = getPlayer();
    player:resetModelNextFrame();
end

function UpdateBodyLocations()
    print('UpdateBodyLocations')
    local group = BodyLocations.getGroup("Human")
    group:getOrCreateLocation("Transmog_OutfitBagOne")
    group:getOrCreateLocation("Transmog_OutfitBagTwo")
end

Events.OnLoad.Add(ApplyItemsFix);
Events.OnGameStart.Add(UpdateBodyLocations)