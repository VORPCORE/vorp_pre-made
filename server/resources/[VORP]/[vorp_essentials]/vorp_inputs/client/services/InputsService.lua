InputsService = {}
local callbackOfCurrentOpenInput = nil

-- This is a workaround to consider if the 'x' button is pressed to close the input without an submit. The submit originally
-- calls the callback and executes the InputsService.CloseInput() method after that. The 'x' button calls the InputsService.CloseInput()
-- directly. So we need to check if the callback was already called by the submit otherwise the trigger was the 'x' button
-- then we need to call the callback now.
---@param result string
---@private
InputsService._callCallbackIfNotCalledAlready = function(result)

    if callbackOfCurrentOpenInput == nil then
        return
    end

    callbackOfCurrentOpenInput(result)
    callbackOfCurrentOpenInput = nil -- Don't call callback twice
end

InputsService.CloseInput = function()
    InputsService._callCallbackIfNotCalledAlready("")
    SetNuiFocus(false, false)
    SendNUIMessage(NUIEvent:New({ style = "none" }))
end

---@param result table
InputsService.CallCallbackAndCloseInput = function(result)

    local resultText = result.stringtext or nil

    if resultText ~= nil then
        InputsService._callCallbackIfNotCalledAlready(resultText)
    end

    Wait(1)

    InputsService.CloseInput()
end

---@param result table
InputsService.SetSubmit = function(result)
    InputsService.CallCallbackAndCloseInput(result)
end

---@param result table
InputsService.SetClose = function(result)
   --TODO At which point will this method be called? Is it correct to set result.resultText and call callback?
    InputsService.CallCallbackAndCloseInput(result)
end

---@param title string
---@param placeHolder string
---@param cb function
InputsService.GetInputs = function(title, placeHolder, cb)
    InputsService.WaitForInputs(title, placeHolder, cb)
end

---@param title string
---@param placeHolder string
---@param inputType string
---@param cb function
InputsService.GetInputsWithInputType = function(title, placeHolder, inputType, cb)
    InputsService.WaitForInputs(title, placeHolder, cb, inputType)
end

---@param inputConfig string
---@param cb function
InputsService.OnAdvancedInput = function(inputConfig, cb)
    SetNuiFocus(true, true)
    SendNUIMessage(json.decode(inputConfig))
    callbackOfCurrentOpenInput = cb
end

---@param button string
---@param placeHolder string
---@param cb function
---@param inputType string
InputsService.WaitForInputs = function(button, placeHolder, cb, inputType)
    inputType = inputType or "input" or "textarea"

    SetNuiFocus(true, true)
    SendNUIMessage(NUIEvent:New({
        style = "block",
        button = button,
        placeholder = placeHolder,
        inputType = inputType,
    }))

    callbackOfCurrentOpenInput = cb
end
