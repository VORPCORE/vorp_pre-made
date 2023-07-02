AddEventHandler('getUtils', function(cb)
    local UtilAPI = {}

    UtilAPI.General = GeneralAPI
    UtilAPI.Files = FilesAPI
    UtilAPI.Print = PrintAPI
    UtilAPI.DataView = DataView
    
    cb(UtilAPI)
end)
