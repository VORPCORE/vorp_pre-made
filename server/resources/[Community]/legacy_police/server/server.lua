local VORPInv = {}
VORPInv = exports.vorp_inventory:vorp_inventoryApi()

local VORPcore = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

RegisterServerEvent("lawmen:grabdata") -- Go on duty, add cop count, restrict based off Max cop count event
AddEventHandler("lawmen:grabdata", function(id)
    local _source = source
    local player = VORPcore.getUser(id).getUsedCharacter
    local playermoney = player.money
    TriggerClientEvent('lawmen:senddata', _source, playermoney)
end)

RegisterServerEvent("lawmen:goondutysv") -- Go on duty, add cop count, restrict based off Max cop count event
AddEventHandler("lawmen:goondutysv", function(ptable)
    local _source = source
    local player = VORPcore.getUser(_source).getUsedCharacter
    local job = player.job
    local grade = player.jobGrade
    local playername = player.firstname .. ' ' .. player.lastname
    if CheckTable(OffDutyJobs, job) then

        if job == OffDutyJobs[1] then
            player.setJob(OnDutyJobs[1], grade)
            VORPcore.NotifyBottomRight(_source, _U('goonduty'), 4000)
        elseif job == OffDutyJobs[2] then
            player.setJob(OnDutyJobs[2], grade)
            VORPcore.NotifyBottomRight(_source, _U('goonduty'), 4000)
        elseif job == OffDutyJobs[3] then
            player.setJob(OnDutyJobs[3], grade)
            VORPcore.NotifyBottomRight(_source, _U('goonduty'), 4000)
        elseif job == OffDutyJobs[4] then
            player.setJob(OnDutyJobs[4], grade)
            VORPcore.NotifyBottomRight(_source, _U('goonduty'), 4000)
        elseif job == OffDutyJobs[5] then
            player.setJob(OnDutyJobs[5], grade)
            VORPcore.NotifyBottomRight(_source, _U('goonduty'), 4000)
        elseif job == OffDutyJobs[6] then
            player.setJob(OnDutyJobs[6], grade)
            VORPcore.NotifyBottomRight(_source, _U('goonduty'), 4000)
        elseif job == OffDutyJobs[7] then
            player.setJob(OnDutyJobs[7], grade)
            VORPcore.NotifyBottomRight(_source, _U('goonduty'), 4000)
        elseif job == OffDutyJobs[8] then
            player.setJob(OnDutyJobs[8], grade)
            VORPcore.NotifyBottomRight(_source, _U('goonduty'), 4000)
        elseif job == OffDutyJobs[9] then
            player.setJob(OnDutyJobs[9], grade)
            VORPcore.NotifyBottomRight(_source, _U('goonduty'), 4000)
        elseif job == OffDutyJobs[10] then
            player.setJob(OnDutyJobs[10], grade)
            VORPcore.NotifyBottomRight(_source, _U('goonduty'), 4000)
        end
        TriggerClientEvent("lawmen:onduty", _source, true)
    else
        VORPcore.NotifyBottomRight(_source, _U('nottherightjob'), 4000)
    end
end)

RegisterServerEvent("lawmen:synsociety", function(status)
    local _source = source
    local player = VORPcore.getUser(_source).getUsedCharacter
    local job = player.job
    exports["syn_society"]:SetPlayerDuty(_source, job, status, nil)
end)

RegisterServerEvent("lawmen:gooffdutysv") -- Go off duty event
AddEventHandler("lawmen:gooffdutysv", function()
    print('offduty is triggered')
    local _source = source
    local player = VORPcore.getUser(_source).getUsedCharacter
    local job = player.job
    local grade = player.jobGrade
    for k, v in pairs(OnDutyJobs) do
        if v == job then
            player.setJob('off' .. job, grade)

            VORPcore.NotifyBottomRight(_source, _U('gooffduty'), 4000)
            TriggerClientEvent("lawmen:offdutycl", _source, false)
        end
        TriggerClientEvent("lawmen:onduty", _source, false)
    end
end)

