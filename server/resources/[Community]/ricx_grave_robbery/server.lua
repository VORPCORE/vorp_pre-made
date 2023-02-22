data = {}
local VorpCore = {}
local VorpInv = {}

local stafftable = {}

if Config.framework == "redemrp" then
    TriggerEvent("redemrp_inventory:getData", function(call)
        data = call
    end)
elseif Config.framework == "vorp" then
    TriggerEvent("getCore", function(core)
        VorpCore = core
    end)

    VorpInv = exports.vorp_inventory:vorp_inventoryApi()
elseif Config.framework == "qbr" then
    QBRItems = exports['qbr-core']:GetItems()
end

local TEXTS = Config.Texts
local TEXTURES = Config.Textures

local DiggedGraves = {}

RegisterServerEvent("ricx_grave_robbery:check_shovel")
AddEventHandler("ricx_grave_robbery:check_shovel", function(id, Town)
    local _source = source

    if DiggedGraves[id] == true then
        TriggerClientEvent("Notification:left_grave_robbery", _source, TEXTS.GraveRobbery, TEXTS.GraveRobbed,
            TEXTURES.alert[1], TEXTURES.alert[2], 2000)
        return
    end
    local count = nil
    if Config.framework == "redemrp" then
        local itemD = data.getItem(_source, Config.ShovelItem)
        if itemD and itemD.ItemAmount > 0 then
            count = itemD.ItemAmount
        end
    elseif Config.framework == "vorp" then
        count = VorpInv.getItemCount(_source, Config.ShovelItem)
    elseif Config.framework == "qbr" then
        local User = exports['qbr-core']:GetPlayer(_source)
        local hasItem = User.Functions.GetItemByName(Config.ShovelItem)
        if hasItem and hasItem.amount > 0 then
            count = hasItem.amount
        end
    end
    if count and count > 0 then
        TriggerClientEvent("ricx_grave_robbery:start_dig", _source, id)
        if Config.framework == "vorp" then
            TriggerEvent("outsider_alertjobs", Town)
        end
    else
        TriggerClientEvent("Notification:left_grave_robbery", _source, TEXTS.GraveRobbery, TEXTS.NoShovel,
            TEXTURES.alert[1], TEXTURES.alert[2], 2000)
    end
end)

RegisterServerEvent("ricx_grave_robbery:reward")
AddEventHandler("ricx_grave_robbery:reward", function(id)
    local _source = source
    Citizen.Wait(math.random(200, 800))
    if DiggedGraves[id] == true then
        TriggerClientEvent("Notification:left_grave_robbery", _source, TEXTS.GraveRobbery, TEXTS.GraveRobbed,
            TEXTURES.alert[1], TEXTURES.alert[2], 2000)
        return
    end
    DiggedGraves[id] = true
    local itemnr = math.random(1, #Config.Rewards)
    local item = Config.Rewards[itemnr].item
    local label = Config.Rewards[itemnr].label
    if Config.framework == "redemrp" then
        local itemD = data.getItem(_source, item)
        itemD.AddItem(1)
    elseif Config.framework == "vorp" then
        VorpInv.addItem(_source, item, 1)
    elseif Config.framework == "qbr" then
        local User = exports['qbr-core']:GetPlayer(_source)
        User.Functions.AddItem(item, 1)
    end
    TriggerClientEvent("Notification:left_grave_robbery", _source, TEXTS.GraveRobbery, TEXTS.FoundItem .. "\n+ " .. label
        , TEXTURES.alert[1], TEXTURES.alert[2], 2000)
end)

function CheckTable(table, element)
    for k, v in pairs(table) do
        if v == element then
            return true
        end
    end
    return false
end

RegisterServerEvent("outsider_robbery:sendPlayers", function(source)
    local _source = source
    local user = VorpCore.getUser(_source).getUsedCharacter
    local job = user.job -- player job

    if CheckTable(Config.JobsToAlert, job) then -- if player exist and job equals to config then add to table
        stafftable[#stafftable + 1] = _source -- id
    end
end)

-- remove player from table when leaving
AddEventHandler('playerDropped', function()
    local _source = source
    for index, value in pairs(stafftable) do
        if value == _source then
            stafftable[index] = nil
        end
    end

end)

AddEventHandler('outsider_alertjobs', function(Town)
    for _, jobHolder in pairs(stafftable) do
        for key, v in pairs(Config.JobsToAlert) do

            local onduty = exports["syn_society"]:IsPlayerOnDuty(jobHolder, v)
            if Config.synSociety then
                if onduty then
                    VorpCore.NotifyLeft(jobHolder, Town, "grave robbery was witnessed ", "generic_textures",
                        "temp_pedshot", 8000,
                        "COLOR_WHITE")
                end
            else
                VorpCore.NotifyLeft(jobHolder, Town, "grave robbery was witnessed ", "generic_textures",
                    "temp_pedshot", 8000,
                    "COLOR_WHITE")
            end
        end
    end
end)
