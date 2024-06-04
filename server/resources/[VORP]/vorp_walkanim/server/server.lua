local Core = exports.vorp_core:GetCore()

AddEventHandler("vorp:SelectedCharacter", function(source, character)
    local charId = character.charIdentifier
    exports.oxmysql:execute('SELECT walk FROM characters WHERE charidentifier = @charidentifier',  { charidentifier = charId }, function(result)
        if result[1] then
            local walk = result[1].walk
            TriggerClientEvent("vorp_walkanim:Server:setwalk", source, walk)
        end
    end)
end)

RegisterServerEvent("vorp_walkanim:setwalk", function(animation)
    local _source = source
    local walk = animation
    local user = Core.getUser(_source)
    if not user then
        return
    end
    local Character = user.getUsedCharacter
    local charidentifier = Character.charIdentifier
    exports.oxmysql:execute("UPDATE characters Set walk=@walk WHERE charidentifier = @charidentifier",  { walk = walk, charidentifier = charidentifier })
end)


