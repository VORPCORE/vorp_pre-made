local PastHSN = {} --Track net hashs

Validator = {}
Validator.IsValidNuiCallback = function(hsn)
    local valid = false

    local isb64 = exports['vorp_inventory']:checkRegex('^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}|[A-Za-z0-9+/]{2}={2})$', hsn)
    if PastHSN[hsn] == nil and isb64 then
        valid = true
        PastHSN[hsn] = true
    else
        TriggerServerEvent("vorpinventory:netduplog")
    end

    return valid
end