Translation = {}

Translation.Langs = {
    English = {
        Menu = {
            Hire = "Hire",
            Fire = "Fire",
            HirePlayer = "Hire Player",
            FirePlayer = "Fire Player",
            DoctorMenu = "Doctor Menu",
            HireFireMenu = "Hire/Fire Menu",
            OpenDoctorMenu = "Open Doctor Menu",
            Press = "Press",
            SubMenu = "SubMenu",
        },
        Teleport = {
            TeleportTo = "Teleport to",
            TeleportMenu = "Teleport Menu",
            TeleportToDifferentLocations = "Teleport to different locations",
        },
        Duty = {
            GoOnDuty = "Go on duty",
            GoOffDuty = "Go off duty",
            OnDuty = "On Duty",
            OffDuty = "Off Duty",
            YouAreNotOnDuty = "You are not on duty",
            YouAreNowOnDuty = "You are now on duty",
        },
        Jobs = {
            Job = "Job",
            YouAreNotADoctor = "You are not a doctor",
            Nojoblabel = "Job doesn't have a label in config, please add",
        },
        Player = {
            PlayerId = "Player ID",
            Confirm = "Confirm",
            OnlyNumbersAreAllowed = "Only numbers are allowed",
            NoPlayerFound = "Player not found. You can only hire players in session.",
            PlayeAlreadyHired = "Player is already a ",
            NotNear = "Player is not near you to be hired",
            HireedPlayer = "You have been hired as ",
            CantFirenotHired = "Player is not a doctor, you can't fire them",
            FiredPlayer = "You have fired the player",
            BeenFireed = "You have been fired",
            NoPlayerFoundToRevive = "No player close to you to revive",
        },
        Error = {
            OnlyDoctorOpenMenu = "You are not allowed to open this menu",
            PlayerNearbyCantOpenInventory = "There is a player nearby. Cannot open inventory", -- Fixed naming
            AlreadyAlertedDoctors = "You already alerted the doctors. To cancel, use /cancelalert",
            NoDoctorsAvailable = "No doctors available at this moment",
            NotDeadCantAlert = "You are not dead to alert doctors",
            NoAlertToCancel = "You have not alerted the doctors",
            NotOnCall = "You are not on call to cancel an alert",
        },
        Alert = {
            PlayerNeedsHelp = "Player needs help. Look at the map for their location",
            DoctorsAlerted = "Doctors have been alerted",
            AlertCanceled = "You have canceled the alert",
            AlertCanceledByPlayer = "Player has canceled the alert",
            AlertCanceledByDoctor = "Doctor has canceled the alert",
            PlayerDisconnectedAlertCanceled = "Player has disconnected, alert canceled",
            ArrivedAtLocation = "You have arrived at the location",
            playeralert = "player alert"
        }
    },
    -- Add your language here and open a PR to merge other languages to the main repo
}
