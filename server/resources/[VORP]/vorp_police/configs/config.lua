Config = {}

Config.DevMode = true

Config.Align = "top-left" -- menu alignment

Config.Lang = "English" -- language you want to use please make sure its in the translation.lua

Config.Dragcommand = "Drag" -- Comand to drag players

Config.PoliceMenuCommand = 'policeMenu' -- Command to go on duty and teleport

Config.alertPolice = "callpolice" -- command to alert police

Config.cancelpolicealert = "cancelPoliceAlert"

Config.finishpolicelert = "finishPoliceAlert"

Config.AllowOnlyDeadToAlert = true -- if true only dead players can alert police if false anyone can alert police

-- add any job names here
Config.PoliceJobs = {
    BWSheriff = true,
    RhoSheriff = true,
    SDSheriff = true,
    StrSheriff = true,
    ArmSheriff = true,
    ValSheriff = true
}

Config.Keys = { -- prompts
    B = 0x4CC0E2FE
}

-- jobs allowed to hire
Config.JobLabels = {
    BWSheriff = "Sheriff",
    RhoSheriff = "Sheriff",
    SDSheriff = "Sheriff",
    StrSheriff = "Sheriff",
    ArmSheriff = "Sheriff",
    ValSheriff = "Sheriff"
}

-- jobs that can open hire menu
Config.SheriffJobs = {
    BWSheriff = true,
    RhoSheriff = true,
    SDSheriff = true,
    StrSheriff = true,
    ArmSheriff = true,
    ValSheriff = true
}

-- items
Config.CuffItem = "handcuffs" -- can only uncuff if theres a key for the handcuffs

Config.KeysItem = "handcuffkey" -- when using this will get you handcuffs if you dont have one already

-- if true storage for every police station will be shared if false they will be unique
Config.ShareStorage = true

-- storage locations
-- check the server.lua for webhook url location line 19 in server.lua
Config.Storage = {

    Valentine = {
        Name = "Storage",
        Limit = 1000,
        Coords = vector3(-276.97, 810.83, 119.38)
    },
    Strawberry = {
        Name = "Storage",
        Limit = 1000,
        Coords = vector3(-1814.17, -354.75, 164.65)
    },
    Blackwater = {
        Name = "Armoury",
        Limit = 1000,
        Coords = vector3(-765.12, -1272.37, 44.04)
    },
    Rhodes = {
        Name = "Armoury",
        Limit = 1000,
        Coords = vector3(1361.17, -1305.83, 77.76)

    },
    SaintDenis = {
        Name = "Armoury",
        Limit = 1000,
        Coords = vector3(2494.62, -1304.3, 48.95)

    },
    Tumbleweed = {
        Name = "Armoury",
        Limit = 1000,
        Coords = vector3(-5526.59, -2928.51, -1.36)
    },
    Annesburg = {
        Name = "Armoury",
        Limit = 1000,
        Coords = vector3(2904.03, 1309.86, 44.94)
    },
    Armadillo = {
        Name = "Armoury",
        Limit = 1000,
        Coords = vector3(-3622.69, -2600.0, -13.34)
    }
}

-- if true players can use teleport from the police menu if false only from locations
Config.UseTeleportsMenu = true

-- set up locations to teleport to or from
Config.Teleports = {

    Valentine = {
        Name = " Valentine",
        Coords = vector3(-278.17, 814.88, 119.28)
    },
    Strawberry = {
        Name = "Strawberry",
        Coords = vector3(-1805.13, -355.05, 164.14)
    },
    Blackwater = {
        Name = "Blackwater",
        Coords = vector3(-752.53, -1266.1, 43.43)
    },
    Rhodes = {
        Name = "Rhodes",
        Coords = vector3(1354.9, -1306.85, 76.94)

    },
    SaintDenis = {
        Name = "Saint Denis",
        Coords = vector3(2510.0, -1318.0, 48.53)

    },
    Tumbleweed = {
        Name = "Tumbleweed",
        Coords = vector3(-5531.39, -2935.31, -1.91)
    },
    Annesburg = {
        Name = "Annesburg",
        Coords = vector3(2916.59, 1317.09, 44.35)
    },
    Armadillo = {
        Name = "Armadillo",
        Coords = vector3(-3610.4, -2599.16, -13.88)
    }
}

-- blips for stations
Config.Blips = {
    Sprite = "blip_mp_bounty_hunter_introduction",
    Color = "COLOR_WHITE",
    Style = "BLIP_STYLE_FRIENDLY_ON_RADAR"
}

Config.AlertBlips = {
    Color = "COLOR_RED",
    Style = "BLIP_STYLE_CHALLENGE_OBJECTIVE",
    Sprite = "blip_mp_bounty_hunter_introduction"
}

-- police stations  boss menu locations
Config.Stations = {

    Valentine = {
        Name = "Valentine",
        Coords = vector3(-277.73, 804.84, 119.38),
        Teleports = Config.Teleports,
        Storage = Config.Storage
    },
    Strawberry = {
        Name = "Strawberry",
        Coords = vector3(-1807.03, -348.47, 164.65),
        Teleports = Config.Teleports,
        Storage = Config.Storage
    },
    Blackwater = {
        Name = "Blackwater",
        Coords = vector3(-761.95, -1272.62, 44.05),
        Teleports = Config.Teleports,
        Storage = Config.Storage
    },
    Rhodes = {
        Name = "Rhodes",
        Coords = vector3(1361.57, -1303.4, 77.77),
        Teleports = Config.Teleports,
        Storage = Config.Storage
    },
    SaintDenis = {
        Name = "Saint Denis",
        Coords = vector3(2508.46, -1308.56, 48.95),
        Teleports = Config.Teleports,
        Storage = Config.Storage
    },
    Tumbleweed = {
        Name = "Tumbleweed",
        Coords = vector3(-5529.55, -2929.25, -1.36),
        Teleports = Config.Teleports,
        Storage = Config.Storage
    },
    Annesburg = {
        Name = "Annesburg",
        Coords = vector3(2907.11, 1313.93, 44.94),
        Teleports = Config.Teleports,
        Storage = Config.Storage
    },
    Armadillo = {
        Name = "Armadillo",
        Coords = vector3(-3624.7, -2601.96, -13.34),
        Teleports = Config.Teleports,
        Storage = Config.Storage
    }
}
