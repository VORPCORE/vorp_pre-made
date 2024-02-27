Log = {}

function Log.Warning(text)
    if not Config.Debug or not Config.DevMode then
        return
    end
    print("^3WARNING: ^7" .. tostring(text) .. "^7")
end

function Log.error(text)
    if not Config.Debug or not Config.DevMode then
        return
    end
    print("^1ERROR: ^7" .. tostring(text) .. "^7")
end

function Log.print(text)
    if not Config.Debug or not Config.DevMode then
        return
    end
    print("^2Inventory: ^7" .. tostring(text))
end
