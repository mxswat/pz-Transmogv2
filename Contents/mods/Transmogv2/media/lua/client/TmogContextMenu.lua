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
	local testItem = getTestItem(items);
	if not testItem or instanceof(testItem, "InventoryContainer") then
		-- ignore if it's a tmogged backpack
		return
	end
	local scriptItem = testItem:getScriptItem()
	if scriptItem:getModuleName() ~= "TransmogV2" then
		return
	end

    local option = context:addOption("Delete Transmog", testItem, ISRemoveItemTool.removeItem, player)
	option.iconTexture = tmogIcon
end

Events.OnFillInventoryObjectContextMenu.Add(changeColorTexture);
Events.OnFillInventoryObjectContextMenu.Add(deleteTmogItems);
