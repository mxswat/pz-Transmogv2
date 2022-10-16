local function getItem(inputItems)
    for i = 0, (inputItems:size() - 1) do
        local item = inputItems:get(i);
        return item
    end
end

local function printError(player, text)
    HaloTextHelper.addText(player, text, HaloTextHelper.getColorRed())
end

function GetTransmoggableClothing(scriptItems)
    local allScriptItems = getScriptManager():getAllItems();
    for i = 1, allScriptItems:size() do
        local item = allScriptItems:get(i - 1);

        local isClothing = tostring(item:getType()) == "Clothing"
        local isNotTransmogged = item:getModuleName() ~= "TransmogV2"
        local isWorldRender = item:isWorldRender()
        local isCosmetic = item:isCosmetic()
        if isClothing and isNotTransmogged and isWorldRender and not isCosmetic then
            scriptItems:add(item);
        end
    end
end

function GetTransmogClothing(inputItems, resultItem, player)
    local item = getItem(inputItems)
    if not item then
        return
    end

    local scriptItem = item:getScriptItem()
    local TmogItemName = "TransmogV2." .. scriptItem:getModuleName() .. '_' .. scriptItem:getName()
    local newTmogItem = InventoryItemFactory.CreateItem(TmogItemName)
    if not newTmogItem then
        printError(player, 'The "Cosmetic" item is missing, check if the TransmogItems.txt is generated')
        print('Error GetTransmogClothing')
        return
    end
    newTmogItem:setName("Cosmetic " .. tostring(item:getDisplayName()));
    newTmogItem:setCustomName(true);
    player:getInventory():AddItem(newTmogItem);
end

function GetHideClothing(inputItems, resultItem, player)
    local item = getItem(inputItems)
    if not item then
        return
    end

    local scriptItem = item:getScriptItem()
    local bodyLocation = scriptItem:getBodyLocation()

    local TmogHideItemName = "TransmogV2.Hide_" .. bodyLocation
    local newTmogItem = InventoryItemFactory.CreateItem(TmogHideItemName)
    if not newTmogItem then
        printError(player, 'The "Hide" items is missing, check if the TransmogItems.txt is generated')
        print('Error GetHideClothing')
        return
    end

    player:getInventory():AddItem(newTmogItem);
end

function GetHideableBags(scriptItems)
    local allScriptItems = getScriptManager():getAllItems();
    for i = 1, allScriptItems:size() do
        local item = allScriptItems:get(i - 1);

        local isContainer = tostring(item:getType()) == "Container"
        local isNotTransmogged = item:getModuleName() ~= "TransmogV2"

        if isNotTransmogged and isContainer and item:InstanceItem(nil):canBeEquipped() == "Back" then
            scriptItems:add(item);
        end
    end
end

function GetInvisibleBag(inputItems, _, player)
    local item = getItem(inputItems)
    if not item then
        return
    end

    if item:getInventory():getItems():size() > 0 then    
        printError(player, "The Bag MUST be empty!")
        return
    end

    
    local resultItem = player:getInventory():AddItem("TransmogV2.Bag_InvisibleBag")
    resultItem:setItemCapacity(item:getItemCapacity());
    resultItem:setCapacity(item:getCapacity());
    resultItem:setWeightReduction(item:getWeightReduction());
    resultItem:setActualWeight(item:getWeight());
    resultItem:setName("Hidden "..item:getName());
    
    local modData = resultItem:getModData()
    modData["TmogOriginalName"] = item:getScriptItem():getFullName()

    player:getInventory():Remove(item)
end

function GetOriginalBagBack(inputItems, resultItem, player)
    local item = getItem(inputItems)
    if not item then
        return
    end

    if item:getInventory():getItems():size() > 0 then    
        printError(player, "The Bag MUST be empty!")
        return
    end

    local originalName = item:getModData()["TmogOriginalName"]
    player:getInventory():AddItem(originalName)
    player:getInventory():Remove(item)
end
