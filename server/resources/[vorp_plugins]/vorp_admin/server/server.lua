----------------------------------------------------------------------------------------------------
------------------------------------- SERVER EXPORTS ------------------------------------------------------
local VorpCore = {}
local VORPwl = {}
local stafftable = {}
TriggerEvent("getCore", function(core)
    VorpCore = core
end)

TriggerEvent("getWhitelistTables", function(cb)
    VORPwl = cb
end)


VORPInv = exports.vorp_inventory:vorp_inventoryApi()

----------------------------------------------------------------------------------------------------
------------------------------------- EVENTS -------------------------------------------------------

--get players info list
RegisterServerEvent('vorp_admin:GetPlayers')
AddEventHandler('vorp_admin:GetPlayers', function()
    local _source = source
    local players = GetPlayers()
    local data = {}

    for _, player in ipairs(players) do
        local playerPed = GetPlayerPed(player)

        if DoesEntityExist(playerPed) then
            local coords = GetEntityCoords(playerPed)
            local User = VorpCore.getUser(player)
            local Character = User.getUsedCharacter --get player info
            local group = Character.group
            if Character.firstname then
                local playername = Character.firstname .. ' ' .. Character.lastname --player char name
                local job = Character.job --player job
                local identifier = Character.identifier --player steam
                local PlayerMoney = Character.money --money
                local PlayerGold = Character.gold --gold
                local JobGrade = Character.jobGrade --jobgrade
                local getid = VORPwl.getEntry(identifier).getId() -- userID this is a static ID used to whitelist or ban
                local getstatus = VORPwl.getEntry(identifier).getStatus() -- whitelisted returns true or false
                local warnstatus = User.getPlayerwarnings() --get players warnings

                data[tostring(player)] = {
                    serverId = player,
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    name = GetPlayerName(player),
                    Group = group,
                    PlayerName = playername,
                    Job = job,
                    SteamId = identifier,
                    ped = playerPed,
                    Money = PlayerMoney,
                    Gold = PlayerGold,
                    Grade = JobGrade,
                    staticID = tonumber(getid),
                    WLstatus = tostring(getstatus),
                    warns = tonumber(warnstatus),
                }
            end
        end
    end
    TriggerClientEvent("vorp_admin:SendPlayers", _source, data)
end)

-------------------------------------------------------------------------------
--------------------------------- EVENTS TELEPORTS -----------------------------
--TP TO
RegisterServerEvent("vorp_admin:TpToPlayer", function(targetID)
    local _source = source

    if targetID then
        local targetCoords = GetEntityCoords(GetPlayerPed(targetID))
        TriggerClientEvent('vorp_admin:gotoPlayer', _source, targetCoords)
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
    if _source then
        TriggerClientEvent("vorp_admin:Freezeplayer", _source, state)
    end
end)
---------------------------------------------------------------
--BRING
RegisterServerEvent("vorp_admin:Bring", function(targetID, adminCoords)
    if targetID then
        TriggerClientEvent("vorp_admin:Bring", targetID, adminCoords)
    end
end)

--TPBACK
RegisterServerEvent("vorp_admin:TeleportPlayerBack", function(targetID)
    if targetID then
        TriggerClientEvent('vorp_admin:TeleportPlayerBack', targetID)
    end
end)

----------------------------------------------------------------------------------
---------------------------- ADVANCED ADMIN ACTIONS ---------------------------------------

--KICK
RegisterServerEvent("vorp_admin:kick", function(targetID, reason)
    local _source = targetID
    if targetID then
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
    if _source then
        if stats == "warn" then
            TriggerClientEvent("vorp:warn", _source, staticID)
            TriggerClientEvent("vorp:TipRight", _source, reason, 8000)
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
    if _source then
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
    local _source = targetID
    if _source then
        TriggerEvent("vorp:PlayerForceRespawn", _source)
        TriggerClientEvent("vorp:PlayerForceRespawn", _source)
        VORPInv.CloseInv(_source)
        TriggerClientEvent('vorp:updatemissioNotify', _source, _U("respawned"),
            _U("lostall"), 8000)
        Wait(8000)
        TriggerClientEvent("vorp_core:respawnPlayer", _source) --remove player 
        TriggerClientEvent("vorp_admin:respawn", _source) --add effects
    end

end)


