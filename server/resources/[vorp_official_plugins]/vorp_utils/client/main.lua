AddEventHandler('getUtils', function(cb)
    local UtilAPI = {}

    UtilAPI.General = GeneralAPI
    UtilAPI.Prompts = PromptsAPI
    UtilAPI.Blips = BlipAPI
    UtilAPI.Peds = PedAPI
    UtilAPI.DataView = DataView
    UtilAPI.Print = PrintAPI
    UtilAPI.Objects = ObjectAPI
    UtilAPI.Events = EventsAPI
    UtilAPI.Destruct = DestructionAPI
    UtilAPI.Render = RenderAPI

    cb(UtilAPI)
end)
