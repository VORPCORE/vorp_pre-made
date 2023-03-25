local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

-- ADMIN MANAGER

RegisterServerEvent('vorp_bossmanager:checkadmin')
AddEventHandler('vorp_bossmanager:checkadmin', function()
    local User = VorpCore.getUser(source)
    local _source = source
    local Character = User.getUsedCharacter
    local targetidentifier = Character.identifier
    local targetcharidentifier = Character.charIdentifier
    local group = Character.group

    TriggerClientEvent('vorp_bossmanager:sendgroup', _source, group)
end)

-- Give a boss license to a player
RegisterServerEvent('vorp_bossmanager:givelicense')
AddEventHandler('vorp_bossmanager:givelicense', function(target, job)
  -- What are the character identifier and charidentifier of the player who will receive the license?
  local Character2 = VorpCore.getUser(target).getUsedCharacter
  local targetidentifier = Character2.identifier
  local targetcharidentifier = Character2.charIdentifier
  local _source = source

  exports.ghmattimysql:execute('SELECT * FROM jobmanager WHERE identifier=@identifier AND charidentifier=@charidentifier', {['identifier'] = targetidentifier, ['charidentifier'] = targetcharidentifier}, function(result)
    if result[1] ~= nil then
      print("player is already a boss " .. targetidentifier)
    else
      exports.ghmattimysql:execute('INSERT INTO jobmanager (identifier, charidentifier, jobname) VALUES (@identifier, @charidentifier, @job)', {['identifier'] = targetidentifier, ['charidentifier'] = targetcharidentifier, ['job'] = job},function (result)
        if result.affectedRows < 1 then
          log("error", "failed to create license for " .. targetidentifier)
        end
      end)
    end

  end)
end) 

-- Revoke license from a player
RegisterServerEvent('vorp_bossmanager:revokelicense')
AddEventHandler('vorp_bossmanager:revokelicense', function (target)
    -- What are the character identifier and charidentifier of the player who will be revoke?
    local Character2 = VorpCore.getUser(target).getUsedCharacter
    local targetidentifier = Character2.identifier
    local targetcharidentifier = Character2.charIdentifier
    local _source = source

  exports.ghmattimysql:execute('DELETE FROM jobmanager WHERE identifier=@identifier AND charidentifier=@charidentifier', { ['identifier'] = targetidentifier, ['charidentifier'] = targetcharidentifier},function (result)
    if result.affectedRows < 1 then
      log("error", "failed to revoke license for " .. targetidentifier)
    end

  end)
end)

-- BOSS MANAGER

-- Check if the player is a boss
RegisterServerEvent('vorp_bossmanager:checkboss')
AddEventHandler('vorp_bossmanager:checkboss', function()
    local User = VorpCore.getUser(source)
    local _source = source
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier

    exports.ghmattimysql:execute('SELECT * FROM jobmanager WHERE identifier=@identifier AND charidentifier=@charidentifier', {['identifier'] = u_identifier, ['charidentifier'] = u_charid}, function(result)
        if result[1] ~= nil then
          jobname = result[1].jobname
          TriggerClientEvent('vorp_bossmanager:open', _source, jobname)
        else
          print("Not a boss")
        end
    
    end)
end)

-- Give a job and a grade to a player
RegisterServerEvent('vorp_bossmanager:givejob')
AddEventHandler('vorp_bossmanager:givejob', function(target, job, jobgrade)
  -- What is the boss job to inherit?
  --local _source = source
  --local Character = VorpCore.getUser(_source).getUsedCharacter
  --local job = Character.job
  -- What are the character identifier and charidentifier of the player who will receive the job?
  local Character2 = VorpCore.getUser(target).getUsedCharacter
  local targetidentifier = Character2.identifier
  local targetcharidentifier = Character2.charIdentifier

  local jobgrade = tonumber(jobgrade)

  exports.ghmattimysql:execute('UPDATE characters SET job=@updjob, jobgrade=@updjobgrade  WHERE identifier=@identifier AND charidentifier=@charidentifier', {['updjob'] = job, ['updjobgrade'] = jobgrade, ['identifier'] = targetidentifier, ['charidentifier'] = targetcharidentifier},function (result)
    if result.affectedRows < 1 then
      log("error", "failed to update job for " .. targetidentifier)
    end

  end)
end)  

-- Revoke job and grade from a player
RegisterServerEvent('vorp_bossmanager:revokejob')
AddEventHandler('vorp_bossmanager:revokejob', function (targetidentifier, targetcharidentifier)
  -- What are the character identifier and charidentifier?
  --local Character2 = VorpCore.getUser(target).getUsedCharacter
  --local targetidentifier = Character2.identifier
  --local targetcharidentifier = Character2.charIdentifier

  exports.ghmattimysql:execute('UPDATE characters SET job=@updjob, jobgrade=@updjobgrade  WHERE identifier=@identifier AND charidentifier=@charidentifier', { ['updjob'] = 'none', ['updjobgrade'] = 0, ['identifier'] = targetidentifier, ['charidentifier'] = targetcharidentifier},function (result)
    if result.affectedRows < 1 then
      log("error", "failed to revoke job for " .. targetidentifier)
    end

  end)
end)

RegisterServerEvent('vorp_bossmanager:findemployeename')
AddEventHandler('vorp_bossmanager:findemployeename', function (target)
  -- What are the character identifier and charidentifier?
  local _source = source
  local Character2 = VorpCore.getUser(target).getUsedCharacter
  local firstName = Character2.firstname
  local lastName = Character2.lastname

  print("ClosestPlayerName" .. firstName .. " " .. tostring(lastName))

  TriggerClientEvent('vorp_bossmanager:sendemployeename', _source, firstName .. " " .. lastName)

end)

RegisterServerEvent('vorp_bossmanager:bossemployeelist')
AddEventHandler('vorp_bossmanager:bossemployeelist', function(bossjobname)
  local _source = source

  exports.ghmattimysql:execute('SELECT firstname, lastname, identifier, charidentifier, jobgrade FROM characters WHERE job=@job ORDER BY firstname ASC, lastname ASC', {['job'] = bossjobname}, function(result)
        if result[1] ~= nil then
          TriggerClientEvent('vorp_bossmanager:sendemployeelist', _source, result)
        else
          print("no employee found")
        end
    
    end)
end)