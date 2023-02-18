CORE = {}
local usersCache = {}
local lastUserMessageSent = {}
local lastUserBroadcastSent = {}
local lastUsersRefresh = 0;

Citizen.CreateThread(function()

    TriggerEvent("getCore", function(dic)
        CORE = dic;
    end)

    RefreshUsersCache()
end)

RegisterServerEvent("mailbox:sendMessage")
AddEventHandler("mailbox:sendMessage", function(data)
    if source == nil then
        print("[mailbox:sendMessage] source is null")
    end
    local _source = source
    local receiver = data.receiver
    local message = data.message
    local sourceCharacter = CORE.getUser(source).getUsedCharacter
    local steamIdentifier =  CORE.getUser(source).getIdentifier()

    local delay = Config['DelayBetweenTwoMessage']
    local lastMessageSentTime = lastUserMessageSent[steamIdentifier]
    local gameTime = GetGameTimer()
    -- checking if user is allowed to send a message now
    if lastMessageSentTime ~= nil and lastMessageSentTime + 1000 * delay >= gameTime then
        local remainingTime = ((lastMessageSentTime + 1000 * delay) - gameTime) / 1000
        local errorMessage = _U("TipOnTooRecentMessageSent"):gsub("%$1", remainingTime)

        TriggerClientEvent("vorp:Tip", _source, errorMessage, 5000)
        return
    end

    -- checking if user has enough money
    local price = Config['MessageSendPrice']

    if sourceCharacter.money < price then
        TriggerClientEvent("vorp:Tip", _source, _U("TipOnInsufficientMoneyForMessage"), 5000)
        return;
    end

    exports.ghmattimysql:execute("INSERT INTO mailbox_mails SET sender_id = ? , sender_firstname = ?, sender_lastname = ?, receiver_id = ?, receiver_firstname = ?, receiver_lastname = ?, message = ?;",
    {steamIdentifier,
    sourceCharacter.firstname,
    sourceCharacter.lastname,
    receiver.steam,
    receiver.firstname,
    receiver.lastname,
    message
    })

    TriggerEvent("vorp:removeMoney", _source, 0, price)
    lastUserMessageSent[steamIdentifier] = gameTime
    TriggerClientEvent("vorp:Tip", _U("TipOnMessageSent"), 5000)

    local connectedUsers = CORE.getUsers() -- return a Dictionary of <SteamID, User>
    for steam, user in pairs(connectedUsers) do
        -- if the steamID correspond to the receiver SteamID.
        if steam == receiver.steam then
            local receiverCharacter = user.GetUsedCharacter()

            -- if connected receiver use the right character, send a tip to him
            if receiverCharacter.firstname == receiver.firstname and receiverCharacter.lastname == receiver.lastname then
                TriggerClientEvent("mailbox:receiveMessage", user.source, {author= sourceCharacter.firstname .. " " .. sourceCharacter.lastname })
                return
            end
        end
    end
end)


RegisterServerEvent("mailbox:broadcastMessage")
AddEventHandler("mailbox:broadcastMessage", function(data)
    if source == nil then
        print("[mailbox:broadcastMessage] source is null")
    end
    local _source = source
    local message = data.message
    local sourceCharacter = CORE.getUser(source).getUsedCharacter
    local steamIdentifier = CORE.getUser(source).getIdentifier()

    local delay = Config['DelayBetweenTwoBroadcast']
    local lastBroadcastSentTime = lastUserBroadcastSent[steamIdentifier]
    local gameTime = GetGameTimer()
    -- checking if user is allowed to send a message now
    if lastBroadcastSentTime ~= nil and lastBroadcastSentTime + 1000 * delay >= gameTime then
        local remainingTime = ((lastBroadcastSentTime + 1000 * delay) - gameTime) / 1000
        local errorMessage = _U("TipOnTooRecentMessageSent"):gsub("%$1", remainingTime)

        TriggerClientEvent("vorp:Tip", _source, errorMessage, 5000)
        return
    end

    -- checking if user has enough money
    local price = Config['MessageBroadcastPrice']

    if sourceCharacter.money < price then
        TriggerClientEvent("vorp:Tip", _source, _U("TipOnInsufficientMoneyForBroadcast"), 5000)
        return;
    end

    TriggerEvent("vorp:removeMoney", _source, 0, price)
    lastUserBroadcastSent[steamIdentifier] = gameTime
    TriggerClientEvent("vorp:Tip", _U("TipOnMessageSent"), 5000)

    local connectedUsers = CORE.getUsers() -- return a Dictionary of <SteamID, User>
    for _, user in pairs(connectedUsers) do
        TriggerClientEvent("mailbox:receiveBroadcast", user.source, {message=message, author= sourceCharacter.firstname .. " " .. sourceCharacter.lastname })
    end
end)

