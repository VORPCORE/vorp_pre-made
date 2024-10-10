local Core                  = exports.vorp_core:GetCore()
local Inv                   = exports.vorp_inventory
local T <const>             = Translation.Langs[Config.Lang]
local JobsToAlert <const>   = {}
local PlayersAlerts <const> = {}

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
    return Config.MedicJobs[Character.job]
end

local function isOnDuty(source)
    return Player(source).state.isMedicDuty
end

local function isPlayerNear(source, target)
    local sourcePos <const> = GetEntityCoords(GetPlayerPed(source))
    local targetPos <const> = GetEntityCoords(GetPlayerPed(target))
    local distance <const> = #(sourcePos - targetPos)
    return distance <= 5
end

local function openDoctorMenu(source)
    local user <const> = Core.getUser(source)
    if not user then return end

    if not hasJob(user) then
        return Core.NotifyObjective(source, T.Jobs.YouAreNotADoctor, 5000)
    end
    TriggerClientEvent('vorp_medic:Client:OpenMedicMenu', source)
end

local function getClosestPlayer(source)
    local players <const> = GetPlayers()
    local ent <const> = GetPlayerPed(source)
    local doctorCoords <const> = GetEntityCoords(ent)

    for _, value in ipairs(players) do
        if tonumber(value) ~= source then
            local targetCoords <const> = GetEntityCoords(GetPlayerPed(value))
            local distance <const> = #(doctorCoords - targetCoords)
            if distance <= 3.0 then
                return value
            end
        end
    end
    return nil
end

local function getSourceInfo(user, _source)
    local sourceCharacter <const> = user.getUsedCharacter
    local charname <const> = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
    local sourceIdentifier <const> = sourceCharacter.identifier
    local steamname <const> = GetPlayerName(_source)
    return charname, sourceIdentifier, steamname
end

--* OPEN STORAGE
RegisterNetEvent("vorp_medic:Server:OpenStorage", function(key)
    local _source <const> = source
    local user <const> = Core.getUser(_source)
    if not user then return end

    if not hasJob(user) then
        return Core.NotifyObjective(_source, T.Jobs.YouAreNotADoctor, 5000)
    end

    if not isOnDuty(_source) then
        return Core.NotifyObjective(_source, T.Duty.YouAreNotOnDuty, 5000)
    end

    local prefix = "vorp_medic_storage_" .. key
    if Config.ShareStorage then
        prefix = "vorp_medic_storage"
    end

    local storageName <const> = Config.Storage[key].Name
    local storageLimit <const> = Config.Storage[key].Limit
    registerStorage(prefix, storageName, storageLimit)
    Inv:openInventory(_source, prefix)
end)

--* CLEANUP
AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for key, _ in pairs(Config.Storage) do
        local prefix = "vorp_medic_storage_" .. key
        if Config.ShareStorage then
            prefix = "vorp_medic_storage"
        end
        Inv:removeInventory(prefix)
    end

    local players <const> = GetPlayers()
    for i = 1, #players do
        local _source <const> = players[i]
        Player(_source).state:set('isMedicDuty', nil, true)
    end
end)

--* REGISTER STORAGE
AddEventHandler("onResourceStart", function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for key, value in pairs(Config.Storage) do
        local prefix = "vorp_medic_storage_" .. key
        if Config.ShareStorage then
            prefix = "vorp_medic_storage"
        end
        registerStorage(prefix, value.Name, value.Limit)
    end
    if Config.DevMode then
        TriggerClientEvent("chat:addSuggestion", -1, "/" .. Config.DoctorMenuCommand, T.Menu.OpenDoctorMenu, {})
        RegisterCommand(Config.DoctorMenuCommand, openDoctorMenu, false)
    end
end)

--* ON PLAYER SPAWN
AddEventHandler("vorp:SelectedCharacter", function(source, char)
    if Config.DevMode then return end
    if not Config.MedicJobs[char.job] then return end
    TriggerClientEvent("chat:addSuggestion", source, "/" .. Config.DoctorMenuCommand, T.Menu.OpenDoctorMenu, {})
    RegisterCommand(Config.DoctorMenuCommand, openDoctorMenu, false)
end)

