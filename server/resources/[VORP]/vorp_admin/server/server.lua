---@diagnostic disable: undefined-global
----------------------------------------------------------------------------------------------------
------------------------------------- SERVER EXPORTS ------------------------------------------------------

local VORPInv = exports.vorp_inventory:vorp_inventoryApi()
local VorpCore = {}
local VORPwl = {}
local stafftable = {}
local PlayersTable = {}
TriggerEvent("getCore", function(core)
    VorpCore = core
end)

TriggerEvent("getWhitelistTables", function(cb)
    VORPwl = cb
end)


VORPInv.addItem(targetID, item, qty)
----------------------------------------------------------------------------------------------------
------------------------------------- EVENTS -------------------------------------------------------
VorpCore.addRpcCallback("vorp_admin:Callback:getplayersinfo", function(source, cb, args)
    if next(PlayersTable) then
        if args.search == "search" then -- is for unique player
            if PlayersTable[args.id] then
                return cb(PlayersTable[args.id])
            else
                return cb(false)
            end
        end
        return cb(PlayersTable)
    end
    return cb(false)
end)



-------------------------------------------------------------------------------
--------------------------------- EVENTS TELEPORTS -----------------------------
--TP TO
RegisterServerEvent("vorp_admin:TpToPlayer", function(targetID)
    local _source = source
    if VorpCore.getUser(targetID) then
        local targetCoords = GetEntityCoords(GetPlayerPed(targetID))
        TriggerClientEvent('vorp_admin:gotoPlayer', _source, targetCoords)
    else
        VorpCore.NotifyRightTip(_source, "user dont exist", 8000)
    end
end)

--SENDBACK
RegisterServerEvent("vorp_admin:sendAdminBack", function()
    local _source = source
    TriggerClientEvent('vorp_admin:sendAdminBack', _source)
end)


--FREEZE
RegisterServerEvent("vorp_admin:freeze", function(targetID, freeze)
    local _source = targetID
    local state = freeze
    if VorpCore.getUser(targetID) then
        TriggerClientEvent("vorp_admin:Freezeplayer", _source, state)
    end
end)
---------------------------------------------------------------
--BRING
RegisterServerEvent("vorp_admin:Bring", function(targetID, adminCoords)
    if VorpCore.getUser(targetID) then
        TriggerClientEvent("vorp_admin:Bring", targetID, adminCoords)
    end
end)

--TPBACK
RegisterServerEvent("vorp_admin:TeleportPlayerBack", function(targetID)
    if VorpCore.getUser(targetID) then
        TriggerClientEvent('vorp_admin:TeleportPlayerBack', targetID)
    end
end)

----------------------------------------------------------------------------------
---------------------------- ADVANCED ADMIN ACTIONS ---------------------------------------

--KICK
RegisterServerEvent("vorp_admin:kick", function(targetID, reason)
    local _source = targetID
    if VorpCore.getUser(targetID) then
        TriggerClientEvent('vorp:updatemissioNotify', _source, _U("kickednotify"), _U("notify"), 8000)
        Wait(8000)
        DropPlayer(_source, reason)
    end
end)

--UNWARN WARN
RegisterServerEvent("vorp_admin:warns", function(targetID, status, staticid, msg)
    local _source = targetID
    local staticID = staticid
    local stats = status
    local reason = msg
    if VorpCore.getUser(targetID) then
        if stats == "warn" then
            TriggerClientEvent("vorp:warn", _source, staticID)
            VorpCore.NotifyRightTip(_source, reason, 8000)
        elseif stats == "unwarn" then
            TriggerClientEvent("vorp:unwarn", _source, staticID)
        end
    end
end)

--BAN
-- todo add a reason
RegisterServerEvent("vorp_admin:BanPlayer", function(targetID, staticid, time)
    local _source = targetID
    local targetStaticId = tonumber(staticid)
    local datetime = os.time(os.date("!*t"))
    local banTime
    if VorpCore.getUser(targetID) then
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

        TriggerClientEvent('vorp:updatemissioNotify', _source, _U("banned"),
            _U("notify"), 8000)
        Wait(8000)
        TriggerClientEvent("vorp:ban", _source, targetStaticId, datetime)
    end
end)

