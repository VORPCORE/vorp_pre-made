local isInMenu = false
MenuData = {}

TriggerEvent("menuapi:getData", function(call)
    MenuData = call
end)

AddEventHandler('menuapi:closemenu', function()
    if isInMenu then
        isInMenu = false
    end
end)
function OpenMenu()
    MenuData.CloseAll()
    isInMenu = true
    local elements = {
        { label = "Clothes", value = "CL", desc = "chooseAnim" },
        { label = "Walk styles", value = "WS", desc = "chooseAnim" },

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

function OpenWalkMenu()
    MenuData.CloseAll()
    isInMenu = true
    local elements = {
        { label = _U("Casual"), value = "A1", desc = _U("chooseAnim"), info = "MP_Style_Casual" },
        { label = _U("Crazy"), value = "A2", desc = _U("chooseAnim"), info = "MP_Style_Crazy" },
        { label = _U("Drunk"), value = "A3", desc = _U("chooseAnim"), info = "mp_style_drunk" },
        { label = _U("EasyRider"), value = "A4", desc = _U("chooseAnim"), info = "MP_Style_EasyRider" },
        { label = _U("Flamboyant"), value = "A5", desc = _U("chooseAnim"), info = "MP_Style_Flamboyant" },
        { label = _U("Greenhorn"), value = "A6", desc = _U("chooseAnim"), info = "MP_Style_Greenhorn" },
        { label = _U("Gunslinger"), value = "A7", desc = _U("chooseAnim"), info = "MP_Style_Gunslinger" },
        { label = _U("Inquisitive"), value = "A8", desc = _U("chooseAnim"), info = "mp_style_inquisitive" },
        { label = _U("Refined"), value = "A9", desc = _U("chooseAnim"), info = "MP_Style_Refined" },
        { label = _U("SilentType"), value = "A10", desc = _U("chooseAnim"), info = "MP_Style_SilentType" },
        { label = _U("Veteran"), value = "A11", desc = _U("chooseAnim"), info = "MP_Style_Veteran" },
        { label = _U("RemoveWalk"), value = "removeA", desc = _U("removedesc"), info = "noanim" },
    }

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
                TriggerEvent("vorp_walkanim:setAnim", animation)

                DisplayRadar(true)
                isInMenu = false
                menu.close()
            end

        end,

        function(data, menu)
            menu.close()
            isInMenu = false
            DisplayRadar(true)
        end)

end

