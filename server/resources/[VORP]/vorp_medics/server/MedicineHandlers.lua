VORPcore = {}
VorpInv = nil
local HerbalLocs = {}
local MedicalHorse = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

VorpInv.RegisterUsableItem("syringe", function(data)
    if CanPlayerRevive(data.source) then
        VorpInv.subItem(data.source, "syringe", 1)
        TriggerClientEvent("vorpMed:revive", data.source)
    else
        TriggerClientEvent("vorp:Tip", data.source, _U("NotDoctor"), 5000)
    end
end)

VorpInv.RegisterUsableItem("consumable_medicine", function(data)
    if IsPlayerMedic(data.source) then
        VorpInv.subItem(data.source, "consumable_medicine", 1)
        TriggerClientEvent("vorpMed:healOuter", data.source, 100)
    else
        TriggerClientEvent("vorp:Tip", data.source, _U("NotDoctor"), 5000)
    end
end)

VorpInv.RegisterUsableItem("bandage", function(data)
    VorpInv.subItem(data.source, "bandage", 1)
    if IsPlayerMedic(data.source) then
        TriggerClientEvent("vorpMed:healOuter", data.source, 40)
    else
        TriggerClientEvent("vorpMed:healInner", data.source, 25, "bandage")
    end
end)

VorpInv.RegisterUsableItem("herbal_medicine", function(data) -- https://reddead.fandom.com/wiki/Medicine
    VorpInv.subItem(data.source, "herbal_medicine", 1)
    if IsPlayerHerbalist(data.source) then
        TriggerClientEvent("vorpMed:healOuter", data.source, 75)
    else
        TriggerClientEvent("vorpMed:healInner", data.source, 75, "herbal_medicine")
    end
end)

VorpInv.RegisterUsableItem("herbal_tonic", function(data) -- https://reddead.fandom.com/wiki/Tonic
    VorpInv.subItem(data.source, "herbal_tonic", 1)
    if IsPlayerHerbalist(data.source) then
        TriggerClientEvent("vorpMed:healOuter", data.source, 50)
    else
        TriggerClientEvent("vorpMed:healInner", data.source, 50, "herbal_tonic")
    end
end)

function IsPlayerMedic(_source)
    local Character = VORPcore.getUser(_source)
    if not Character then
      return 
    end
    Character = Character.getUsedCharacter  
    if tostring(Character.job) == "doctor" then
        return true
    end
    return false
end

function CanPlayerRevive(_source)
    local Character = VORPcore.getUser(_source).getUsedCharacter
    for k,v in pairs(Config.Job) do
        if tostring(Character.job) == v then
            return true
        end
    end
    return false
end

function IsPlayerHerbalist(_source)
    local steamId = VORPcore.getUser(_source).getIdentifier()
    local charId = VORPcore.getUser(_source).getUsedCharacter.charIdentifier

    local retvalList = exports.ghmattimysql:executeSync("SELECT * FROM herbalists WHERE `identifier`=? AND `charidentifier`=?", {steamId, charId})
    if #retvalList>0 then
        return true
    else
        return false
    end
end

function BecomeHerbalist(_source, location)
    local steamId = VORPcore.getUser(_source).getIdentifier()
    local charId = VORPcore.getUser(_source).getUsedCharacter.charIdentifier
    print(steamId, charId, location)

    if HerbalLocs[location] > 0 then
        HerbalLocs[location] = HerbalLocs[location] - 1
        exports.ghmattimysql:executeSync("INSERT INTO herbalists (identifier, charidentifier, location) VALUES (@identifier, @charidentifier, @location)",
        {['@identifier'] = steamId, ['@charidentifier']=charId, ['@location']=tostring(location)})
    else
        TriggerClientEvent("vorp:Tip", source, _U("NoMoreHerbalists"), 5000)
    end
end

function SaveHorse(_source, horse)
    local identifier = VORPcore.getUser(_source).getIdentifier()
    local charId =  VORPcore.getUser(_source).getUsedCharacter.charIdentifier
    MedicalHorse[#MedicalHorse+1] = {steamid = identifier, charId = charId, horse = horse}
end

function DeleteHorse(_source)
    local identifier = VORPcore.getUser(_source).getIdentifier()
    local charId =  VORPcore.getUser(_source).getUsedCharacter.charIdentifier
    for i,v in ipairs(MedicalHorse) do
        if v.steamid == identifier and v.charId == charId then
            table.remove(MedicalHorse, i)
            return
        end
    end
end

function FindHorse(_source)
    local identifier = VORPcore.getUser(_source).getIdentifier()
    local charId =  VORPcore.getUser(_source).getUsedCharacter.charIdentifier
    for i,v in ipairs(MedicalHorse) do
        if v.steamid == identifier and v.charId == charId then
            TriggerClientEvent("vorpMed:horseFound", _source)
            return
        end
    end
end

Citizen.CreateThread(function()
    for k,v in pairs(Config.HerbalistLocations) do
        HerbalLocs[k] = v.maxAllowed
    end

    local retvalList = exports.ghmattimysql:executeSync("SELECT * FROM herbalists")

    if retvalList then
        for k,v in pairs(retvalList) do
            HerbalLocs[v.location] = HerbalLocs[v.location] - 1
        end
    end
end)
