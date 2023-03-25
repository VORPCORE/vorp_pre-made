Translation = Translations[Config.Locale]

PlayerStatus = {}
local loaded = false
local metabolismActive = false

local waistTypes = {
    -2045421226, -- Skinny
    -1745814259,
    -325933489,
    -1065791927,
    -844699484,
    -1273449080,
    927185840,
    149872391,
    399015098,
    -644349862,
    1745919061, -- Normal
    1004225511,
    1278600348,
    502499352,
    -2093198664,
    -1837436619,
    1736416063,
    2040610690,
    -1173634986,
    -867801909,
    1960266524, -- Fat
}

-- [ EVENTS ] --
RegisterNetEvent('vorpmetabolism:StartFunctions', function(status)
    if (#status < 2) then
        return
    end

    PlayerStatus = json.decode(status)

    if (PlayerStatus["Thirst"] and PlayerStatus["Hunger"]) then
        Wait(1000)

        NUIEvents.UpdateHUD()

        StartMetabolismThread()
        StartMetabolismUpdatersThread()
        StartMetabolismSaveDBThread()
        StartRadarControlHudThread()
        StartMetabolismSetThread()
    end
    loaded = true
end)

RegisterNetEvent('vorp:PlayerForceRespawn', function(status)
    PlayerStatus["Thirst"] = Config["OnRespawnThirstStatus"];
    PlayerStatus["Hunger"] = Config["OnRespawnHungerStatus"];
    NUIEvents.UpdateHUD();
end)

RegisterNetEvent('vorp:SelectedCharacter', function(charId)
    TriggerServerEvent("vorpmetabolism:GetStatus")
end)

-- [ THREADS ] --
function StartMetabolismThread()
    CreateThread(function()
        while (true) do
            if (not loaded) then return end

            Wait(3000);

            if (PlayerStatus["Thirst"] <= 0 and not IsPlayerDead(PlayerId())) then
                local newHealth = GetEntityHealth(PlayerPedId()) - 20;
                if (newHealth < 1) then
                    ApplyDamageToPed(PlayerPedId(), 500000, false, true, true);
                end
                SetEntityHealth(PlayerPedId(), newHealth, 0);
            end
            if (PlayerStatus["Hunger"] <= 0 and not IsPlayerDead(PlayerId())) then
                local newHealth = GetEntityHealth(PlayerPedId()) - 20;
                if (newHealth < 1) then
                    ApplyDamageToPed(PlayerPedId(), 500000, false, true, true);
                end
                SetEntityHealth(PlayerPedId(), newHealth, 0);
            end

            NUIEvents.UpdateHUD()
        end
    end)
end

function StartMetabolismUpdatersThread()
    CreateThread(function()
        while true do
            if (not loaded) then return end

            Wait(Config["EveryTimeStatusDown"])

            if (PlayerStatus["Thirst"] > 0 and PlayerStatus["Hunger"] > 0 and not IsPlayerDead(PlayerId())) then
                if (IsPedRunning(PlayerPedId())) then
                    PlayerStatus["Thirst"] = PlayerStatus["Thirst"] - Config["HowAmountThirstWhileRunning"];
                    PlayerStatus["Hunger"] = PlayerStatus["Hunger"] - Config["HowAmountHungerWhileRunning"];
                else
                    PlayerStatus["Thirst"] = PlayerStatus["Thirst"] - Config["HowAmountThirst"];
                    PlayerStatus["Hunger"] = PlayerStatus["Hunger"] - Config["HowAmountHunger"];
                end

                if (PlayerStatus["Thirst"] < 0) then
                    PlayerStatus["Thirst"] = 0;
                end
                if (PlayerStatus["Thirst"] < 0) then
                    PlayerStatus["Hunger"] = 0;
                end
            end

            if (PlayerStatus["Metabolism"] < 10000 and PlayerStatus["Metabolism"] > -10000) then
                if (IsPedRunning(PlayerPedId())) then
                    PlayerStatus["Metabolism"] = PlayerStatus["Metabolism"] - Config["HowAmountMetabolismWhileRunning"];
                else
                    PlayerStatus["Metabolism"] = PlayerStatus["Metabolism"] - Config["HowAmountMetabolism"];
                end
            end
        end
    end)
end

function StartMetabolismSaveDBThread()
    CreateThread(function()
        while true do
            if (not loaded) then return end
            Wait(60000)
            TriggerServerEvent("vorpmetabolism:SaveLastStatus", json.encode(PlayerStatus))
        end
    end)
end

function StartRadarControlHudThread()
    CreateThread(function()
        while true do
            if (not loaded) then return end
            Wait(1000)
            if ((IsRadarHidden()) or (IsPauseMenuActive()) or (not ApiCalls.APIShowOn) or (NetworkIsInSpectatorMode()) or (IsHudHidden())) then
                NUIEvents.ShowHUD(false);
            else
                NUIEvents.ShowHUD(true);
            end
        end
    end)
end

function StartMetabolismSetThread()
    CreateThread(function()
        if (not loaded or not metabolismActive) then return; end

        Wait(10000);
        local pPedID = PlayerPedId();
        local metabolism = PlayerStatus["Metabolism"] / 1000

        if (metabolism == 10) then
            EquipMetaPedOutfit(pPedID, waistTypes[20]);
            SaveNewMetabolism(waistTypes[20]);
        elseif (metabolism == 9) then
            EquipMetaPedOutfit(pPedID, waistTypes[19]);
            SaveNewMetabolism(waistTypes[19]);
        elseif (metabolism == 8) then
            EquipMetaPedOutfit(pPedID, waistTypes[18]);
            SaveNewMetabolism(waistTypes[18]);
        elseif (metabolism == 7) then
            EquipMetaPedOutfit(pPedID, waistTypes[17]);
            SaveNewMetabolism(waistTypes[17]);
        elseif (metabolism == 6) then
            EquipMetaPedOutfit(pPedID, waistTypes[16]);
            SaveNewMetabolism(waistTypes[16]);
        elseif (metabolism == 5) then
            EquipMetaPedOutfit(pPedID, waistTypes[15]);
            SaveNewMetabolism(waistTypes[15]);
        elseif (metabolism == 4) then
            EquipMetaPedOutfit(pPedID, waistTypes[14]);
            SaveNewMetabolism(waistTypes[14]);
        elseif (metabolism == 3) then
            EquipMetaPedOutfit(pPedID, waistTypes[13]);
            SaveNewMetabolism(waistTypes[13]);
        elseif (metabolism == 2) then
            EquipMetaPedOutfit(pPedID, waistTypes[12]);
            SaveNewMetabolism(waistTypes[12]);
        elseif (metabolism == 1) then
            EquipMetaPedOutfit(pPedID, waistTypes[11]);
            SaveNewMetabolism(waistTypes[11]);
        elseif (metabolism == 0) then
            EquipMetaPedOutfit(pPedID, waistTypes[10]);
            SaveNewMetabolism(waistTypes[10]);
        elseif (metabolism == -1) then
            EquipMetaPedOutfit(pPedID, waistTypes[9]);
            SaveNewMetabolism(waistTypes[9]);
        elseif (metabolism == -2) then
            EquipMetaPedOutfit(pPedID, waistTypes[8]);
            SaveNewMetabolism(waistTypes[8]);
        elseif (metabolism == -3) then
            EquipMetaPedOutfit(pPedID, waistTypes[7]);
            SaveNewMetabolism(waistTypes[7]);
        elseif (metabolism == -4) then
            EquipMetaPedOutfit(pPedID, waistTypes[6]);
            SaveNewMetabolism(waistTypes[6]);
        elseif (metabolism == -5) then
            EquipMetaPedOutfit(pPedID, waistTypes[5]);
            SaveNewMetabolism(waistTypes[5]);
        elseif (metabolism == -6) then
            EquipMetaPedOutfit(pPedID, waistTypes[4]);
            SaveNewMetabolism(waistTypes[4]);
        elseif (metabolism == -7) then
            EquipMetaPedOutfit(pPedID, waistTypes[3]);
            SaveNewMetabolism(waistTypes[3]);
        elseif (metabolism == -8) then
            EquipMetaPedOutfit(pPedID, waistTypes[2]);
            SaveNewMetabolism(waistTypes[2]);
        elseif (metabolism == -9) then
            EquipMetaPedOutfit(pPedID, waistTypes[1]);
            SaveNewMetabolism(waistTypes[1]);
        elseif (metabolism == -10) then
            EquipMetaPedOutfit(pPedID, waistTypes[0]);
            SaveNewMetabolism(waistTypes[0]);
        end

        UpdatePedVariation(pPedID, 0, 1, 1, 1, false);
        Wait(300000);
    end)
end