--* HIRE PLAYER
RegisterNetEvent("vorp_medic:server:hirePlayer", function(id, job)
    local _source <const> = source
    local user <const> = Core.getUser(_source)
    if not user then return end

    if not hasJob(user) then
        return Core.NotifyObjective(_source, T.Jobs.YouAreNotADoctor, 5000)
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

    TriggerClientEvent("chat:addSuggestion", _source, "/" .. Config.DoctorMenuCommand, T.Menu.OpenDoctorMenu, {})
    RegisterCommand(Config.DoctorMenuCommand, openDoctorMenu, false)

    TriggerClientEvent("vorp_medic:Client:JobUpdate", target)
    local sourcename <const>, identifier <const>, steamname <const> = getSourceInfo(user, _source)
    local targetname <const>, identifier2 <const>, steamname2 <const> = getSourceInfo(targetUser, target)

    local description <const> = "**" .. Logs.Lang.HiredBy .. "** " .. sourcename .. "\n" .. "** " .. Logs.Lang.Steam .. "** " .. steamname .. "\n" .. "** "
        .. Logs.Lang.Identifier .. "** " .. identifier .. "\n" .. "** " .. Logs.Lang.PlayerID .. "** " .. _source .. "\n\n**" .. Logs.Lang.Job .. "** " .. label .. "\n\n" ..
        "**" .. Logs.Lang.HiredPlayer .. "** " .. targetname .. "\n" .. "** " .. Logs.Lang.Steam .. "** " .. steamname2 .. "\n" .. "** "
        .. Logs.Lang.Identifier .. "** " .. identifier2 .. "\n" .. "** " .. Logs.Lang.PlayerID .. "** " .. _source
    Core.AddWebhook(Logs.Lang.JobHired, Logs.Webhook, description, Logs.color, Logs.Namelogs, Logs.logo, Logs.footerlogo, Logs.avatar)
end)

--* FIRE PLAYER
RegisterNetEvent("vorp_medic:server:firePlayer", function(id)
    local _source <const> = source
    local user <const> = Core.getUser(_source)
    if not user then return end

    if not hasJob(user) then
        return Core.NotifyObjective(_source, T.Jobs.YouAreNotADoctor, 5000)
    end

    local target <const> = id
    local targetUser <const> = Core.getUser(target)
    if not targetUser then return Core.NotifyObjective(_source, T.Player.NoPlayerFound, 5000) end

    local targetCharacter <const> = targetUser.getUsedCharacter
    local targetJob <const> = targetCharacter.job
    if not Config.MedicJobs[targetJob] then
        return Core.NotifyObjective(_source, T.Player.CantFirenotHired, 5000)
    end

    targetCharacter.setJob("unemployed", true)
    targetCharacter.setJobLabel("Unemployed", true)

    Core.NotifyObjective(target, T.Player.BeenFireed, 5000)
    Core.NotifyObjective(_source, T.Player.FiredPlayer, 5000)

    if isOnDuty(target) then
        Player(target).state:set('isMedicDuty', nil, true)
    end

    TriggerClientEvent("vorp_medic:Client:JobUpdate", target)
    local sourcename <const>, identifier <const>, steamname <const> = getSourceInfo(user, _source)
    local targetname <const>, identifier2 <const>, steamname2 <const> = getSourceInfo(targetUser, target)

    local description <const> = "**" .. Logs.Lang.FiredBy .. "** " .. sourcename .. "\n" .. "** " .. Logs.Lang.Steam .. "** " .. steamname .. "\n" .. "** " .. Logs.Lang.Identifier .. "** " .. identifier .. "\n" .. "** " .. Logs.Lang.PlayerID .. "** " .. _source ..
        "\n\n**" .. Logs.Lang.FromJob .. "** " .. targetJob .. "\n\n" .. "**" .. Logs.Lang.FiredPlayer .. "** " .. targetname .. "\n" .. "** " .. Logs.Lang.Steam .. "** " .. steamname2 .. "\n" .. "** " .. Logs.Lang.Identifier .. "** " .. identifier2 .. "\n" .. "** " .. Logs.Lang.PlayerID .. "** " .. target
    Core.AddWebhook(Logs.Lang.Jobfired, Logs.Webhook, description, Logs.color, Logs.Namelogs, Logs.logo, Logs.footerlogo, Logs.avatar)
end)



