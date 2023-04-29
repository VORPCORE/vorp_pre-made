local prompts = GetRandomIntInRange(0, 0xffffff)
local PromptGroup2 = GetRandomIntInRange(0, 0xffffff)
local openmenu
local CloseBanks
local inmenu = false
local bankinfo = {}
local blips = {}

TriggerEvent("menuapi:getData", function(call)
    MenuData = call
end)

AddEventHandler('menuapi:closemenu', function()
    if inmenu then
        inmenu = false
        bankinfo = nil
        ClearPedTasks(PlayerPedId())
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for i, v in pairs(Config.banks) do
            if v.BlipHandle then
                RemoveBlip(v.BlipHandle)
            end
            if v.NPC then
                DeleteEntity(v.NPC)
                DeletePed(v.NPC)
                SetEntityAsNoLongerNeeded(v.NPC)
            end
        end
        MenuData.CloseAll()
        inmenu = false
        ClearPedTasks(PlayerPedId())
    end
end)

---------------- BLIPS ---------------------
function AddBlip(index)
    if Config.banks[index].blipAllowed then
        Config.banks[index].BlipHandle = N_0x554d9d53f696d002(1664425300, Config.banks[index].x,
            Config.banks[index].y, Config.banks[index].z)
        SetBlipSprite(Config.banks[index].BlipHandle, Config.banks[index].blipsprite, 1)
        SetBlipScale(Config.banks[index].BlipHandle, 0.2)
        Citizen.InvokeNative(0x9CB1A1623062F402, Config.banks[index].BlipHandle, Config.banks[index].name)
    end
end

---------------- NPC ---------------------
function LoadModel(model)
    local model = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(100)
    end
end

function SpawnNPC(index)
    local v = Config.banks[index]
    LoadModel(v.NpcModel)
    if v.NpcAllowed then
        local npc = CreatePed(v.NpcModel, v.Nx, v.Ny, v.Nz, v.Nh, false, true, true, true)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        SetEntityCanBeDamaged(npc, false)
        SetEntityInvincible(npc, true)
        Wait(1000)
        TaskStandStill(npc, 10, -1)
        -- FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        Config.banks[index].NPC = npc
    end
end

function PromptSetUp()
    local str = Config.language.openmenu
    openmenu = PromptRegisterBegin()
    PromptSetControlAction(openmenu, Config.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(openmenu, str)
    PromptSetEnabled(openmenu, 1)
    PromptSetVisible(openmenu, 1)
    PromptSetStandardMode(openmenu, 1)
    PromptSetGroup(openmenu, prompts)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, openmenu, true)
    PromptRegisterEnd(openmenu)
end

function PromptSetUp2()
    local str = "Closed"
    CloseBanks = PromptRegisterBegin()
    PromptSetControlAction(CloseBanks, Config.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(CloseBanks, str)
    PromptSetEnabled(CloseBanks, 1)
    PromptSetVisible(CloseBanks, 1)
    PromptSetStandardMode(CloseBanks, 1)
    PromptSetGroup(CloseBanks, PromptGroup2)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, CloseBanks, true)
    PromptRegisterEnd(CloseBanks)

end

RegisterNetEvent("vorp_bank:recinfo")
AddEventHandler("vorp_bank:recinfo", function(data)
    bankinfo = data
end)

RegisterNetEvent("vorp_bank:ready")
AddEventHandler("vorp_bank:ready", function()
    inmenu = false
end)

RegisterNetEvent("vorp_bank:ReloadBankMenu")
AddEventHandler("vorp_bank:ReloadBankMenu", function(_bankinfo, index)
    local Menu = MenuData.GetOpened("default", GetCurrentResourceName(), "menuapi")
    bankinfo = _bankinfo
    Wait(200)

    Openbank(Menu.data.title, bankinfo.name)
end)

