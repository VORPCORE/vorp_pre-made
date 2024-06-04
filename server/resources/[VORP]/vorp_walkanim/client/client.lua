local isInMenu = false
local MenuData = exports.vorp_menu:GetMenuData()
local Core = exports.vorp_core:GetCore()

local Clothing = {
    { label = _U('remove_hat'),       value = "A1",  desc = _U("remove"), info = 'hat' },
    { label = _U('remove_shirt'),     value = "A2",  desc = _U("remove"), info = 'shirt' },
    { label = _U('remove_mask'),      value = "A3",  desc = _U("remove"), info = 'mask' },
    { label = _U('remove_glasses'),   value = "A4",  desc = _U("remove"), info = 'eyewear' },
    { label = _U('remove_tie'),       value = "A5",  desc = _U("remove"), info = 'neckties' },
    { label = _U('remove_neck'),      value = "A6",  desc = _U("remove"), info = 'neckwear' },
    { label = _U('remove_braces'),    value = "A7",  desc = _U("remove"), info = 'suspender' },
    { label = _U('remove_vest'),      value = "A8",  desc = _U("remove"), info = 'vest' },
    { label = _U('remove_coat'),      value = "A9",  desc = _U("remove"), info = 'coat' },
    { label = _U('remove_ccoat'),     value = "A9",  desc = _U("remove"), info = 'ccoat' },
    { label = _U('remove_poncho'),    value = "A10", desc = _U("remove"), info = 'poncho' },
    { label = _U('remove_layer'),     value = "A11", desc = _U("remove"), info = 'cloack' },
    { label = _U('remove_gloves'),    value = "A12", desc = _U("remove"), info = 'glove' },
    { label = _U('remove_rings'),     value = "A13", desc = _U("remove"), info = 'rings' },
    { label = _U('remove_bracelets'), value = "A14", desc = _U("remove"), info = 'bracelet' },
    { label = _U('remove_belt'),      value = "A15", desc = _U("remove"), info = 'belt' },
    { label = _U('remove_buckle'),    value = "A16", desc = _U("remove"), info = 'buckle' },
    { label = _U('remove_pants'),     value = "A17", desc = _U("remove"), info = 'pant' },
    { label = _U('remove_chaps'),     value = "A18", desc = _U("remove"), info = 'chap' },
    { label = _U('remove_skirt'),     value = "A19", desc = _U("remove"), info = 'faskirtlda' },
    { label = _U('remove_boots'),     value = "A20", desc = _U("remove"), info = 'boots' },
    { label = _U('remove_spurs'),     value = "A21", desc = _U("remove"), info = 'spurs' },
    { label = _U('remove_armor'),     value = "A21", desc = _U("remove"), info = 'armor' },
    { label = _U('sleeves'),          value = "A22", desc = _U("remove"), info = 'sleeves' },
    { label = _U('sleeves2'),         value = "A23", desc = _U("remove"), info = 'sleeves2' },
    { label = _U('bandana'),          value = "A24", desc = _U("remove"), info = 'bandana' },
    { label = _U('bow'),              value = "A25", desc = _U("remove"), info = 'bow' },
    { label = _U('accessories'),      value = "A26", desc = _U("remove"), info = 'accessories' },
    { label = _U('loadouts'),         value = "A27", desc = _U("remove"), info = 'loadouts' },
    { label = _U('satchels'),         value = "A28", desc = _U("remove"), info = 'satchels' },
    { label = _U('gunbeltaccs'),      value = "A29", desc = _U("remove"), info = 'gunbeltaccs' },
    { label = _U('gauntletss'),       value = "A30", desc = _U("remove"), info = 'gauntlets' },
    { label = _U('undress'),          value = "A31", desc = _U("remove"), info = 'undress' },
    { label = _U('dresson'),          value = "A32", desc = _U("remove"), info = 'dress' },
}

local Walkstyle = {
    { label = _U("Casual"),      value = "A1",      desc = _U("chooseAnim"), info = "MP_Style_Casual" },
    { label = _U("Crazy"),       value = "A2",      desc = _U("chooseAnim"), info = "MP_Style_Crazy" },
    { label = _U("Drunk"),       value = "A3",      desc = _U("chooseAnim"), info = "MP_Style_drunk" },
    { label = _U("EasyRider"),   value = "A4",      desc = _U("chooseAnim"), info = "MP_Style_EasyRider" },
    { label = _U("Flamboyant"),  value = "A5",      desc = _U("chooseAnim"), info = "MP_Style_Flamboyant" },
    { label = _U("Greenhorn"),   value = "A6",      desc = _U("chooseAnim"), info = "MP_Style_Greenhorn" },
    { label = _U("Gunslinger"),  value = "A7",      desc = _U("chooseAnim"), info = "MP_Style_Gunslinger" },
    { label = _U("Inquisitive"), value = "A8",      desc = _U("chooseAnim"), info = "MP_Style_inquisitive" },
    { label = _U("Refined"),     value = "A9",      desc = _U("chooseAnim"), info = "MP_Style_Refined" },
    { label = _U("SilentType"),  value = "A10",     desc = _U("chooseAnim"), info = "MP_Style_SilentType" },
    { label = _U("Veteran"),     value = "A11",     desc = _U("chooseAnim"), info = "MP_Style_Veteran" },
    { label = _U("RemoveWalk"),  value = "removeA", desc = _U("removedesc"), info = "noanim" },
}

