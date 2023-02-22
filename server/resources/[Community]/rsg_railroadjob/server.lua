--######################### edit for VORP by: outsider ########################
local VORPcore = {}
TriggerEvent("getCore", function(core)
    VORPcore = core
end)


-------------------- GetJOB --------------------
RegisterServerEvent('get:PlayerJob')
AddEventHandler('get:PlayerJob', function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local CharacterJob = Character.job

    TriggerClientEvent('send:PlayerJob', _source, CharacterJob)

end)
