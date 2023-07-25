local VorpCore = {}

TriggerEvent("getCore", function(core)
    VorpCore = core
end)


RegisterServerEvent("vorp_sellhorse:giveReward", function(data)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    if type(data) == "table" then
        if data.money ~= 0 then
            Character.addCurrency(0, data.money)
        end

        if data.gold ~= 0 then
            Character.addCurrency(1, data.gold)
        end

        if data.rolPoints ~= 0 then
            Character.addCurrency(2, data.rolPoints)
        end

        if data.xp ~= 0 then
            Character.addXp(data.xp)
        end
    else
        print(_source, Character.identifier, " this is a cheater bann player ")
        VorpCore.AddWebhook("Cheater", Config.WebhookCheatLog,
            "player with steam: " .. Character.identifier .. " server id: " .. _source .. " is cheating")
    end
end)

local function CheckJob(index, job)
    for i, value in ipairs(Config.trainers[index].trainerjob) do
        if value == job then
            return true
        end
    end
    return false
end

VorpCore.addRpcCallback('vorp_sellhorse:getjob', function(source, cb, args)
    local _source = source
    local index = args
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local job = Character.job
    if CheckJob(index, job) then
        return cb(true)
    end
    VorpCore.NotifyObjective(_source, "you do not have the right job to sell this animal", 4000)
    return cb(false)
end)
