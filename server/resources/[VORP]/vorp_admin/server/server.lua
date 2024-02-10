---@diagnostic disable: undefined-global

local stafftable = {}
local PlayersTable = {}

local T = Translation.Langs[Config.Lang]

-------------------------- ONLY WORKS WITH UPDATES --------------------------------
local hasResourceStarted = GetResourceState("vorp_inventory") == "started"
local hasvorpcorestarted = GetResourceState("vorp_core") == "started"
if not hasResourceStarted or not hasvorpcorestarted then
    print("vorp_inventory or vorp_core is not started this resource will stop")
    return
end

local invVersion = GetResourceMetadata("vorp_inventory", "version", 0)
local coreVersion = GetResourceMetadata("vorp_core", "version", 0)
if tonumber(invVersion) < 2.9 or tonumber(coreVersion) < 2.3 then
    print("vorp_inventory or vorp core is not up to date this resource will stop")
    StopResource("vorp_admin")
    return
end
----------------------------------------------------------------------------------

local Core = exports.vorp_core:GetCore()

local function getUserData(User, _source)
    local Character = User.getUsedCharacter
    local group = Character.group

    local playername = (Character.firstname or "no name") .. ' ' .. (Character.lastname or "noname")
    local job = Character.job
    local identifier = Character.identifier
    local PlayerMoney = Character.money
    local PlayerGold = Character.gold
    local JobGrade = Character.jobGrade
    local getid = Core.Whitelist.getEntry(identifier)
    local getstatus = Core.Whitelist.getEntry(identifier)
    local warnstatus = User.getPlayerwarnings()

    local data = {
        serverId = _source,
        name = GetPlayerName(_source),
        Group = group,
        PlayerName = playername,
        Job = job,
        SteamId = identifier,
        Money = PlayerMoney,
        Gold = PlayerGold,
        Grade = JobGrade,
        staticID = getid and tonumber(getid.id) or "no id",
        WLstatus = getstatus and tostring(getstatus.status) or "no status",
        warns = tonumber(warnstatus),
    }
    return data
end



-- Register CallBack
Core.Callback.Register("vorp_admin:Callback:getplayersinfo", function(source, cb, args)
    if next(PlayersTable) then
        if args.search == "search" then -- is for unique player
            if PlayersTable[args.id] then
                local User = Core.getUser(args.id)
                if User then
                    local data = getUserData(User, args.id)
                    PlayersTable[args.id] = data
                    return cb(PlayersTable[args.id])
                end
                return cb(false)
            else
                return cb(false)
            end
        end

        for id, v in pairs(PlayersTable) do
            local User = Core.getUser(id)
            if User then
                local data = getUserData(User, id)
                PlayersTable[id] = data
            end
        end
        return cb(PlayersTable)
    end
    return cb(false)
end)


local function CheckTable(group, group1, object)
    for key, value in ipairs(Config.AllowedGroups) do
        for k, v in ipairs(value.group) do
            if v == group or v == group1 then
                return true
            end
        end
    end
    return false
end

local function AllowedToExecuteAction(source, command)
    local User = Core.getUser(source)
    local Character = User.getUsedCharacter
    local group = Character.group
    local group1 = User.getGroup

    if IsPlayerAceAllowed(source, command) or CheckTable(group, group1, command) then
        return true
    end

    return false
end

-------------------------------------------------------------------------------
--------------------------------- EVENTS TELEPORTS -----------------------------
--TP TO
RegisterServerEvent("vorp_admin:TpToPlayer", function(targetID, command)
    local _source = source
    if Core.getUser(targetID) then
        if not AllowedToExecuteAction(_source, command) then
            return
        end

        local targetCoords = GetEntityCoords(GetPlayerPed(targetID))
        TriggerClientEvent('vorp_admin:gotoPlayer', _source, targetCoords)
    else
        Core.NotifyRightTip(_source, T.Notify.userNotExist, 8000)
    end
end)

