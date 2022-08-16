Config = {
    --add your language
    defaultlang = "en_lang",

    Key = 0x3C3DD371, --PGDOWN open menu

    CanOpenMenuWhenDead = true, -- if true any staff can open menu when dead, !WARNING! staff can abuse this to get revived

    ---------------------- NO CLIP ----------------------
    ShowControls = false,
    Controls = {

        goUp = 0xDE794E3E, -- Q
        goDown = 0x26E9DC00, -- Z
        turnLeft = 0x7065027D, -- A
        turnRight = 0xB4E465B4, -- D
        goForward = 0x8FD015D8, -- W
        goBackward = 0xD27782E3, -- S
        changeSpeed = 0x8FFC75D6, -- L-Shift
        camMode = 0x24978A28, -- H
        ShowControls = 0x8AAA0AD4 -- left alt
    },

    Speeds = {
        -- You can add or edit existing speeds with relative label
        { label = 'Very Slow', speed = 0 },
        { label = 'Slow', speed = 0.5 },
        { label = 'Normal', speed = 2 },
        { label = 'Fast', speed = 10 },
        { label = 'Very Fast', speed = 15 },
        { label = 'Max', speed = 29 },
    },

    Offsets = {
        y = 0.2, -- Forward and backward movement speed multiplier
        z = 0.1, -- Upward and downward movement speed multiplier
        h = 1, -- Rotation movement speed multiplier
    },

    FrozenPosition = true,


    -----------------------------------------------------
    -- Users scoreboard
    -- only one can be added
    -- choose what info should show to all users
    showUsersInfo = "showAll", -- showAll --showJob --showGroup -- showID

    --------------------------------------------------------
    -- WEBHOOKS/LOGS
    ReportLogs   = "", -- for reports
    webhookColor = 16711680, --EMBED COLOR RED
    name         = "VORP", --NAME OF EMBED
    logo         = "https://via.placeholder.com/30x30", --HEAD LOGO
    footerLogo   = "https://via.placeholder.com/30x30", --FOOTER LOGO
    Avatar       = "https://via.placeholder.com/30x30", -- AVATAR LOGO
    -- delete the ones you dont want to LOG into your discord.
    BoosterLogs  = {
        NoClip = "",
        InfiniteAmmo = "",
        GoldenCores = "",
        GodMode = "",
        SelfHeal = "",
        SelfRevive = "",
        SelfSpawnHorse = "",
        SelfSpawnWagon = "",
    },
    -- delete the ones you dont want to LOG into your discord.
    AdminLogs    = {
        --simple actions
        Freezed = "",
        Bring = "",
        Goto = "",
        Revive = "",
        Heal = "",
        Warned = "",
        Unwarned = "",
        Spectate = "",
        --advanced actions
        Respawn = "",
        Kick = "",
        Ban = "",
        Unban = "",
        Whitelist = "",
        Unwhitelist = "",
        Setgroup = "",
        Setjob = "",
        Announce = ""

    },
    -- delete the ones you dont want to LOG into your discord.
    TeleportLogs = {
        Tpm = "",
        Tptocoords = "",
        Tptoplayer = "",
        Bringplayer = "",
    },
    -- delete the ones you dont want to LOG into your discord.
    DatabaseLogs = {
        Giveitem = "",
        Giveweapon = "",
        Givecurrency = "",
        Givehorse = "",
        Givewagon = "",
        Clearmoney = "",
        Cleargold = "",
        Clearitems = "",
        Clearweapons = "",
    }



}