Citizen.CreateThread(function()
    PromptSetUp()
    PromptSetUp2()
    while true do
        Citizen.Wait(0)
        local sleep = true
        local player = PlayerPedId()
        local coords = GetEntityCoords(PlayerPedId())
        local hour = GetClockHours()
        local dead = IsEntityDead(player)

        if not inmenu and not dead then
            for index, bankConfig in pairs(Config.banks) do
                if bankConfig.StoreHoursAllowed then

                    if hour >= bankConfig.StoreClose or hour < bankConfig.StoreOpen then
                        if Config.banks[index].BlipHandle then
                            RemoveBlip(Config.banks[index].BlipHandle)
                            Config.banks[index].BlipHandle = nil
                        end
                        if Config.banks[index].NPC then
                            DeleteEntity(Config.banks[index].NPC)
                            DeletePed(Config.banks[index].NPC)
                            SetEntityAsNoLongerNeeded(Config.banks[index].NPC)
                            Config.banks[index].NPC = nil
                        end
                        local coordsDist = vector3(coords.x, coords.y, coords.z)
                        local coordsStore = vector3(bankConfig.x, bankConfig.y, bankConfig.z)
                        local distance = #(coordsDist - coordsStore)
                        if distance <= bankConfig.distOpen then
                            sleep = false

                            local label2 = CreateVarString(10, 'LITERAL_STRING',
                                "Opening Hours " .. bankConfig.StoreOpen .. "am - " .. bankConfig.StoreClose .. "pm")
                            PromptSetActiveGroupThisFrame(PromptGroup2, label2)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, CloseBanks) then
                                Wait(100)
                                TriggerEvent("vorp:TipRight", Config.language.closed, 6000)
                            end
                        end

                    elseif hour >= bankConfig.StoreOpen then
                        if not Config.banks[index].BlipHandle and bankConfig.blipAllowed then
                            AddBlip(index)
                        end
                        if not Config.banks[index].NPC and bankConfig.NpcAllowed then
                            SpawnNPC(index)
                        end

                        local coordsDist = vector3(coords.x, coords.y, coords.z)
                        local coordsStore = vector3(bankConfig.x, bankConfig.y, bankConfig.z)
                        local distance = #(coordsDist - coordsStore)

                        if distance <= bankConfig.distOpen then
                            sleep = false

                            local label = CreateVarString(10, 'LITERAL_STRING', Config.language.bank)
                            PromptSetActiveGroupThisFrame(prompts, label)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, openmenu) then
                                inmenu = true

                                TriggerServerEvent("vorp_bank:getinfo", bankConfig.city)
                                Wait(400) -- needed
                                TaskStandStill(PlayerPedId(), -1)
                                DisplayRadar(false)
                                Openbank(bankConfig.name, index)
                            end
                        end


                    end
                else
                    if not Config.banks[index].BlipHandle and bankConfig.blipAllowed then
                        AddBlip(index)
                    end
                    if not Config.banks[index].NPC and bankConfig.NpcAllowed then
                        SpawnNPC(index)
                    end
                    local coordsDist = vector3(coords.x, coords.y, coords.z)
                    local coordsStore = vector3(bankConfig.x, bankConfig.y, bankConfig.z)
                    local distance = #(coordsDist - coordsStore)

                    if distance <= bankConfig.distOpen then
                        sleep = false

                        local label = CreateVarString(10, 'LITERAL_STRING', Config.language.bank)
                        PromptSetActiveGroupThisFrame(prompts, label)

                        if Citizen.InvokeNative(0xC92AC953F0A982AE, openmenu) then
                            inmenu = true
                            TriggerServerEvent("vorp_bank:getinfo", bankConfig.city)
                            Wait(200)
                            TaskStandStill(PlayerPedId(), -1)
                            Openbank(bankConfig.name, index)

                        end
                    end
                end
            end
        end
        if sleep then
            Citizen.Wait(500)
        end
    end
end)

