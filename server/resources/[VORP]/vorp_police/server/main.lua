local Core          = exports.vorp_core:GetCore()
local Inv           = exports.vorp_inventory
local T             = Translation.Langs[Config.Lang]
local PlayersAlerts = {}
local JobsToAlert   = {}

local function registerStorage(prefix, name, limit)
    local isInvRegstered <const> = Inv:isCustomInventoryRegistered(prefix)
    if not isInvRegstered then
        local data <const> = {
            id = prefix,
            name = name,
            limit = limit,
            acceptWeapons = true,
            shared = true,
            ignoreItemStackLimit = true,
            whitelistItems = false,
            UsePermissions = false,
            UseBlackList = false,
            whitelistWeapons = false,
            webhook = Logs.StorageWebook,

        }
        Inv:registerInventory(data)
    end
end

local function hasJob(user)
    local Character <const> = user.getUsedCharacter
    return Config.PoliceJobs[Character.job]
end

local function isOnDuty(source)
    return Player(source).state.isPoliceDuty
end

local function isPlayerNear(source, target)
    local sourcePos <const> = GetEntityCoords(GetPlayerPed(source))
    local targetPos <const> = GetEntityCoords(GetPlayerPed(target))
    local distance <const> = #(sourcePos - targetPos)
    return distance <= 5
end

local function openPoliceMenu(source)
    local user <const> = Core.getUser(source)
    if not user then return end

    if not hasJob(user) then
        return Core.NotifyObjective(source, T.Jobs.YouAreNotAPoliceOfficer, 5000)
    end

    TriggerClientEvent('vorp_police:Client:OpenPoliceMenu', source)
end

local function getSourceInfo(user, _source)
    local sourceCharacter <const> = user.getUsedCharacter
    local charname <const> = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
    local sourceIdentifier <const> = sourceCharacter.identifier
    local steamname <const> = GetPlayerName(_source)
    return charname, sourceIdentifier, steamname
end

--* OPEN STORAGE
RegisterNetEvent("vorp_police:Server:OpenStorage", function(key)
    local _source <const> = source
    local User <const> = Core.getUser(_source)
    if not User then return end

    if not hasJob(User) then
        return Core.NotifyObjective(_source, T.Jobs.YouAreNotAPoliceOfficer, 5000)
    end

    if not isOnDuty(_source) then
        return Core.NotifyObjective(_source, T.Duty.YouAreNotOnDuty, 5000)
    end

    local prefix = "vorp_police_storage_" .. key
    if Config.ShareStorage then
        prefix = "vorp_police_storage"
    end

    local storageName <const> = Config.Storage[key].Name
    local storageLimit <const> = Config.Storage[key].Limit
    registerStorage(prefix, storageName, storageLimit)
    Inv:openInventory(_source, prefix)
end)

--* CLEANUP
AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for key, value in pairs(Config.Storage) do
        local prefix = "vorp_police_storage_" .. key
        if Config.ShareStorage then
            prefix = "vorp_police_storage"
        end
        Inv:removeInventory(prefix)
    end

    local players <const> = GetPlayers()
    for i = 1, #players do
        local _source <const> = players[i]
        Player(_source).state:set('isPoliceDuty', nil, true)
    end
end)

--* REGISTER STORAGE
AddEventHandler("onResourceStart", function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for key, value in pairs(Config.Storage) do
        local prefix = "vorp_police_storage_" .. key
        if Config.ShareStorage then
            prefix = "vorp_police_storage"
        end
        registerStorage(prefix, value.Name, value.Limit)
    end

    if Config.DevMode then
        TriggerClientEvent("chat:addSuggestion", -1, "/" .. Config.PoliceMenuCommand, T.Menu.OpenPoliceMenu, {})
        RegisterCommand(Config.PoliceMenuCommand, openPoliceMenu, false)
    end
end)
-- vorpCharSelect
AddEventHandler("vorp:SelectedCharacter", function(source, char)
    if Config.DevMode then return end
    if not Config.PoliceJobs[char.job] then return end
    -- add chat suggestion
    TriggerClientEvent("chat:addSuggestion", source, "/" .. Config.PoliceMenuCommand, T.Menu.OpenPoliceMenu, {})
    RegisterCommand(Config.PoliceMenuCommand, openPoliceMenu, false)
end)

