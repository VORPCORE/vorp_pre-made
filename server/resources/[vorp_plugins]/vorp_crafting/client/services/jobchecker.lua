local backoff = 500
local dlq = 0
job = nil

appready = false

function CheckJob(joblist)
    -- job = nil

    if joblist == 0 then
        return true
    end

    if joblist ~= 0 then
        for k, v in pairs(joblist) do
            if v == job then
                return true
            end
        end
    end

    return false
end

Citizen.CreateThread(function()
    while true do
        TriggerServerEvent('vorp:findjob')
        Wait(60000) --waiting five minutes for the next check
    end
end)

RegisterNetEvent("vorp:setjob")
AddEventHandler("vorp:setjob", function(rjob)
    job = rjob
end)

RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", function()
    appready = true
    TriggerServerEvent('vorp:findjob')
end)