--function IsPlayerConnected(handle)
--    for _, playerId in ipairs(GetPlayers()) do
--        if playerId == handle then
--            return true
--        end
--    end
--end

RegisterServerEvent("mailbox:getMessages")
AddEventHandler("mailbox:getMessages", function()
    if source == nil then
        print("[mailbox:getMessages] source is null")
    end
    local _source = source
    local sourceCharacter = CORE.getUser(source).getUsedCharacter
    local steamIdentifier = CORE.getUser(source).getIdentifier()

    exports.ghmattimysql:execute("SELECT * FROM mailbox_mails WHERE receiver_id = ? AND receiver_firstname = ? AND receiver_lastname = ?;",
    {steamIdentifier,
    sourceCharacter.firstname,
    sourceCharacter.lastname
    }, function (result)
        --[[letters: Array<{
                         id,
                         sender_id,
                         sender_firstname,
                         sender_lastname,
                         receiver_id,
                         receiver_firstname,
                         receiver_lastname,
                         message,
                         opened,
                         received_at
                         }
                         >--]]
        local messages = {}
        for _, msg in pairs(result) do
            messages[#messages+1] = {id=tostring(msg.id), firstname=msg.sender_firstname, lastname=msg.sender_lastname, message=msg.message, steam=msg.sender_id, received_at=msg.received_at}
        end
        TriggerClientEvent("mailbox:setMessages", _source, messages)
    end)
end)

RegisterServerEvent("mailbox:getUsers")
AddEventHandler("mailbox:getUsers", function()
    if source == nil then
        print("[mailbox:getUsers] source is null")
    end
    local _source = source
    local refreshRate = Config["TimeBetweenUsersRefresh"]

    if refreshRate > 0 and lastUsersRefresh + (1000 * refreshRate) < GetGameTimer() then
        RefreshUsersCache()
    end
    TriggerClientEvent("mailbox:setUsers", _source, usersCache)
end)

RegisterServerEvent("mailbox:updateMessages")
AddEventHandler("mailbox:updateMessages", function(data)
    if source == nil then
        print("[mailbox:updateMessages] source is null")
    end

    local toDelete = data.toDelete
    local toMarkAsread = data.toMarkAsread

    if toDelete ~= nil and #toDelete > 0 then
        exports.ghmattimysql:execute("DELETE FROM mailbox_mails WHERE id IN (?);", toDelete)
    end
    if toMarkAsread ~= nil and #toMarkAsread > 0 then
        exports.ghmattimysql:execute("UPDATE mailbox_mails SET opened = true WHERE id IN (?);", toMarkAsread)
    end
end)

function RefreshUsersCache()
    exports.ghmattimysql:execute("SELECT identifier as steam, firstname, lastname FROM characters;",
    {}, function (result)
        --[[users: Array<{
                     identifier,
                     firstname,
                     lastname
                     }
                     >--]]
        usersCache = result
        table.sort(usersCache, function(a, b)
            local aName = a.firstname .. " " .. a.lastname
            local bName = b.firstname .. " " .. b.lastname
            return aName:upper() < bName:upper()
        end)
        lastUsersRefresh = GetGameTimer()
    end)

    
end