--RESPAWN
RegisterServerEvent("vorp_admin:respawnPlayer", function(targetID)
    if VorpCore.getUser(targetID) then
        TriggerEvent("vorp:PlayerForceRespawn", targetID)
        TriggerClientEvent("vorp:PlayerForceRespawn", targetID)
        VORPInv.CloseInv(targetID)
        TriggerClientEvent('vorp:updatemissioNotify', targetID, _U("respawned"),
            _U("lostall"), 8000)
        Wait(8000)
        TriggerClientEvent("vorp_core:respawnPlayer", targetID) --remove player
        TriggerClientEvent("vorp_admin:respawn", targetID)      --add effects
    end
end)


--------------------------------------------------------------------
--------------------------------------------------------------------

RegisterServerEvent("vorp_admin:givePlayer", function(targetID, type, data1, data2, data3)
    local _source = source
    local Character = VorpCore.getUser(targetID).getUsedCharacter
    if not data2 then
        return VorpCore.NotifyRightTip(_source, "item and AMOUNT", 5000)
    end
    if not Character then
        return
    end

    if type == "item" then
        local item = data1
        local qty = data2
        local itemCheck = VORPInv.getDBItem(targetID, item)             --check items exist in DB
        if itemCheck then
            local canCarry = VORPInv.canCarryItems(targetID, qty)       --can carry inv space
            local canCarry2 = VORPInv.canCarryItem(targetID, item, qty) --cancarry item limit
            local itemLabel = itemCheck.label
            if canCarry then
                if canCarry2 then
                    VORPInv.addItem(targetID, item, qty)

                    VorpCore.NotifyRightTip(targetID,
                        _U("received") .. qty .. _U("of") .. itemLabel .. "~q~"
                        , 5000)
                    VorpCore.NotifyRightTip(_source, _U("itemgiven"), 4000)
                else
                    VorpCore.NotifyRightTip(_source, _U("itemlimit"), 5000)
                end
            else
                VorpCore.NotifyRightTip(_source, _U("inventoryfull"), 5000)
            end
        else
            VorpCore.NotifyRightTip(_source, _U("doesnotexist"), 5000)
        end
    elseif type == "weapon" then
        local weapon = data1
        VORPInv.canCarryWeapons(targetID, 1, function(cb) --can carry weapons
            local canCarry = cb
            if canCarry then
                VORPInv.createWeapon(targetID, weapon)
                VorpCore.NotifyRightTip(targetID, _U("receivedweapon"), 5000)
                VorpCore.NotifyRightTip(_source, _U("weapongiven"), 4000)
            else
                VorpCore.NotifyRightTip(_source, _U("cantcarryweapon"), 5000)
            end
        end)
    elseif type == "moneygold" then
        local CurrencyType = data1
        local qty = data2
        if qty then
            Character.addCurrency(tonumber(CurrencyType), tonumber(qty))
            if CurrencyType == 0 then
                VorpCore.NotifyRightTip(targetID, _U("received") .. qty .. _U("money"), 5000)
            elseif CurrencyType == 1 then
                VorpCore.NotifyRightTip(targetID, _U("received") .. qty .. _U("gold"), 5000)
            end
            VorpCore.NotifyRightTip(_source, _U("sent"), 4000)
        else
            VorpCore.NotifyRightTip(_source, _U("addquantity"), 4000)
        end
    elseif type == "horse" then
        local identifier = Character.identifier
        local charid = Character.charIdentifier
        local hash = data1
        local name = data2
        local sex = data3
        exports.oxmysql:execute(
            "INSERT INTO horses ( `identifier`, `charid`, `name`, `model`, `sex`) VALUES ( @identifier, @charid, @name, @model, @sex)"
            , {
                ['identifier'] = identifier,
                ['charid'] = charid,
                ['name'] = tostring(name),
                ['model'] = hash,
                ['sex'] = sex
            })

        VorpCore.NotifyRightTip(targetID,
            _U("horsereceived"), 5000)
        VorpCore.NotifyRightTip(_source, _U("horsegiven"), 4000)
    elseif type == "wagon" then
        local identifier = Character.identifier
        local charid = Character.charIdentifier
        local hash = data1
        local name = data2
        exports.oxmysql:execute(
            "INSERT INTO wagons ( `identifier`, `charid`, `name`, `model`) VALUES ( @identifier, @charid, @name, @model)"
            , {
                ['identifier'] = identifier,
                ['charid'] = charid,
                ['name'] = tostring(name),
                ['model'] = hash
            })
        VorpCore.NotifyRightTip(targetID,
            _U("wagonreceived"), 5000)
        VorpCore.NotifyRightTip(_source, _U("givenwagon"), 4000)
    end
end)