--SENDBACK
RegisterServerEvent("vorp_admin:sendAdminBack", function(command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    TriggerClientEvent('vorp_admin:sendAdminBack', _source)
end)


--FREEZE
RegisterServerEvent("vorp_admin:freeze", function(targetID, freeze, command)
    local _source = source
    local _target = targetID
    local state = freeze
    if Core.getUser(_target) then
        if not AllowedToExecuteAction(_source, command) then
            return
        end

        TriggerClientEvent("vorp_admin:Freezeplayer", target, state)
    end
end)
---------------------------------------------------------------
--BRING
RegisterServerEvent("vorp_admin:Bring", function(targetID, adminCoords, command)
    local _source = source
    if Core.getUser(targetID) then
        if not AllowedToExecuteAction(_source, command) then
            return
        end
        TriggerClientEvent("vorp_admin:Bring", targetID, adminCoords)
    end
end)

--TPBACK
RegisterServerEvent("vorp_admin:TeleportPlayerBack", function(targetID, command)
    local _source = source
    if Core.getUser(targetID) then
        if not AllowedToExecuteAction(_source, command) then
            return
        end
        TriggerClientEvent('vorp_admin:TeleportPlayerBack', targetID)
    end
end)

----------------------------------------------------------------------------------
---------------------------- ADVANCED ADMIN ACTIONS ---------------------------------------

--KICK
RegisterServerEvent("vorp_admin:kick", function(targetID, reason, command)
    local _source = source
    local _target = targetID
    if Core.getUser(targetID) then
        if not AllowedToExecuteAction(_source, command) then
            return
        end
        TriggerClientEvent('vorp:updatemissioNotify', _target, T.Notify.kickedNotify, T.Notify.kickedNotify, 5000)

        SetTimeout(5000, function()
            DropPlayer(_target, reason)
        end)
    end
end)

--UNWARN WARN
RegisterServerEvent("vorp_admin:warns", function(targetID, status, staticid, msg, command)
    local _source = source
    local _target = targetID
    local staticID = staticid
    local stats = status
    local reason = msg
    if Core.getUser(_target) then
        if not AllowedToExecuteAction(_source, command) then
            return
        end

        if stats == "warn" then
            TriggerClientEvent("vorp:warn", _target, staticID)
            Core.NotifyRightTip(_target, reason, 8000)
        elseif stats == "unwarn" then
            TriggerClientEvent("vorp:unwarn", _target, staticID)
        end
    end
end)

--BAN
RegisterServerEvent("vorp_admin:BanPlayer", function(targetID, staticid, time, command)
    local _source = source
    local _target = targetID
    local targetStaticId = tonumber(staticid)
    local datetime = os.time(os.date("!*t"))
    local banTime
    if Core.getUser(_target) then
        if not AllowedToExecuteAction(_source, command) then
            return
        end
        if time:sub(-1) == 'd' then
            banTime = tonumber(time:sub(1, -2))
            banTime = banTime * 24
        elseif time:sub(-1) == 'w' then
            banTime = tonumber(time:sub(1, -2))
            banTime = banTime * 168
        elseif time:sub(-1) == 'm' then
            banTime = tonumber(time:sub(1, -2))
            banTime = banTime * 720
        elseif time:sub(-1) == 'y' then
            banTime = tonumber(time:sub(1, -2))
            banTime = banTime * 8760
        else
            banTime = tonumber(time)
        end
        if banTime == 0 then
            datetime = 0
        else
            datetime = datetime + banTime * 3600
        end

        TriggerClientEvent('vorp:updatemissioNotify', _target, T.Notify.bannedNotify, T.Notify.bannedNotify, 8000)
        SetTimeout(8000, function()
            TriggerEvent("vorpbans:addtodb", false, targetStaticId, datetime)
        end)
    end
end)

--RESPAWN
RegisterServerEvent("vorp_admin:respawnPlayer", function(targetID, command)
    local _source = source
    if not Core.getUser(targetID) then
        return
    end

    if not AllowedToExecuteAction(_source, command) then
        return
    end

    TriggerEvent("vorp:PlayerForceRespawn", targetID)
    TriggerClientEvent("vorp:PlayerForceRespawn", targetID)
    exports.vorp_inventory:closeInventory(targetID)
    TriggerClientEvent('vorp:updatemissioNotify', targetID, T.Notify.respawnedNotify, T.Notify.lostAllItems, 8000)
    SetTimeout(8000, function()
        TriggerClientEvent("vorp_core:respawnPlayer", targetID) --remove player
        TriggerClientEvent("vorp_admin:respawn", targetID)      --add effects
    end)
end)



--------------------------------------------------------------------
--------------------------------------------------------------------
-- DATABASE GIVE ITEM

RegisterServerEvent("vorp_admin:givePlayer", function(targetID, action, data1, data2, data3, command)
    local _source = source
    local user = Core.getUser(targetID)
    if not user then
        return
    end
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    local Character = user.getUsedCharacter

    if action == "item" then
        local item = data1
        local qty = data2

        if not qty or not item then
            return Core.NotifyRightTip(_source, T.Notify.invalidAdd, 5000)
        end

        local itemCheck = exports.vorp_inventory:getItemDB(item)
        local canCarryItem = exports.vorp_inventory:canCarryItem(targetID, item, qty)
        local canCarryInv = exports.vorp_inventory:canCarryItems(targetID, qty)

        if not itemCheck then
            return Core.NotifyRightTip(_source, T.Notify.doesNotExistInDB, 5000)
        end

        if not canCarryInv then
            return Core.NotifyRightTip(_source, T.Notify.inventoryFull, 5000)
        end

        if not canCarryItem then
            return Core.NotifyRightTip(_source, T.Notify.itemLimit, 5000)
        end

        exports.vorp_inventory:addItem(targetID, item, qty)

        Core.NotifyRightTip(targetID, T.Notify.receivedItem .. qty .. T.Notify.of .. itemCheck.label .. "~q~", 5000)
        Core.NotifyRightTip(_source, T.Notify.itemGiven, 4000)
        return
    end

    if action == "weapon" then
        local weapon = data1

        local canCarryWeapons = exports.vorp_inventory:canCarryWeapons(targetID, 1, nil, weapon)

        if not canCarryWeapons then
            return Core.NotifyRightTip(_source, T.Notify.cantCarryWeapon, 5000)
        end

        exports.vorp_inventory:createWeapon(targetID, weapon)

        Core.NotifyRightTip(targetID, T.Notify.receivedWeapon, 5000)
        Core.NotifyRightTip(_source, T.Notify.weaponGiven, 4000)
        return
    end

    if action == "moneygold" then
        local CurrencyType = data1
        local qty = data2

        if not qty then
            return Core.NotifyRightTip(_source, T.Notify.addQuantity, 5000)
        end

        Character.addCurrency(tonumber(CurrencyType), tonumber(qty))
        if CurrencyType == 0 then
            Core.NotifyRightTip(targetID, T.Notify.receivedItem .. qty .. T.Notify.money, 5000)
        elseif CurrencyType == 1 then
            Core.NotifyRightTip(targetID, T.Notify.receivedItem .. qty .. T.Notify.gold, 5000)
        elseif CurrencyType == 2 then
            Core.NotifyRightTip(targetID, T.Notify.receivedItem .. qty .. T.Notify.ofRoll, 5000)
        end
        Core.NotifyRightTip(_source, T.Notify.sent, 4000)

        return
    end

    if action == "horse" then
        local identifier = Character.identifier
        local charid = Character.charIdentifier
        local hash = data1
        local name = data2
        local sex = data3
        if not Config.VorpStable then
            MySQL.insert(
                "INSERT INTO horses ( `identifier`, `charid`, `name`, `model`, `sex`) VALUES ( @identifier, @charid, @name, @model, @sex)"
                , {
                    identifier = identifier,
                    charid = charid,
                    name = tostring(name),
                    model = hash,
                    sex = sex
                })
        else
            MySQL.insert(
                "INSERT INTO stables ( `identifier`, `charidentifier`, `name`, `modelname`,`type`,`inventory` ) VALUES ( @identifier, @charid, @name, @modelname, @type, @inventory)"
                , {
                    identifier = identifier,
                    charid = charid,
                    name = tostring(name),
                    modelname = hash,
                    type = "horse",
                    inventory = json.encode({})
                })
        end
        Core.NotifyRightTip(targetID, T.Notify.horseReceived, 5000)
        Core.NotifyRightTip(_source, T.Notify.horseGiven, 4000)
        return
    end

    if action == "wagon" then
        local identifier = Character.identifier
        local charid = Character.charIdentifier
        local hash = data1
        local name = data2

        if not Config.VorpStable then
            MySQL.insert(
                "INSERT INTO wagons ( `identifier`, `charid`, `name`, `model`) VALUES ( @identifier, @charid, @name, @model)"
                , {
                    identifier = identifier,
                    charid = charid,
                    name = tostring(name),
                    model = hash
                })
        else
            MySQL.insert(
                "INSERT INTO stables ( `identifier`, `charidentifier`, `name`, `modelname`,`type`,`inventory` ) VALUES ( @identifier, @charid, @name, @modelname, @type, @inventory)"
                , {
                    identifier = identifier,
                    charid = charid,
                    name = tostring(name),
                    modelname = hash,
                    type = "wagon",
                    inventory = json.encode({})
                })
        end
        Core.NotifyRightTip(targetID, T.Notify.wagonReceived, 5000)
        Core.NotifyRightTip(_source, T.Notify.weaponGiven, 4000)
    end
end)


--REMOVE DB

RegisterServerEvent("vorp_admin:ClearAllItems", function(type, targetID, command)
    local _source = source

    if not Core.getUser(targetID) then
        return
    end

    if not AllowedToExecuteAction(_source, command) then
        return
    end

    exports.vorp_inventory:closeInventory(targetID)

    if type == "items" then
        local inv = exports.vorp_inventory:getUserInventoryItems(targetID)
        if not inv then
            return print("empty inventory ")
        end

        for key, inventoryItems in pairs(inv) do
            Wait(10)
            exports.vorp_inventory:subItem(targetID, inventoryItems.name, inventoryItems.count)
        end
        Core.NotifyRightTip(_source, T.Notify.itemsWiped, 4000)
        Core.NotifyRightTip(targetID, T.Notify.itemWipe, 5000)
    end

    if type == "weapons" then
        local weaponsPlayer = exports.vorp_inventory:getUserInventoryWeapons(targetID)
        for key, value in pairs(weaponsPlayer) do
            local id = value.id
            exports.vorp_inventory:subWeapon(targetID, id)
            exports.vorp_inventory:deleteWeapon(targetID, id)
            TriggerClientEvent('syn_weapons:removeallammo', targetID)  -- syn script
            TriggerClientEvent('vorp_weapons:removeallammo', targetID) -- vorp
        end
        Core.NotifyRightTip(_source, T.Notify.weaponsWiped, 4000)
        Core.NotifyRightTip(targetID, T.Notify.weaponWipe, 5000)
    end
end)

--GET ITEMS FROM INVENTORY
RegisterServerEvent("vorp_admin:checkInventory", function(targetID, command)
    local _source = source
    if not Core.getUser(targetID) then
        return
    end
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    local inv = exports.vorp_inventory:getUserInventoryItems(targetID)
    TriggerClientEvent("vorp_admin:getplayerInventory", _source, inv)
end)

--REMOVE CURRENCY
RegisterServerEvent("vorp_admin:ClearCurrency", function(targetID, type, command)
    local _source = source

    local User = Core.getUser(targetID)
    if not User then
        return
    end

    if not AllowedToExecuteAction(_source, command) then
        return
    end

    local Character = User.getUsedCharacter
    local money = User.getUsedCharacter.money
    local gold = User.getUsedCharacter.gold

    if type == "money" then
        Character.removeCurrency(0, money)
        Core.NotifyRightTip(_source, T.Notify.moneyRemoved, 4000)
        Core.NotifyRightTip(targetID, T.Notify.moneyRemovedFromAdmin, 4000)
    else
        Character.removeCurrency(1, gold)
        Core.NotifyRightTip(_source, T.Notify.goldRemoved, 4000)
        Core.NotifyRightTip(targetID, T.Notify.goldRemovedFromAdmin, 4000)
    end
end)

-----------------------------------------------------------------------------------------------------------------
--ADMINACTIONS
--GROUP
RegisterServerEvent("vorp_admin:setGroup", function(targetID, newgroup, command)
    local _source = source
    local _target = targetID
    local NewPlayerGroup = newgroup
    local user = Core.getUser(_target)
    if not user then
        return
    end

    if not AllowedToExecuteAction(_source, command) then
        return
    end

    local character = user.getUsedCharacter
    character.setGroup(NewPlayerGroup)
    user.setGroup(NewPlayerGroup)
    TriggerEvent("vorp:setGroup", _target, NewPlayerGroup)
    Core.NotifyRightTip(_target, T.Notify.groupGiven .. NewPlayerGroup, 5000)
end)
-- JOB
RegisterServerEvent("vorp_admin:setJob", function(targetID, newjob, newgrade, newJobLabel, command)
    local _source = source
    local _target = targetID

    if not AllowedToExecuteAction(_source, command) then
        return
    end

    local user = Core.getUser(_target)
    if not user then
        return print("user not found")
    end
    local character = user.getUsedCharacter
    character.setJob(newjob)
    character.setJobGrade(newgrade)
    character.setJobLabel(newJobLabel)

    Core.NotifyRightTip(_target, T.Notify.jobGiven .. newjob, 5000)
    Core.NotifyRightTip(_target, T.Notify.gradeGiven .. newgrade, 5000)
    Core.NotifyRightTip(_target, T.Notify.jobLabelGiven .. newJobLabel, 5000)
end)

-- WHITELIST
RegisterServerEvent("vorp_admin:Whitelist", function(targetID, steam, type, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    local steam = steam
    if type == "addWhiteList" then
        Core.Whitelist.WhitelistUser(steam)
    else
        Core.Whitelist.unWhitelistUser(steam)
    end
end)

RegisterServerEvent("vorp_admin:Whitelistoffline", function(staticid, type, command)
    local _source = source
    local staticID = staticid

    if not AllowedToExecuteAction(_source, command) then
        return
    end
    if type == "whiteList" then
        TriggerEvent("vorp:whitelistPlayer", staticID)
    else
        TriggerEvent("vorp:unwhitelistPlayer", staticID)
    end
end)

--REVIVE
RegisterServerEvent("vorp_admin:revive", function(targetID, command)
    local _source = source
    local _target = targetID

    if not AllowedToExecuteAction(_source, command) then
        return
    end

    if Core.getUser(_target) then
        TriggerClientEvent('vorp:resurrectPlayer', _target)
    end
end)

--HEAL
RegisterServerEvent("vorp_admin:heal", function(targetID, command)
    local _source = source
    local _target = targetID

    if not AllowedToExecuteAction(_source, command) then
        return
    end

    if Core.getUser(_target) then
        TriggerClientEvent('vorp:heal', _target)
    end
end)

--SPECTATE
RegisterServerEvent("vorp_admin:spectate", function(targetID, command)
    local _source = source

    if not AllowedToExecuteAction(_source, command) then
        return
    end
    local targetCoords = GetEntityCoords(GetPlayerPed(targetID))
    TriggerClientEvent("vorp_admin:spectatePlayer", _source, targetID, targetCoords)
end)


RegisterServerEvent("vorp_admin:announce", function(announce, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end

    Core.NotifySimpleTop(-1, T.Notify.announce, announce, 10000)
end)

RegisterNetEvent('vorp_admin:HealSelf', function(command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    TriggerClientEvent('vorp:heal', _source)
end)

RegisterNetEvent('vorp_admin:ReviveSelf', function(command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    TriggerClientEvent('vorp:resurrectPlayer', _source)
end)

RegisterNetEvent("vorp_admin:Unban", function(staticid, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end

    TriggerEvent("vorpbans:addtodb", false, staticid, 0)
end)

RegisterNetEvent("vorp_admin:BanOffline", function(staticid, time, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end

    TriggerEvent("vorpbans:addtodb", false, staticid, time)
end)

RegisterNetEvent('vorp:teleportWayPoint', function(command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    TriggerClientEvent('vorp:teleportWayPoint', _source)
end)


-----------------------------------------------------------------------------------------------------------------
--PERMISSIONS
--OPEN MAIN MENU
RegisterServerEvent('vorp_admin:opneStaffMenu', function(object)
    local _source = source
    local ace = IsPlayerAceAllowed(_source, object) -- this feature allows to have discord role permissions
    local Character = Core.getUser(_source).getUsedCharacter
    local User = Core.getUser(_source)
    local group = Character.group
    local group1 = User.getGroup
    if ace or CheckTable(group, group1, object) then
        Perm = true
        TriggerClientEvent('vorp_admin:OpenStaffMenu', _source, Perm)
    else
        Perm = false
        TriggerClientEvent('vorp_admin:OpenStaffMenu', _source, Perm)
    end
end)


-------------------------------------------------------------------------------------------------------------------
-------------------------- Troll Actions--------------------------------------------------------------------------
RegisterServerEvent('vorp_admin:ServerTrollKillPlayerHandler', function(playerserverid, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    TriggerClientEvent('vorp_admin:ClientTrollKillPlayerHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerTrollInvisibleHandler', function(playerserverid, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    TriggerClientEvent('vorp_admin:ClientTrollInvisbleHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerTrollLightningStrikePlayerHandler', function(playerserverid, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    local playerPed = GetPlayerPed(playerserverid)
    local coords = GetEntityCoords(playerPed)
    TriggerClientEvent('vorp_admin:ClientTrollLightningStrikePlayerHandler', -1, coords)
end)

RegisterServerEvent('vorp_admin:ServerTrollSetPlayerOnFireHandler', function(playerserverid, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    TriggerClientEvent('vorp_admin:ClientTrollSetPlayerOnFireHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerTrollTPToHeavenHandler', function(playerserverid, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    TriggerClientEvent('vorp_admin:ClientTrollTPToHeavenHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerTrollRagdollPlayerHandler', function(playerserverid, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    TriggerClientEvent('vorp_admin:ClientTrollRagdollPlayerHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerDrainPlayerStamHandler', function(playerserverid, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    TriggerClientEvent('vorp_admin:ClientDrainPlayerStamHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerHandcuffPlayerHandler', function(playerserverid, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    TriggerClientEvent('vorp_admin:ClientHandcuffPlayerHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerTempHighPlayerHandler', function(playerserverid, command)
    local _source = source
    if not AllowedToExecuteAction(_source, command) then
        return
    end
    TriggerClientEvent('vorp_admin:ClientTempHighPlayerHandler', playerserverid)
end)

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- DISCORD --------------------------------------------------------

function GetIdentity(source, identity)
    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len(identity .. ":")) == identity .. ":" then
            return v
        end
    end
end

RegisterServerEvent('vorp_admin:logs', function(webhook, title, description)
    local _source = source

    local Identifier = GetPlayerIdentifier(_source, 1)
    local discordIdentity = GetIdentity(_source, "discord")
    local discordId = string.sub(discordIdentity, 9)
    local ip = GetPlayerEndpoint(_source)
    local steamName = GetPlayerName(_source)

    local message = "**Steam name: **`" ..
        steamName ..
        "`**\nIdentifier**`" ..
        Identifier ..
        "` \n**Discord:** <@" ..
        discordId ..
        ">**\nIP: **`" .. ip .. "`\n `" .. description .. "`"
    Core.AddWebhook(title, webhook, message, Config.webhookColor, Config.name, Config.logo, Config.footerLogo,
        Config.Avatar)
end)



-- alert staff of report
RegisterServerEvent('vorp_admin:alertstaff', function(source)
    local _source = source
    local Character = Core.getUser(_source).getUsedCharacter
    local playername = Character.firstname .. ' ' .. Character.lastname --player char name

    for _, staff in pairs(stafftable) do
        Core.NotifyRightTip(staff, T.Notify.player .. playername .. T.Notify.reportedToDiscord, 4000)
    end
end)


RegisterServerEvent("vorp_admin:getStaffInfo", function(source)
    local _source = source

    local Staff = Core.getUser(_source).getUsedCharacter
    local User = Core.getUser(_source)
    local staffgroup1 = User.getGroup
    local staffgroup = Staff.group

    if staffgroup and staffgroup ~= "user" or staffgroup1 and staffgroup1 ~= "user" then
        stafftable[_source] = _source
    end
    local data = getUserData(User, _source)
    PlayersTable[_source] = data
end)

RegisterNetEvent("vorp_admin:requeststaff", function(source, type)
    local _source = source
    local playerID = _source
    local Character = Core.getUser(_source).getUsedCharacter
    local playername = Character.firstname .. ' ' .. Character.lastname --player char name
    for id, staff in pairs(stafftable) do
        if type == "new" then
            Core.NotifyRightTip(staff, playername .. " ID: " .. playerID .. T.Notify.requestingAssistance .. T.Notify
                .new, 4000)
        elseif type == "bug" then
            Core.NotifyRightTip(staff,
                playername .. " ID: " .. playerID .. T.Notify.requestingAssistance .. T.Notify.foundBug, 4000)
        elseif type == "rules" then
            Core.NotifyRightTip(staff,
                playername .. " ID: " .. playerID .. T.Notify.requestingAssistance .. T.Notify.someoneBrokerules, 4000)
        elseif type == "cheating" then
            Core.NotifyRightTip(staff,
                playername .. " ID: " .. playerID .. T.Notify.requestingAssistance .. T.Notify.someoneCheating, 4000)
        end
    end
end)


AddEventHandler('playerDropped', function()
    local _source = source

    if stafftable[_source] then
        stafftable[_source] = nil
    end
    if PlayersTable[_source] then
        PlayersTable[_source] = nil
    end
end)
