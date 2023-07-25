GpsApi = {}

function GpsApi:SetGps(x, y, z)
    local pl = GetEntityCoords(PlayerPedId())
    StartGpsMultiRoute(6, true, true)
    AddPointToGpsMultiRoute(pl.x, pl.y, pl.z)
    AddPointToGpsMultiRoute(x, y, z)
    SetGpsMultiRouteRender(true)
end

function GpsApi:RemoveGps()
    ClearGpsMultiRoute()
end