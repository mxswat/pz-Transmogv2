MxTexturePickerModal = MxColorPickerModal:derive("MxTexturePickerModal");

function MxTexturePickerModal:initialise()
    MxColorPickerModal.initialise(self);

    self.textureSelect = ISComboBox:new(self.colorBtn:getX(), self.colorBtn:getY(), self.colorBtn:getWidth(),
        self.colorBtn:getHeight(), self, self.onSelectTexture)
    self.textureSelect:initialise()

    local textureChoices = self.param1;
    for i = 0, textureChoices:size() - 1 do
        local text = getText("UI_ClothingTextureType", i + 1)
        self.textureSelect:addOption(text)
    end

    self.textureSelect:initialise();

    self:addChild(self.textureSelect);
    self.colorBtn:setVisible(false);
end

function MxTexturePickerModal:onSelectTexture()
    -- print(self.textureSelect.selected -1 )
    self.onSelectionCallback(self.textureSelect.selected - 1)
end

-- Direct Summon
function OpenMxTexturePickerModal(item, textureChoices, onSelectionCallback)
    local title = "Change Texture of " .. item:getName()
    local modal = MxTexturePickerModal:new(0, 0, 280, 180, title, '', nil, nil, nil, textureChoices);
    modal:initialise();
    modal:addToUIManager();
    modal:setOnSelectionCallback(function(textureIdx)
		onSelectionCallback(item, textureIdx)
	end)
end
