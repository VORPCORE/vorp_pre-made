RenderAPI = {}

function RenderAPI:WorldToScreen(pos)
    local on_screen, x, y = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
    return vector2(x,y), on_screen
end

function RenderAPI:WorldToHud(pos)
    local _, x, y = GetHudScreenPositionFromWorldPosition(pos.x, pos.y, pos.z)
    return vector2(x,y)
end

function RenderAPI:DrawSprite(pos, size, rotation, color, textureDict, textureName)
    if not HasStreamedTextureDictLoaded(textureDict) then
        RequestStreamedTextureDict(textureDict, false);
    else
        DrawSprite(textureDict, textureName, pos.x, pos.y, tofloat(size.x), tofloat(size.y), tofloat(rotation), color.r, color.g, color.b, color.a)
    end
end

function RenderAPI:DrawRectangle(pos, size, color)
    DrawRect(pos.x, pos.y, size.x, size.y, color.r, color.g, color.b, color.a, true, true)
end


function RenderAPI:DrawMarker(type, pos, dir, rot, scale, color, bobeffect, facecamera, rotate, drawonents)
    return Citizen.InvokeNative(0x2A32FAA57B937173, type, pos.x, pos.y, pos.z, dir.x, dir.y, dir.z, rot.x, rot.y, rot.z, scale.x, scale.y, scale.z, color.r, color.g, color.b, color.a, bobeffect, facecamera, 2, rotate, drawonents)
end

function RenderAPI:DrawText(pos, text, color, scale, enableShadow)
    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", tostring(text), Citizen.ResultAsLong())
    SetTextScale(scale, scale)
    SetTextColor(math.floor(color.r), math.floor(color.g), math.floor(color.b), math.floor(color.a))
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    DisplayText(str, pos.x, pos.y)
    return str
end