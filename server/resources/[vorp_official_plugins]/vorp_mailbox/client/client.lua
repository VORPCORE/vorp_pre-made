local json = require "json"
local mailboxOpened = false
local messageCache = {}
local canRefreshMessage = true
local ready = false

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    Locales[Config.locale]["TextNearMailboxLocation"] = Locales[Config.locale]["TextNearMailboxLocation"]:gsub("%$1",
        Config.keyToOpen):gsub("%$2", Config.keyToOpenBroadcast)

    for _, location in pairs(Config.locations) do
        SetBlipAtPos(location.x, location.y, location.z)
    end


    SendNUIMessage({ action = "set_language", language = json.encode(Locales[Config.locale]) })
    TriggerServerEvent("mailbox:getUsers");
    TriggerServerEvent("mailbox:getMessages");

    ready = true

end)

RegisterNetEvent('mailbox:receiveMessage')
AddEventHandler('mailbox:receiveMessage', function(payload)
    local author = payload.author

    DisplayTip(_U("TipOnMessageReceived"):gsub("%$1", author), 5000)
    canRefreshMessage = true
end)

RegisterNetEvent('mailbox:receiveBroadcast')
AddEventHandler('mailbox:receiveBroadcast', function(payload)
    local author = payload.author
    local message = payload.message

    print(_U("TipOnBroadcastReceived"):gsub("%$1", message):gsub("%$2", author))
    DisplayTip(_U("TipOnBroadcastReceived"):gsub("%$1", message):gsub("%$2", author), 20000)
end)

RegisterNetEvent('mailbox:setMessages')
AddEventHandler('mailbox:setMessages', function(payload)
    if canRefreshMessage then
        messageCache = payload

        SendNUIMessage({ action = "set_messages", messages = json.encode(payload) })
    end
end)

RegisterNetEvent('mailbox:setUsers')
AddEventHandler('mailbox:setUsers', function(payload)
    SendNUIMessage({ action = "set_users", users = json.encode(payload) })
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if not ready then
            return
        end

        if not mailboxOpened and IsNearbyMailbox() then
            DrawText(_U("TextNearMailboxLocation"), 23, 0.5, 0.85, 0.50, 0.40, 255, 255, 255, 255)

            if not mailboxOpened and IsControlJustReleased(0, Keys[Config.keyToOpen]) then
                OpenUI(false)
                Citizen.Wait(300)
            elseif not mailboxOpened and IsControlJustReleased(0, Keys[Config.keyToOpenBroadcast]) then
                OpenUI(true)
                Citizen.Wait(300)
            end
        end
    end
end)

function IsNearbyMailbox()
    for _, mailbox in pairs(Config.locations) do
        if IsPlayerNearCoords(mailbox.x, mailbox.y, mailbox.z, 2) then
            return true
        end
    end
    return false
end

function OpenUI(broadcastMode)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = (broadcastMode and "open_broadcast" or "open") })
    mailboxOpened = true

    if not broadcastMode then
        if canRefreshMessage then
            TriggerServerEvent("mailbox:getMessages")
        end
    end
end

-- UI Events

RegisterNUICallback("close", function(payload)

    -- First close UI. In case of fail, the user will not be stuck focused on the UI
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "close" })

    mailboxOpened = false

    local messages = json.decode(payload.messages)
    local toDelete = {}
    local toMarkAsOpened = {}

    if messages == nil then
        return
    end

    for _, message in pairs(messageCache) do
        local msg = nil

        for _, m in pairs(messages) do
            if m.id == message.id then
                msg = m
                break
            end
        end

        if msg == nil then -- if message is not found, then message is deleted
            toDelete[#toDelete + 1] = message.id
        elseif not message.opened and msg.opened then -- if cached message is not marked as opened but received message is, update
            toMarkAsOpened[#toMarkAsOpened + 1] = message.id
        end
    end

    -- Send data to server
    TriggerServerEvent("mailbox:updateMessages", { toDelete = toDelete, toMarkAsOpened = toMarkAsOpened });

    -- Finally, Cache received messages from UI as most recent messages
    messageCache = messages
end)

RegisterNUICallback("send", function(payload)
    local receiver = payload.receiver
    local message = payload.message

    TriggerServerEvent("mailbox:sendMessage", { receiver = receiver, message = message });
end)

RegisterNUICallback("broadcast", function(payload)
    local message = payload.message

    TriggerServerEvent("mailbox:broadcastMessage", { message = message });
end)

-- utils

function IsPlayerNearCoords(x, y, z, dst)
    local playerPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)

    local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, x, y, z, true)

    if distance < dst then
        return true
    end
    return false
end

function DrawText(text, fontId, x, y, scaleX, scaleY, r, g, b, a)
    -- Draw Text
    SetTextScale(scaleX, scaleY);
    SetTextColor(r, g, b, a);
    SetTextCentre(true);
    Citizen.InvokeNative(0xADA9255D, fontId); -- Loads the font requested
    DisplayText(CreateVarString(10, "LITERAL_STRING", text), x, y);

    -- Draw Backdrop
    local lineLength = string.len(text) / 100 * 0.66;
    DrawTexture("boot_flow", "selection_box_bg_1d", x, y, lineLength, 0.035, 0, 0, 0, 0, 200);
end

function DrawTexture(textureDict, textureName, x, y, width, height, rotation, r, g, b, a)

    if not HasStreamedTextureDictLoaded(textureDict) then

        RequestStreamedTextureDict(textureDict, false);
        while not HasStreamedTextureDictLoaded(textureDict) do
            Citizen.Wait(100)
        end
    end
    DrawSprite(textureDict, textureName, x, y + 0.015, width, height, rotation, r, g, b, a, true);
end

function SetBlipAtPos(x, y, z)
    --blip--
    --local blipname = "" .. name
    local bliphash = 1475382911
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, x, y, z)

    Citizen.InvokeNative(0x74F74D3207ED525C, blip, bliphash, 1) -- See blips here: https://cloudy-docs.bubbleapps.io/rdr2_blips
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Mail Box")
end

function DisplayTip(message, time)
    if (#message == 0) then
        return
    end
    TriggerEvent("vorp:Tip", message, time);
end

function table.find(f, l) -- find element v of l satisfying f(v)
    for _, v in ipairs(l) do
        if f(v) then
            return v
        end
    end
    return nil
end