RegisterServerEvent('lawmen:FinePlayer') --Fine a player event, this is the one that removes right from pockets
AddEventHandler('lawmen:FinePlayer', function(player, amount)
    local _source = source
    local target = VORPcore.getUser(player).getUsedCharacter
    local user = VORPcore.getUser(_source).getUsedCharacter
    local username = user.firstname .. ' ' .. target.lastname
    local Job = user.job
    local targetname = target.firstname .. ' ' .. target.lastname

    local fine = tonumber(amount)
    print("fine", fine)

    for i, v in pairs(OnDutyJobs) do
        if v == user.job then
            local pJob = v
            local Society_Account = pJob
            if user.job == Society_Account then
                if target.money < fine then
                    target.removeCurrency(0, target.money)
                    exports.ghmattimysql:executeSync('UPDATE society_ledger SET ledger = ledger + @fine WHERE job = @job'
                        , { fine = target.money, job = Society_Account })
                else
                    target.removeCurrency(0, fine)
                    exports.ghmattimysql:executeSync('UPDATE society_ledger SET ledger = ledger + @fine WHERE job = @job'
                        , { fine = fine, job = Society_Account })
                end

                if Config.UseWebhook then
                    VORPcore.AddWebhook(Config.WebhookInfo.FineTitle, Config.WebhookInfo.FineWebhook,
                        Job .. ' ' .. username .. _U('gaveafine') .. amount .. _U('to') .. targetname,
                        Config.WebhookInfo.FineColor,
                        Config.WebhookInfo.FineName, Config.WebhookInfo.FineLogo, Config.WebhookInfo.FineFooterLogo,
                        Config.WebhookInfo.FineAvatar)
                end

                VORPcore.NotifyBottomRight(_source,
                    _U('youfined') .. target.firstname .. ' ' .. target.lastname .. _U('currency') .. amount, 4000)
                VORPcore.NotifyBottomRight(player, _U('recievedfine') .. fine, 4000)
            end
        end
    end
end)

RegisterServerEvent('lawmen:JailPlayer') --Jail player event
AddEventHandler('lawmen:JailPlayer', function(player, amount, loc)
    local _source = source
    local target = VORPcore.getUser(player).getUsedCharacter
    local user = VORPcore.getUser(_source).getUsedCharacter
    local username = user.firstname .. ' ' .. target.lastname
    local Job = user.job
    local targetname = target.firstname .. ' ' .. target.lastname
    local steam_id = target.identifier
    local Character = target.charIdentifier
    -- TIME
    local time_m = tostring(amount)
    local amount = amount * 60
    local timestamp = getTime() + amount

    exports.ghmattimysql:execute("INSERT INTO jail (identifier, characterid, name, time, time_s, jaillocation) VALUES (@identifier, @characterid, @name, @timestamp, @time, @jaillocation)"
        ,
        { ["@identifier"] = steam_id, ["@characterid"] = Character, ["@name"] = targetname, ["@timestamp"] = timestamp,
            ["@time"] = amount, ["@jaillocation"] = loc })
    TriggerClientEvent("lawmen:JailPlayer", player, amount, loc)

    if Config.UseWebhook then
        VORPcore.AddWebhook(Config.WebhookInfo.JailTitle, Config.WebhookInfo.JailWebhook,
            Job .. ' ' .. username .. _U('sentto') .. targetname .. _U('tojailfor') .. amount .. _U('seconds'),
            Config.WebhookInfo.JailColor,
            Config.WebhookInfo.JailName, Config.WebhookInfo.JailLogo, Config.WebhookInfo.JailFooterLogo,
            Config.WebhookInfo.JailAvatar)
    end

end)

