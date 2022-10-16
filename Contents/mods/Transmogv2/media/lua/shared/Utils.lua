function GenerateTmogItem(name, displayname, bodylocation, iconType, iconValue)
    -- Icon value if it's an array will be printed like this: "[ShirtScrubsBlue, ShirtScrubsGreen]"
    -- so I gsub it to remove the wrong parts
    iconValue = string.gsub(iconValue, "%[", "") .. ''
    iconValue = string.gsub(iconValue, ",", ";") .. ''
    iconValue = string.gsub(iconValue, "%]", "") .. ''
    return string.format([[
        item %s
        {
            DisplayCategory = Transmog,
            Type = Clothing,
            Cosmetic = TRUE,
            DisplayName = Cosmetic %s,
            ClothingItem = InvisibleItem,
            BodyLocation = Transmog_%s,
            %s = %s,
            Weight = 0,
        }]],
        name,
        displayname,
        bodylocation,
        iconType,
        iconValue
    ) .. '\n\n';
end

function GenerateHideBodyLocation(bodyLocation)
    return string.format([[
        item Hide_%s
        {
            DisplayCategory = TransmogHide,
            Type = Clothing,
            Cosmetic = TRUE,
            DisplayName = Hide %s,
            ClothingItem = InvisibleItem,
            BodyLocation = Hide_%s,
            Icon = HideClothing,
            Weight = 0,
        }]],
        bodyLocation,
        bodyLocation,
        bodyLocation
    ) .. '\n\n';
end

local locations = {
    ["ZedDmg"] = true
}
function IsBannedBodyLocation(bodylocation)
    return locations[bodylocation]
        or string.find(bodylocation, "MakeUp_")
        or string.find(bodylocation, "Transmog_")
        or string.find(bodylocation, "Hide_")
end

function IsTransmoggableClothing(item)
    local isClothing = tostring(item:getType()) == "Clothing" and not IsBannedBodyLocation(item:getBodyLocation())
    if item:getModuleName() == "TransmogV2"
        or not item:isWorldRender()
        or not isClothing
    then
        return false
    end
    return true
end

function IsTransmoggableBag(item)
    local isContainer = tostring(item:getType()) == "Container"
    if item:getModuleName() == "TransmogV2"
        or not item:isWorldRender()
        or not isContainer
    then
        return false
    end
    local canBeEquipped = item:InstanceItem(nil):canBeEquipped()
    if canBeEquipped == nil or canBeEquipped == '' then
        return false
    end
    return true
end
