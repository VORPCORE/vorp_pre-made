Config = {
    --add your language
    defaultlang         = "en_lang",
    Key                 = 0x3C3DD371, --PGDOWN open menu
    CanOpenMenuWhenDead = true, -- if true any staff can open menu when dead, !WARNING! staff can abuse this to get revived
    useQWreports        = true, -- disable this if you are not using qw reports
    -- heal
    Heal                = {
        Players = function()
            --TriggerServerEvent("outsider_needs:Heal") -- trigger to server and from there heal player
            TriggerEvent("vorpmetabolism:changeValue", "Thirst", 1000)
            TriggerEvent("vorpmetabolism:changeValue", "Hunger", 1000)
            --TriggerEvent('fred_meta:consume', 100, 100, 0, 0, 0.0, 0.0, 0.0, 0.0, 0.0) -- fred metabolism
        end
    },
    ---------------------- NO CLIP ----------------------

    Controls            = {

        goUp = 0xF84FA74F, -- Q
        goDown = 0x07CE1E61, -- Z
        turnLeft = 0x7065027D, -- A
        turnRight = 0xB4E465B4, -- D
        goForward = 0x8FD015D8, -- W
        goBackward = 0x8CF90A9D, -- S I DONT FUCKING KNOW WHY S DONT WORK
        changeSpeed = 0x8FFC75D6, -- L-Shift
        camMode = 0x24978A28, -- H
        Cancel = 0x4AF4D473

    },
    Speeds              = {
        -- You can add or edit existing speeds with relative label
        { label = 'Very Slow', speed = 0 },
        { label = 'Slow',      speed = 0.5 },
        { label = 'Normal',    speed = 2 },
        { label = 'Fast',      speed = 10 },
        { label = 'Very Fast', speed = 15 },
        { label = 'Max',       speed = 29 },
    },
    Offsets             = {
        y = 0.2, -- Forward and backward movement speed multiplier
        z = 0.1, -- Upward and downward movement speed multiplier
        h = 1, -- Rotation movement speed multiplier
    },
    FrozenPosition      = true, -- frozen on open menu vorp.staff.OpenMenu
    AllowedGroups       = {
        { group = { "admin" }, command = "vorp.staff.OpenMenu" },
        { group = { "admin" }, command = "vorp.staff.Admin" }, -- groups you want for these permissions
        { group = { "admin" }, command = "vorp.staff.Boosters" },
        { group = { "admin" }, command = "vorp.staff.Database" },
        { group = { "admin" }, command = "vorp.staff.Teleports" },
        { group = { "admin" }, command = "vorp.staff.Devtools" },
        { group = { "admin" }, command = "vorp.staff.PlayersList" },
        { group = { "admin" }, command = "vorp.staff.AdminActions" },
        { group = { "admin" }, command = "vorp.staff.OfflineActions" },
        { group = { "admin" }, command = "vorp.staff.PlayersListSubmenu" },
        { group = { "admin" }, command = "vorp.staff.OpenSimpleActions" },
        { group = { "admin" }, command = "vorp.staff.Spectate" },
        { group = { "admin" }, command = "vorp.staff.Frezee" },
        { group = { "admin" }, command = "vorp.staff.Revive" },
        { group = { "admin" }, command = "vorp.staff.Heal" },
        { group = { "admin" }, command = "vorp.staff.GoTo" },
        { group = { "admin" }, command = "vorp.staff.Bring" },
        { group = { "admin" }, command = "vorp.staff.Warn" },
        { group = { "admin" }, command = "vorp.staff.UnWarn" },
        { group = { "admin" }, command = "vorp.staff.OpenAdvancedActions" },
        { group = { "admin" }, command = "vorp.staff.Kick" },
        { group = { "admin" }, command = "vorp.staff.Ban" },
        { group = { "admin" }, command = "vorp.staff.Unban" },
        { group = { "admin" }, command = "vorp.staff.Respawn" },
        { group = { "admin" }, command = "vorp.staff.Whitelist" },
        { group = { "admin" }, command = "vorp.staff.Unwhitelist" },
        { group = { "admin" }, command = "vorp.staff.Setjob" },
        { group = { "admin" }, command = "vorp.staff.Setgroup" },
        { group = { "admin" }, command = "vorp.staff.DeleteHorse" },
        { group = { "admin" }, command = "vorp.staff.DeleteWagon" },
        { group = { "admin" }, command = "vorp.staff.DeleteWagonsRadius" },
        { group = { "admin" }, command = "vorp.staff.GetCoords" },
        { group = { "admin" }, command = "vorp.staff.Announce" },
        { group = { "admin" }, command = "vorp.staff.Godmode" },
        { group = { "admin" }, command = "vorp.staff.Noclip" },
        { group = { "admin" }, command = "vorp.staff.Golden" },
        { group = { "admin" }, command = "vorp.staff.SpawnWagon" },
        { group = { "admin" }, command = "vorp.staff.SpawHorse" },
        { group = { "admin" }, command = "vorp.staff.SelfHeal" },
        { group = { "admin" }, command = "vorp.staff.SelfRevive" },
        { group = { "admin" }, command = "vorp.staff.OpenDatabase" },
        { group = { "admin" }, command = "vorp.staff.OpenGiveMenu" },
        { group = { "admin" }, command = "vorp.staff.ShowInvGive" },
        { group = { "admin" }, command = "vorp.staff.Giveitems" },
        { group = { "admin" }, command = "vorp.staff.GiveWeapons" },
        { group = { "admin" }, command = "vorp.staff.GiveCurrency" },
        { group = { "admin" }, command = "vorp.staff.GiveHorse" },
        { group = { "admin" }, command = "vorp.staff.GiveWagons" },
        { group = { "admin" }, command = "vorp.staff.OpenRemoveMenu" },
        { group = { "admin" }, command = "vorp.staff.ShowInvRemove" },
        { group = { "admin" }, command = "vorp.staff.RemoveAllMoney " },
        { group = { "admin" }, command = "vorp.staff.RemoveAllGold" },
        { group = { "admin" }, command = "vorp.staff.RemoveAllItems" },
        { group = { "admin" }, command = "vorp.staff.RemoveAllWeapons" },
        { group = { "admin" }, command = "vorp.staff.WayPoint" },
        { group = { "admin" }, command = "vorp.staff.TpCoords" },
        { group = { "admin" }, command = "vorp.staff.AutoTpm" },
        { group = { "admin" }, command = "vorp.staff.TpPlayer" },
        { group = { "admin" }, command = "vorp.staff.BringPlayer" },
        { group = { "admin" }, command = "vorp.staff.ViewReports" },
        { group = { "admin" }, command = "vorp.staff.Invisibility" },
        { group = { "admin" }, command = "vorp.staff.SetPlayerOnFire" },
        { group = { "admin" }, command = "vorp.staff.LightningStrikePlayer" },
        { group = { "admin" }, command = "vorp.staff.TPToHeaven" },
        { group = { "admin" }, command = "vorp.staff.InvisPlayer" },
        { group = { "admin" }, command = "vorp.staff.KillPlayer" },
        { group = { "admin" }, command = "vorp.staff.RagdollPlayer" },
        { group = { "admin" }, command = "vorp.staff.DrainPlayerStam" },
        { group = { "admin" }, command = "vorp.staff.CuffPlayer" },
        { group = { "admin" }, command = "vorp.staff.PlayerTempHigh" },
        { group = { "admin" }, command = "vorp.staff.OpenTrollActions" },
    },
    -----------------------------------------------------
    -- Users scoreboard
    -- only one can be added
    -- choose what info should show to all users
    showUsersInfo       = "showAll", -- showAll --showJob --showGroup -- showID
    UseUsersMenu        = true, --leave false if you dont need users menu
    EnablePlayerlist    = true, -- enable scroeboard
    --------------------------------------------------------
    -- WEBHOOKS/LOGS
    AlertCooldown       = 60, -- cooldown for request staff to request again (seconds)
    webhookColor        = 16711680, --EMBED COLOR RED
    name                = "VORP", --NAME OF EMBED
    logo                = "https://via.placeholder.com/30x30", --HEAD LOGO
    footerLogo          = "https://via.placeholder.com/30x30", --FOOTER LOGO
    Avatar              = "https://via.placeholder.com/30x30", -- AVATAR LOGO
    ReportLogs          = {
        Reports = "", -- for reports
        RequestStaff = "", -- for request staff
        BugReport = "", -- for bug report
        RulesBroken = "", -- for rules broken report
        Cheating = "" -- for cheating report
    },
    BoosterLogs         = {
        NoClip = "",
        InfiniteAmmo = "",
        GoldenCores = "",
        GodMode = "",
        SelfHeal = "",
        SelfRevive = "",
        SelfSpawnHorse = "",
        SelfSpawnWagon = "",
    },
    AdminLogs           = {
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
    TeleportLogs        = {
        Tpm = "",
        Tptocoords = "",
        Tptoplayer = "",
        Bringplayer = "",
    },
    DatabaseLogs        = {
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