--* CHECK IF PLAYER IS ON DUTY
Core.Callback.Register("vorp_medic:server:checkDuty", function(source, CB, args)
    local user <const> = Core.getUser(source)
    if not user then return end

    if not hasJob(user) then
        return CB(false)
    end

    local sourcename <const>, identifier <const>, steamname <const> = getSourceInfo(user, source)
    local Character <const> = user.getUsedCharacter
    local Job <const> = Character.job
    local description = "**" .. Logs.Lang.Steam .. "** " .. steamname .. "\n" ..
        "**" .. Logs.Lang.Identifier .. "** " .. identifier .. "\n" ..
        "**" .. Logs.Lang.PlayerID .. "** " .. source .. "\n" ..
        "**" .. Logs.Lang.Job .. "** " .. Job .. "\n" ..
        "**" .. Logs.Lang.PlayerName .. "** " .. sourcename .. "\n"

    if not isOnDuty(source) then
        if not JobsToAlert[source] then
            JobsToAlert[source] = true
        end
        Player(source).state:set('isMedicDuty', true, true)
        return CB(true)
    else
        if JobsToAlert[source] then
            JobsToAlert[source] = nil
        end
        Player(source).state:set('isMedicDuty', false, true)

        description = description .. "**" .. Logs.Lang.JobOffDuty .. "**"
        Core.AddWebhook(Logs.Lang.JobOffDuty, Logs.DutyWebhook, description, Logs.color, Logs.Namelogs, Logs.logo, Logs.footerlogo, Logs.Avatar)

        return CB(false)
    end
end)



--* ON PLAYER JOB CHANGE
AddEventHandler("vorp:playerJobChange", function(source, new, old)
    if not Config.MedicJobs[new] then return end
    TriggerClientEvent("vorp_medic:Client:JobUpdate", source)
end)

CreateThread(function()
    for key, value in pairs(Config.Items) do
        Inv:registerUsableItem(key, function(data)
            local _source <const> = data.source
            Inv:closeInventory(_source)

            if value.mustBeOnDuty then
                if not isOnDuty(_source) then
                    return Core.NotifyObjective(_source, T.Duty.YouAreNotOnDuty, 5000)
                end
            end

            if value.revive then
                local closestPlayer <const> = getClosestPlayer(_source)
                if not closestPlayer then return Core.NotifyObjective(_source, T.Player.NoPlayerFoundToRevive, 5000) end
                TriggerClientEvent("vorp_medic:Client:ReviveAnim", _source)
                SetTimeout(3000, function()
                    Core.Player.Revive(tonumber(closestPlayer))
                end)
            else
                local closestPlayer <const> = getClosestPlayer(_source)
                if not closestPlayer then return Core.NotifyObjective(_source, T.Player.NoPlayerFoundToRevive, 5000) end
                TriggerClientEvent("vorp_medic:Client:HealAnim", _source)
                TriggerClientEvent("vorp_medic:Client:HealPlayer", tonumber(closestPlayer), value.health, value.stamina)
            end

            Inv:subItem(_source, key, 1)
        end)
    end
end)

--* ALERTS

local function isDoctorOnCall(source)
    if not next(PlayersAlerts) then return false, 0 end

    for key, value in pairs(PlayersAlerts) do
        if value == source then
            return true, value
        end
    end
    return false, 0
end

local function getDoctorFromCall(source)
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