RegisterServerEvent('lawmen:CommunityService') --Start community Service event
AddEventHandler('lawmen:CommunityService', function(player, chore, amount)
    local _source = source
    local target = VORPcore.getUser(player).getUsedCharacter
    local user = VORPcore.getUser(_source).getUsedCharacter
    local username = user.firstname .. ' ' .. target.lastname
    local Job = user.job
    local targetname = target.firstname .. ' ' .. target.lastname
    local steam_id = target.identifier
    local Character = target.charIdentifier

    exports.ghmattimysql:execute("INSERT INTO communityservice (identifier, characterid, name, communityservice, servicecount) VALUES (@identifier, @characterid, @name, @communityservice, @servicecount)"
        ,
        { ["@identifier"] = steam_id, ["@characterid"] = Character, ["@name"] = targetname, ["@communityservice"] = chore,
            ["@servicecount"] = amount })

    TriggerClientEvent("lawmen:ServicePlayer", player, chore, amount)
    VORPcore.NotifyBottomRight(player, _U('givenservice'), 4000)

    if Config.UseWebhook then
        VORPcore.AddWebhook(Config.WebhookInfo.ServiceTitle, Config.WebhookInfo.ServiceWebhook,
            Job .. " " .. username .. _U('gaveservice') .. targetname .. amount .. _U('ofchores'),
            Config.WebhookInfo.ServiceColor,
            Config.WebhookInfo.ServiceName, Config.WebhookInfo.ServiceLogo, Config.WebhookInfo.ServiceFooterLogo,
            Config.WebhookInfo.ServiceAvatar)
    end

end)

RegisterServerEvent("lawmen:finishedjail") --Unjail event
AddEventHandler("lawmen:finishedjail", function(target_id)
    local _source = source
    local target = VORPcore.getUser(target_id).getUsedCharacter
    local steam_id = target.identifier
    local Character = target.charIdentifier
    exports.ghmattimysql:execute("SELECT * FROM `jail` WHERE characterid = @characterid",
        { ["@characterid"] = Character }
        , function(result)

        if result[1] then
            local loc = result[1]["jaillocation"]
            TriggerClientEvent("lawmen:UnjailPlayer", target_id, loc)
        end
    end)
    exports.ghmattimysql:execute("DELETE FROM jail WHERE identifier = @identifier AND characterid = @characterid",
        { ["@identifier"] = steam_id, ["@characterid"] = Character })

end)

RegisterServerEvent("lawmen:unjailed") --Unjail event
AddEventHandler("lawmen:unjailed", function(target_id, loc)
    local _source = source
    local target = VORPcore.getUser(target_id).getUsedCharacter
    local user = VORPcore.getUser(_source).getUsedCharacter
    local username = user.firstname .. ' ' .. target.lastname
    local Job = user.job
    local targetname = target.firstname .. ' ' .. target.lastname
    local steam_id = target.identifier
    local Character = target.charIdentifier
    exports.ghmattimysql:execute("SELECT * FROM `jail` WHERE characterid = @characterid",
        { ["@characterid"] = Character }
        , function(result)

        if result[1] then
            local loc = result[1]["jaillocation"]
            TriggerClientEvent("lawmen:UnjailPlayer", target_id, loc)
        end
    end)
    exports.ghmattimysql:execute("DELETE FROM jail WHERE identifier = @identifier AND characterid = @characterid",
        { ["@identifier"] = steam_id, ["@characterid"] = Character })

    if Config.UseWebhook then
        VORPcore.AddWebhook(Config.WebhookInfo.JailTitle, Config.WebhookInfo.JailWebhook,
            Job .. " " .. username .. _U('unjailed') .. targetname, Config.WebhookInfo.JailColor,
            Config.WebhookInfo.JailName, Config.WebhookInfo.JailLogo, Config.WebhookInfo.JailFooterLogo,
            Config.WebhookInfo.JailAvatar)
    end

end)

RegisterServerEvent('lawmen:GetID') -- Get id event currently not used/ *now fixed
AddEventHandler('lawmen:GetID', function(player)
    local _source = tonumber(source)

    local User = VORPcore.getUser(player)
    local Target = User.getUsedCharacter

    VORPcore.NotifyLeft(_source, _U('idcheck'),
        _U('name') .. Target.firstname .. ' ' .. Target.lastname .. "             " .. _U('job') .. Target.job,
        "toasts_mp_generic", "toast_mp_customer_service", 8000, "COLOR_WHITE")

end)

