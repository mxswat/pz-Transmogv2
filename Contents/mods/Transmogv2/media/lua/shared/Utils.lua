function GenerateHideBodyLocation(bodyLocation)
    return string.format([[
        item Hide_%s
        {
            Type = Clothing,
            Cosmetic = TRUE,
            DisplayName = Hide %s,
            DisplayCategory = Clothing,
            ClothingItem = Belt,
            BodyLocation = Hide_%s,
            Icon = NoseRing_Gold,
            Weight = 0,
        }]],
        bodyLocation,
        bodyLocation,
        bodyLocation
    ) .. '\n\n';
end

function GenerateTmogItem(name, displayname, bodylocation, iconName)
    return string.format([[
        item %s
        {
            Type = Clothing,
            Cosmetic = TRUE,
            DisplayName = Cosmetic %s,
            DisplayCategory = Clothing,
            ClothingItem = Belt,
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

function GenerateTmogItemRecipe(displayName, fullName, newFullName)
    return string.format([[
        recipe Get Cosmetic %s
        {
            keep %s,

            Result:TransmogV2.%s,
            Time:30.0,
            Category:Transmog,
        }]],
        displayName,
        fullName,
        newFullName
    ) .. '\n\n';
end

function GenerateTmogHideRecipe(displayName, fullName, bodyLocation)
    return string.format([[
        recipe Hide %s
        {
            keep %s,

            Result:TransmogV2.Hide_%s,
            Time:30.0,
            Category:Transmog,
        }]],
        displayName,
        fullName,
        bodyLocation
    ) .. '\n\n';
end