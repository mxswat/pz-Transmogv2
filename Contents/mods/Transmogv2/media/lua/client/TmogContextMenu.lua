require "ISInventoryPaneContextMenu"
require "Modals/MxColorPicker"
require "Modals/MxTexturePicker"

local tmogIcon = getTexture("media/ui/TransmogIcon.png")

function ChangeItemColor(color, item)
	item:getVisual():setTint(ImmutableColor.new(color));
	item:setColor(color);
	item:setCustomColor(true)

	local player = getPlayer();
	player:resetModelNextFrame();
end

function ChangeItemTexture(item, textureIdx)
	item:getVisual():setTextureChoice(textureIdx)
	local player = getPlayer();
	player:resetModelNextFrame();
end

local function getTestItem(items)
	for _, v in ipairs(items) do
		local item = v;

		if not instanceof(v, "InventoryItem") then
			item = v.items[1];
		end

		return item
	end
end

local changeColorTexture = function(player, context, items)
	local testItem = getTestItem(items);
	if not testItem then
		return
	end
	local clothingItem = testItem:getClothingItem()
	if not clothingItem then
		return
	end

	if clothingItem:getAllowRandomTint() then
		local option = context:addOption("Change Color", testItem, function(item)
			OpenMxColorPickerModal(item, ChangeItemColor)
		end);
		option.iconTexture = tmogIcon
	end

	local textureChoices = clothingItem:hasModel() and clothingItem:getTextureChoices() or clothingItem:getBaseTextures()
	if textureChoices and (textureChoices:size() > 1) then
		local option = context:addOption("Change Texture", testItem, function(item, textureChoices)
			OpenMxTexturePickerModal(item, textureChoices, ChangeItemTexture)
		end, textureChoices);
		option.iconTexture = tmogIcon
	end
end

local function deleteTmogItems(player, context, items)
	local resItems = {}

	local function addToDeleteList(item)
		local scriptItem = item:getScriptItem()
		local moddata = item:getModData() and item:getModData() or {}
		if scriptItem:getModuleName() == "TransmogV2" and not moddata["TmogOriginalName"] then
			resItems[item] = true
		end
	end

	for _, v in ipairs(items) do
		if not instanceof(v, "InventoryItem") then
			-- Do notthing I guess`
			for _, it in ipairs(v.items) do
                addToDeleteList(it)
            end
		else
			addToDeleteList(v)
		end
	end

	local listItems = {}
    for v, _ in pairs(resItems) do
        table.insert(listItems, v)
    end

	if #listItems <= 0 then
		return
	end

	local name = "Delete " .. tostring(#listItems) .. " Transmog"
	local option = context:addOption(name, listItems, ISRemoveItemTool.removeItems, player)
	option.iconTexture = tmogIcon
end

Events.OnFillInventoryObjectContextMenu.Add(changeColorTexture);
Events.OnFillInventoryObjectContextMenu.Add(deleteTmogItems);
