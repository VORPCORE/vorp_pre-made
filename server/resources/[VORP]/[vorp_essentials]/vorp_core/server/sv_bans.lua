local T = Translation[Lang].MessageOfSystem

AddEventHandler("vorpbans:addtodb", function(status, id, datetime)
	local sid = _whitelist[id].GetEntry().getIdentifier() --IdsToIdentifiers[id]

	if status == true then
		for _, player in ipairs(GetPlayers()) do
			if sid == GetPlayerIdentifiers(player)[1] then
				if datetime == 0 then
					DropPlayer(player, Translation[Lang].Notify.banned3)
				else
					local bannedUntil = os.date(Config.DateTimeFormat, datetime + Config.TimeZoneDifference * 3600)
					DropPlayer(player, T.DropReasonBanned .. bannedUntil .. Config.TimeZone)
				end
				break
			end
		end
	end

	MySQL.update("UPDATE users SET banned = @banned, banneduntil=@time WHERE identifier = @identifier",
		{ ['@banned'] = status, ['@time'] = datetime, ['@identifier'] = sid }, function(result)
	end)
end)

--todo this will have a overhaul soon to add a reason to the warns/or kick player

---WARNING SYSTEM
---@param status boolean status true false
---@param targetSteamid string target steam id
---@param sourceId number admin id
AddEventHandler("vorp_core:Server:Warnings", function(status, targetSteamid, sourceId)
	local warnings
	--local sid = _whitelist[targetSteamid].GetEntry().getIdentifier() --IdsToIdentifiers[id] -- you have the steam available why do we need this?
	-- does player exist in the databse? why are we calling the database without check if if player is in game ?
	--local resultList = MySQL.prepare.await("SELECT * FROM users WHERE identifier = ?", { sid })

	if targetSteamid and _users[targetSteamid] then
		local user = _users[targetSteamid].GetUser()
		local targetId = user.Source()
		print(targetId)
		warnings = user.getPlayerwarnings()

		-- for _, player in ipairs(GetPlayers()) do --! why the  need to iterate over all players if the id is already available?
		-- if sid == GetPlayerIdentifiers(player)[1] then
		if status then
			TriggerClientEvent("vorp:Tip", targetId, T.Warned, 10000)
			TriggerClientEvent("vorp:Tip", sourceId, "Player Has been warned", 10000)
			warnings = warnings + 1
		else
			TriggerClientEvent("vorp:Tip", targetId, T.Unwarned, 10000)
			TriggerClientEvent("vorp:Tip", sourceId, "Player Has been unwarned", 10000)
			warnings = warnings - 1
		end
		--  break
		--  end
		-- end
		user.setPlayerWarnings(warnings)
		return
	else
		local resultList = MySQL.prepare.await("SELECT * FROM users WHERE identifier = ?", { targetSteamid })

		if resultList == nil then
			return print("^1error: ^3steam id does not match any user in the database")
		end

		local user = resultList
		warnings = user.warnings
		if warnings then
			if status then
				TriggerClientEvent("vorp:Tip", sourceId, "Player Has been warned", 10000)
				warnings = warnings + 1
			else
				TriggerClientEvent("vorp:Tip", sourceId, "Player Has been unwarned", 10000)
				warnings = warnings - 1
			end
			MySQL.update("UPDATE users SET warnings = ? WHERE identifier = ?", { warnings, targetSteamid })
		end
	end

	--! why are we updating here for both cases when above is setPlayerWarnings(warnings) being used ?
	-- MySQL.update("UPDATE users SET warnings = @warnings WHERE identifier = @identifier",
	--  { ['@warnings'] = warnings, ['@identifier'] = sid })
end)