RegisterServerEvent('lawmen:getVehicleInfo') --Get vehicle/horse owner event
AddEventHandler('lawmen:getVehicleInfo', function(player, mount)
    local _source = tonumber(source)

    local User = VORPcore.getUser(player)
    local Character = User.getUsedCharacter

    exports.ghmattimysql:execute("SELECT * FROM `horses` WHERE charid=@identifier",
        { identifier = Character.charIdentifier }
        , function(result)
        local found = false
        if result[1] then
            for i, v in pairs(result) do
                if GetHashKey(v.model) == mount then
                    found = true
                    VORPcore.NotifyLeft(_source, _U('idcheck'),
                        _U('name') .. Character.firstname .. ' ' .. Character.lastname .. '', "toasts_mp_generic",
                        "toast_mp_customer_service", 8000, "COLOR_WHITE")
                end
            end
        end
        if not found then
            VORPcore.NotifyLeft(_source, _U('idcheck'), _U('notowned'), "toasts_mp_generic", "toast_mp_customer_service"
                , 8000, "COLOR_WHITE")
        end
    end)
end)

RegisterServerEvent('lawmen:handcuff', function(player)
    local _source = source
    TriggerClientEvent('lawmen:handcuff', player)
end)

RegisterServerEvent('lawmen:lockpicksv') --Lockpick Handcuff event
AddEventHandler('lawmen:lockpicksv', function(player)
    local _source = source
    local chance = math.random(1, 100)
    local user = VORPcore.getUser(_source).getUsedCharacter
    if chance < 5 then
        VORPInv.subItem(_source, 'lockpick', 1)
        VORPcore.NotifyBottomRight(_source, _U('lockpickbroke'), 4000)
    else
        TriggerClientEvent('lawmen:lockpicked', player)
    end
end)

RegisterServerEvent('lawmen:drag') --Drag Event
AddEventHandler('lawmen:drag', function(target)
    local _source = source
    local user = VORPcore.getUser(_source).getUsedCharacter
    for i, v in pairs(OnDutyJobs) do
        if user.job == v then
            TriggerClientEvent('lawmen:drag', target, _source)
        end
    end
end)

RegisterServerEvent("lawmen:updateservice") --Update chore amount when chore is completed event
AddEventHandler("lawmen:updateservice", function()
    local _source = source
    Citizen.Wait(2000)
    local User = VORPcore.getUser(_source)
    local CharInfo = User.getUsedCharacter
    local steam_id = CharInfo.identifier
    local Character = CharInfo.charIdentifier
    exports.ghmattimysql:execute("SELECT * FROM communityservice WHERE identifier = @identifier AND characterid = @characterid"
        , { ["@identifier"] = steam_id, ["@characterid"] = Character }, function(result)
        if result[1] ~= nil then
            local count = result[1]["servicecount"]
            local identifier = result[1]["identifier"]
            local charid = result[1]["characterid"]
            exports.ghmattimysql:execute("UPDATE communityservice SET servicecount = @count WHERE identifier = @identifier AND characterid = @characterid"
                , { ["@identifier"] = identifier, ["@characterid"] = charid, ["@count"] = count - 1 })
        end
    end)
end)

RegisterNetEvent("lawmen:endservice") -- Finished Community Service Event
AddEventHandler("lawmen:endservice", function()
    local _source = source
    local User = VORPcore.getUser(_source)
    local CharInfo = User.getUsedCharacter
    local steam_id = CharInfo.identifier
    local Character = CharInfo.charIdentifier
    exports.ghmattimysql:execute("DELETE FROM communityservice WHERE identifier = @identifier AND characterid = @characterid"
        , { ["@identifier"] = steam_id, ["@characterid"] = Character }, function(result)
        if result[1] ~= nil then
            VORPcore.NotifyBottomRight(_source, _U('servicecomplete'), 4000)

        end
    end)
end)

