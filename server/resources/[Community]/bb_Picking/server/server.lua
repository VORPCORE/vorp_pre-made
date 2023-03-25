Inventory = exports.vorp_inventory:vorp_inventoryApi()
VORP = exports.vorp_core:vorpAPI()
local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

RegisterServerEvent('herb:giveHarvestItems')
AddEventHandler("herb:giveHarvestItems", function(itemName, itemCount)
    local _source = source

    Inventory.addItem(_source, itemName, itemCount)
    TriggerClientEvent("vorp:TipBottom", _source, " You have "..itemCount.." "..itemName.."  collected", 4000)
end)