--------------------------------------------------------------------
--------------------------------------------------------------------
-- DATABASE GIVE ITEM

RegisterServerEvent("vorp_admin:givePlayer", function(targetID, type, data1, data2, data3)
    local _source = source
    if targetID then
        local Character = VorpCore.getUser(targetID).getUsedCharacter
        if type == "item" then
            local item = data1
            local qty = data2
            local itemCheck = VORPInv.getDBItem(targetID, item) --check items exist in DB
            if itemCheck then
                local canCarry = VORPInv.canCarryItems(targetID, qty) --can carry inv space
                local canCarry2 = VORPInv.canCarryItem(targetID, item, qty) --cancarry item limit
                local itemLabel = itemCheck.label
                if canCarry then
                    if canCarry2 then
                        VORPInv.addItem(targetID, item, qty)
                        TriggerClientEvent("vorp:TipRight", targetID,
                            _U("received") .. qty .. _U("of") .. itemLabel .. "~q~"
                            , 5000)
                        TriggerClientEvent("vorp:TipRight", _source, _U("itemgiven"), 4000)
                    else
                        TriggerClientEvent("vorp:TipRight", _source, _U("itemlimit"), 5000)
                    end
                else
                    TriggerClientEvent("vorp:TipRight", _source, _U("inventoryfull"), 5000)
                end
            else
                TriggerClientEvent("vorp:TipRight", _source, _U("doesnotexist"), 5000)
            end

        elseif type == "weapon" then
            local weapon = data1
            VORPInv.canCarryWeapons(targetID, 1, function(cb) --can carry weapons
                local canCarry = cb
                if canCarry then
                    VORPInv.createWeapon(targetID, weapon)
                    TriggerClientEvent("vorp:TipRight", targetID, _U("receivedweapon"), 5000)
                    TriggerClientEvent("vorp:TipRight", _source, _U("weapongiven"), 4000)
                else
                    TriggerClientEvent("vorp:TipRight", _source, _U("cantcarryweapon"), 5000)
                end
            end)
        elseif type == "moneygold" then
            local CurrencyType = data1
            local qty = data2
            if qty then
                Character.addCurrency(tonumber(CurrencyType), tonumber(qty))
                if CurrencyType == 0 then
                    TriggerClientEvent("vorp:TipRight", targetID, _U("received") .. qty .. _U("money"), 5000)
                elseif CurrencyType == 1 then
                    TriggerClientEvent("vorp:TipRight", targetID, _U("received") .. qty .. _U("gold"), 5000)
                end
                TriggerClientEvent("vorp:TipRight", _source, _U("sent"), 4000)
            else
                TriggerClientEvent("vorp:TipRight", _source, _U("addquantity"), 4000)
            end
        elseif type == "horse" then
            local identifier = Character.identifier
            local charid = Character.charIdentifier
            local hash = data1
            local name = data2
            local sex = data3
            exports.ghmattimysql:execute("INSERT INTO horses ( `identifier`, `charid`, `name`, `model`, `sex`) VALUES ( @identifier, @charid, @name, @model, @sex)"
                , { ['identifier'] = identifier, ['charid'] = charid, ['name'] = tostring(name),
                ['model'] = hash, ['sex'] = sex })

            TriggerClientEvent("vorp:TipRight", targetID,
                _U("horsereceived"), 5000)
            TriggerClientEvent("vorp:TipRight", _source, _U("horsegiven"), 4000)

        elseif type == "wagon" then
            local identifier = Character.identifier
            local charid = Character.charIdentifier
            local hash = data1
            local name = data2
            exports.ghmattimysql:execute("INSERT INTO wagons ( `identifier`, `charid`, `name`, `model`) VALUES ( @identifier, @charid, @name, @model)"
                , { ['identifier'] = identifier, ['charid'] = charid, ['name'] = tostring(name),
                ['model'] = hash })
            TriggerClientEvent("vorp:TipRight", targetID,
                _U("wagonreceived"), 5000)
            TriggerClientEvent("vorp:TipRight", _source, _U("givenwagon"), 4000)
        end
    end

end)


