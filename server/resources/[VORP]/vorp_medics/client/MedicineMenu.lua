IsInMenu = false

TriggerEvent("menuapi:getData", function(call)
    MenuData = call
end)

function OpenMenu(craftLocationId)
    MenuData.CloseAll()
    IsInMenu = true

    local elements = {}

    for k,item in pairs(Config.MedicCraft) do
        elements[#elements+1] = {
            label = _U(item.desc),
            value = item.name,
            desc = _U(item.desc),
            info = item
        }
    end

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi' .. craftLocationId, {
        title = Config.Locations[craftLocationId].name,
        subtext = _U("CraftMenu"),
        align = Config.Align,
        elements = elements
    }, function(data, menu)
        local ItemName = data.current.info.name
        local ItemLabel = _U(data.current.info.name)
        
        local myInput = {
            type = "enableinput",
            inputType = "input",
            button = _U("confirm"),
            placeholder = _U("insertamount"),
            style = "block",
            attributes = {
                inputHeader = _U("amount"), -- header
                type = "number", -- inputype text, number,date.etc if number comment out the pattern
                pattern = "[0-9]", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                title = _U("must"), -- if input doesnt match show this message
                style = "border-radius: 10px; background-color: ; border:none;" -- style  the input
            }
        }

        TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
            local qty = tonumber(result)

            if qty ~= nil and qty ~= 0 and qty > 0 then
                Wait(qty*500) --replace with ProgressBar
                TriggerServerEvent("vorpMed:giveBack", ItemName, qty) -- give it
            else
                TriggerEvent("vorp:TipRight", _U("insertamount"), 3000)
            end

        end)
    end, function(data, menu)
        menu.close()
        ClearPedTasksImmediately(PlayerPedId())
        IsInMenu = false
        DisplayRadar(true)
    end)
end