RegisterNetEvent("lawmen:jailedservice") --Jailed from breaking community service event
AddEventHandler("lawmen:jailedservice", function()
    local _source = source

    local User = VORPcore.getUser(_source)
    local CharInfo = User.getUsedCharacter
    local steam_id = CharInfo.identifier

    local Character = CharInfo.charIdentifier
    exports.ghmattimysql:execute("DELETE FROM communityservice WHERE identifier = @identifier AND characterid = @characterid"
        , { ["@identifier"] = steam_id, ["@characterid"] = Character }, function(result)
        if result[1] ~= nil then
            VORPcore.NotifyBottomRight(_source, _U('jailed'), 4000)
        end
    end)
end)


RegisterServerEvent("lawmen:check_jail") --Check if jailed when selecting character event
AddEventHandler("lawmen:check_jail", function()
    local _source = source
    Citizen.Wait(2000)
    local User = VORPcore.getUser(_source)
    local CharInfo = User.getUsedCharacter
    local steam_id = CharInfo.identifier
    local Character = CharInfo.charIdentifier
    exports.ghmattimysql:execute("SELECT * FROM jail WHERE identifier = @identifier AND characterid = @characterid",
        { ["@identifier"] = steam_id, ["@characterid"] = Character }, function(result)
        if result[1] ~= nil then
            local time = result[1]["time_s"]
            local identifier = result[1]["identifier"]
            exports.ghmattimysql:execute("UPDATE jail SET time = @time WHERE identifier = @identifier",
                { ["@time"] = getTime() + time, ["@identifier"] = identifier })
            time = tonumber(time)
            TriggerClientEvent("lawmen:JailPlayer", _source, time)
            TriggerEvent("lawmen:wear_prison", _source)
        end
    end)
end)

RegisterNetEvent("lawmen:jailbreak") --Jail break event, deletes time in jail
AddEventHandler("lawmen:jailbreak", function()
    local _source = source
    Citizen.Wait(1000)
    local User = VORPcore.getUser(_source)
    local CharInfo = User.getUsedCharacter
    local steam_id = CharInfo.identifier
    local Character = CharInfo.charIdentifier
    exports.ghmattimysql:execute("DELETE FROM jail WHERE identifier = @identifier AND characterid = @characterid",
        { ["@identifier"] = steam_id, ["@characterid"] = Character }, function(result)
    end)
end)

RegisterServerEvent("lawmen:taketime") --Updates timer of how long left in jail defined by player
AddEventHandler("lawmen:taketime", function()
    local _source = source
    local User = VORPcore.getUser(_source)
    local CharInfo = User.getUsedCharacter
    local steam_id = CharInfo.identifier
    local Character = CharInfo.charIdentifier
    exports.ghmattimysql:execute("SELECT * FROM jail WHERE identifier = @identifier AND characterid = @characterid",
        { ["@identifier"] = steam_id, ["@characterid"] = Character }, function(result)
        if result[1] ~= nil then
            local time = result[1]["time_s"]
            local newtime = time - 30
            local identifier = result[1]["identifier"]
            exports.ghmattimysql:execute("UPDATE jail SET time_s = @time WHERE identifier = @identifier",
                { ["@time"] = newtime, ["@identifier"] = identifier })
        end
    end)
end)

RegisterServerEvent("lawmen:guncabinet") -- Adds weapon from gun cabinet
AddEventHandler("lawmen:guncabinet", function(weapon, ammoList, compList)
    local _source = source
    VORPInv.createWeapon(_source, weapon, ammoList, compList)
end)

RegisterServerEvent("lawmen:addammo") -- Adds weapon from gun cabinet
AddEventHandler("lawmen:addammo", function(ammotype)
    local _source = source
    VORPInv.addItem(_source, ammotype, 1)
end)

