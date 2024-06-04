UIPrompt = {}

local promptGroup = GetRandomIntInRange(0, 0xffffff)

UIPrompt.activate = function(title)
    local label = CreateVarString(10, 'LITERAL_STRING', title)
    PromptSetActiveGroupThisFrame(promptGroup, label)
end

UIPrompt.initialize = function()
    local str = _U('Press')
    MedPrompt = PromptRegisterBegin()
    PromptSetControlAction(MedPrompt, Config.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(MedPrompt, str)
    PromptSetEnabled(MedPrompt, 1)
    PromptSetVisible(MedPrompt, 1)
    PromptSetStandardMode(MedPrompt, 1)
    PromptSetGroup(MedPrompt, promptGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, MedPrompt, true)
    PromptRegisterEnd(MedPrompt)
end