require "GenerateTransmog"

Events.OnGameBoot.Add(function ()
    GenerateTransmog('TransmogV2Default')
end);