function Openbank(bankName, index)

    MenuData.CloseAll()
    if not bankinfo.money then
        print("no money?", bankinfo.money)
        DisplayRadar(true)
        ClearPedTasks(PlayerPedId())
        inmenu = false
        return
    end

    local elements = {
        { label = Config.language.cashbalance .. bankinfo.money, value = 'nothing', desc = Config.language.cashbalance2 },
        { label = Config.language.depocash, value = 'dcash', desc = Config.language.depocash2 },
        { label = Config.language.takecash, value = 'wcash', desc = Config.language.takecash2 }
    }
    print(index)
    if Config.banks[index].items then
        elements[#elements + 1] = { label = Config.language.depoitem, value = 'bitem',
            desc = Config.language.depoitem2 .. bankinfo.invspace }
    end

    if Config.banks[index].upgrade then
        elements[#elements + 1] = { label = Config.language.upgradeitem, value = 'upitem',
            desc = Config.language.upgradeitem2 .. Config.banks[index].costslot }
    end

    if Config.banks[index].gold then
        elements[#elements + 1] = { label = Config.language.goldbalance .. bankinfo.gold, value = 'nothing',
            desc = Config.language.cashbalance2 }
        elements[#elements + 1] = { label = Config.language.depogold, value = 'dgold',
            desc = Config.language.depogold2 }
        elements[#elements + 1] = { label = Config.language.takegold, value = 'wgold',
            desc = Config.language.takegold2 }
    end


    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = bankName,
            subtext  = Config.language.welcome,
            align    = 'top-left',
            elements = elements,
        },
        function(data, menu)
            if (data.current.value == 'dcash') then
                local myInput = {
                    type = "enableinput", -- don't touch
                    inputType = "input", -- input type
                    button = "Confirm", -- button name
                    placeholder = "insertamount", -- placeholder name
                    style = "block", -- don't touch
                    attributes = {
                        inputHeader = "DEPOSIT CASH", -- header
                        type = "text", -- inputype text, number,date,textarea
                        pattern = "[0-9.]{1,10}", --  only numbers "[0-9]" | for letters only "[A-Za-z]+"
                        title = "numbers only", -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;" -- style
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = tonumber(cb)
                    if result ~= "" and result then
                        TriggerServerEvent("vorp_bank:depositcash", result, Config.banks[index].city, bankinfo)
                    else
                        TriggerEvent("vorp:TipBottom", Config.language.invalid, 6000)
                        inmenu = false
                    end
                end)
            end
            if (data.current.value == 'dgold') then

                local myInput = {
                    type = "enableinput", -- don't touch
                    inputType = "input", -- input type
                    button = "Confirm", -- button name
                    placeholder = "insertamount", -- placeholder name
                    style = "block", -- don't touch
                    attributes = {
                        inputHeader = "DEPOSIT GOLD", -- header
                        type = "text", -- inputype text, number,date,textarea
                        pattern = "[0-9.]{1,10}", --  only numbers "[0-9]" | for letters only "[A-Za-z]+"
                        title = "numbers only", -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;" -- style
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = tonumber(cb)
                    if result ~= "" and result then
                        TriggerServerEvent("vorp_bank:depositgold", result, Config.banks[index].city, bankinfo)
                    else
                        TriggerEvent("vorp:TipBottom", Config.language.invalid, 6000)
                        inmenu = false
                    end
                end)

            end
            if (data.current.value == 'wcash') then
                local myInput = {
                    type = "enableinput", -- don't touch
                    inputType = "input", -- input type
                    button = "Confirm", -- button name
                    placeholder = "insertamount", -- placeholder name
                    style = "block", -- don't touch
                    attributes = {
                        inputHeader = "WITHDRAW CASH", -- header
                        type = "text", -- inputype text, number,date,textarea
                        pattern = "[0-9.]{1,10}", --  only numbers "[0-9]" | for letters only "[A-Za-z]+"
                        title = "numbers only", -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;" -- style
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = tonumber(cb)
                    if result ~= "" and result then
                        TriggerServerEvent("vorp_bank:withcash", result, Config.banks[index].city, bankinfo)
                    else
                        TriggerEvent("vorp:TipBottom", Config.language.invalid, 6000)
                        inmenu = false
                    end
                end)

            end
            if (data.current.value == 'wgold') then
                local myInput = {
                    type = "enableinput", -- don't touch
                    inputType = "input", -- input type
                    button = "Confirm", -- button name
                    placeholder = "insertamount", -- placeholder name
                    style = "block", -- don't touch
                    attributes = {
                        inputHeader = "WITHDRAW GOLD", -- header
                        type = "text", -- inputype text, number,date,textarea
                        pattern = "[0-9.]{1,10}", --  only numbers "[0-9]" | for letters only "[A-Za-z]+"
                        title = "numbers only", -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;" -- style
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = tonumber(cb)
                    if result ~= "" and result then
                        TriggerServerEvent("vorp_bank:withgold", result, Config.banks[index].city, bankinfo)
                    else
                        TriggerEvent("vorp:TipBottom", Config.language.invalid, 6000)
                        inmenu = false
                    end
                end)

            end
            if (data.current.value == 'bitem') then
                TriggerServerEvent("vorp_bank:ReloadBankInventory", Config.banks[index].city)
                Wait(300)
                TriggerEvent("vorp_inventory:OpenBankInventory", Config.language.namebank, Config.banks[index].city,
                    bankinfo.invspace)
                menu.close()
                DisplayRadar(true)
                inmenu = false
                ClearPedTasks(PlayerPedId())
            end
            if (data.current.value == 'upitem') then


                local invspace = bankinfo.invspace
                local maxslots = Config.banks[index].maxslots
                local costslot = Config.banks[index].costslot
                local myInput = {
                    type = "enableinput", -- don't touch
                    inputType = "input", -- input type
                    button = "Confirm", -- button name
                    placeholder = "insertamount", -- placeholder name
                    style = "block", -- don't touch
                    attributes = {
                        inputHeader = "UP SLOTS", -- header
                        type = "text", -- inputype text, number,date,textarea
                        pattern = "[0-9]{1,10}", --  only numbers "[0-9]" | for letters only "[A-Za-z]+"
                        title = "numbers only", -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;" -- style
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = tonumber(cb)
                    if result ~= "" and result then
                        TriggerServerEvent("vorp_bank:UpgradeSafeBox", costslot, maxslots, math.floor(result),
                            Config.banks[index].city,
                            invspace)
                        menu.close()
                        inmenu = false
                    else
                        TriggerEvent("vorp:TipBottom", Config.language.invalid, 6000)
                        inmenu = false
                    end
                end)


            end
        end,
        function(data, menu)
            menu.close()
            DisplayRadar(true)
            inmenu = false
            ClearPedTasks(PlayerPedId())
        end)
end

-- open doors
CreateThread(function()
    for door, state in pairs(Config.Doors) do
        if not IsDoorRegisteredWithSystem(door) then
            Citizen.InvokeNative(0xD99229FE93B46286, door, 1, 1, 0, 0, 0, 0)
        end
        DoorSystemSetDoorState(door, state)
    end
end)
