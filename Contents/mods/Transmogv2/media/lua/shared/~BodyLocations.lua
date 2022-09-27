local group = BodyLocations.getGroup("Human")
local allLoc = group:getAllLocations();
local allLocSize = allLoc:size() - 1

for i = 0, allLocSize do
    local ID = allLoc:get(i):getId()
    print('BodyLocations: '..allLoc:get(i):getId());
    group:getOrCreateLocation("Hide_"..ID)
    group:setHideModel("Hide_"..ID, ID)
    group:getOrCreateLocation("Transmog_"..ID);
end
