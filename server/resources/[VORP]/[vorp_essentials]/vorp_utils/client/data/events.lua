EVENTS = {
    [1385704366] = {
        name = "EVENT_NETWORK_PICKUP_RESPAWNED",
        hash = "0x52982BAE",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "pickup entity id" },
        }
    },
    [-818205375] = {
        name = "EVENT_STAT_VALUE_CHANGED",
        hash = "0xCF3B2D41",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [0] = { type = "int", data =
            "stat value type hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/stat_values.lua) )" },
        }
    },
    [1658389497] = {
        name = "EVENT_NETWORK_SESSION_EVENT",
        hash = "0x62D903F9",
        datasize = 10,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "unknown (??? session event type)" },
        }
    },
    [676208328] = {
        name = "EVENT_NETWORK_INCAPACITATED_ENTITY",
        hash = "0x284E1EC8",
        datasize = 4,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "Damager entity id" },
            [2] = { type = "int", data =
            "WeaponUsed hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [3] = { type = "float", data = "Damage" },
            [0] = { type = "int", data = "VictimEntityId" },
        }
    },
    [-745090075] = {
        name = "EVENT_IMPENDING_SAMPLE_PROMPT",
        hash = "0xD396D3E5",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "inventory item hash" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    [347157807] = {
        name = "EVENT_RAN_OVER_PED",
        hash = "0x14B1352F",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "ped id that was ran over" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    [1376140891] = {
        name = "EVENT_LOOT_COMPLETE",
        hash = "0x52063E5B",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "Looted entity id" },
            [2] = { type = "int", data = "isLootSuccess" },
            [0] = { type = "int", data = "looterId" },
        }
    },
    [1741908893] = {
        name = "EVENT_NETWORK_AWARD_CLAIMED",
        hash = "0x67D36B9D",
        datasize = 12,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown (??? result code [list](#award-claimed-result-codes))" },
            [5] = { type = "int", data =
            "unknown (??? award hash [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/awards.lua))" },
            [6] = { type = "int", data = "unknown (??? awarded xp amount)" },
            [7] = { type = "int", data = "unknown (??? awarded rank amount)" },
            [8] = { type = "int", data = "unknown (??? awarded cash amount)" },
            [9] = { type = "int", data = "unknown (??? awarded gold amount)" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "request id" },
        }
    },
    [-843555838] = {
        name = "EVENT_SCENARIO_DESTROY_PROP",
        hash = "0xCDB85C02",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "iScriptUID" },
        }
    },
    [-2091944374] = {
        name = "EVENT_CALCULATE_LOOT",
        hash = "0x834F764A",
        datasize = 26,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "inventory item hash" },
            [3] = { type = "int", data = "consumable action hash" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [23] = { type = "int", data = "looter entity id" },
            [24] = { type = "int", data = "looted entity id" },
            [25] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    [-2020006491] = {
        name = "EVENT_NETWORK_POSSE_EX_ADMIN_DISBANDED",
        hash = "0x879925A5",
        datasize = 9,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    [1559647390] = {
        name = "EVENT_NETWORK_PICKUP_COLLECTION_FAILED",
        hash = "0x5CF6549E",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "player id" },
            [2] = { type = "int", data =
            "pickup type hash  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/objects/pickup_list.lua))" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    --TODO: START FROM HERE: https://github.com/femga/rdr3_discoveries/tree/master/AI/EVENTS
    [867155253] = {
        name = "EVENT_CARRIABLE_VEHICLE_STOW_COMPLETE",
        hash = "0x33AFBD35",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "vehicle entity id" },
            [2] = { type = "int", data = "isItemToAddCancelled" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    [1351025667] = {
        name = "EVENT_CHALLENGE_GOAL_COMPLETE",
        hash = "0x50870403",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data =
            "challenge goal hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/challenge_goals.lua))" }
        }
    },
    [1669410864] = {
        name = "EVENT_CHALLENGE_GOAL_UPDATE",
        hash = "0x63813030",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data =
            "challenge goal hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/challenge_goals.lua))" }
        }
    },
    [-1682387274] = {
        name = "EVENT_PLAYER_MOUNT_WILD_HORSE",
        hash = "0x9BB8CEB6",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "wild horse ped id" }
        }
    },
    [1208357138] = {
        name = "EVENT_CARRIABLE_UPDATE_CARRY_STATE",
        hash = "0x48061112",
        datasize = 5,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "PerpitratorEntityId" },
            [2] = { type = "int", data = "CarrierEntityId" },
            [3] = { type = "int", data = "IsOnHorse" },
            [4] = { type = "int", data = "IsOnGround" },
            [0] = { type = "int", data = "CarriableEntityId" },
        }
    },
    [-346212524] = {
        name = "EVENT_UI_ITEM_INSPECT_ACTIONED",
        hash = "0xEB5D3754",
        datasize = 6,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown (??? FitsSlot hash)" },
            [5] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    [2030961287] = {
        name = "EVENT_PED_HAT_KNOCKED_OFF",
        hash = "0x790E0287",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "hat entity id" },
            [0] = { type = "int", data = "ped id" },
        }
    },
    [-1315570756] = {
        name = "EVENT_NETWORK_DAMAGE_ENTITY",
        hash = "0xB195FBBC",
        datasize = 32,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "killer entity id" },
            [2] = { type = "float", data = "Damage" },
            [3] = { type = "int", data = "isVictimDestroyed" },
            [4] = { type = "int", data = "isVictimIncapacitated" },
            [5] = { type = "int", data =
            "WeaponUsed hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [6] = { type = "int", data =
            "AmmoUsed hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua) )" },
            [7] = { type = "int", data = "InstigatedWeaponUsed" },
            [8] = { type = "float", data = "VictimSpeed" },
            [9] = { type = "float", data = "DamagerSpeed" },
            [10] = { type = "int", data = "IsResponsibleForCollision" },
            [11] = { type = "int", data = "IsHeadShot" },
            [12] = { type = "int", data = "IsWithMeleeWeapon" },
            [13] = { type = "int", data = "IsVictimExecuted" },
            [14] = { type = "int", data = "VictimBledOut" },
            [15] = { type = "int", data = "DamagerWasScopedIn" },
            [16] = { type = "int", data = "DamagerSpecialAbilityActive" },
            [17] = { type = "int", data = "VictimHogtied" },
            [18] = { type = "int", data = "VictimMounted" },
            [19] = { type = "int", data = "VictimInVehicle" },
            [20] = { type = "int", data = "VictimInCover" },
            [21] = { type = "int", data = "DamagerShotLastBullet" },
            [22] = { type = "int", data = "VictimKilledByStealth" },
            [23] = { type = "int", data = "VictimKilledByTakedown" },
            [24] = { type = "int", data = "VictimKnockedOut" },
            [25] = { type = "int", data = "isVictimTranquilized" },
            [26] = { type = "int", data = "VictimKilledByStandardMelee" },
            [27] = { type = "int", data = "VictimMissionEntity" },
            [28] = { type = "int", data = "VictimFleeing" },
            [29] = { type = "int", data = "VictimInCombat" },
            [30] = { type = "int", data = "unknown" },
            [31] = { type = "int", data = "IsSuicide" },
            [0] = { type = "int", data = "damaged entity id" },
        }
    },
    [402722103] = {
        name = "EVENT_ENTITY_DAMAGED",
        hash = "0x18010D37",
        datasize = 9,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "object (or ped id) that caused damage to the entity " },
            [2] = { type = "int", data =
            "weaponHash that damaged the entity ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [3] = { type = "int", data =
            "ammo hash that damaged the entity ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua) )" },
            [4] = { type = "float", data = "damage amount" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "float", data = "entity coord x" },
            [7] = { type = "float", data = "entity coord y" },
            [8] = { type = "float", data = "entity coord z" },
            [0] = { type = "int", data = "damaged entity id" },
        }
    },
    [-1692828063] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_DISBANDED",
        hash = "0x9B197E61",
        datasize = 23,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "network gamer handle" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "posse id}" },
        }
    },
    [-437497832] = {
        name = "EVENT_NETWORK_PLAYER_LEFT_SCRIPT",
        hash = "0xE5EC5018",
        datasize = 41,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown (??? Player id)" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "NumThreads" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [23] = { type = "int", data = "unknown" },
            [24] = { type = "int", data = "unknown" },
            [25] = { type = "int", data = "unknown" },
            [26] = { type = "int", data = "unknown" },
            [27] = { type = "int", data = "unknown" },
            [28] = { type = "int", data = "unknown" },
            [29] = { type = "int", data = "unknown" },
            [30] = { type = "int", data = "unknown" },
            [31] = { type = "int", data = "unknown" },
            [32] = { type = "int", data = "unknown" },
            [33] = { type = "int", data = "unknown" },
            [34] = { type = "int", data = "unknown" },
            [35] = { type = "int", data = "unknown" },
            [36] = { type = "int", data = "unknown" },
            [37] = { type = "int", data = "unknown" },
            [38] = { type = "int", data = "unknown" },
            [39] = { type = "int", data = "unknown" },
            [40] = { type = "int", data = "participant id" },
            [0] = { type = "int", data = "unknown (??? leaving PlayerName)" },
        }
    },
    [1268264445] = {
        name = "EVENT_NETWORK_POSSE_JOINED",
        hash = "0x4B982DFD",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "posse id" },
            [0] = { type = "int", data = "isSuccess" },
        }
    },
    [-1034120588] = {
        name = "EVENT_HELP_TEXT_REQUEST",
        hash = "0xC25C9274",
        datasize = 4,
        group = 0,
        dataelements = {
            [1] = { type = "int", data =
            "tutorial flag hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/tutorial_flags.lua) )" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "inventory item hash" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    [-1651585854] = {
        name = "EVENT_HITCH_ANIMAL",
        hash = "0x9D8ECCC2",
        datasize = 4,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "mount ped id" },
            [2] = { type = "int", data = "isAnimalHitched" },
            [3] = { type = "int", data = "hitching type id" },
            [0] = { type = "int", data = "rider ped id" },
        }
    },
    [141007368] = {
        name = "EVENT_NETWORK_LOOT_CLAIMED",
        hash = "0x08679A08",
        datasize = 9,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown (??? result code  [list](#award-claimed-result-codes) )" },
            [5] = { type = "int", data = "unknown (??? loot entity model hash)" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "status" },
            [8] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "request id" },
        }
    },
    [-421353837] = {
        name = "EVENT_NETWORK_POSSE_DISBANDED",
        hash = "0xE6E2A693",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "posse id" },
            [0] = { type = "int", data = "isSuccess" },
        }
    },
    [1327216456] = {
        name = "EVENT_PED_WHISTLE",
        hash = "0x4F1BB748",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data =
            "whistle type ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/aud_ped_whistle_types.lua))" },
            [0] = { type = "int", data = "whistler ped id" },
        }
    },
    [-2001102517] = {
        name = "EVENT_NETWORK_PLAYER_JOIN_SCRIPT",
        hash = "0x88B9994B",
        datasize = 41,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown (??? Player id)" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "NumThreads" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [23] = { type = "int", data = "unknown" },
            [24] = { type = "int", data = "unknown" },
            [25] = { type = "int", data = "unknown" },
            [26] = { type = "int", data = "unknown" },
            [27] = { type = "int", data = "unknown" },
            [28] = { type = "int", data = "unknown" },
            [29] = { type = "int", data = "unknown" },
            [30] = { type = "int", data = "unknown" },
            [31] = { type = "int", data = "unknown" },
            [32] = { type = "int", data = "unknown" },
            [33] = { type = "int", data = "unknown" },
            [34] = { type = "int", data = "unknown" },
            [35] = { type = "int", data = "unknown" },
            [36] = { type = "int", data = "unknown" },
            [37] = { type = "int", data = "unknown" },
            [38] = { type = "int", data = "unknown" },
            [39] = { type = "int", data = "unknown" },
            [40] = { type = "int", data = "participant id" },
            [0] = { type = "int", data = "unknown (??? joining PlayerName)" },
        }
    },
    [2099179610] = {
        name = "EVENT_ITEM_PROMPT_INFO_REQUEST",
        hash = "0x7D1EF05A",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "entity id, requesting prompt info" },
            [0] = { type = "int", data = "inventory item hash" },
        }
    },
    [-687266558] = {
        name = "EVENT_PICKUP_CARRIABLE",
        hash = "0xD7092502",
        datasize = 4,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "carriable entity id" },
            [2] = { type = "int", data = "isPickupDoneFromParent" },
            [3] = { type = "int", data = "carrier mount ped id (parent id)" },
            [0] = { type = "int", data = "carrier ped id" },
        }
    },
    [2058130545] = {
        name = "EVENT_NETWORK_PROJECTILE_NO_DAMAGE_IMPACT",
        hash = "0x7AAC9471",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data =
            "AmmoUsed hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua))" },
            [0] = { type = "int", data = "ped id" },
        }
    },
    [-308071988] = {
        name = "EVENT_NETWORK_POSSE_LEFT",
        hash = "0xEDA331CC",
        datasize = 1,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "posse id" },
        }
    },
    [-1231347001] = {
        name = "EVENT_VEHICLE_DESTROYED",
        hash = "0xB69B22C7",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown (??? destroyed vehicle id)" },
        }
    },
    [1342634267] = {
        name = "EVENT_NETWORK_PED_HAT_SHOT_OFF",
        hash = "0x5006F91B",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "DamagerEntityId" },
            [2] = { type = "int", data =
            "UsedWeapon hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua))" },
            [0] = { type = "int", data = "VictimEntityId" },
        }
    },
    [-1509407906] = {
        name = "EVENT_LOOT_VALIDATION_FAIL",
        hash = "0xA608435E",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "looted_entity" },
            [0] = { type = "int", data = "fail reason id ( [list](#event_loot_validation_fail-fail-reason-ids) )" },
        }
    },
    [1047667690] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_LEFT",
        hash = "0x3E7223EA",
        datasize = 23,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "network gamer handle" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "posse id" },
        }
    },
    [1830788491] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_JOINED",
        hash = "0x6D1F9D8B",
        datasize = 23,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "network gamer handle" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "posse id" },
        }
    },
    [-857756425] = {
        name = "EVENT_NETWORK_SESSION_MERGE_START",
        hash = "0xCCDFACF7",
        datasize = 1,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "session message id ( [list](#event_network_session_merge_start-message-ids))" },
        }
    },
    [-454144443] = {
        name = "EVENT_NETWORK_PLAYER_COLLECTED_PICKUP",
        hash = "0xE4EE4E45",
        datasize = 8,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "collector player id" },
            [2] = { type = "int", data =
            "pickup type hash  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/objects/pickup_list.lua) )" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data =
            "pickup entity model hash  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/objects/object_list.lua) )" },
            [5] = { type = "int", data = "pickup ammo amount" },
            [6] = { type = "int", data =
            "pickup ammo type hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua) )" },
            [7] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "collected entity id" },
        }
    },
    [-1267317510] = {
        name = "EVENT_UI_QUICK_ITEM_USED",
        hash = "0xB47644FA",
        datasize = 6,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown (??? FitsSlot hash)" },
            [5] = { type = "int", data = "entity id, item was used for" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    [-1286831256] = {
        name = "EVENT_PLAYER_HAT_KNOCKED_OFF",
        hash = "0xB34C8368",
        datasize = 5,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "ped id who threw off player hat" },
            [2] = { type = "int", data = "hat entity id" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "player ped id" },
        }
    },
    [1655597605] = {
        name = "EVENT_PLAYER_HORSE_AGITATED_BY_ANIMAL",
        hash = "0x62AE6A25",
        datasize = 4,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "agitated animal" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "horse ped id" },
        }
    },
    [-1500256914] = {
        name = "EVENT_NETWORK_PERMISSION_CHECK_RESULT",
        hash = "0xA693E56E",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown (??? check result)" },
            [0] = { type = "int", data = "unknown (??? PermissionsRequestID)" },
        }
    },
    [-2117667982] = {
        name = "EVENT_NETWORK_LASSO_DETACH",
        hash = "0x81C6F372",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "PerpitratorEntityId" },
            [0] = { type = "int", data = "VictimEntityId" },
        }
    },
    [1082572570] = {
        name = "EVENT_PLACE_CARRIABLE_ONTO_PARENT",
        hash = "0x4086BF1A",
        datasize = 6,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "carriable entity id" },
            [2] = { type = "int", data = "carrier id(parent id)" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "isCarriedEntityAPelt" },
            [5] = { type = "int", data = "inventory item hash" },
            [0] = { type = "int", data = "perpitrator entity id" },
        }
    },
    [1924269094] = {
        name = "EVENT_CRIME_CONFIRMED",
        hash = "0x72B20426",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "criminal ped id" },
            [2] = { type = "int", data = "witness" },
            [0] = { type = "int", data =
            "crime type hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/crime_types.lua) )" },
        }
    },
    [-1246119244] = {
        name = "EVENT_PED_ANIMAL_INTERACTION",
        hash = "0xB5B9BAB4",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "animal ped id" },
            [2] = { type = "int", data = "interaction type hash" },
            [0] = { type = "int", data = "ped id" },
        }
    },
    [735942751] = {
        name = "EVENT_PED_CREATED",
        hash = "0x2BDD985F",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "ped id that was created" },
        }
    },
    [1626561060] = {
        name = "EVENT_PED_DESTROYED",
        hash = "0x60F35A24",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "??? destroyed ped id" },
        }
    },
    [176872144] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_KICKED",
        hash = "0x0A8ADAD0",
        datasize = 23,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "network gamer handle" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "posse id" },
        }
    },
    [-1578459229] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_SET_ACTIVE",
        hash = "0xA1EA9FA3",
        datasize = 23,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "network gamer handle" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "posse id" },
        }
    },
    [-1511724297] = {
        name = "EVENT_LOOT",
        hash = "0xA5E4EAF7",
        datasize = 36,
        group = 0,
        dataelements = {
            [1] = { type = "int", data =
            "nRewardHash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/loot_rewards.lua) )" },
            [2] = { type = "int", data = "inventory item hash" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "nNum" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data =
            "weaponhash( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [23] = { type = "int", data = "unknown" },
            [24] = { type = "int", data = "unknown" },
            [25] = { type = "int", data = "unknown" },
            [26] = { type = "int", data = "LooterId" },
            [27] = { type = "int", data = "LootedId" },
            [28] = { type = "int", data = "Looted entity model" },
            [29] = { type = "int", data = "LootedCompositeHashid" },
            [30] = { type = "int", data = "unknown" },
            [31] = { type = "int", data = "unknown" },
            [32] = { type = "int", data = "unknown" },
            [33] = { type = "int", data = "unknown" },
            [34] = { type = "int", data = "unknown" },
            [35] = { type = "int", data = "unknown " },
            [0] = { type = "int", data = "nNumGivenRewards" },
        }
    },
    [-1816722641] = {
        name = "EVENT_PLAYER_ESCALATED_PED",
        hash = "0x93B7032F",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "escalated ped id" },
            [0] = { type = "int", data = "player ped id" },
        }
    },
    [-885048077] = {
        name = "EVENT_NETWORK_VEHICLE_LOOTED",
        hash = "0xCB3F3CF3",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "looted vehicle id" },
            [2] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "looter ped id" },
        }
    },
    [-313265754] = {
        name = "EVENT_ENTITY_BROKEN",
        hash = "0xED53F1A6",
        datasize = 9,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown " },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "float", data = "unknown(??? damage amount)" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "float", data = "entity coord x" },
            [7] = { type = "float", data = "entity coord y" },
            [8] = { type = "float", data = "entity coord z" },
            [0] = { type = "int", data = "broken entity id" },
        }
    },
    [-45008988] = {
        name = "EVENT_SCENARIO_ADD_PED",
        hash = "0xFD5137A4",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "iScriptUID" },
        }
    },
    [218595333] = {
        name = "EVENT_HORSE_BROKEN",
        hash = "0x0D078005",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "broken horse ped id" },
            [2] = { type = "int", data = "HorseBrokenEventTypeId ( [list](#horse-broken-event-type-ids))" },
            [0] = { type = "int", data = "rider ped id" },
        }
    },
    [-617453104] = {
        name = "EVENT_CHALLENGE_REWARD",
        hash = "0xDB3269D0",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "challenge reward hash" },
        }
    },
    [1793200955] = {
        name = "EVENT_NETWORK_PED_DISARMED",
        hash = "0x6AE2133B",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "DamagerEntityId" },
            [2] = { type = "int", data =
            "UsedWeapon hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua))" },
            [0] = { type = "int", data = "VictimEntityId" },
        }
    },
    [-648745775] = {
        name = "EVENT_NETWORK_GANG",
        hash = "0xD954ECD1",
        datasize = 18,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "GangEventType id  ( [list](#gangeventtype-ids) )" },
            [2] = { type = "int", data = "sender network GamerHandle" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "unknown (??? remote player name)" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "unknown (??? GangId)" },
        }
    },
    [1194448728] = {
        name = "EVENT_NETWORK_CREW_LEFT",
        hash = "0x4731D758",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "left crew id" },
        }
    },
    [1832265142] = {
        name = "EVENT_NETWORK_VEHICLE_UNDRIVABLE",
        hash = "0x6D3625B6",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "Damager entity id" },
            [2] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "vehicle entity id" },
        }
    },
    [1626145032] = {
        name = "EVENT_NETWORK_PLAYER_MISSED_SHOT",
        hash = "0x60ED0108",
        datasize = 9,
        group = 1,
        dataelements = {
            [1] = { type = "int", data =
            "UsedWeapon hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "shooter id" },
        }
    },
    [-1482146560] = {
        name = "EVENT_NETWORK_PLAYER_JOIN_SESSION",
        hash = "0xA7A83D00",
        datasize = 10,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "player id" },
            [9] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "unknown (??? player name)" },
        }
    },
    [-1308368394] = {
        name = "EVENT_NETWORK_CREW_RANK_CHANGE",
        hash = "0xB203E1F6",
        datasize = 7,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "rank order" },
            [2] = { type = "int", data = "promotion" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "crew id" },
        }
    },
    [2013393302] = {
        name = "EVENT_NETWORK_BULLET_IMPACTED_MULTIPLE_PEDS",
        hash = "0x7801F196",
        datasize = 4,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "NumImpacted" },
            [2] = { type = "int", data = "NumKilled" },
            [3] = { type = "int", data = "NumIncapacitated" },
            [0] = { type = "int", data = "shooter ped id" },
        }
    },
    [1794914733] = {
        name = "EVENT_ENTITY_HOGTIED",
        hash = "0x6AFC39AD",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "hogtier ped id" },
            [2] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "hogtied entity id" },
        }
    },
    [-2036121834] = {
        name = "EVENT_NETWORK_PROJECTILE_ATTACHED",
        hash = "0x86A33F16",
        datasize = 6,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "victim entity id" },
            [2] = { type = "float", data = "projectile hit coord x" },
            [3] = { type = "float", data = "projectile hit coord y" },
            [4] = { type = "float", data = "projectile hit coord z" },
            [5] = { type = "int", data =
            "weaponhash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua))" },
            [0] = { type = "int", data = "damager entity id" },
        }
    },
    [453501714] = {
        name = "EVENT_NETWORK_HUB_UPDATE",
        hash = "0x1B07E312",
        datasize = 1,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "updateHash" },
        }
    },
    [1731288223] = {
        name = "EVENT_NETWORK_CASHINVENTORY_TRANSACTION",
        hash = "0x67315C9F",
        datasize = 6,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "failed" },
            [3] = { type = "int", data = "result code" },
            [4] = { type = "int", data = "items amount" },
            [5] = { type = "int", data =
            "action hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/cashinventory_transition_actions.lua))" },
            [0] = { type = "int", data = "transaction id" },
        }
    },
    [1640116056] = {
        name = "EVENT_LOOT_PLANT_START",
        hash = "0x61C22F58",
        datasize = 36,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [23] = { type = "int", data = "OriginalTargetSpawnLocation" },
            [24] = { type = "int", data = "unknown" },
            [25] = { type = "int", data = "unknown" },
            [26] = { type = "int", data = "LooterId" },
            [27] = { type = "int", data = "LootedId" },
            [28] = { type = "int", data = "unknown" },
            [29] = { type = "int", data = "LootedCompositeHashId" },
            [30] = { type = "int", data = "LootedPedStatHashName" },
            [31] = { type = "int", data = "LootedEntityWasAnimal" },
            [32] = { type = "int", data = "LootedEntityWasBird" },
            [33] = { type = "int", data = "unknown" },
            [34] = { type = "int", data = "LootingBehaviorType" },
            [35] = { type = "int", data = "unknown " },
            [0] = { type = "int", data = "NumGivenRewards" },
        }
    },
    [1697477512] = {
        name = "EVENT_NETWORK_PLAYER_LEFT_SESSION",
        hash = "0x652D7388",
        datasize = 10,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "player id" },
            [9] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "unknown (??? player name)" },
        }
    },
    [-1102089407] = {
        name = "EVENT_SHOT_FIRED_WHIZZED_BY",
        hash = "0xBE4F7341",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "entity id that was shot" },
        }
    },
    [1784289253] = {
        name = "EVENT_TRIGGERED_ANIMAL_WRITHE",
        hash = "0x6A5A17E5",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "ped id who damaged animal" },
            [0] = { type = "int", data = "animal ped id" },
        }
    },
    [-1863021589] = {
        name = "EVENT_VEHICLE_CREATED",
        hash = "0x90F48BEB",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "vehicle id that was created" },
        }
    },
    [415576404] = {
        name = "EVENT_NETWORK_POSSE_DATA_CHANGED",
        hash = "0x18C53154",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    [1553659161] = {
        name = "EVENT_REVIVE_ENTITY",
        hash = "0x5C9AF519",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "reviver ped id" },
            [2] = { type = "int", data = "used inventory item hash" },
            [0] = { type = "int", data = "VictimEntityId" },
        }
    },
    [2114586158] = {
        name = "EVENT_NETWORK_CREW_DISBANDED",
        hash = "0x7E0A062E",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "isDisbandingSuccessful" },
        }
    },
    [-178091376] = {
        name = "EVENT_PLAYER_COLLECTED_AMBIENT_PICKUP",
        hash = "0xF5628A90",
        datasize = 8,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown (??? pickup entity id)" },
            [2] = { type = "int", data = "player id" },
            [3] = { type = "int", data = "pickup model hash" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "collected inventory item quantity" },
            [7] = { type = "int", data = "inventory item hash" },
            [0] = { type = "int", data = "pickup name hash" },
        }
    },
    [-97516606] = {
        name = "EVENT_NETWORK_LASSO_ATTACH",
        hash = "0xFA3003C2",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "PerpitratorEntityId" },
            [0] = { type = "int", data = "VictimEntityId" },
        }
    },
    [1274067014] = {
        name = "EVENT_NETWORK_PLAYER_COLLECTED_PORTABLE_PICKUP",
        hash = "0x4BF0B846",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "player id" },
            [2] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "collected pickup network id" },
        }
    },
    [678947301] = {
        name = "EVENT_NETWORK_GANG_WAYPOINT_CHANGED",
        hash = "0x2877E9E5",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "Gang Waypoint Changing type id ( [list](#gang-waypoint-changing-type-ids) )" },
        }
    },
    [-582361627] = {
        name = "EVENT_CARRIABLE_PROMPT_INFO_REQUEST",
        hash = "0xDD49DDE5",
        datasize = 6,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "carry action id ( [list](#carry-action-ids) )" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "vehicle entity id (parent id)" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "CarriableEntityId" },
        }
    },
    [797969925] = {
        name = "EVENT_NETWORK_POSSE_EX_INACTIVE_DISBANDED",
        hash = "0x2F900E05",
        datasize = 10,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    [-1171710795] = {
        name = "EVENT_NETWORK_REVIVED_ENTITY",
        hash = "0xBA291CB5",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "Reviver entity id" },
            [0] = { type = "int", data = "Victim entity id" },
        }
    },
    [2145012826] = {
        name = "EVENT_ENTITY_DESTROYED",
        hash = "0x7FDA4C5A",
        datasize = 9,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "object (or ped id) that caused damage to the entity" },
            [2] = { type = "int", data =
            "weaponHash that damaged the entity  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [3] = { type = "int", data =
            "ammo hash that damaged the entity ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua) )" },
            [4] = { type = "float", data = "damage amount" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "float", data = "entity coord x" },
            [7] = { type = "float", data = "entity coord y" },
            [8] = { type = "float", data = "entity coord z" },
            [0] = { type = "int", data = "destroyed entity id" },
        }
    },
    [1113682948] = {
        name = "EVENT_ENTITY_DISARMED",
        hash = "0x42617404",
        datasize = 4,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "damager entity id" },
            [2] = { type = "int", data =
            "weaponHash that damaged the entity  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [3] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "victim entity id" },
        }
    },
    [-1241852893] = {
        name = "EVENT_CARRIABLE_VEHICLE_STOW_START",
        hash = "0xB5FAD423",
        datasize = 5,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "carriable entity id" },
            [2] = { type = "int", data = "vehicle entity id" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    [-919500771] = {
        name = "EVENT_NETWORK_HOGTIE_END",
        hash = "0xC931881D",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "PerpitratorEntityId" },
            [0] = { type = "int", data = "VictimEntityId" },
        }
    },
    [-2119801478] = {
        name = "EVENT_NETWORK_SESSION_MERGE_END",
        hash = "0x81A6657A",
        datasize = 1,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "session message id ( [list](#event_network_session_merge_end-message-ids))" },
        }
    },
    [-1507090758] = {
        name = "EVENT_SHOT_FIRED_BULLET_IMPACT",
        hash = "0xA62B9EBA",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "entity id that bullet hit" },
        }
    },
    [-843924932] = {
        name = "EVENT_NETWORK_PLAYER_DROPPED_PORTABLE_PICKUP",
        hash = "0xCDB2BA3C",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "player id" },
            [2] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "collected pickup network id" },
        }
    },
    [1505348054] = {
        name = "EVENT_INVENTORY_ITEM_REMOVED",
        hash = "0x59B9C9D6",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "inventory item hash" },
        }
    },
    [23105215] = {
        name = "EVENT_NETWORK_POSSE_LEADER_SET_ACTIVE",
        hash = "0x01608EBF",
        datasize = 23,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "network gamer handle" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "posse id" },
        }
    },
    [1417095237] = {
        name = "EVENT_BUCKED_OFF",
        hash = "0x54772845",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = { type = 'int', data = "mount id" },
            [2] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "rider id" },
        }
    },
    [-1126217932] = {
        name = "EVENT_NETWORK_MINIGAME_REQUEST_COMPLETE",
        hash = "0xBCDF4734",
        datasize = 6,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "seatRequestData1" },
            [2] = { type = "int", data = "seatRequestData2" },
            [3] = { type = "int", data = "seatRequestData3" },
            [4] = { type = "int", data = "isSuccess" },
            [5] = { type = "int", data =
            "MinigameErrorCodeHash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/minigame_error_codes.lua ))" },
            [0] = { type = "int", data = "seatRequestData0" },
        }
    },
    [353377915] = {
        name = "EVENT_HOGTIED_ENTITY_PICKED_UP",
        hash = "0x15101E7B",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "carrier ped id" },
            [0] = { type = "int", data = "hogtied ped id" },
        }
    },
    [-369170747] = {
        name = "EVENT_PLAYER_HAT_EQUIPPED",
        hash = "0xE9FEE6C5",
        datasize = 10,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "hat entity id" },
            [2] = { type = "int", data = "hat drawble hash" },
            [3] = { type = "int", data = "hat albedo hash" },
            [4] = { type = "int", data = "hat normal hash" },
            [5] = { type = "int", data = "hat material hash" },
            [6] = { type = "int", data = "hat palette hash" },
            [7] = { type = "int", data = "hat tint1" },
            [8] = { type = "int", data = "hat tint2" },
            [9] = { type = "int", data = "hat tint3" },
            [0] = { type = "int", data = "player ped id" },
        }
    },
    [1694142010] = {
        name = "EVENT_NETWORK_BOUNTY_REQUEST_COMPLETE",
        hash = "0x64FA8E3A",
        datasize = 7,
        group = 1,
        dataelements = {
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "Result code" },
            [5] = { type = "int", data = "Total Value" },
            [6] = { type = "int", data = "Pay Off Value" },
            [0] = { type = "int", data = "unknown (??? request id)" },
        }
    },
    [1234888675] = {
        name = "EVENT_NETWORK_CREW_CREATION",
        hash = "0x499AE7E3",
        datasize = 10,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "crew id" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "isCreationSuccessful" },
        }
    },
    [1028782110] = {
        name = "EVENT_NETWORK_CREW_INVITE_RECEIVED",
        hash = "0x3D51F81E",
        datasize = 11,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "hasMessage" },
            [0] = { type = "int", data = "id" },
        }
    },
    [-1130756835] = {
        name = "EVENT_DAILY_CHALLENGE_STREAK_COMPLETED",
        hash = "0xBC9A051D",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown (???isDailyChallengeStreakCompleted)" },
        }
    },
    [753021595] = {
        name = "EVENT_NETWORK_CREW_KICKED",
        hash = "0x2CE2329B",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "primary" },
            [0] = { type = "int", data = "crew id" },
        }
    },
    [1081092949] = {
        name = "EVENT_INVENTORY_ITEM_PICKED_UP",
        hash = "0x40702B55",
        datasize = 5,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "picked up entity model " },
            [2] = { type = "int", data = "isItemWasUsed" },
            [3] = { type = "int", data = "isItemWasBought" },
            [4] = { type = "int", data = "picked up entity id" },
            [0] = { type = "int", data = "inventory item hash" },
        }
    },
    [1387172233] = {
        name = "EVENT_PLAYER_PROMPT_TRIGGERED",
        hash = "0x52AE9189",
        datasize = 10,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "target entity id" },
            [3] = { type = "int", data = "unknown (??? discovered inventory item)" },
            [4] = { type = "float", data = "player ped coord x" },
            [5] = { type = "float", data = "player ped coord y" },
            [6] = { type = "float", data = "player ped coord z" },
            [7] = { type = "int", data = "discoverable entity type id ( [list](#discoverable-entity-type-ids) )" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data =
            "kit_emote_action hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/animations/kit_emotes_list.lua))" },
            [0] = { type = "int", data = "prompt type id ( [list](#prompt-type-ids) )" },
        }
    },
    [-569301261] = {
        name = "EVENT_MISS_INTENDED_TARGET",
        hash = "0xDE1126F3",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "entity id that was shot" },
            [2] = { type = "int", data =
            "weaponhash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua))" },
            [0] = { type = "int", data = "shooter ped id" },
        }
    },
    [-231935285] = {
        name = "EVENT_NETWORK_POSSE_CREATED",
        hash = "0xF22CF2CB",
        datasize = 10,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "posse id" },
            [2] = { type = "int", data = "unknown (??? posse name)" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "isSuccess" },
        }
    },
    [-1730772208] = {
        name = "EVENT_OBJECT_INTERACTION",
        hash = "0x98D68310",
        datasize = 10,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "interaction entity id " },
            [2] = { type = "int", data = "inventory item hash" },
            [3] = { type = "int", data = "inventory item quantity" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "scenario point id" },
            [9] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "ped id" },
        }
    },
    [-456923784] = {
        name = "EVENT_SCENARIO_REMOVE_PED",
        hash = "0xE4C3E578",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "iScriptUID" },
        }
    },
    -- TODO: RUN GetHashKey("EVENT_SHOCKING_ITEM_STOLEN") to get the hash
    -- TODO: not sure how to get the id
    -- [toBeFiguredOut] = {
    --     name = "EVENT_SHOCKING_ITEM_STOLEN",
    --     hash = "RUN GetHashKey("EVENT_SHOCKING_ITEM_STOLEN") to get the hash",
    --     datasize = 3,
    --     group = 0,
    --     dataelements = {
    --         [1] = {type = "int", data = "ped id"},
    --         [2] = {type = "int", data = "carriable entity id"},
    --         [0] = {type = "int", data = "ped id"},
    --     }
    -- },
    [1165534493] = {
        name = "EVENT_HEADSHOT_BLOCKED_BY_HAT",
        hash = "0x4578A51D",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "Inflictor entity id" },
            [0] = { type = "int", data = "Victim entity id" },
        }
    },
    [1638298852] = {
        name = "EVENT_MOUNT_OVERSPURRED",
        hash = "0x61A674E4",
        datasize = 6,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "mount id" },
            [2] = { type = "float", data = "unknown (??? horse rage amount)" },
            [3] = { type = "int", data = "the number of times the horse has overspurred" },
            [4] = { type = "int", data = "maximum number or times the horse can be overspurred before buck off rider" },
            [5] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "rider id" },
        }
    },
    [-1315453179] = {
        name = "EVENT_NETWORK_CREW_JOINED",
        hash = "0xB197C705",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [0] = { type = "int", data = "unknown" },
        }
    },
    [1352063587] = {
        name = "EVENT_CONTAINER_INTERACTION",
        hash = "0x5096DA63",
        datasize = 4,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "searched entity id" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "isContainerClosed after interaction" },
            [0] = { type = "int", data = "searcher ped id" },
        }
    },
    [-140551285] = {
        name = "EVENT_ENTITY_EXPLOSION",
        hash = "0xF79F5B8B",
        datasize = 6,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data =
            "weaponhash( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [3] = { type = "float", data = "explosion coord x" },
            [4] = { type = "float", data = "explosion coord y" },
            [5] = { type = "float", data = "explosion coord z" },
            [0] = { type = "int", data = "ped id who did explosion" },
        }
    },
    [-1065733433] = {
        name = "EVENT_NETWORK_HOGTIE_BEGIN",
        hash = "0xC07A32C7",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = { type = "int", data = "PerpitratorEntityId" },
            [0] = { type = "int", data = "VictimEntityId" },
        }
    },
    [-1985279805] = {
        name = "EVENT_CALM_PED",
        hash = "0x89AB08C3",
        datasize = 4,
        group = 0,
        dataelements = {
            [1] = { type = "int", data = "mount ped id" },
            [2] = { type = "int", data = "CalmTypeId ( [list](#calm-type-ids) )" },
            [3] = { type = "int", data = "isFullyCalmed" },
            [0] = { type = "int", data = "calmer ped id" },
        }
    }
}
