MxColorPickerModal = ISTextBox:derive("MxColorPickerModal");

function MxColorPickerModal:initialise()
    ISTextBox.initialise(self);

    local inset = 2
    local height = inset + self.fontHgt * self.numLines + inset
    self:removeChild(self.colorBtn);
    self.colorBtn = ISButton:new(self.entry.x + self.entry.width + 5, self.entry.y, height, height, "", self, MxColorPickerModal.onColorPicker);
    self.colorBtn:setX(self.entry:getX());
    self.colorBtn:setWidth(self.entry:getWidth());
    self.colorBtn:initialise();
    self.colorBtn.backgroundColor = {r = 1, g = 1, b = 1, a = 1};
    self:addChild(self.colorBtn);
    self.colorBtn:setVisible(true);
    self.entry:setVisible(false);

    self.yes:setTitle("Close")
    self:removeChild(self.no);
end

function MxColorPickerModal:setOnSelectionCallback(functionCallback)
    self.onSelectionCallback = functionCallback
end

function MxColorPickerModal:onColorPicker(button)
    self.colorPicker:setX(getMouseX() - 100);
    self.colorPicker:setY(getMouseY() - 20);
    self.colorPicker.pickedFunc = MxColorPickerModal.OnSelection;
    self.colorPicker:setVisible(true);
    self.colorPicker:bringToTop();
end

function MxColorPickerModal:OnSelection(color, mouseUp)
    self.currentColor = ColorInfo.new(color.r, color.g, color.b,1);
    self.colorBtn.backgroundColor = {r = color.r, g = color.g, b = color.b, a = 1};
    self.entry.javaObject:setTextColor(self.currentColor);
    self.colorPicker:setVisible(false);
    if self.onSelectionCallback ~= nil then
        local color = Color.new(color.r, color.g, color.b,1);
        self.onSelectionCallback(color)
    end
end

function OpenMxColorPickerModal(item, onSelectionCallBack)
    local item = item
	local modal = MxColorPickerModal:new(0, 0, 280, 180, "Change color of " .. item:getName(), '');
	modal:initialise();
	modal:addToUIManager();
	modal:setOnSelectionCallback(function(color)
		onSelectionCallBack(color, item)
	end)
end