-- funtions


function SET_PED_RELATIONSHIP_GROUP_HASH(iVar0, iParam0)
    return Citizen.InvokeNative(0xC80A74AC829DDD92, iVar0, _GET_DEFAULT_RELATIONSHIP_GROUP_HASH(iParam0))
end

function _GET_DEFAULT_RELATIONSHIP_GROUP_HASH(iParam0)
    return Citizen.InvokeNative(0x3CC4A718C258BDD0, iParam0);
end

function Modelrequest(model)
    Citizen.CreateThread(function()
        RequestModel(model)
    end)
end
