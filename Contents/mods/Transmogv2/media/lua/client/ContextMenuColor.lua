require "ISInventoryPaneContextMenu"

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

local changeColor = function(player, context, items)
	local testItem = nil;
	for _, v in ipairs(items) do
		local item = v;

		if not instanceof(v, "InventoryItem") then
			item = v.items[1];
		end

		testItem = item;
	end
	if not testItem then
		return
	end
	local clothingItem = testItem:getClothingItem()
	print(tostring(clothingItem))
	if not clothingItem then
		return
	end

	if clothingItem:getAllowRandomTint() then
		context:addOption("Change Color", testItem, function(item)
			OpenMxColorPickerModal(item, ChangeItemColor)
		end);
	end

	local textureChoices = clothingItem:hasModel() and clothingItem:getTextureChoices() or clothingItem:getBaseTextures()
	if textureChoices and (textureChoices:size() > 1) then
		context:addOption("Change Texture", testItem, function(item, textureChoices)
			OpenMxTexturePickerModal(item, textureChoices, ChangeItemTexture)
		end, textureChoices);
	end

end

Events.OnFillInventoryObjectContextMenu.Add(changeColor);