function OpenClothesMenu()
    MenuData.CloseAll()
    isInMenu = true
    local elements = {
        { label = _U('remove_hat'), value = "A1", desc = _U("remove"), info = 'hat' },
        { label = _U('remove_shirt'), value = "A2", desc = _U("remove"), info = 'shirt' },
        { label = _U('remove_mask'), value = "A3", desc = _U("remove"), info = 'mask' },
        { label = _U('remove_glasses'), value = "A4", desc = _U("remove"), info = 'eyewear' },
        { label = _U('remove_tie'), value = "A5", desc = _U("remove"), info = 'neckties' },
        { label = _U('remove_neck'), value = "A6", desc = _U("remove"), info = 'neckwear' },
        { label = _U('remove_braces'), value = "A7", desc = _U("remove"), info = 'suspender' },
        { label = _U('remove_vest'), value = "A8", desc = _U("remove"), info = 'vest' },
        { label = _U('remove_coat'), value = "A9", desc = _U("remove"), info = 'coat' },
        { label = _U('remove_ccoat'), value = "A9", desc = _U("remove"), info = 'ccoat' },
        { label = _U('remove_poncho'), value = "A10", desc = _U("remove"), info = 'poncho' },
        { label = _U('remove_layer'), value = "A11", desc = _U("remove"), info = 'cloack' },
        { label = _U('remove_gloves'), value = "A12", desc = _U("remove"), info = 'glove' },
        { label = _U('remove_rings'), value = "A13", desc = _U("remove"), info = 'rings' },
        { label = _U('remove_bracelets'), value = "A14", desc = _U("remove"), info = 'bracelet' },
        { label = _U('remove_belt'), value = "A15", desc = _U("remove"), info = 'belt' },
        { label = _U('remove_buckle'), value = "A16", desc = _U("remove"), info = 'buckle' },
        { label = _U('remove_pants'), value = "A17", desc = _U("remove"), info = 'pant' },
        { label = _U('remove_chaps'), value = "A18", desc = _U("remove"), info = 'chap' },
        { label = _U('remove_skirt'), value = "A19", desc = _U("remove"), info = 'faskirtlda' },
        { label = _U('remove_boots'), value = "A20", desc = _U("remove"), info = 'boots' },
        { label = _U('remove_spurs'), value = "A21", desc = _U("remove"), info = 'spurs' },
        { label = _U('remove_armor'), value = "A21", desc = _U("remove"), info = 'armor' },
        { label = _U('sleeves'), value = "A22", desc = _U("remove"), info = 'sleeves' },
        { label = _U('sleeves2'), value = "A23", desc = _U("remove"), info = 'sleeves2' },
        { label = _U('bandana'), value = "A24", desc = _U("remove"), info = 'bandana' },
        { label = _U('bow'), value = "A25", desc = _U("remove"), info = 'bow' },
        { label = _U('accessories'), value = "A26", desc = _U("remove"), info = 'accessories' },
        { label = _U('loadouts'), value = "A27", desc = _U("remove"), info = 'loadouts' },
        { label = _U('satchels'), value = "A28", desc = _U("remove"), info = 'satchels' },
        { label = _U('gunbeltaccs'), value = "A29", desc = _U("remove"), info = 'gunbeltaccs' },
        { label = _U('gauntletss'), value = "A30", desc = _U("remove"), info = 'gauntlets' },
        { label = _U('undress'), value = "A31", desc = _U("remove"), info = 'undress' },
        { label = _U('dresson'), value = "A32", desc = _U("remove"), info = 'dress' },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi', {
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

RegisterNetEvent("vorp_walkanim:getwalk2")
AddEventHandler("vorp_walkanim:getwalk2", function(walk)
    local animation = walk
    local player = PlayerPedId()
    if animation == "noanim" then
        Citizen.InvokeNative(0xCB9401F918CB0F75, player, animation, 0, -1)
        Wait(500)
        TriggerServerEvent("vorp_walkanim:setwalk", animation)
    else
        Citizen.InvokeNative(0xCB9401F918CB0F75, player, animation, 1, -1)
    end

end)

AddEventHandler("vorp_walkanim:setAnim", function(animation)
    local player = PlayerPedId()

    if animation == "noanim" then
        Citizen.InvokeNative(0xCB9401F918CB0F75, player, animation, 0, -1)
        Wait(500)
        TriggerServerEvent("vorp_walkanim:setwalk", animation)
        Wait(500)
        ExecuteCommand("rc")
    else

        Citizen.InvokeNative(0xCB9401F918CB0F75, player, animation, 0, -1)
        Wait(500)
        Citizen.InvokeNative(0xCB9401F918CB0F75, player, animation, 1, -1)
        TriggerServerEvent("vorp_walkanim:setwalk", animation)
        Wait(500)
        ExecuteCommand("rc")
    end

end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        Wait(10000)
        TriggerServerEvent("vorp_walkanim:getwalk")
    end
end)

TriggerEvent("chat:addSuggestion", "/" .. Config.command, Config.walkanimsuggestion, {})

RegisterCommand(Config.command, function()

    if isInMenu == false then
        OpenMenu()
        DisplayRadar(false)

    end
end)

Command = false

TriggerEvent("chat:addSuggestion", "/" .. Config.slowWalkCommand, Config.slowcommandSuggestion, {})
RegisterCommand(Config.slowWalkCommand, function()

    if not Command then
        Command = true
        while Command do
            Citizen.Wait(15)
            SetPedMaxMoveBlendRatio(PlayerPedId(), 0.2)

        end
    else
        Command = false
        SetPedMaxMoveBlendRatio(PlayerPedId(), 3.0)

    end
end)

-- charcters already have these commands

--[[RegisterCommand("sleeves", function(source, args, rawCommand)
    ExecuteCommand("sleeves")

end)

RegisterCommand("sleeves2", function(source, args, rawCommand)
    ExecuteCommand("sleeves2")

end)
RegisterCommand("bandana", function(source, args, rawCommand)
    ExecuteCommand("bandana")

end)
RegisterCommand("hat", function(source, args, rawCommand)
    ExecuteCommand("hat")

end)
RegisterCommand("eyewear", function(source, args, rawCommand)
    ExecuteCommand("eyewear")

end)
RegisterCommand("mask", function(source, args, rawCommand)
    ExecuteCommand("mask")

end)
RegisterCommand("neckwear", function(source, args, rawCommand)
    ExecuteCommand("neckwear")

end)
RegisterCommand("undress", function(source, args, rawCommand)
    ExecuteCommand("undress")

end)


RegisterCommand("dress", function(source, args, rawCommand)
    ExecuteCommand("dress")

end)
RegisterCommand("suspender", function(source, args, rawCommand)
    ExecuteCommand("suspender")

end)
RegisterCommand("vest", function(source, args, rawCommand)
    ExecuteCommand("vest")

end)
RegisterCommand("coat", function(source, args, rawCommand)
    ExecuteCommand("coat")

end)
RegisterCommand("ccoat", function(source, args, rawCommand)
    ExecuteCommand("ccoat")

end)
RegisterCommand("bow", function(source, args, rawCommand)
    ExecuteCommand("bow")

end)
RegisterCommand("armor", function(source, args, rawCommand)
    ExecuteCommand("armor")

end)
RegisterCommand("poncho", function(source, args, rawCommand)
    ExecuteCommand("poncho")

end)
RegisterCommand("cloack", function(source, args, rawCommand)
    ExecuteCommand("cloack")

end)
RegisterCommand("glove", function(source, args, rawCommand)
    ExecuteCommand("glove")

end)
RegisterCommand("rings", function(source, args, rawCommand)
    ExecuteCommand("rings")

end)
RegisterCommand("bracelet", function(source, args, rawCommand)
    ExecuteCommand("bracelet")

end)
RegisterCommand("accessories", function(source, args, rawCommand)
    ExecuteCommand("accessories")

end)
RegisterCommand("neckties", function(source, args, rawCommand)
    ExecuteCommand("neckties")

end)
RegisterCommand("shirt", function(source, args, rawCommand)
    ExecuteCommand("shirt")

end)
RegisterCommand("loadouts", function(source, args, rawCommand)
    ExecuteCommand("loadouts")

end)
RegisterCommand("satchels", function(source, args, rawCommand)
    ExecuteCommand("satchels")

end)
RegisterCommand("gunbeltaccs", function(source, args, rawCommand)
    ExecuteCommand("gunbeltaccs")

end)
RegisterCommand("buckle", function(source, args, rawCommand)
    ExecuteCommand("buckle")

end)
RegisterCommand("pant", function(source, args, rawCommand)
    ExecuteCommand("pant")

end)
RegisterCommand("skirt", function(source, args, rawCommand)
    ExecuteCommand("skirt")

end)
RegisterCommand("chap", function(source, args, rawCommand)
    ExecuteCommand("chap")

end)
RegisterCommand("boots", function(source, args, rawCommand)
    ExecuteCommand("boots")

end)
RegisterCommand("spurs", function(source, args, rawCommand)
    ExecuteCommand("spurs")

end)

RegisterCommand("spats", function(source, args, rawCommand)
    ExecuteCommand("spats")

end)

RegisterCommand("gauntlets", function(source, args, rawCommand)
    ExecuteCommand("gauntlets")

end)]]
