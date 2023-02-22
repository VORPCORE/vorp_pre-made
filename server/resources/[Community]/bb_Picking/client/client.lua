local keys = { ['G'] = 0x760A9C6F, ['S'] = 0xD27782E3, ['W'] = 0x8FD015D8, ['H'] = 0x24978A28, ['G'] = 0x5415BE48, ["ENTER"] = 0xC7B5340A, ['E'] = 0xDFF812F9,["BACKSPACE"] = 0x156F7119 }
local still = 0
local isHarvesting = false
local prompt, prompt2 = false, false

--############################## Interaction Menu ##############################--

-- search for items
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        
        for prop,item in pairs(Config.collectables) do
            local isNearStill = DoesObjectOfTypeExistAtCoords(x, y, z, 1.5, GetHashKey(tostring(prop)), true)
           
            if isNearStill and not isHarvesting then 
                TriggerEvent('vorp:Tip', "[E] Search "..item.Label, 100)
                if IsControlJustReleased(0, 0xDFF812F9) then -- e
                    isHarvesting = true
                    TriggerEvent("herb:harvest", item)
                end
            end
		end
	end
end)
--############################## END Interaction Menu ##############################--


RegisterNetEvent('herb:harvest')
AddEventHandler('herb:harvest', function(values)
    local playerPed = PlayerPedId()
    local itemArrayLength = GetArrayLength(values.items)    
    local randomItem = math.random(1, itemArrayLength)
    local arrayCount = 1
    local itemCount = 0
    local item

    for k,v in pairs(values.items) do
        if arrayCount == randomItem then
            itemCount = math.random(1, v)
            item = k
        end
        arrayCount = arrayCount + 1
    end
    
    exports['progressBars']:startUI(4000, "Searching...")
    goCollect()
    Citizen.Wait(4000)s
    ClearPedTasksImmediately(playerPed)
    oldbush = true
    isHarvesting = false
    TriggerServerEvent("herb:giveHarvestItems", item, itemCount) 
end)

function goCollect()
    local playerPed = PlayerPedId()
    RequestAnimDict("mech_pickup@plant@berries")
    while not HasAnimDictLoaded("mech_pickup@plant@berries") do
        Wait(100)
    end
    TaskPlayAnim(playerPed, "mech_pickup@plant@berries", "enter_lf", 8.0, -0.5, -1, 0, 0, true, 0, false, 0, false)
    Wait(800)
    TaskPlayAnim(playerPed, "mech_pickup@plant@berries", "base", 8.0, -0.5, -1, 0, 0, true, 0, false, 0, false)
    Wait(2300)
end

--############################## END Events ##############################--

--############################## Functions ##############################--

function GetArrayLength(array)
    local arrayLength = 0
    for k,v in pairs(array) do
        arrayLength = arrayLength + 1
    end
    return arrayLength
end


function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

--############################## END Functions ##############################--