Config = {}

Config.Cooldown = 1000 * 60 -- 300000 = 5 minutes in how many miliseconds should check the lucky number when crossing the location. if you put 0 it will defenitly spawn npcs Advise to keep it 50000
Config.DeleteNPcsAfterPlayerDied = 1000 * 60 -- after player is dead delte npcs after cool down  so that firends can kill them

Config.Outlaws = {

	firstLocation = {
		Random = { min = 1, max = 10 }, -- set between min and max how lucky a player will be to trigger an ambush
		luckynumber = 1, -- if the random number = this number then start ambush
		x = -1406.96, y = -965.50, z = 61.75, -- location that triggers the ambush
		BlipHandle = 953018525, -- sprite of the npc blip. dont change
		DistanceTriggerMission = 18.0, -- distance from the location to trigger the ambush
		DistanceToStopAmbush = 150, -- distance to stop the ambush when player is 150 away then ambush will stop
		MaxPeds = 10, -- this says dont spawn more than 10 per wave
		MaxAlive = 4, -- spawn how many - then when killed will keep spawning untill has reached MXAPEDS ^
		RandomPedSpawn = { min = 1, max = 3 }, -- random amount to spawn at first
		outlawsLocation = {
			{ x = -1364.356, y = -966.014, z = 72.52 }, -- location to spawn peds for each ped
			{ x = -1369.356, y = -960.0144, z = 72.52 },
			{ x = -1391.35, y = -985.014, z = 72.52 },
			{ x = -1480.86, y = -915.48, z = 80.94 },
			{ x = -1491.77, y = -944.48, z = 88.94 },
			{ x = -1491.77, y = -944.48, z = 88.94 },
		},
		outlawsModels = {
			{ hash = "G_M_M_UniBanditos_01" }, -- models it will pick a random model
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" }
		},
		-- NOTIFY for each location
		Notification = "you are being ambushed by the notorious gang of black water",
		NotificationTitle = "~e~AMBUSH",
		NotificationKilledTitle = "you have killed them all",
		NotificationKilled = "Safe Travels...",
		NotificationEscapeTitle = "!you have escaped!",
		NotificationEscape = "keep an eye on the road",
		NotificationDiedTitle = "!you have been killed!",
		NotificationDied = "bandits will stay for awhile"
	},

	secondLocation = {
		Random = { min = 1, max = 10 },
		luckynumber = 3,
		x = -1370.55, y = 1471.54, z = 241.58, -- beartooth pass
		BlipHandle = 953018525,
		DistanceTriggerMission = 13.0,
		DistanceToStopAmbush = 150,
		MaxPeds = 10,
		MaxAlive = 7,
		RandomPedSpawn = { min = 1, max = 6 },
		outlawsLocation = {
			{ x = -1362.819, y = 1429.0799, z = 234.409 },
			{ x = -1366.819, y = 1428.0799, z = 235.409 },
			{ x = -1359.819, y = 1423.0799, z = 234.409 },
		},

		outlawsModels = {
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" }
		},
		Notification = "you are being ambushed by the notorious gang of black water",
		NotificationTitle = "~e~AMBUSH",
		NotificationKilledTitle = "you have killed them all",
		NotificationKilled = "Safe Travels...",
		NotificationEscapeTitle = "!you have escaped!",
		NotificationEscape = "keep an eye on the road",
		NotificationDiedTitle = "!you have been killed!",
		NotificationDied = "bandits will stay for awhile"
	},

	thirdLocation = {
		Random = { min = 1, max = 10 },
		luckynumber = 1,
		x = 356.13, y = 442.88, z = 111.37, -- Citadel Rock area
		BlipHandle = 953018525,
		DistanceTriggerMission = 13.0,
		DistanceToStopAmbush = 150,
		MaxPeds = 10,
		MaxAlive = 7,
		RandomPedSpawn = { min = 1, max = 6 },
		outlawsLocation = {
			{ x = 466.03, y = 376.79, z = 106.49 },
			{ x = 450.94, y = 367.32, z = 104.30 },
			{ x = 469.02, y = 376.98, z = 106.72 },
			{ x = 454.90, y = 377.63, z = 105.72 },
		},
		outlawsModels = {
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" }
		},
		Notification = "you are being ambushed by the notorious gang of black water",
		NotificationTitle = "~e~AMBUSH",
		NotificationKilledTitle = "you have killed them all",
		NotificationKilled = "Safe Travels...",
		NotificationEscapeTitle = "!you have escaped!",
		NotificationEscape = "keep an eye on the road",
		NotificationDiedTitle = "!you have been killed!",
		NotificationDied = "bandits will stay for awhile"
	},

	fourthLocation = {
		Random = { min = 1, max = 10 },
		luckynumber = 1,
		x = 2163.16, y = -1329.416, z = 42.50,
		BlipHandle = 953018525,
		DistanceTriggerMission = 13.0,
		DistanceToStopAmbush = 150,
		MaxPeds = 10,
		MaxAlive = 7,
		RandomPedSpawn = { min = 1, max = 6 },
		outlawsLocation = {
			{ x = 2160.73, y = -1315.26, z = 41.35 },
			{ x = 2160.73, y = -1313.26, z = 41.39 },
			{ x = 2139.51, y = -1295.05, z = 41.32 },
			{ x = 2131.51, y = -1305.36, z = 41.54 }
		},
		outlawsModels = {
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" },
			{ hash = "G_M_M_UniBanditos_01" }
		},
		Notification = "you are being ambushed by the notorious gang of black water",
		NotificationTitle = "~e~AMBUSH",
		NotificationKilledTitle = "you have killed them all",
		NotificationKilled = "Safe Travels...",
		NotificationEscapeTitle = "!you have escaped!",
		NotificationEscape = "keep an eye on the road",
		NotificationDiedTitle = "!you have been killed!",
		NotificationDied = "bandits will stay for awhile"
	}
	-- to add more just copy from above and make new coords
}