function getTime() -- GEt time function
    return os.time(os.date("!*t"))
end

RegisterServerEvent('lawmen:lockpick:break') --Lockpick broke event
AddEventHandler('lawmen:lockpick:break', function()
    local _source = source
    local user = VORPcore.getUser(_source).getUsedCharacter
    VORPInv.subItem(_source, "lockpick", 1)
    VORPcore.NotifyBottomRight(_source, _U('lockpickbroke'), 4000)
end)

VORPInv.RegisterUsableItem("lockpick", function(data) --Lockpick usable
    VORPInv.CloseInv(data.source)
    TriggerClientEvent("lawmen:lockpick", data.source)
end)

VORPInv.RegisterUsableItem("handcuffs", function(data) --Handcuffs usable
    VORPInv.CloseInv(data.source)
    TriggerClientEvent("lawmen:cuffs", data.source)
end)

function CheckTable(table, element)
    for k, v in pairs(table) do
        if v == element then
            return true
        end
    end
    return false
end

RegisterServerEvent("lawmen:policenotify")
AddEventHandler("lawmen:policenotify", function(coords)
    print(coords)
    for z, m in ipairs(GetPlayers()) do
        local User = VORPcore.getUser(m)
        local used = User.getUsedCharacter
        if CheckTable(OnDutyJobs, used.job) then -- if job exist in table then pass
            Wait(200)
            TriggerClientEvent("lawmen:witness", m, coords)
        end
    end
end)

RegisterCommand(Config.finecommand, function(source, args, rawCommand)
    local _source = source -- player source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local Job = Character.job
    local target = args[1]
    local fine = args[2]
    if Character.group == "admin" or CheckTable(OnDutyJobs, job) then
        TriggerEvent("lawmen:FinePlayer", tonumber(target), tonumber(fine))
    end
end)

RegisterCommand(Config.jailcommand, function(source, args, rawCommand)
    local _source = source -- player source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local target = args[1]
    local jailtime = args[2]
    local jailid = args[3]
    if jailid == nil then
        jailid = 'sk'
    end
    if Character.group == "admin" or CheckTable(OnDutyJobs, job) then
        TriggerEvent('lawmen:JailPlayer', tonumber(target), tonumber(jailtime), jailid)
    end
end)

RegisterCommand(Config.unjailcommand, function(source, args, rawCommand)
    local _source = source -- player source

    local Character = VORPcore.getUser(_source).getUsedCharacter
    local target = tonumber(args[1])
    if target then
        if VORPcore.getUser(target) then
            if Character.group == "admin" or CheckTable(OnDutyJobs, job) then
                TriggerEvent("lawmen:unjailed", tonumber(target))
            end
        end
    end
end)

RegisterServerEvent('lawmen:PlayerJob')
AddEventHandler('lawmen:PlayerJob', function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local CharacterJob = Character.job
    TriggerClientEvent('lawmen:PlayerJob', _source, CharacterJob)
end)

RegisterServerEvent("lawmen:GetPlayerWagonID") -- Take out vehicle event not currently used
AddEventHandler("lawmen:GetPlayerWagonID", function(player)
    local _source = source
    if player ~= nil then
        TriggerClientEvent('lawmen:PlayerInWagon', player)
    end
end)

RegisterServerEvent('syn_search:TakeFromsteal')
AddEventHandler('syn_search:TakeFromsteal', function(obj)
    local _source = source
    TriggerClientEvent('lawmen:GetSearch', _source, obj)
    TriggerClientEvent("vorp_inventory:CloseInv", _source)
end)

