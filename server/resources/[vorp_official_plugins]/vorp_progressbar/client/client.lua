-- Queue all progress tasks to prevent infinite loops and overlap
local queue = {}

exports('initiate',function()
    local self = {}
    
    self.start = function (message, miliseconds, cb, theme, color, width)
        if theme == nil then
            theme = "linear"
        end
    
        if color == nil then
            color = 'rgb(124, 45, 45)'
        end
        
        if width == nil then
            width = '20vw'
        end
    
        table.insert(queue, {
            message = message,
            callback = cb
        })
    
        SetNuiFocus(true, false)
        SendNUIMessage({
            type = 'vp-open',
            message = message,
            mili = miliseconds,
            theme = theme,
            color = color,
            width = width
        })
    end

    return self
end)

RegisterNUICallback('ProgressFinished', function(args, nuicb)
    SetNuiFocus(false, false)

    if queue[1].callback then
        queue[1].callback() 
    end

    table.remove(queue, 1) -- Remove prog from queue 
    
    nuicb('ok')
end)