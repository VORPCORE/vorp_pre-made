GpsApi = {}

---@param x number
---@param y number
---@param z number
---@param color string|number color of gps route
function GpsApi:SetGps(x, y, z, color)
    local player = PlayerPedId()
    local pl = GetEntityCoords(player)

    if color and type(color) == "string" then
       color = joaat(color)
    end

    StartGpsMultiRoute(color or joaat("COLOR_RED"), true, true)
    AddPointToGpsMultiRoute(pl.x, pl.y, pl.z)
    AddPointToGpsMultiRoute(x, y, z)
    SetGpsMultiRouteRender(true)
end

function GpsApi:RemoveGps()
    ClearGpsMultiRoute()
end
