local VorpCore
TriggerEvent("getCore", function(core)
    VorpCore = core
end)



RegisterServerEvent("vorp_walkanim:getwalk")
AddEventHandler("vorp_walkanim:getwalk", function()
    local _source = source
    local User = VorpCore.getUser(source)
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier

    exports.ghmattimysql:execute('SELECT walk FROM characters WHERE identifier=@identifier AND charidentifier = @charidentifier', { ['identifier'] = u_identifier, ['charidentifier'] = u_charid }, function(result)
        if result[1] then
            local walk = result[1].walk

            TriggerClientEvent("vorp_walkanim:getwalk2", _source, walk)
        end
    end)
end)

RegisterServerEvent("vorp_walkanim:setwalk")
AddEventHandler("vorp_walkanim:setwalk", function(animation)
    local _source = source
    local walk = animation
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier

    exports.ghmattimysql:execute("UPDATE characters Set walk=@walk WHERE identifier=@identifier AND charidentifier = @charidentifier", { ['walk'] = walk, ['identifier'] = identifier, ['charidentifier'] = charidentifier })
end)
