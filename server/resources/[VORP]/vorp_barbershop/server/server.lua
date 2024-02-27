local Core = exports.vorp_core:GetCore()
local T = Translation.Langs[Lang]

RegisterServerEvent('vorp_barbershop:getinfo')
AddEventHandler('vorp_barbershop:getinfo', function()
    local User = Core.getUser(source)
    local _source = source
    local Character = User.getUsedCharacter
    local u_charid = Character.charIdentifier
    exports.ghmattimysql:execute('SELECT skinPlayer FROM characters WHERE charidentifier = @charidentifier',
        { ['charidentifier'] = u_charid }, function(result)
            if result[1] ~= nil then
                local skin = result[1].skinPlayer
                TriggerClientEvent("vorp_barbershop:recinfo", _source, skin)
            end
        end)
end)

Core.Callback.Register("vorp_barbershop:payforservice", function(source, cb, data)
    local _source = source
    local Character = Core.getUser(_source).getUsedCharacter
    local cash = Character.money

    if cash < data.amount then
        Core.NotifyRightTip(_source, T.nomoney, 10000)
        return cb(false)
    end

    Character.removeCurrency(0, data.amount)
    Core.NotifyRightTip(_source, T.youpaid .. data.amount, 10000)

    local newcomps = {}
    if data.beard ~= nil then
        newcomps["Beard"] = data.beard
    end
    newcomps["Hair"] = data.hair
    local newskinjson = json.encode(newcomps)

    TriggerClientEvent("vorpcharacter:savenew", _source, false, newskinjson)
    return cb(true)
end)
