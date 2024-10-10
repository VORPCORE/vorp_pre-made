function NUIService.OpenClanInventory(clanName, clanId, capacity)
    ApplyPosfx()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "display",
        type = "clan",
        title = "" .. clanName .. "",
        clanid = clanId,
        capacity = capacity,
        search = Config.InventorySearchable
    })
    InInventory = true
end

function NUIService.NUIMoveToClan(obj)
    TriggerServerEvent("syn_clan:MoveToClan", json.encode(obj))
end

function NUIService.NUITakeFromClan(obj)
    if not SynPending then
        SynPending = true
        TriggerServerEvent("syn_clan:TakeFromClan", json.encode(obj))
    end
end

function NUIService.OpenContainerInventory(ContainerName, Containerid, capacity)
    ApplyPosfx()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "display",
        type = "Container",
        title = "" .. ContainerName .. "",
        Containerid = Containerid,
        capacity = capacity,
        search = Config.InventorySearchable
    })
    InInventory = true
end

function NUIService.NUIMoveToContainer(obj)
    TriggerServerEvent("syn_Container:MoveToContainer", json.encode(obj))
end

function NUIService.NUITakeFromContainer(obj)
    if not SynPending then
        SynPending = true

        TriggerServerEvent("syn_Container:TakeFromContainer", json.encode(obj))
    end
end

function NUIService.OpenHorseInventory(horseTitle, horseId, capacity)
    ApplyPosfx()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "display",
        type = "horse",
        title = horseTitle,
        horseid = horseId,
        capacity = capacity,
        search = Config.InventorySearchable
    })
    InInventory = true
    TriggerEvent("vorp_stables:setClosedInv", true)
end

function NUIService.NUIMoveToHorse(obj)
    TriggerServerEvent("vorp_stables:MoveToHorse", json.encode(obj))
end

function NUIService.NUITakeFromHorse(obj)
    if not SynPending then
        SynPending = true

        TriggerServerEvent("vorp_stables:TakeFromHorse", json.encode(obj))
    end
end

function NUIService.NUIMoveToStore(obj)
    TriggerServerEvent("syn_store:MoveToStore", json.encode(obj))
end

function NUIService.NUITakeFromStore(obj)
    if not SynPending then
        SynPending = true

        TriggerServerEvent("syn_store:TakeFromStore", json.encode(obj))
    end
end

function NUIService.OpenStoreInventory(StoreName, StoreId, capacity, geninfox)
    StoreSynMenu = true
    GenSynInfo   = geninfox
    ApplyPosfx()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "display",
        type = "store",
        title = StoreName,
        StoreId = StoreId,
        capacity = capacity,
        geninfo = GenSynInfo,
        search = Config.InventorySearchable
    })
    InInventory = true
    TriggerEvent("syn_store:setClosedInv", true)
end

function NUIService.OpenstealInventory(stealName, stealId, capacity)
    ApplyPosfx()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "display",
        type = "steal",
        title = stealName,
        stealId = stealId,
        capacity = capacity,
        search = Config.InventorySearchable
    })
    InInventory = true
    TriggerEvent("vorp_stables:setClosedInv", true)
end

function NUIService.NUIMoveTosteal(obj)
    TriggerServerEvent("syn_search:MoveTosteal", json.encode(obj))
end

function NUIService.NUITakeFromsteal(obj)
    if not SynPending then
        SynPending = true

        TriggerServerEvent("syn_search:TakeFromsteal", json.encode(obj))
    end
end

function NUIService.OpenCartInventory(cartName, wagonId, capacity)
    ApplyPosfx()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "display",
        type = "cart",
        title = cartName,
        wagonid = wagonId,
        capacity = capacity,
        search = Config.InventorySearchable
    })
    InInventory = true

    TriggerEvent("vorp_stables:setClosedInv", true)
end

function NUIService.NUIMoveToCart(obj)
    TriggerServerEvent("vorp_stables:MoveToCart", json.encode(obj))
end

function NUIService.NUITakeFromCart(obj)
    if not SynPending then
        SynPending = true

        TriggerServerEvent("vorp_stables:TakeFromCart", json.encode(obj))
    end
end

function NUIService.OpenHouseInventory(houseName, houseId, capacity)
    ApplyPosfx()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "display",
        type = "house",
        title = houseName,
        houseId = houseId,
        capacity = capacity,
        search = Config.InventorySearchable
    })
    InInventory = true
end

function NUIService.NUIMoveToHouse(obj)
    TriggerServerEvent("vorp_housing:MoveToHouse", json.encode(obj))
end

function NUIService.NUITakeFromHouse(obj)
    if not SynPending then
        SynPending = true

        TriggerServerEvent("vorp_housing:TakeFromHouse", json.encode(obj))
    end
end

function NUIService.OpenHideoutInventory(hideoutName, hideoutId, capacity)
    ApplyPosfx()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "display",
        type = "hideout",
        title = hideoutName,
        hideoutId = hideoutId,
        capacity = capacity,
        search = Config.InventorySearchable
    })
    InInventory = true
end

function NUIService.NUIMoveToHideout(obj)
    TriggerServerEvent("syn_underground:MoveToHideout", json.encode(obj))
end

function NUIService.NUITakeFromHideout(obj)
    if not SynPending then
        SynPending = true

        TriggerServerEvent("syn_underground:TakeFromHideout", json.encode(obj))
    end
end

function NUIService.OpenBankInventory(bankName, bankId, capacity)
    ApplyPosfx()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "display",
        type = "bank",
        title = bankName,
        bankId = bankId,
        capacity = capacity,
        search = Config.InventorySearchable
    })
    InInventory = true
end

function NUIService.NUIMoveToBank(obj)
    TriggerServerEvent("vorp_bank:MoveToBank", json.encode(obj))
end

function NUIService.NUITakeFromBank(obj)
    if not SynPending then
        SynPending = true

        TriggerServerEvent("vorp_bank:TakeFromBank", json.encode(obj))
    end
end
