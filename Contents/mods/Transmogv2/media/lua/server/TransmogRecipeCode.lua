TransmogV2Recipe = TransmogV2Recipe or {}

local function getItem(inputItems)
    for i = 0, (inputItems:size() - 1) do
        local item = inputItems:get(i);
        return item
    end
end

local function printError(player, text)
    HaloTextHelper.addText(player, text, HaloTextHelper.getColorWhite())
end

function TransmogV2Recipe.GetTransmoggableClothing(scriptItems)
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

function TransmogV2Recipe.GetTransmogClothing(inputItems, resultItem, player)
    local item = getItem(inputItems)
    if not item then
        return
    end

    local scriptItem = item:getScriptItem()
    local TmogItemName = "TransmogV2." .. scriptItem:getModuleName() .. '_' .. scriptItem:getName()
    local newTmogItem = InventoryItemFactory.CreateItem(TmogItemName)
    if not newTmogItem then
        printError(player, 'The "Cosmetic" item is missing, check if the TransmogItems.txt is generated')
        print('Error TransmogV2Recipe.GetTransmogClothing')
        return
    end
    newTmogItem:setName("Cosmetic " .. tostring(item:getDisplayName()));
    newTmogItem:setCustomName(true);
    player:getInventory():AddItem(newTmogItem);
end

function TransmogV2Recipe.GetHideClothing(inputItems, resultItem, player)
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
        print('Error TransmogV2Recipe.GetHideClothing')
        return
    end

    player:getInventory():AddItem(newTmogItem);
end
