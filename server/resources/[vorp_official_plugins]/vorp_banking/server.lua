local VorpCore = {}
TriggerEvent("getCore", function(core)
  VorpCore = core
end)

local VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local invspace = 10

RegisterServerEvent('vorp_bank:getinfo')
AddEventHandler('vorp_bank:getinfo', function(name)

  local _source = source
  local Character = VorpCore.getUser(_source).getUsedCharacter
  local charidentifier = Character.charIdentifier
  local identifier = Character.identifier

  exports["ghmattimysql"]:execute("SELECT money, gold, invspace FROM bank_users WHERE charidentifier = @charidentifier AND name = @name"
    , { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
    local money = 0
    local gold = 0
    invspace = 0
    if result[1] then
      money = result[1].money
      gold = result[1].gold
      invspace = result[1].invspace
    else
      local Parameters = { ['name'] = name, ['identifier'] = identifier, ['charidentifier'] = charidentifier,
        ['money'] = money, ['gold'] = gold, ['invspace'] = invspace }
      exports.ghmattimysql:execute("INSERT INTO bank_users ( `name`,`identifier`,`charidentifier`,`money`,`gold`,`invspace`) VALUES ( @name, @identifier, @charidentifier, @money, @gold, @invspace)"
        , Parameters)
    end

    local bankinfo = { money = money, gold = gold, invspace = invspace, name = name }

    TriggerClientEvent("vorp_bank:recinfo", _source, bankinfo)
  end)
end)

RegisterServerEvent('vorp_bank:UpgradeSafeBox')
AddEventHandler('vorp_bank:UpgradeSafeBox', function(costlot, maxslots, amount, name, invspac)
  local _source = source
  local Character = VorpCore.getUser(_source).getUsedCharacter
  local charidentifier = Character.charIdentifier
  local money = Character.money 
  local amountToPay = costlot * amount
  local nextslot = invspac + amount
  if money >= amountToPay then
    if nextslot <= maxslots then
      Character.removeCurrency(0, amountToPay)
      exports["ghmattimysql"]:execute("SELECT invspace FROM bank_users WHERE charidentifier = @charidentifier AND name = @name"
        , { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
        local Parameters = { ['charidentifier'] = charidentifier, ['invspace'] = amount, ['name'] = name }
        exports.ghmattimysql:execute("UPDATE bank_users Set invspace=invspace+@invspace WHERE charidentifier=@charidentifier AND name = @name"
          , Parameters)
      end)
      TriggerClientEvent("vorp:TipRight", _source,
        Config.language.success .. (costlot * amount) .. " | " .. nextslot .. " / " .. maxslots, 10000)
    else
      TriggerClientEvent("vorp:TipRight", _source,
        Config.language.maxslots .. " | " .. invspac .. " / " .. maxslots, 10000)
    end
  else
    TriggerClientEvent("vorp:TipRight", _source, Config.language.nomoney, 10000)
  end
end)

RegisterServerEvent('vorp_bank:depositcash')
AddEventHandler('vorp_bank:depositcash', function(amount, name, bankinfo)
  local _source = source
  local Character = VorpCore.getUser(_source).getUsedCharacter
  local charidentifier = Character.charIdentifier
  local money = Character.money
  if money >= amount then
    Character.removeCurrency(0, amount)
    local Parameters = { ['charidentifier'] = charidentifier, ['money'] = amount, ['name'] = name }
    exports.ghmattimysql:execute("UPDATE bank_users Set money=money+@money WHERE charidentifier=@charidentifier AND name = @name"
      , Parameters)
    TriggerClientEvent("vorp:TipRight", _source, Config.language.youdepo .. amount, 10000)

    local bankinfo = {
      money = bankinfo.money + amount,
      gold = bankinfo.gold,
      invspace = bankinfo.invspace,
      name = bankinfo.name
    }
    TriggerClientEvent("vorp_bank:ReloadBankMenu", _source, bankinfo)

    Discord(Config.language.depoc, GetPlayerName(_source), amount, name)
  else
    TriggerClientEvent("vorp:TipRight", _source, Config.language.invalid, 10000)
  end
  --TriggerClientEvent("vorp_bank:ready", _source)
end)

RegisterServerEvent('vorp_bank:depositgold')
AddEventHandler('vorp_bank:depositgold', function(amount, name, bankinfo)
  local _source = source
  local Character = VorpCore.getUser(_source).getUsedCharacter
  local charidentifier = Character.charIdentifier
  local money = Character.gold
  if money >= amount then
    Character.removeCurrency(1, amount)
    local Parameters = { ['charidentifier'] = charidentifier, ['gold'] = amount, ['name'] = name }
    exports.ghmattimysql:execute("UPDATE bank_users Set gold=gold+@gold WHERE charidentifier=@charidentifier AND name = @name"
      , Parameters)
    TriggerClientEvent("vorp:TipRight", _source, Config.language.youdepog .. amount, 10000)

    local bankinfo = {
      money = bankinfo.money,
      gold = bankinfo.gold + amount,
      invspace = bankinfo.invspace,
      name = bankinfo.name
    }
    TriggerClientEvent("vorp_bank:ReloadBankMenu", _source, bankinfo)

    Discord(Config.language.depog, GetPlayerName(_source), amount, name)
  else
    TriggerClientEvent("vorp:TipRight", _source, Config.language.invalid, 10000)
  end
  --TriggerClientEvent("vorp_bank:ready", _source)
end)

RegisterServerEvent('vorp_bank:withcash')
AddEventHandler('vorp_bank:withcash', function(amount, name, bankinfo)
  local _source = source
  local Character = VorpCore.getUser(_source).getUsedCharacter
  local charidentifier = Character.charIdentifier
  exports["ghmattimysql"]:execute("SELECT money FROM bank_users WHERE charidentifier = @charidentifier AND name = @name"
    , { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
    local money = result[1].money
    if money >= amount then
      local Parameters = { ['charidentifier'] = charidentifier, ['money'] = amount, ['name'] = name }
      exports.ghmattimysql:execute("UPDATE bank_users Set money=money-@money WHERE charidentifier=@charidentifier AND name = @name"
        , Parameters)
      Character.addCurrency(0, amount)
      TriggerClientEvent("vorp:TipRight", _source, Config.language.withdrew .. amount, 10000)

      local bankinfo = {
        money = bankinfo.money - amount,
        gold = bankinfo.gold,
        invspace = bankinfo.invspace,
        name = bankinfo.name
      }
      TriggerClientEvent("vorp_bank:ReloadBankMenu", _source, bankinfo)

      Discord(Config.language.withc, GetPlayerName(_source), amount, name)
    else
      TriggerClientEvent("vorp:TipRight", _source, Config.language.invalid, 10000)
    end
    --TriggerClientEvent("vorp_bank:ready", _source)
  end)
end)

RegisterServerEvent('vorp_bank:withgold')
AddEventHandler('vorp_bank:withgold', function(amount, name, bankinfo)
  local _source = source
  local Character = VorpCore.getUser(_source).getUsedCharacter
  local charidentifier = Character.charIdentifier
  exports["ghmattimysql"]:execute("SELECT gold FROM bank_users WHERE charidentifier = @charidentifier AND name = @name",
    { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
    local gold = result[1].gold
    if gold >= amount then
      local Parameters = { ['charidentifier'] = charidentifier, ['gold'] = amount, ['name'] = name }
      exports.ghmattimysql:execute("UPDATE bank_users Set gold=gold-@gold WHERE charidentifier=@charidentifier AND name = @name"
        , Parameters)
      Character.addCurrency(1, amount)
      TriggerClientEvent("vorp:TipRight", _source, Config.language.withdrewg .. amount, 10000)

      local bankinfo = {
        money = bankinfo.money,
        gold = bankinfo.gold - amount,
        invspace = bankinfo.invspace,
        name = bankinfo.name
      }
      TriggerClientEvent("vorp_bank:ReloadBankMenu", _source, bankinfo)

      Discord(Config.language.withg, GetPlayerName(_source), amount, name)
    else
      TriggerClientEvent("vorp:TipRight", _source, Config.language.invalid, 10000)
    end
    --TriggerClientEvent("vorp_bank:ready", _source)
  end)
end)

RegisterServerEvent("vorp_bank:find")
AddEventHandler("vorp_bank:find", function(name)
  local _source = source
  exports.ghmattimysql:execute('SELECT * FROM bank_users', {}, function(result)
    local banklocations = {}
    if result[1] then
      for i = 1, #result, 1 do
        banklocations[#banklocations + 1] = {
          id             = result[i].id,
          name           = result[i].name,
          identifier     = result[i].identifier,
          charidentifier = result[i].charidentifier,
          money          = result[i].money,
          gold           = result[i].gold,
          invspace       = result[i].invspace,
        }
      end
      TriggerClientEvent("vorp_bank:findbank", _source, banklocations)
    end
  end)
end)

local processinguser = {}

function inprocessing(id)
  for k, v in pairs(processinguser) do
    if v == id then
      return true
    end
  end
  return false
end

function trem(id)
  for k, v in pairs(processinguser) do
    if v == id then
      table.remove(processinguser, k)
    end
  end
end

function AnIndexOf(t, val)
  for k, v in ipairs(t) do
    if v == val then return k end
  end
end

function ToInteger(number)
  _source = source
  number = tonumber(number)
  if number then
    if 0 > number then
      number = number * -1
    elseif number == 0 then
      return nil
    end
    return math.floor(number or error("Could not cast '" .. tostring(number) .. "' to number.'"))
  else
    return nil
  end
end

RegisterNetEvent("vorp_bank:ReloadBankInventory") -- inventory system
AddEventHandler("vorp_bank:ReloadBankInventory", function(bankid)
  local _source = source
  local name = bankid
  local Character = VorpCore.getUser(_source).getUsedCharacter
  local charidentifier = Character.charIdentifier
  exports["ghmattimysql"]:execute("SELECT items, id FROM bank_users WHERE charidentifier = @charidentifier AND name = @name "
    , { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
    if result[1].items then
      local items = {}
      local inv = json.decode(result[1].items)
      if not inv then
        items.itemList = {}
        items.action = "setSecondInventoryItems"
        TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
      else
        items.itemList = inv
        items.action = "setSecondInventoryItems"
        TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
      end
    end
  end)
end)

RegisterServerEvent("vorp_bank:TakeFromBank") -- inventory system
AddEventHandler("vorp_bank:TakeFromBank", function(jsonData)
  local _source = source
  if not inprocessing(_source) then
    processinguser[#processinguser + 1] = _source
    local notpass = false
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local data = json.decode(jsonData)
    local name = data["bank"]
    local item = data.item
    local itemCount = ToInteger(data["number"])
    local itemType = data.type
    if itemCount and itemCount ~= 0 then
      if item.count < itemCount then
        TriggerClientEvent("vorp:TipRight", _source, Config.language.invalid, 5000)
        return trem(_source)
      end
    else
      TriggerClientEvent("vorp:TipRight", _source, Config.language.invalid, 5000)
      return trem(_source)
    end
    if itemType == "item_weapon" then
      TriggerEvent("vorpCore:canCarryWeapons", tonumber(_source), itemCount, function(canCarry)
        if canCarry then
          exports["ghmattimysql"]:execute("SELECT items FROM bank_users WHERE charidentifier = @charidentifier AND name = @name"
            , { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
            notpass = true
            if result[1] then
              local items = {}
              local inv = json.decode(result[1].items)
              local foundItem, foundIndex = nil, nil
              for k, v in pairs(inv) do
                if v.name == item.name then
                  foundItem = v
                  if #foundItem > 1 then
                    if k == 1 then
                      foundItem = v
                    end
                  end
                end
              end
              if foundItem then
                local foundIndex2 = AnIndexOf(inv, foundItem)
                foundItem.count = foundItem.count - itemCount
                if 0 >= foundItem.count then
                  table.remove(inv, foundIndex2)
                end
                items.itemList = inv
                items.action = "setSecondInventoryItems"
                local weapId = foundItem.id
                VorpInv.giveWeapon(_source, weapId, 0)
                TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                exports["ghmattimysql"]:execute("UPDATE bank_users SET items = @inv WHERE charidentifier = @charidentifier AND name = @name"
                  , { ["@inv"] = json.encode(inv), ["@charidentifier"] = charidentifier, ["@name"] = name })

              end
            end
            notpass = false
          end)
          while notpass do
            Wait(500)
          end
        else
          TriggerClientEvent("vorp:TipRight", _source, Config.language.limit, 5000)
        end
      end)
    else
      if itemCount and itemCount ~= 0 then
        if item.count < itemCount then
          TriggerClientEvent("vorp:TipRight", _source, Config.language.invalid, 5000)
          return trem(_source)
        end
      else
        TriggerClientEvent("vorp:TipRight", _source, Config.language.invalid, 5000)
        return trem(_source)
      end
      local count = VorpInv.getItemCount(_source, item.name)

      if (count + itemCount) > item.limit then
        TriggerClientEvent("vorp:TipRight", _source, Config.language.maxlimit, 5000)
        return trem(_source)
      end
      TriggerEvent("vorpCore:canCarryItems", tonumber(_source), itemCount, function(canCarry)
        TriggerEvent("vorpCore:canCarryItem", tonumber(_source), item.name, itemCount, function(canCarry2)
          if canCarry and canCarry2 then
            exports["ghmattimysql"]:execute("SELECT items FROM bank_users WHERE charidentifier = @charidentifier AND name = @name"
              , { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
              notpass = true
              if result[1] then
                local items = {}
                local inv = json.decode(result[1].items)
                local foundItem, foundIndex = nil, nil
                for k, v in pairs(inv) do
                  if v.name == item.name then
                    foundItem = v
                  end
                end
                if foundItem then
                  local foundIndex2 = AnIndexOf(inv, foundItem)
                  foundItem.count = foundItem.count - itemCount
                  if 0 >= foundItem.count then
                    table.remove(inv, foundIndex2)
                  end

                  items.itemList = inv
                  items.action = "setSecondInventoryItems"

                  VorpInv.addItem(_source, item.name, itemCount)
                  TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                  exports["ghmattimysql"]:execute("UPDATE bank_users SET items = @inv WHERE charidentifier = @charidentifier AND name = @name"
                    , { ["@inv"] = json.encode(inv), ["@charidentifier"] = charidentifier, ["@name"] = name })
                end
              end
              notpass = false
            end)
            while notpass do
              Wait(500)
            end
          else
            TriggerClientEvent("vorp:TipRight", _source, Config.language.limit, 5000)
          end
        end)
      end)
    end
    trem(_source)
  end
end)

function checkLimit(limit, name)
  for k, v in pairs(limit) do
    if k == name then 
      return true 
    end
  end
end

function checkCount(countinv, countdb, limit, nameitem)
  for k, v in pairs(limit) do
    if k == nameitem then 
      if countinv > v or countdb > v then 
        return true 
      end
    end
  end
end

function checkLimite(limit, nameitem)
  for index, countConfig in pairs(limit) do
    if index == nameitem then
      return countConfig
    end
  end
end

function checkDB(inv, itemName, itemType)
  for k, v in pairs(inv) do
    if v.name == itemName then
      if itemType == "item_standard" then 
        return v.count -- da quanti item c erano prima del deposito
      else
        for index, data in pairs(inv) do 
          if v.name == itemName and itemType == "item_weapon" then 
            count = count + 1
            return count
          end
        end
      end
    end
  end
end

RegisterServerEvent("vorp_bank:MoveToBank") -- inventory system
AddEventHandler("vorp_bank:MoveToBank", function(jsonData)
  local _source = source
  if not inprocessing(_source) then
    processinguser[#processinguser + 1] = _source
    local notpass = false
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local data = json.decode(jsonData)
    local bankName = data["bank"]
    local item = data.item
    local itemCount = ToInteger(data["number"])
    local itemType = data["type"]
    local itemDBCount = 1

    for index, bankConfig in pairs(Config.banks) do
      if bankConfig.city == bankName then
        local existItem = checkLimit(bankConfig.itemlist, item.name)
        if (existItem and bankConfig.useitemlimit) or (existItem and bankConfig.usespecificitem) then                        
          exports["ghmattimysql"]:execute("SELECT items FROM bank_users WHERE charidentifier = @charidentifier AND name = @name", { ["@charidentifier"] = charidentifier, ["@name"] = bankName }, function(result)
            if result[1].items ~= "[]" then
              local inv = json.decode(result[1].items) 
              for k, v in pairs(inv) do
                if v.name == item.name then
                  if itemType == "item_standard" then 
                    itemDBCount = v.count + itemCount
                  elseif itemType == "item_weapon" then 
                    itemDBCount = itemDBCount + itemCount
                  end
                end
              end
            else
              itemDBCount = itemCount
            end 
            local checkCount = checkCount(itemCount, itemDBCount, bankConfig.itemlist, item.name)
            if checkCount then
              local limite = checkLimite(bankConfig.itemlist, item.name)
              TriggerClientEvent("vorp:TipRight", _source, Config.language.maxitems .. limite, 5000)
              return trem(_source)
            else
              if itemType ~= "item_weapon" then
                local countin = VorpInv.getItemCount(_source, item.name)
                if itemCount > countin then
                  TriggerClientEvent("vorp:TipRight", _source, Config.language.limit, 5000)
                  return trem(_source)
                end
              end
              if itemType == "item_weapon" then
                itemCount = 1
                item.count = 1
              end
              if itemCount and itemCount ~= 0 then
                if item.count < itemCount then
                  TriggerClientEvent("vorp:TipRight", _source, Config.language.invalid, 5000)
                  return trem(_source)
                end
              else
                TriggerClientEvent("vorp:TipRight", _source, Config.language.invalid, 5000)
                return trem(_source)
              end
              exports["ghmattimysql"]:execute("SELECT items, invspace FROM bank_users WHERE charidentifier = @charidentifier AND name = @name", { ["@charidentifier"] = charidentifier, ["@name"] = bankName }, function(result)
                notpass = true
                if result[1].items then
                  local space = result[1].invspace
                  local items = {}
                  local countDB = 0
                  local inv = json.decode(result[1].items)
                  local foundItem = nil
                  for _, k in pairs(inv) do
                    if k.name == item.name then
                      if itemType == "item_standard" then
                        foundItem = k
                      end
                    end
                  end
                  for _, k in pairs(inv) do
                    countDB = countDB + k.count
                  end
                  countDB = countDB + itemCount
                  if countDB > space then
                    TriggerClientEvent("vorp:TipRight", _source, Config.language.limit, 5000)
                  else
                    if foundItem then
                      foundItem.count = foundItem.count + itemCount
                    else
                      if itemType == "item_standard" then
                        foundItem = { name = item.name, count = itemCount, label = item.label, type = item.type, limit = item.limit }

                        inv[#inv + 1] = foundItem
                      else
                        foundItem = { name = item.name, count = itemCount, label = item.label, type = item.type, limit = item.limit, id = item.id }

                        inv[#inv + 1] = foundItem
                      end
                    end
                    items.itemList = inv
                    items.action = "setSecondInventoryItems"
                    if itemType == "item_standard" then
                      VorpInv.subItem(_source, item.name, itemCount)
                      TriggerClientEvent("vorp:TipRight", _source, Config.language.depoitem3 .. itemCount .. Config.language.of .. item.label, 5000)
                    end
                    if itemType == "item_weapon" then
                      local weapId = item.id
                      VorpInv.subWeapon(_source, weapId)
                      TriggerClientEvent("vorp:TipRight", _source, Config.language.depoitem3 .. item.label, 5000)
                    end
                    TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                    exports["ghmattimysql"]:execute("UPDATE bank_users SET items = @inv WHERE charidentifier = @charidentifier AND name = @name", { ["@inv"] = json.encode(inv), ["@charidentifier"] = charidentifier, ["@name"] = bankName })
                  end
                end
                notpass = false
              end)
              while notpass do
              Wait(500)
              end
              trem(_source)
            end  
          end)
        elseif (bankConfig.useitemlimit and not bankConfig.usespecificitem) or (not bankConfig.useitemlimit and not bankConfig.usespecificitem) then                                                                                
          if itemType ~= "item_weapon" then
            local countin = VorpInv.getItemCount(_source, item.name)
            if itemCount > countin then
              TriggerClientEvent("vorp:TipRight", _source, Config.language.limit, 5000)
              return trem(_source)
            end
          end
          if itemType == "item_weapon" then
            itemCount = 1
            item.count = 1
          end
          if itemCount and itemCount ~= 0 then
            if item.count < itemCount then
              TriggerClientEvent("vorp:TipRight", _source, Config.language.invalid, 5000)
              return trem(_source)
            end
          else
            TriggerClientEvent("vorp:TipRight", _source, Config.language.invalid, 5000)
            return trem(_source)
          end
          exports["ghmattimysql"]:execute("SELECT items, invspace FROM bank_users WHERE charidentifier = @charidentifier AND name = @name"
            , { ["@charidentifier"] = charidentifier, ["@name"] = bankName }, function(result)
            notpass = true
            if result[1].items then
              local space = result[1].invspace
              local items = {}
              local countDB = 0
              local inv = json.decode(result[1].items)
              local foundItem = nil
              for k, v in pairs(inv) do
                if v.name == item.name then
                  if itemType == "item_standard" then
                    foundItem = v
                  end
                end
              end
              for k, v in pairs(inv) do
                countDB = countDB + v.count
              end
              countDB = countDB + itemCount
              if countDB > space then
                TriggerClientEvent("vorp:TipRight", _source, Config.language.limit, 5000)
              else
                if foundItem then
                  foundItem.count = foundItem.count + itemCount
                else
                  if itemType == "item_standard" then
                    foundItem = { name = item.name, count = itemCount, label = item.label, type = item.type, limit = item.limit }
      
                    inv[#inv + 1] = foundItem
                  else
                    foundItem = { name = item.name, count = itemCount, label = item.label, type = item.type, limit = item.limit,
                      id = item.id }
      
                    inv[#inv + 1] = foundItem
                  end
                end
                items.itemList = inv
                items.action = "setSecondInventoryItems"
                if itemType == "item_standard" then
                  VorpInv.subItem(_source, item.name, itemCount)
                  TriggerClientEvent("vorp:TipRight", _source, Config.language.depoitem3 .. itemCount .. Config.language.of .. item.label, 5000)
                end
                if itemType == "item_weapon" then
                  local weapId = item.id
                  VorpInv.subWeapon(_source, weapId)
                  TriggerClientEvent("vorp:TipRight", _source, Config.language.depoitem3 .. item.label, 5000)
                end
                TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                exports["ghmattimysql"]:execute("UPDATE bank_users SET items = @inv WHERE charidentifier = @charidentifier AND name = @name"
                  , { ["@inv"] = json.encode(inv), ["@charidentifier"] = charidentifier, ["@name"] = bankName })
              end
            end
            notpass = false
          end)
          while notpass do
            Wait(500)
          end
          trem(_source)
        else
          TriggerClientEvent("vorp:TipRight", _source, Config.language.cant, 5000)
          trem(_source)
        end
      end 
    end
  end
end)

function Discord(title, name, description, location)
  local logs = ""
  local webhook = Config.adminwebhook
  local avatar = Config.webhookavatar
  local color = 3447003
  local title = title
  logs = {
    {
      ["color"] = color,
      ["title"] = title,
      ["description"] = description,
      ["footer"] = { ["text"] = location }
    }
  }
  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST',
    json.encode({ ["username"] = name, ["avatar_url"] = avatar, embeds = logs }),
    { ['Content-Type'] = 'application/json' })
end
