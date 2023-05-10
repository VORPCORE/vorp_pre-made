-- ADMIN MANAGER
Config = {}

local user_group = ""

RegisterNetEvent('vorp_bossmanager:sendgroup')
AddEventHandler('vorp_bossmanager:sendgroup', function(cb)
    user_group = cb
end)

RegisterCommand("givelicense", function(source, args)
    TriggerServerEvent("vorp_bossmanager:checkadmin")
    Wait(500)
    if user_group == "admin" then
        -- Give boss license for a job : playerId - job
        if args[1] ~= nil and args[2] ~= nil then 
            TriggerServerEvent('vorp_bossmanager:givelicense', args[1], args[2])
        end
    end
end)

RegisterCommand("revokelicense", function(source, args)
    TriggerServerEvent("vorp_bossmanager:checkadmin")
    Wait(500)
    if user_group == "admin" then
        -- Revoke boss license for a job : playerId
        if args[1] ~= nil then 
            TriggerServerEvent('vorp_bossmanager:revokelicense', args[1])
        end
    end
end)

-- BOSS MANAGER

local playername = ''
local employeejoblist = {}
local bossjobname = ''

Citizen.CreateThread( function()
    WarMenu.CreateMenu('perso', _U('title'))
    WarMenu.SetSubTitle('perso', _U('subtitle'))
    WarMenu.CreateSubMenu('inv1', 'perso', _U('sub_menu1'))
    WarMenu.CreateSubMenu('inv2', 'perso', _U('sub_menu2'))

    while true do

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if WarMenu.IsMenuOpened('perso') then
            WarMenu.SetSubTitle('perso', _U('subtitle') .. " - " .. bossjobname)
            
            if WarMenu.MenuButton(_U('sub_menu1'), 'inv1') then
            end

            if WarMenu.MenuButton(_U('sub_menu2'), 'inv2') then
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('inv1') then
            local closestPlayer, closestDistance = GetClosestPlayer()
            print("ClosestPlayerId" .. tostring(closestPlayer) .. " closestdistance " .. tostring(closestDistance))
            if closestPlayer ~= -1 and closestDistance <= 3.0 then
                openMenuHireEmployee(GetPlayerServerId(closestPlayer))
            else
                openMenuHireEmployee(-1)
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('inv2') then -- Fire player
            for k,employeeinfos in pairs(employeejoblist) do
                if WarMenu.Button(tostring(employeeinfos.firstname .. " " .. employeeinfos.lastname)) then
                    TriggerServerEvent('vorp_bossmanager:revokejob', employeeinfos.identifier, employeeinfos.charidentifier)
                    refreshEmployeeList()
                end
            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, Config.Key) then
            playername = ''
            refreshBossName()
            refreshEmployeeList()
        end
        Citizen.Wait(0)
    end
end)

function openMenuHireEmployee(closestPlayer)
    if closestPlayer ~= -1 and (playername == "" or playername == nil) then -- We have a closest player, we need to know is name. We are doing this one time to limit server requests
        refreshClosestPlayerName(closestPlayer)
    end

    if playername == '' or playername == nil then
        playername = _U('error_noclosestplayer')
    end

    if WarMenu.Button(playername) then
        if playername ~= _U('error_noclosestplayer') then
            TriggerEvent("vorpinputs:getInput", _U('gradelbl'), _U('inputgrademsg'), function(jobgrade)
                if(jobgrade ~= nil) then
                    TriggerServerEvent("vorp_bossmanager:givejob", closestPlayer, bossjobname, jobgrade)
                    WarMenu.CloseMenu()
                else
                    TriggerEvent("vorp:TipRight", _U('gradeerrormsg'), 4000)
                end
            end)
        end
    end
end

function refreshClosestPlayerName(closestPlayer)
    print("ClosestPlayerName")
    TriggerServerEvent('vorp_bossmanager:findemployeename', closestPlayer)
    Wait(500)
end

function refreshBossName()
    bossjobname = ''
    TriggerServerEvent("vorp_bossmanager:checkboss")
    Wait(500)
end

function refreshEmployeeList()
    employeejoblist = {}
    TriggerServerEvent('vorp_bossmanager:bossemployeelist', bossjobname)
    Wait(500)
end

RegisterNetEvent('vorp_bossmanager:open')
AddEventHandler('vorp_bossmanager:open', function(cb)
    bossjobname = cb
	WarMenu.OpenMenu('perso')
end)

RegisterNetEvent('vorp_bossmanager:sendemployeename')
AddEventHandler('vorp_bossmanager:sendemployeename', function(cb)
	playername = cb
end)

RegisterNetEvent('vorp_bossmanager:sendemployeelist')
AddEventHandler('vorp_bossmanager:sendemployeelist', function(cb)
	employeejoblist = cb
end)

function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
	local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false
    
    if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		usePlayerPed = true
		coords = GetEntityCoords(playerPed)
    end
    
	for i=1, #players, 1 do
        local tgt = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)
			if closestDistance == -1 or closestDistance > distance then
				closestPlayer = players[i]
				closestDistance = distance
			end
		end
	end
	return closestPlayer, closestDistance
end