RegisterServerEvent('lawmen:TakeFrom')
AddEventHandler('lawmen:TakeFrom', function(obj, steal_source)
    local _steal_source = steal_source
    local _source = source
    local target = VORPcore.getUser(_steal_source).getUsedCharacter
    local targetname = target.firstname .. ' ' .. target.lastname
    local user = VORPcore.getUser(_source).getUsedCharacter
    local username = user.firstname .. ' ' .. user.lastname
    local Job = user.job

    local decode_obj = json.decode(obj)

    if decode_obj.type ~= 'item_weapon' and tonumber(decode_obj.number) > 0 and
        tonumber(decode_obj.number) <= tonumber(decode_obj.item.count) then
        local canCarry = VORPInv.canCarryItem(_source, decode_obj.item.name, decode_obj.number)
        if canCarry then
            VORPInv.subItem(_steal_source, decode_obj.item.name, decode_obj.number, decode_obj.item.metadata)
            VORPInv.addItem(_source, decode_obj.item.name, decode_obj.number, decode_obj.item.metadata)
            VORPcore.NotifyBottomRight(_source, _U('took') .. decode_obj.number .. " " .. decode_obj.item.label, 4000)
            Wait(100)
            TriggerEvent('lawmen:ReloadInventory', _steal_source, _source)
            if Config.UseWebhook then
                VORPcore.AddWebhook(Config.WebhookInfo.SearchedTitle, Config.WebhookInfo.SearchedWebhook,
                    Job ..
                    " " ..
                    username ..
                    _U('took') .. decode_obj.number .. " " .. decode_obj.item.label .. _U('from') .. targetname,
                    Config.WebhookInfo.SearchedColor,
                    Config.WebhookInfo.SearchedName, Config.WebhookInfo.SearchedLogo,
                    Config.WebhookInfo.SearchedFooterLogo,
                    Config.WebhookInfo.SearchedAvatar)
            end
        else
        end
    elseif decode_obj.type == 'item_weapon' then
        VORPInv.canCarryWeapons(_source, decode_obj.number, function(cb)
            local canCarry = cb
            if canCarry then
                VORPInv.subWeapon(_steal_source, decode_obj.item.id)
                VORPInv.giveWeapon(_source, decode_obj.item.id, 0)
                VORPcore.NotifyBottomRight(_source, _U('took') .. decode_obj.item.label .. _U('from') .. targetname, 4000)

                Wait(100)
                TriggerEvent('lawmen:ReloadInventory', _steal_source, _source)
                if Config.UseWebhook then
                    VORPcore.AddWebhook(Config.WebhookInfo.SearchedTitle, Config.WebhookInfo.SearchedWebhook,
                        Job ..
                        " " ..
                        username ..
                        _U('took') .. decode_obj.number .. " " .. decode_obj.item.label .. _U('from') .. targetname,
                        Config.WebhookInfo.SearchedColor,
                        Config.WebhookInfo.SearchedName, Config.WebhookInfo.SearchedLogo,
                        Config.WebhookInfo.SearchedFooterLogo,
                        Config.WebhookInfo.SearchedAvatar)
                end
            else
            end
        end)
    end
end)

RegisterServerEvent('lawmen:ReloadInventory')
AddEventHandler('lawmen:ReloadInventory', function(steal_source, player_source)
    local _steal_source = steal_source
    local _source
    if not player_source then
        _source = source
    else
        _source = player_source
    end
    local inventory = {}

    TriggerEvent('vorpCore:getUserInventory', tonumber(_steal_source), function(getInventory)
        for _, item in pairs(getInventory) do
            local data_item = {
                count = item.count,
                name = item.name,
                limit = item.limit,
                type = item.type,
                label = item.label,
                metadata = item.metadata,
            }
            table.insert(inventory, data_item)
        end
    end)
    TriggerEvent('vorpCore:getUserWeapons', tonumber(_steal_source), function(getUserWeapons)
        for _, weapon in pairs(getUserWeapons) do
            local data_weapon = {
                count = -1,
                name = weapon.name,
                limit = -1,
                type = 'item_weapon',
                label = '',
                id = weapon.id,
            }
            table.insert(inventory, data_weapon)
        end
    end)

    local data = {
        itemList = inventory,
        action = 'setSecondInventoryItems',
    }
    TriggerClientEvent('vorp_inventory:ReloadstealInventory', _source, json.encode(data))
end)