local function OpenClothesMenu()
    MenuData.CloseAll()
    isInMenu = true
    local elements = {}
    for key, value in pairs(Clothing) do
        elements[#elements + 1] = { label = value.label, value = value.value, desc = value.desc, info = value.info }
    end

    MenuData.Open('default', GetCurrentResourceName(), 'OpenClothesMenu', {
            title    = _U("MenuTitle1"),
            subtext  = _U("SubMenuTitle"),
            align    = Config.Align,
            elements = elements,
            lastmenu = "OpenMenu"
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()
            end

            if data.current.value then
                local clothes = data.current.info
                ExecuteCommand(clothes)
            end
        end,

        function(data, menu)
            menu.close()
            isInMenu = false
            DisplayRadar(true)
        end)
end


local function OpenWalkMenu()
    MenuData.CloseAll()
    isInMenu = true
    local elements = {
    }
    for key, value in pairs(Walkstyle) do
        elements[#elements + 1] = { label = value.label, value = value.value, desc = value.desc, info = value.info }
    end
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi', {
            title    = _U("MenuTitle"),
            subtext  = _U("SubMenuTitle"),
            align    = Config.Align,
            elements = elements,
            lastmenu = "OpenMenu"
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()
            end

            if data.current.value then
                local animation = data.current.info
                TriggerEvent("vorp_walkanim:Client:setAnim", animation)
            end
        end,

        function(data, menu)
            menu.close()
            isInMenu = false
            DisplayRadar(true)
        end)
end

function OpenMenu()
    MenuData.CloseAll()
    isInMenu = true
    local elements = {
        { label = "Clothes menu", value = "CL", desc = "Remove or add clothing options" },
        { label = "Walk styles",  value = "WS", desc = "Choose walk styles this will save inthe database" },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi', {
            title    = _U("MenuTitle"),
            subtext  = _U("SubMenuTitle"),
            align    = Config.Align,
            elements = elements,
        },
        function(data, menu)
            if data.current.value == "CL" then
                OpenClothesMenu()
            elseif data.current.value == "WS" then
                OpenWalkMenu()
            end
        end,

        function(data, menu)
            menu.close()
            isInMenu = false
            DisplayRadar(true)
        end)
end

RegisterNetEvent("vorp_walkanim:Server:setwalk", function(walk)
    local animation = walk
    local player = PlayerPedId()
    if animation == "noanim" then
        Citizen.InvokeNative(0xA6F67BEC53379A32, PlayerPedId(), "MP_Style_Casual") 
        return
    end
    Citizen.InvokeNative(0xCB9401F918CB0F75, player, animation, 1, -1)
end)

local old = nil
AddEventHandler("vorp_walkanim:Client:setAnim", function(animation)
    if old then
        Citizen.InvokeNative(0xA6F67BEC53379A32, PlayerPedId(), old)    
    end
    Citizen.InvokeNative(0xCB9401F918CB0F75, PlayerPedId(), animation, 1, -1) 
    old = animation
    TriggerServerEvent("vorp_walkanim:setwalk", animation)
end)


TriggerEvent("chat:addSuggestion", "/" .. Config.command, Config.walkanimsuggestion, {})
RegisterCommand(Config.command, function()
    if isInMenu == false then
        OpenMenu()
        DisplayRadar(false)
    end
end, false)

local Command = false
TriggerEvent("chat:addSuggestion", "/" .. Config.slowWalkCommand, Config.slowcommandSuggestion, {})
RegisterCommand(Config.slowWalkCommand, function(source, args)
    Command = not Command
    local value = tonumber(args[1])
    if Command then
        Core.NotifyObjective("Slow walk enabled", 5000)
    else
        Core.NotifyObjective("Slow walk Disabled", 5000)
    end
    while Command do
        Wait(0)

        if not value and value > 3 and value == 0 then
            Core.NotifyObjective("you need to add an argument example 0.3", 5000)
            break
        end

        if value > 3 then
            value = 3.0
        end

        if value == 0 then
            Core.NotifyObjective("you need to add an argument bigger than that", 5000)
            return
        end
        SetPedMaxMoveBlendRatio(PlayerPedId(), value)
    end
    SetPedMaxMoveBlendRatio(PlayerPedId(), 3.0)
end, false)