--REMOVE DB

RegisterServerEvent("vorp_admin:ClearAllItems", function(type, targetID)

    local _source = source
    if targetID then
        if type == "items" then
            local inv = VORPInv.getUserInventory(targetID) --getcharinventory
            for key, inventoryItems in pairs(inv) do
                VORPInv.CloseInv(targetID)
                VORPInv.subItem(targetID, inventoryItems.name, inventoryItems.count)
            end
            TriggerClientEvent("vorp:TipRight", _source, _U("itemswiped"), 4000)
            TriggerClientEvent("vorp:TipRight", targetID, _U("itemwipe"), 5000)
        elseif type == "weapons" then
            local weaponsPlayer = VORPInv.getUserWeapons(targetID) --getloadoutcharweapons
            for key, value in pairs(weaponsPlayer) do
                local id = value.id
                VORPInv.subWeapon(targetID, id)
                exports.ghmattimysql:execute("DELETE FROM loadout WHERE id=@id", { ['id'] = id })
                TriggerClientEvent('syn_weapons:removeallammo', targetID) -- syn script
                TriggerClientEvent('vorp_weapons:removeallammo', targetID) -- vorp
            end
            TriggerClientEvent("vorp:TipRight", _source, _U("weaponswiped"), 4000)
            TriggerClientEvent("vorp:TipRight", targetID, _U("weaponwipe"), 5000)
        end
    end
end)

--GET ITEMS FROM INVENTORY
RegisterServerEvent("vorp_admin:checkInventory", function(targetID)
    local _source = source
    local inv = VORPInv.getUserInventory(targetID) --getcharinventory
    if targetID then
        TriggerClientEvent("vorp_admin:getplayerInventory", _source, inv)
    end
end)
--REMOVE CURRENCY
RegisterServerEvent("vorp_admin:ClearCurrency", function(targetID, type)
    local _source = source
    local Character = VorpCore.getUser(targetID).getUsedCharacter
    local money = Character.money
    local gold = Character.gold
    if targetID then
        if type == "money" then
            Character.removeCurrency(0, money)
            TriggerClientEvent("vorp:TipRight", _source, _U("moneyremoved"), 4000)
            TriggerClientEvent("vorp:TipRight", targetID, _U("moneyremovedfromyou"), 4000)
        else
            Character.removeCurrency(1, gold)
            TriggerClientEvent("vorp:TipRight", _source, _U("goldremoved"), 4000)
            TriggerClientEvent("vorp:TipRight", targetID, _U("goldremovedfromyou"), 4000)
        end
    end

end)

-----------------------------------------------------------------------------------------------------------------
--ADMINACTIONS
--GROUP
RegisterServerEvent("vorp_admin:setGroup", function(targetID, newgroup)
    local _source = targetID
    local NewPlayerGroup = newgroup
    if _source then
        TriggerEvent("vorp:setGroup", _source, NewPlayerGroup)
        TriggerClientEvent("vorp:TipRight", _source,
            _U("groupgiven") .. NewPlayerGroup, 5000)
    end
end)
-- JOB
RegisterServerEvent("vorp_admin:setJob", function(targetID, newjob, newgrade)
    local _source = targetID
    local NewPlayerJoB = newjob
    local NewPlayerGrade = newgrade
    if _source then
        TriggerEvent("vorp:setJob", _source, NewPlayerJoB, NewPlayerGrade) -- it doesnt update players need to relog
        TriggerClientEvent("vorp:TipRight", _source, _U("jobgiven") .. NewPlayerJoB, 5000)
        Wait(500)
        TriggerClientEvent("vorp:TipRight", _source, _U("gradegiven") .. NewPlayerGrade, 5000)
    end
end)