--REMOVE DB

RegisterServerEvent("vorp_admin:ClearAllItems", function(type, targetID)
    local _source = source

    if not VorpCore.getUser(targetID) then
        return
    end

    if type == "items" then
        local inv = VORPInv.getUserInventory(targetID) --getcharinventory
        for key, inventoryItems in pairs(inv) do
            VORPInv.CloseInv(targetID)
            VORPInv.subItem(targetID, inventoryItems.name, inventoryItems.count)
        end
        VorpCore.NotifyRightTip(_source, _U("itemswiped"), 4000)
        VorpCore.NotifyRightTip(targetID, _U("itemwipe"), 5000)
    elseif type == "weapons" then
        local weaponsPlayer = VORPInv.getUserWeapons(targetID) --getloadoutcharweapons
        for key, value in pairs(weaponsPlayer) do
            local id = value.id
            VORPInv.subWeapon(targetID, id)
            exports.oxmysql:execute("DELETE FROM loadout WHERE id=@id", { ['id'] = id })
            TriggerClientEvent('syn_weapons:removeallammo', targetID)  -- syn script
            TriggerClientEvent('vorp_weapons:removeallammo', targetID) -- vorp
        end
        VorpCore.NotifyRightTip(_source, _U("weaponswiped"), 4000)
        VorpCore.NotifyRightTip(targetID, _U("weaponwipe"), 5000)
    end
end)

--GET ITEMS FROM INVENTORY
RegisterServerEvent("vorp_admin:checkInventory", function(targetID)
    local _source = source
    if VorpCore.getUser(targetID) then
        local inv = VORPInv.getUserInventory(targetID) --getcharinventory
        TriggerClientEvent("vorp_admin:getplayerInventory", _source, inv)
    end
end)
--REMOVE CURRENCY
RegisterServerEvent("vorp_admin:ClearCurrency", function(targetID, type)
    local _source = source

    local Character = VorpCore.getUser(targetID).getUsedCharacter
    if not Character then
        return
    end

    local money = Character.money
    local gold = Character.gold

    if type == "money" then
        Character.removeCurrency(0, money)
        VorpCore.NotifyRightTip(_source, _U("moneyremoved"), 4000)
        VorpCore.NotifyRightTip(targetID, _U("moneyremovedfromyou"), 4000)
    else
        Character.removeCurrency(1, gold)
        VorpCore.NotifyRightTip(_source, _U("goldremoved"), 4000)
        VorpCore.NotifyRightTip(targetID, _U("goldremovedfromyou"), 4000)
    end
end)

-----------------------------------------------------------------------------------------------------------------
--ADMINACTIONS
--GROUP
RegisterServerEvent("vorp_admin:setGroup", function(targetID, newgroup)
    local _source = targetID
    local NewPlayerGroup = newgroup
    if VorpCore.getUser(_source) then
        TriggerEvent("vorp:setGroup", _source, NewPlayerGroup)
        VorpCore.NotifyRightTip(_source, _U("groupgiven") .. NewPlayerGroup, 5000)
    end
end)
-- JOB
RegisterServerEvent("vorp_admin:setJob", function(targetID, newjob, newgrade)
    local _source = targetID
    local NewPlayerJoB = newjob
    local NewPlayerGrade = newgrade
    if VorpCore.getUser(_source) then
        TriggerEvent("vorp:setJob", _source, NewPlayerJoB, NewPlayerGrade) -- it doesnt update players need to relog
        VorpCore.NotifyRightTip(_source, _U("jobgiven") .. NewPlayerJoB, 5000)
        Wait(500)
        VorpCore.NotifyRightTip(_source, _U("gradegiven") .. NewPlayerGrade, 5000)
    end
end)