RegisterCommand(Config.AlertDoctorCommand, function(source, args)
    if PlayersAlerts[source] then
        return Core.NotifyRightTip(source, T.Error.AlreadyAlertedDoctors, 5000)
    end

    if not next(JobsToAlert) then
        return Core.NotifyRightTip(source, T.Error.NoDoctorsAvailable, 5000)
    end

    if Config.AllowOnlyDeadToAlert then
        local Character <const> = Core.getUser(source).getUsedCharacter
        local dead <const> = Character.isdead
        if not dead then
            return Core.NotifyObjective(source, T.Error.NotDeadCantAlert, 5000)
        end
    end

    local sourcePlayer <const> = GetPlayerPed(source)
    local sourceCoords <const> = GetEntityCoords(sourcePlayer)
    local closestDistance      = math.huge
    local closestDoctor        = nil

    for key, _ in pairs(JobsToAlert) do
        local player <const> = GetPlayerPed(key)
        local playerCoords <const> = GetEntityCoords(player)
        local distance <const> = #(sourceCoords - playerCoords)
        local isOnCall <const>, _ <const> = isDoctorOnCall(key)
        if not isOnCall then
            if distance < closestDistance then
                closestDistance = distance
                closestDoctor = key
            end
        end
    end

    if not closestDoctor then
        return Core.NotifyRightTip(source, T.Error.NoDoctorsAvailable, 5000)
    end

    Core.NotifyObjective(closestDoctor, T.Alert.PlayerNeedsHelp, 5000)
    TriggerClientEvent("vorp_medic:Client:AlertDoctor", closestDoctor, sourceCoords)
    Core.NotifyRightTip(source, T.Alert.DoctorsAlerted, 5000)
    PlayersAlerts[source] = closestDoctor
end, false)

--cancel alert for players
RegisterCommand(Config.cancelalert, function(source, args)
    if not PlayersAlerts[source] then
        return Core.NotifyRightTip(source, T.Error.NoAlertToCancel, 5000)
    end

    local doctor <const> = getDoctorFromCall(source)
    if doctor > 0 then
        local user <const> = Core.getUser(doctor) -- make sure is still in game
        if user then
            TriggerClientEvent("vorp_medic:Client:RemoveBlip", doctor)
            Core.NotifyObjective(doctor, T.Alert.AlertCanceledByPlayer, 5000)
        end
    end

    PlayersAlerts[source] = nil
    Core.NotifyRightTip(source, T.Alert.AlertCanceled, 5000)
end, false)


-- for doctors to finish alert
RegisterCommand(Config.finishalert, function(source, args)
    local _source <const> = source

    local hasJobs <const> = hasJob(Core.getUser(_source))
    if not hasJobs then
        return Core.NotifyObjective(_source, T.Jobs.YouAreNotADoctor, 5000)
    end

    local isDuty <const> = isOnDuty(_source)
    if not isDuty then
        return Core.NotifyObjective(_source, T.Duty.YouAreNotOnDuty, 5000)
    end

    local isOnCall <const>, doctor <const> = isDoctorOnCall(_source)
    if isOnCall and doctor > 0 then
        TriggerClientEvent("vorp_medic:Client:RemoveBlip", _source)
        Core.NotifyObjective(_source, T.Alert.AlertCanceled, 5000)
    else
        Core.NotifyObjective(_source, T.Error.NotOnCall, 5000)
    end

    local player <const> = getPlayerFromCall(_source)
    if player > 0 then
        Core.NotifyRightTip(player, T.Alert.AlertCanceledByDoctor, 5000)
        PlayersAlerts[player] = nil
    end
end, false)


--* ON PLAYER DROP
AddEventHandler("playerDropped", function()
    local _source = source

    if Player(_source).state.isMedicDuty then
        Player(_source).state:set('isMedicDuty', nil, true)
    end

    if JobsToAlert[_source] then
        JobsToAlert[_source] = nil
    end

    local isOnCall <const>, doctor <const> = isDoctorOnCall(_source)
    if isOnCall and doctor > 0 then
        TriggerClientEvent("vorp_medic:Client:RemoveBlip", doctor)
        Core.NotifyObjective(doctor, T.Alert.PlayerDisconnectedAlertCanceled, 5000)
    end

    if PlayersAlerts[_source] then
        PlayersAlerts[_source] = nil
    end
end)
