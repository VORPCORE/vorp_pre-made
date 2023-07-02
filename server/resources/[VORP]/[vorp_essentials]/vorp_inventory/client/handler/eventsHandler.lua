-- this isnt being used anywhere
--[[
function RegisterEvent(EventName, cb)
    RegisterNetEvent(EventName)
    AddEventHandler(EventName, function(...)
        cb(...)
    end)
end
 ]]