-- WHITELIST
RegisterServerEvent("vorp_admin:Whitelist", function(targetID, staticid, type)
    local staticID = staticid
    if type == "addWhiteList" then
        TriggerEvent("vorp:whitelistPlayer", staticID)
    else
        TriggerEvent("vorp:unwhitelistPlayer", staticID)
    end
end)

RegisterServerEvent("vorp_admin:Whitelistoffline", function(staticid, type)
    local staticID = staticid

    if type == "whiteList" then
        TriggerEvent("vorp:whitelistPlayer", staticID)
    else
        TriggerEvent("vorp:unwhitelistPlayer", staticID)
    end
end)

--REVIVE
RegisterServerEvent("vorp_admin:revive", function(targetID)
    local _source = targetID
    if VorpCore.getUser(_source) then
        TriggerClientEvent('vorp:resurrectPlayer', _source)
    end
end)

--HEAL
RegisterServerEvent("vorp_admin:heal", function(targetID)
    local _source = targetID
    if VorpCore.getUser(_source) then
        TriggerClientEvent('vorp:heal', _source)
    end
end)

--SPECTATE
RegisterServerEvent("vorp_admin:spectate", function(targetID)
    local _source = source
    local targetCoords = GetEntityCoords(GetPlayerPed(targetID))
    TriggerClientEvent("vorp_sdmin:spectatePlayer", _source, targetID, targetCoords)
end)


RegisterServerEvent("vorp_admin:announce", function(announce)
    VorpCore.NotifySimpleTop(-1, _U("announce"), announce, 10000)
end)