--* HIRE PLAYER
RegisterNetEvent("vorp_police:server:hirePlayer", function(id, job)
    local _source <const> = source

    local user <const> = Core.getUser(_source)
    if not user then return end

    if not hasJob(user) then
        return Core.NotifyObjective(_source, T.Jobs.YouAreNotAPoliceOfficer, 5000)
    end

    local label <const> = Config.JobLabels[job]
    if not label then return print(T.Jobs.Nojoblabel) end

    local target <const> = id
    local targetUser <const> = Core.getUser(target)
    if not targetUser then return Core.NotifyObjective(_source, T.Player.NoPlayerFound, 5000) end

    local targetCharacter <const> = targetUser.getUsedCharacter
    local targetJob <const> = targetCharacter.job
    if job == targetJob then
        return Core.NotifyObjective(_source, T.Player.PlayeAlreadyHired .. label, 5000)
    end

    if not isPlayerNear(_source, target) then
        return Core.NotifyObjective(_source, T.Player.NotNear, 5000)
    end

    targetCharacter.setJob(job, true)
    targetCharacter.setJobLabel(label, true)

    Core.NotifyObjective(target, T.Player.HireedPlayer .. label, 5000)
    Core.NotifyObjective(_source, T.Menu.HirePlayer, 5000)

    TriggerClientEvent("chat:addSuggestion", _source, "/" .. Config.PoliceMenuCommand, T.Menu.OpenPoliceMenu, {})
    RegisterCommand(Config.PoliceMenuCommand, openPoliceMenu, false)

    TriggerClientEvent("vorp_police:Client:JobUpdate", target)
    local sourcename <const>, identifier <const>, steamname <const> = getSourceInfo(user, _source)
    local targetname <const>, identifier2 <const>, steamname2 <const> = getSourceInfo(targetUser, target)

    local description <const> = "**" .. Logs.Lang.HiredBy .. "** " .. sourcename .. "\n" .. "** " .. Logs.Lang.Steam .. "** " .. steamname ..
        "\n" .. "** " .. Logs.Lang.Identifier .. "** " .. identifier .. "\n" .. "** " .. Logs.Lang.PlayerID .. "** " .. _source ..
        "\n\n**" .. Logs.Lang.Job .. "** " .. label .. "\n\n" .. "**" .. Logs.Lang.HiredPlayer .. "** " .. targetname .. "\n" ..
        "** " .. Logs.Lang.Steam .. "** " .. steamname2 .. "\n" .. "** " .. Logs.Lang.Identifier .. "** " .. identifier2 .. "\n" .. "** " .. Logs.Lang.PlayerID .. "** " .. _source
    Core.AddWebhook(Logs.Lang.JobHired, Logs.Webhook, description, Logs.color, Logs.Namelogs, Logs.logo, Logs.footerlogo, Logs.avatar)
end)



--* FIRE PLAYER
RegisterNetEvent("vorp_police:server:firePlayer", function(id)
    local _source <const> = source
    local user <const> = Core.getUser(_source)
    if not user then return end

    if not hasJob(user) then
        return Core.NotifyObjective(_source, T.Jobs.YouAreNotAPoliceOfficer, 5000)
    end

    local target <const> = id
    local targetUser <const> = Core.getUser(target)
    if not targetUser then return Core.NotifyObjective(_source, T.Player.NoPlayerFound, 5000) end

    local targetCharacter <const> = targetUser.getUsedCharacter
    local targetJob <const> = targetCharacter.job
    if not Config.PoliceJobs[targetJob] then
        return Core.NotifyObjective(_source, T.Player.CantFirenotHired, 5000)
    end

    targetCharacter.setJob("unemployed", true)
    targetCharacter.setJobLabel("Unemployed", true)

    Core.NotifyObjective(target, T.Player.BeenFireed, 5000)
    Core.NotifyObjective(_source, T.Player.FiredPlayer, 5000)

    if isOnDuty(target) then
        Player(target).state:set('isPoliceDuty', nil, true)
    end

    TriggerClientEvent("vorp_police:Client:JobUpdate", target)
    local sourcename <const>, identifier <const>, steamname <const> = getSourceInfo(user, _source)
    local targetname <const>, identifier2 <const>, steamname2 <const> = getSourceInfo(targetUser, target)

    local description <const> = "**" .. Logs.Lang.FiredBy .. "** " .. sourcename .. "\n" .. "** " .. Logs.Lang.Steam .. "** " .. steamname ..
        "\n" .. "** " .. Logs.Lang.Identifier .. "** " .. identifier .. "\n" .. "** " .. Logs.Lang.PlayerID .. "** " .. _source ..
        "\n\n**" .. Logs.Lang.FromJob .. "** " .. targetJob .. "\n\n" .. "**" .. Logs.Lang.FiredPlayer .. "** " .. targetname ..
        "\n" .. "** " .. Logs.Lang.Steam .. "** " .. steamname2 .. "\n" .. "** " .. Logs.Lang.Identifier .. "** " .. identifier2 .. "\n"
        .. "** " .. Logs.Lang.PlayerID .. "** " .. target
    Core.AddWebhook(Logs.Lang.Jobfired, Logs.Webhook, description, Logs.color, Logs.Namelogs, Logs.logo, Logs.footerlogo, Logs.avatar)
end)

