---------------------------------------------------------------------------------------------------
--------------------------------------- FUNCTIONS -------------------------------------------------
--close menu

local T = Translation.Langs[Config.Lang]

function Closem()
    MenuData.CloseAll()
    if Inmenu then
        Inmenu = false
    end
end

function GetPlayers()
    TriggerServerEvent("vorp_admin:GetPlayers")
    local playersData = {}
    RegisterNetEvent("vorp_admin:SendPlayers", function(result)
        playersData = result
    end)
    while next(playersData) == nil do
        Wait(10)
    end
    return playersData
end

function GetPlayersClient(player)
    local players = GetActivePlayers()
    for i = 1, #players, 1 do
        local server = GetPlayerServerId(players[i])
        if tonumber(server) == tonumber(player) then
            local ped = 0
            while ped == 0 do
                ped = GetPlayerPed(players[i])
                Wait(10)
            end
            return ped
        end
    end
end

function Inputs(input, button, placeholder, header, type, errormsg, pattern)
    local myInput = {
        type = "enableinput", -- dont touch
        inputType = input,
        button = button, -- button name
        placeholder = placeholder, --placeholdername
        style = "block", --- dont touch
        attributes = {
            inputHeader = header, -- header
            type = type, -- inputype text, number,date.etc if number comment out the pattern
            pattern = pattern, -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
            title = errormsg, -- if input doesnt match show this message
            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
        }
    }
    return myInput
end

---------------------------------------------------------------------------------------------------------------
----------------------------------- MAIN MENU -----------------------------------------------------------------
function OpenMenu()
    MenuData.CloseAll()

    local elements = {
        { label = T.Menus.MainMenuOptions.administration, value = 'administration', desc = T.Menus.MainMenuOptions.administration_desc },
        { label = T.Menus.MainMenuOptions.booster,        value = 'boost',          desc = T.Menus.MainMenuOptions.booster_desc },
        { label = T.Menus.MainMenuOptions.database,       value = 'database',       desc = T.Menus.MainMenuOptions.database_desc },
        { label = T.Menus.MainMenuOptions.teleport,       value = 'teleport',       desc = T.Menus.MainMenuOptions.teleport_desc },
        { label = T.Menus.MainMenuOptions.devTools,       value = 'devtools',       desc = T.Menus.MainMenuOptions.devTools_desc },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitle,
            align    = 'top-left',
            elements = elements,
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()
            end

            if data.current.value == "administration" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Admin')
                Wait(100)
                if AdminAllowed then
                    Admin()
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "boost" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Boosters')
                Wait(100)
                if AdminAllowed then
                    Boost()
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "database" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Database')
                Wait(100)
                if AdminAllowed then
                    DataBase()
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "teleport" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Teleports')
                Wait(100)
                if AdminAllowed then
                    Teleport()
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "devtools" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Devtools')
                Wait(100)
                if AdminAllowed then
                    OpenDevTools()
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            end
        end,

        function(data, menu)
            menu.close()
        end)
end

-- FUNCTIONS
-- CREDITS to the author for the clipboard
function Round(input, decimalPlaces)
    return tonumber(string.format("%." .. (decimalPlaces or 0) .. "f", input))
end

function CopyToClipboard(dataType)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local x, y, z = Round(coords.x, 2), Round(coords.y, 2), Round(coords.z, 2)

    if dataType == 'v2' then
        local copiedText = string.format('{x = %s, y = %s, z = %s}', x, y, z)
        SendNUIMessage({ string = copiedText })
        TriggerEvent('vorp:TipRight', T.Notify.copied, 3000)
    elseif dataType == 'v3' then
        local copiedText = string.format('vector3(%s, %s, %s)', x, y, z)
        SendNUIMessage({ string = copiedText })
        TriggerEvent('vorp:TipRight', T.Notify.copied, 3000)
    elseif dataType == 'v4' then
        local heading = GetEntityHeading(ped)
        local h = Round(heading, 2)
        local copiedText = string.format('vector4(%s, %s, %s, %s)', x, y, z, h)
        SendNUIMessage({ string = copiedText })
        TriggerEvent('vorp:TipRight', T.Notify.copied, 3000)
    elseif dataType == 'heading' then
        local heading = Round(GetEntityHeading(ped), 2)
        SendNUIMessage({ string = heading })
        TriggerEvent('vorp:TipRight', T.Notify.copied, 3000)
    end
end

-- GET CLOSESTOBJECT
function GetClosestObject(coords)
    local ped = PlayerPedId()
    local objects = GetGamePool('CObject')
    local closestDistance = -1
    local closestObject = -1
    if coords then
    else
        coords = GetEntityCoords(ped)
    end
    for i = 1, #objects, 1 do
        local objectCoords = GetEntityCoords(objects[i])
        local distance = #(objectCoords - coords)
        if closestDistance == -1 or closestDistance > distance then
            closestObject = objects[i]
            closestDistance = distance
        end
    end
    return closestObject, closestDistance
end
