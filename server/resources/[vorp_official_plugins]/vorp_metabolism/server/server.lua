local VorpCore = {}

CreateThread(function()
    TriggerEvent("getCore", function(core)
        VorpCore = core;
    end)
    RegisterUsableItemsAsync()
end)

RegisterNetEvent("vorpmetabolism:SaveLastStatus", function(status)
    local _source = source
    local UserCharacter = VorpCore.getUser(_source).getUsedCharacter
    UserCharacter.setStatus(status)
end)
RegisterNetEvent("vorpmetabolism:GetStatus", function()
    local _source = source
    local UserCharacter = VorpCore.getUser(_source).getUsedCharacter
    local s_status = UserCharacter.status
    if (#s_status > 5) then
        TriggerClientEvent("vorpmetabolism:StartFunctions", _source, s_status)
    else
        local status = json.encode({
            ['Hunger'] = Config["FirstHungerStatus"],
            ['Thirst'] = Config["FirstThirstStatus"],
            ['Metabolism'] = Config["FirstMetabolismStatus"]
        })
        UserCharacter.setStatus(status)
        TriggerClientEvent("vorpmetabolism:StartFunctions", _source, status)
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if (resourceName == "vorp_inventory") then
        RegisterUsableItemsAsync()
    end
end)

function RegisterUsableItemsAsync()
    Wait(3000)
    print(("Metabolism: Loading %s items usables"):format(#Config["ItemsToUse"]))
    for i=1, #Config.ItemsToUse, 1 do
        TriggerEvent("vorpCore:registerUsableItem", Config["ItemsToUse"][i]["Name"], function(data)
            local itemLabel = data.item.label
            TriggerClientEvent("vorpmetabolism:useItem", data.source, i, itemLabel)
            TriggerEvent("vorpCore:subItem", data.source, Config["ItemsToUse"][i]["Name"], 1)
        end)
    end
end