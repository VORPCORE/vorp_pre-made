local Core = exports.vorp_core:GetCore()

function CheckJob(joblist)
    local job = Core.Callback.TriggerAwait("vorp_crafting:GetJob")
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

function CheckJobClient(joblist)
    if joblist == 0 then
        return true
    end

    if joblist ~= 0 then
        for k, v in pairs(joblist) do
            if v == LocalPlayer.state.Character.Job then
                return true
            end
        end
    end

    return false
end
