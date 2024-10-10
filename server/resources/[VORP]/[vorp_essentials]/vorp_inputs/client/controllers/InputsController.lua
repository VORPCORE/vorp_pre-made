RegisterNetEvent('vorpinputs:getInput', InputsService.GetInputs)
RegisterNetEvent('vorpinputs:getInputsWithInputType', InputsService.GetInputsWithInputType)
RegisterNetEvent('vorpinputs:advancedInput', InputsService.OnAdvancedInput)

RegisterNUICallback("submit", InputsService.SetSubmit)
RegisterNUICallback("close", InputsService.CloseInput)

RegisterCommand("closeinput", InputsService.CloseInput, false)

-- Init
SetNuiFocus(false, false)

exports("advancedInput", function(input)
    if type(input) == "table" then
        input = json.encode(input)
    end
    local promisse = promise.new()
    InputsService.OnAdvancedInput(input, function(result)
        promisse:resolve(result)
    end)
    return Citizen.Await(promisse)
end)