local function CheckTable(group, group1, object)
    for key, value in ipairs(Config.AllowedGroups) do
        for k, v in ipairs(value.group) do
            if v == group or v == group1 then   -- group characters or users
                if value.command == object then -- if its right command
                    return true
                end
            end
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------
--PERMISSIONS
--OPEN MAIN MENU
RegisterServerEvent('vorp_admin:opneStaffMenu', function(object)
    local _source = source
    local ace = IsPlayerAceAllowed(_source, object) -- this feature allows to have discord role permissions
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local User = VorpCore.getUser(_source)
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
RegisterServerEvent('vorp_admin:ServerTrollKillPlayerHandler', function(playerserverid)
    TriggerClientEvent('vorp_admin:ClientTrollKillPlayerHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerTrollInvisibleHandler', function(playerserverid)
    TriggerClientEvent('vorp_admin:ClientTrollInvisbleHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerTrollLightningStrikePlayerHandler', function(playerserverid)
    local playerPed = GetPlayerPed(playerserverid)
    local coords = GetEntityCoords(playerPed)
    TriggerClientEvent('vorp_admin:ClientTrollLightningStrikePlayerHandler', -1, coords)
end)

RegisterServerEvent('vorp_admin:ServerTrollSetPlayerOnFireHandler', function(playerserverid)
    TriggerClientEvent('vorp_admin:ClientTrollSetPlayerOnFireHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerTrollTPToHeavenHandler', function(playerserverid)
    TriggerClientEvent('vorp_admin:ClientTrollTPToHeavenHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerTrollRagdollPlayerHandler', function(playerserverid)
    TriggerClientEvent('vorp_admin:ClientTrollRagdollPlayerHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerDrainPlayerStamHandler', function(playerserverid)
    TriggerClientEvent('vorp_admin:ClientDrainPlayerStamHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerHandcuffPlayerHandler', function(playerserverid)
    TriggerClientEvent('vorp_admin:ClientHandcuffPlayerHandler', playerserverid)
end)

RegisterServerEvent('vorp_admin:ServerTempHighPlayerHandler', function(playerserverid)
    TriggerClientEvent('vorp_admin:ClientTempHighPlayerHandler', playerserverid)
end)

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- DISCORD --------------------------------------------------------

function Discord(webhook, title, message)
    PerformHttpRequest(webhook, function(err, text, headers)
    end, 'POST', json.encode({
        embeds = {
            {
                ["color"] = Config.webhookColor,
                ["author"] = {
                    ["name"] = Config.name,
                    ["icon_url"] = Config.logo
                },
                ["title"] = title,
                ["description"] = message,
                ["footer"] = {
                    ["text"] = "VORPcore" .. " • " .. os.date("%x %X %p"),
                    ["icon_url"] = Config.footerLogo,

                },
            },

        },
        avatar_url = Config.Avatar
    }), {
        ['Content-Type'] = 'application/json'
    })
end

function GetIdentity(source, identity)
    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len(identity .. ":")) == identity .. ":" then
            return v
        end
    end
end

RegisterServerEvent('vorp_admin:logs', function(webhook, title, description)
    local _source = source
    local Identifier = GetPlayerIdentifier(_source)
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

    Discord(webhook, title, message)
end)

-- alert staff of report
RegisterServerEvent('vorp_admin:alertstaff', function(source)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local playername = Character.firstname .. ' ' .. Character.lastname --player char name

    for _, staff in pairs(stafftable) do
        VorpCore.NotifyRightTip(staff, _U("player") .. playername .. _U("reportedtodiscord"), 4000)
    end
end)

-- check if staff is available
RegisterServerEvent("vorp_admin:getStaffInfo", function(source)
    local _source = source
    local Staff = VorpCore.getUser(_source).getUsedCharacter
    local User = VorpCore.getUser(_source)
    local staffgroup1 = User.group
    local staffgroup = Staff.group

    if staffgroup and staffgroup ~= "user" or staffgroup1 and staffgroup1 ~= "user" then
        stafftable[#stafftable + 1] = _source
    end


    local Character = User.getUsedCharacter --get player info
    local group = Character.group

    local playername = Character.firstname .. ' ' .. Character.lastname --player char name
    local job = Character.job                                           --player job
    local identifier = Character.identifier                             --player steam
    local PlayerMoney = Character.money                                 --money
    local PlayerGold = Character.gold                                   --gold
    local JobGrade = Character.jobGrade                                 --jobgrade
    local getid = VORPwl.getEntry(identifier).getId()                   -- userID this is a static ID used to whitelist or ban
    local getstatus = VORPwl.getEntry(identifier).getStatus()           -- whitelisted returns true or false
    local warnstatus = User.getPlayerwarnings()                         --get players warnings

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
        staticID = tonumber(getid),
        WLstatus = tostring(getstatus),
        warns = tonumber(warnstatus),
    }
    PlayersTable[_source] = data
end)

RegisterNetEvent("vorp_admin:requeststaff", function(source, type)
    local _source = source
    local playerID = _source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local playername = Character.firstname .. ' ' .. Character.lastname --player char name
    for id, staff in pairs(stafftable) do
        if type == "new" then
            VorpCore.NotifyRightTip(staff, playername .. " ID: " .. playerID .. _U("requestingassistance") .. _U("New"),
                4000)
        elseif type == "bug" then
            VorpCore.NotifyRightTip(staff,
                playername .. " ID: " .. playerID .. _U("requestingassistance") .. _U("Foundbug"), 4000)
        elseif type == "rules" then
            VorpCore.NotifyRightTip(staff,
                playername .. " ID: " .. playerID .. _U("requestingassistance") .. _U("Someonebrokerules"), 4000)
        elseif type == "cheating" then
            VorpCore.NotifyRightTip(staff,
                playername .. " ID: " .. playerID .. _U("requestingassistance") .. _U("Someonecheating"), 4000)
        end
    end
end)

-- remove staff from table
AddEventHandler('playerDropped', function()
    local _source = source
    for index, value in pairs(stafftable) do
        if value == _source then
            stafftable[index] = nil
        end
    end
    for key, value in pairs(PlayersTable) do
        if key == _source then
            PlayersTable[key] = nil
        end
    end
end)