RegisterServerEvent('vorp_police:Server:dragPlayer', function(target)
    local _source <const> = source
    local _target <const> = target
    local user <const> = Core.getUser(_source)
    if not user then return end
    if not hasJob(user) then return end

    if _target > 0 and Core.getUser(_target) then
        TriggerClientEvent("vorp_police:Client:dragPlayer", _target, _source)
    end
end)

CreateThread(function()
    if not Config.CuffItem or not Config.KeysItem then return end

    -- register cuffs
    Inv:registerUsableItem(Config.CuffItem, function(data)
        local _source <const> = data.source

        Inv:closeInventory(_source)

        local result <const> = Core.Callback.TriggerAwait("vorp_police:server:isPlayerCuffed", _source)
        if result[1] then
            Core.NotifyObjective(_source, T.Cuff.PlayerCuffAlready, 5000)
            return
        end
        -- no player nearby
        if not result[2] or result[2] == 0 then return end

        Inv:subItem(_source, Config.CuffItem, 1)
        TriggerClientEvent("vorp_police:Client:PlayerCuff", result[2], "cuff")
    end)

    Inv:registerUsableItem(Config.KeysItem, function(data)
        local _source <const> = data.source

        Inv:closeInventory(_source)

        local result <const> = Core.Callback.TriggerAwait("vorp_police:server:isPlayerCuffed", _source)
        if not result[1] then
            Core.NotifyObjective(_source, T.Cuff.PlayerNotcuffed, 5000)
            return
        end

        if not result[2] then return end

        local hasCuffs <const> = Inv:getItem(_source, Config.CuffItem)
        if not hasCuffs then
            Inv:addItem(_source, Config.CuffItem, 1)
        end

        TriggerClientEvent("vorp_police:Client:PlayerCuff", result[2], "uncuff")
    end)
end)

--* CHECK IF PLAYER IS ON DUTY
Core.Callback.Register("vorp_police:server:checkDuty", function(source, CB, args)
    local user <const> = Core.getUser(source)
    if not user then return end

    if not hasJob(user) then return CB(false) end

    local sourcename <const>, identifier <const>, steamname <const> = getSourceInfo(user, source)
    local Character <const> = user.getUsedCharacter
    local Job <const> = Character.job
    local description = "**" .. Logs.Lang.Steam .. "** " .. steamname .. "\n" ..
        "**" .. Logs.Lang.Identifier .. "** " .. identifier .. "\n" ..
        "**" .. Logs.Lang.PlayerID .. "** " .. source .. "\n" ..
        "**" .. Logs.Lang.Job .. "** " .. Job .. "\n" ..
        "**" .. Logs.Lang.PlayerName .. "** " .. sourcename .. "\n"

    if not isOnDuty(source) then
        Player(source).state:set('isPoliceDuty', true, true)
        JobsToAlert[source] = true

        description = description .. "**" .. Logs.Lang.JobOnDuty .. "**"
        Core.AddWebhook(Logs.Lang.JobOnDuty, Logs.DutyWebhook, description, Logs.color, Logs.Namelogs, Logs.logo, Logs.footerlogo, Logs.Avatar)

        return CB(true)
    else
        JobsToAlert[source] = nil
        Player(source).state:set('isPoliceDuty', nil, true)
        description = description .. "**" .. Logs.Lang.JobOffDuty .. "**"
        Core.AddWebhook(Logs.Lang.JobOffDuty, Logs.DutyWebhook, description, Logs.color, Logs.Namelogs, Logs.logo, Logs.footerlogo, Logs.Avatar)

        return CB(false)
    end
end)

--* ON PLAYER JOB CHANGE
AddEventHandler("vorp:playerJobChange", function(source, new, old)
    if not Config.PoliceJobs[new] then return end
    TriggerClientEvent("vorp_police:Client:JobUpdate", source)
end)

