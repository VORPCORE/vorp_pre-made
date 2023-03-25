local VORPcore = {}
TriggerEvent("getCore", function(core)
	VORPcore = core
end)

RegisterNetEvent('vorpclothingstore:getPlayerCloths')
AddEventHandler('vorpclothingstore:getPlayerCloths', function(result)
	local _source = source
	local Character = VORPcore.getUser(_source).getUsedCharacter
	local charIdentifier = Character.charIdentifier

	local comps = Character.comps
	local skin = Character.skin

	TriggerClientEvent('vorpclothingstore:LoadYourCloths', _source, comps, skin)
	local sid = nil
	for _, v in pairs(GetPlayerIdentifiers(_source)) do
		if string.find(v, 'steam') then
			sid = v
			break
		end
	end
	if sid then
		exports["ghmattimysql"]:execute("SELECT * FROM outfits WHERE `identifier` = ? AND `charidentifier` = ?",
			{ sid, charIdentifier }, function(result)
			if result then
				TriggerClientEvent('vorpclothingstore:LoadYourOutfits', _source, result)
			end
		end)
	else
		print("Error: SteamID not found for " .. _source)
	end
end)

RegisterNetEvent('vorpclothingstore:buyPlayerCloths')
AddEventHandler('vorpclothingstore:buyPlayerCloths', function(totalCost, jsonCloths, saveOutfit, outfitName)
	local _source = source
	local Character = VORPcore.getUser(_source).getUsedCharacter
	local sid = nil;
	for _, v in pairs(GetPlayerIdentifiers(_source)) do
		if string.find(v, 'steam') then
			sid = v
			break
		end
	end
	local userMoney = Character.money
	if totalCost <= userMoney then
		TriggerEvent("vorpcharacter:setPlayerCompChange", _source, jsonCloths);
		local charIdentifier = Character.charIdentifier
		if sid then
			if saveOutfit then
				exports.ghmattimysql:execute("INSERT INTO outfits (identifier,charidentifier,title,comps) VALUES (?,?,?,?)",
					{ sid, charIdentifier, outfitName, jsonCloths });
			end
		else
			print("Error: SteamID not found for " .. _source)
		end
		Character.removeCurrency(0, totalCost)
		TriggerClientEvent("vorp:Tip", _source, _("SuccessfulBuy") .. " $" .. totalCost, 4000)
		Wait(1000) -- Gives a little extra time to read the message
		TriggerClientEvent("vorpclothingstore:startBuyCloths", _source, true)
	else
		TriggerClientEvent("vorp:Tip", _source, _("NoMoney"), 4000)
		Wait(1000) -- Gives a little extra time to read the message
		TriggerClientEvent("vorpclothingstore:startBuyCloths", _source, false)
	end
end)

RegisterNetEvent('vorpclothingstore:setOutfit')
AddEventHandler('vorpclothingstore:setOutfit', function(result)
	local _source = source
	if result then
		TriggerEvent("vorpcharacter:setPlayerCompChange", _source, result);
	end
end)

RegisterNetEvent('vorpclothingstore:deleteOutfit')
AddEventHandler('vorpclothingstore:deleteOutfit', function(outfitId)
	local _source = source
	local sid = nil
	for _, v in pairs(GetPlayerIdentifiers(_source)) do
		if string.find(v, 'steam') then
			sid = v
			break
		end
	end
	if sid then
		exports["ghmattimysql"]:execute("DELETE FROM outfits WHERE identifier=? AND id=?", { sid, outfitId })
	else
		print("Error: SteamID not found for " .. _source)
	end
end)


-- Ignore, only to warn devs when debugMode is on
if Config.debugMode then
	print("^3VORP_ClothingStore - Warning: ^7Debug mode is turned on, you may experience issues")
end