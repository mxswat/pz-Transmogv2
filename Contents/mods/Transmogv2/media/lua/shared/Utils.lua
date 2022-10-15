function GenerateTmogItem(name, displayname, bodylocation, iconName)
    return string.format([[
        item %s
        {
            DisplayCategory = Transmog,
            Type = Clothing,
            Cosmetic = TRUE,
            DisplayName = Cosmetic %s,
            ClothingItem = InvisibleItem,
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

function CanThisBeTransmogged()
    
end