local function isPoliceOnCall(source)
    if not next(PlayersAlerts) then return false, 0 end

    for key, value in pairs(PlayersAlerts) do
        if value == source then
            return true, value
        end
    end
    return false, 0
end

local function getPoliceFromCall(source)
    if PlayersAlerts[source] then
        return PlayersAlerts[source]
    end
    return 0
end

local function getPlayerFromCall(source)
    for key, value in pairs(PlayersAlerts) do
        if value == source then
            return key
        end
    end
    return 0
end

RegisterCommand(Config.alertPolice, function(source, args)
    if PlayersAlerts[source] then
        return Core.NotifyRightTip(source, T.Alerts.tocancalert, 5000)
    end

    if not next(JobsToAlert) then
        return Core.NotifyRightTip(source, T.Alerts.noofficers, 5000)
    end

    if Config.AllowOnlyDeadToAlert then
        local Character <const> = Core.getUser(source).getUsedCharacter
        local dead <const> = Character.isdead
        if not dead then return Core.NotifyObjective(source, T.Alerts.onlydead, 5000) end
    end

    local sourcePlayer <const> = GetPlayerPed(source)
    local sourceCoords <const> = GetEntityCoords(sourcePlayer)
    local closestDistance      = math.huge
    local closestPolice        = nil

    for key, _ in pairs(JobsToAlert) do
        local player <const> = GetPlayerPed(key)
        local playerCoords <const> = GetEntityCoords(player)
        local distance <const> = #(sourceCoords - playerCoords)
        local isOnCall <const>, _ <const> = isPoliceOnCall(key)
        if not isOnCall then
            if distance < closestDistance then
                closestDistance = distance
                closestPolice = key
            end
        end
    end

    if not closestPolice then
        return Core.NotifyRightTip(source, T.Alerts.noofficers, 5000)
    end

    Core.NotifyObjective(closestPolice, T.Alerts.policealert, 5000)
    TriggerClientEvent("vorp_police:Client:AlertPolice", closestPolice, sourceCoords)
    Core.NotifyRightTip(source, T.Alerts.playeralert, 5000)
    PlayersAlerts[source] = closestPolice
end, false)

--cancel alert for players
RegisterCommand(Config.cancelpolicealert, function(source, args)
    if not PlayersAlerts[source] then
        return Core.NotifyRightTip(source, T.Alerts.noalerts, 5000)
    end

    local police <const> = getPoliceFromCall(source)
    if police > 0 then
        local user <const> = Core.getUser(police)
        if user then
            TriggerClientEvent("vorp_police:Client:RemoveBlip", police)
            Core.NotifyObjective(police, T.Alerts.alertcanceled, 5000)
        end
    end

    PlayersAlerts[source] = nil
    Core.NotifyRightTip(source, T.Alerts.canceled, 5000)
end, false)


-- for police to finish alert
RegisterCommand(Config.finishpolicelert, function(source, args)
    local _source <const> = source

    local hasJobs <const> = hasJob(Core.getUser(_source))
    if not hasJobs then
        return Core.NotifyObjective(_source, T.Jobs.YouAreNotAPoliceOfficer, 5000)
    end

    local isDuty <const> = isOnDuty(_source)
    if not isDuty then
        return Core.NotifyObjective(_source, T.Duty.YouAreNotOnDuty, 5000)
    end

    local isOnCall <const>, police <const> = isPoliceOnCall(_source)
    if isOnCall and police > 0 then
        TriggerClientEvent("vorp_police:Client:RemoveBlip", _source)
        Core.NotifyObjective(_source, T.Alerts.canceled, 5000)
    else
        Core.NotifyObjective(_source, T.Alerts.notoncall, 5000)
    end

    local player <const> = getPlayerFromCall(_source)
    if player > 0 then
        Core.NotifyRightTip(player, T.Alerts.policecancel, 5000)
        PlayersAlerts[player] = nil
    end
end, false)

--* ON PLAYER DROP
AddEventHandler("playerDropped", function()
    local _source = source
    if Player(_source).state.isPoliceDuty then
        Player(_source).state:set('isPoliceDuty', nil, true)
    end

    if JobsToAlert[_source] then
        JobsToAlert[_source] = nil
    end

    local isOnCall <const>, police <const> = isPoliceOnCall(_source)
    if isOnCall and police > 0 then
        TriggerClientEvent("vorp_police:Client:RemoveBlip", police)
        Core.NotifyObjective(police, T.Alerts.playerDropped, 5000)
    end

    if PlayersAlerts[_source] then
        PlayersAlerts[_source] = nil
    end
end)
