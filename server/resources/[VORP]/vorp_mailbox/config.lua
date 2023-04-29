Config = {}

Config.locale = "en"
Config.keyToOpen = "U"
Config.keyToOpenBroadcast = "G"
Config.locations = {
    { x = -179.0, y = 626.0, z = 113.0 }
}
Config.TimeBetweenUsersRefresh = -1 -- time spent before server fetch all users from database another time. In Seconds. If value is negative or 0, users are only fetched once at server start and never again
Config.DelayBetweenTwoMessage = 600 -- time spent before user is allowed to send a message another time. In Seconds. If value is negative or 0, no delay is set
Config.DelayBetweenTwoBroadcast = 600 -- time spent before user is allowed to send a broadcast another time. In Seconds. If value is negative or 0, no delay is set
Config.MessageSendPrice = 10 --telegram price
Config.MessageBroadcastPrice = 3 -- how much should players pay to brodcast a message to everyone 


Keys = {
    ["G"] = 0x760A9C6F,
    ["Q"] = 0xDE794E3E,
    ["U"] = 0xD8F73058,


}