-- WHITELIST
RegisterServerEvent("vorp_admin:Whitelist", function(targetID, staticid, type)
    local _source = targetID
    local staticID = staticid
    if _source then
        if type == "addWhiteList" then
            TriggerEvent("vorp:whitelistPlayer", staticID)
        else
            TriggerEvent("vorp:unwhitelistPlayer", staticID)
        end
    end
end)

RegisterServerEvent("vorp_admin:Whitelistoffline", function(staticid, type)
    local _source = source
    local staticID = staticid
    if _source then
        if type == "whiteList" then
            TriggerEvent("vorp:whitelistPlayer", staticID)
        else
            TriggerEvent("vorp:unwhitelistPlayer", staticID)
        end
    end
end)

--REVIVE
RegisterServerEvent("vorp_admin:revive", function(targetID)
    local _source = targetID
    if _source then
        TriggerClientEvent('vorp:resurrectPlayer', _source)
    end
end)

--HEAL
RegisterServerEvent("vorp_admin:heal", function(targetID)
    local _source = targetID
    if _source then
        TriggerClientEvent('vorp:heal', _source)
    end
end)

--SPECTATE
RegisterServerEvent("vorp_admin:spectate", function(targetID)
    local _source = source
    if targetID then
        local targetCoords = GetEntityCoords(GetPlayerPed(targetID))
        TriggerClientEvent("vorp_sdmin:spectatePlayer", _source, targetID, targetCoords)
    end
end)


RegisterServerEvent("vorp_admin:announce", function(announce)
    VorpCore.NotifySimpleTop(-1, _U("announce"), announce, 10000)
end)


-----------------------------------------------------------------------------------------------------------------
--PERMISSIONS
--OPEN MAIN MENU
RegisterServerEvent('vorp_admin:opneStaffMenu', function(object)
    local _source = source
    local ace = IsPlayerAceAllowed(_source, object)
    if ace then
        Perm = true
        TriggerClientEvent('vorp_admin:OpenStaffMenu', _source, Perm)
    else
        Perm = false
        TriggerClientEvent('vorp_admin:OpenStaffMenu', _source, Perm)
    end
end)

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- DISCORD --------------------------------------------------------

function Discord(webhook, title, message)

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
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

    for id, staff in pairs(stafftable) do
   
        VorpCore.NotifyRightTip(staff, _U("player") .. playername .. _U("reportedtodiscord"), 4000)
    end
end)

-- check if staff is available
RegisterServerEvent("vorp_admin:getStaffInfo", function(source)
    local _source = source
    local Staff = VorpCore.getUser(_source).getUsedCharacter
    local staffgroup = Staff.group

    if staffgroup and staffgroup ~= "user" then
        stafftable[#stafftable + 1] = _source
    end

end)

RegisterNetEvent("vorp_admin:requeststaff", function(source,type)
    local _source = source
    local playerID = _source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local playername = Character.firstname .. ' ' .. Character.lastname --player char name
    for id, staff in pairs(stafftable) do
      
        if type == "new" then
            VorpCore.NotifyRightTip(staff, playername .. " ID: " .. playerID .. _U("requestingassistance") .. _U("New"), 4000)
        elseif type == "bug" then
            VorpCore.NotifyRightTip(staff, playername .. " ID: " .. playerID .. _U("requestingassistance") .. _U("Foundbug"), 4000)
        elseif type == "rules" then
            VorpCore.NotifyRightTip(staff,playername .. " ID: " .. playerID .. _U("requestingassistance") .. _U("Someonebrokerules"), 4000)
        elseif type == "cheating" then
            VorpCore.NotifyRightTip(staff, playername .. " ID: " ..playerID .. _U("requestingassistance") .. _U("Someonecheating"), 4000)
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

end)
