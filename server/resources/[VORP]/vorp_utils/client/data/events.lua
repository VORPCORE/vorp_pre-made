EVENTS = {
    [1385704366] = {
        name = "EVENT_NETWORK_PICKUP_RESPAWNED",
        hash = "0x52982BAE",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [0] = "pickup entity id"
        }
    },
    [-818205375] = {
        name = "EVENT_STAT_VALUE_CHANGED",
        hash = "0xCF3B2D41",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "unknown",
            [0] = "stat value type hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/stat_values.lua) )"
        }
    },
    [1658389497] = {
        name = "EVENT_NETWORK_SESSION_EVENT",
        hash = "0x62D903F9",
        datasize = 10,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "unknown",
            [0] = "unknown (??? session event type)"
        }
    },
    [676208328] = {
        name = "EVENT_NETWORK_INCAPACITATED_ENTITY",
        hash = "0x284E1EC8",
        datasize = 4,
        group = 1,
        dataelements = {
            [1] = "Damager entity id",
            [2] = "WeaponUsed hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )",
            [3] = "Damage",
            [0] = "VictimEntityId"
        }
    },
    [-745090075] = {
        name = "EVENT_IMPENDING_SAMPLE_PROMPT",
        hash = "0xD396D3E5",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "inventory item hash",
            [0] = "unknown"
        }
    },
    [347157807] = {
        name = "EVENT_RAN_OVER_PED",
        hash = "0x14B1352F",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "ped id that was ran over",
            [0] = "unknown"
        }
    },
    [1376140891] = {
        name = "EVENT_LOOT_COMPLETE",
        hash = "0x52063E5B",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = "Looted entity id",
            [2] = "isLootSuccess",
            [0] = "looterId"
        }
    },
    [1741908893] = {
        name = "EVENT_NETWORK_AWARD_CLAIMED",
        hash = "0x67D36B9D",
        datasize = 12,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown (??? result code [list](#award-claimed-result-codes))",
            [5] = "unknown (??? award hash [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/awards.lua))",
            [6] = "unknown (??? awarded xp amount)",
            [7] = "unknown (??? awarded rank amount)",
            [8] = "unknown (??? awarded cash amount)",
            [9] = "unknown (??? awarded gold amount)",
            [10] = "unknown",
            [11] = "unknown",
            [0] = "request id"
        }
    },
    [-843555838] = {
        name = "EVENT_SCENARIO_DESTROY_PROP",
        hash = "0xCDB85C02",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "unknown",
            [0] = "iScriptUID"
        }
    },
    [-2091944374] = {
        name = "EVENT_CALCULATE_LOOT",
        hash = "0x834F764A",
        datasize = 26,
        group = 0,
        dataelements = {
            [1] = "unknown",
            [2] = "inventory item hash",
            [3] = "consumable action hash",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "unknown",
            [10] = "unknown",
            [11] = "unknown",
            [12] = "unknown",
            [13] = "unknown",
            [14] = "unknown",
            [15] = "unknown",
            [16] = "unknown",
            [17] = "unknown",
            [18] = "unknown",
            [19] = "unknown",
            [20] = "unknown",
            [21] = "unknown",
            [22] = "unknown",
            [23] = "looter entity id",
            [24] = "looted entity id",
            [25] = "unknown",
            [0] = "unknown"
        }
    },
    [-2020006491] = {
        name = "EVENT_NETWORK_POSSE_EX_ADMIN_DISBANDED",
        hash = "0x879925A5",
        datasize = 9,
        group = 1,
        dataelements = {
            [1] = "unknown (??? posse name)",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [0] = "unknown"
        }
    },
    [1559647390] = {
        name = "EVENT_NETWORK_PICKUP_COLLECTION_FAILED",
        hash = "0x5CF6549E",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = "player id",
            [2] = "pickup type hash  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/objects/pickup_list.lua))",
            [0] = " unknown"
        }
    },
    [867155253] = {
        name = "EVENT_CARRIABLE_VEHICLE_STOW_COMPLETE",
        hash = "0x33AFBD35",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = "vehicle entity id",
            [2] = "isItemToAddCancelled",
            [0] = "unknown"
        }
    },
    [-1682387274] = {
        name = "EVENT_PLAYER_MOUNT_WILD_HORSE",
        hash = "0x9BB8CEB6",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = "wild horse ped id"
        }
    },
    [1208357138] = {
        name = "EVENT_CARRIABLE_UPDATE_CARRY_STATE",
        hash = "0x48061112",
        datasize = 5,
        group = 0,
        dataelements = {
            [1] = "PerpitratorEntityId",
            [2] = "CarrierEntityId",
            [3] = "IsOnHorse",
            [4] = "IsOnGround",
            [0] = "CarriableEntityId"
        }
    },
    [-346212524] = {
        name = "EVENT_UI_ITEM_INSPECT_ACTIONED",
        hash = "0xEB5D3754",
        datasize = 6,
        group = 0,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown (??? FitsSlot hash)",
            [5] = "unknown",
            [0] = "unknown"
        }
    },
    [2030961287] = {
        name = "EVENT_PED_HAT_KNOCKED_OFF",
        hash = "0x790E0287",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "hat entity id",
            [0] = "ped id"
        }
    },
    [-1315570756] = {
        name = "EVENT_NETWORK_DAMAGE_ENTITY",
        hash = "0xB195FBBC",
        datasize = 32,
        group = 1,
        dataelements = {
            [1] = "killer entity id",
            [2] = "Damage",
            [3] = "isVictimDestroyed",
            [4] = "isVictimIncapacitated",
            [5] = "WeaponUsed hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )",
            [6] = "AmmoUsed hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua) )",
            [7] = "InstigatedWeaponUsed",
            [8] = "VictimSpeed",
            [9] = "DamagerSpeed",
            [10] = "IsResponsibleForCollision",
            [11] = "IsHeadShot",
            [12] = "IsWithMeleeWeapon",
            [13] = "IsVictimExecuted",
            [14] = "VictimBledOut",
            [15] = "DamagerWasScopedIn",
            [16] = "DamagerSpecialAbilityActive",
            [17] = "VictimHogtied",
            [18] = "VictimMounted",
            [19] = "VictimInVehicle",
            [20] = "VictimInCover",
            [21] = "DamagerShotLastBullet",
            [22] = "VictimKilledByStealth",
            [23] = "VictimKilledByTakedown",
            [24] = "VictimKnockedOut",
            [25] = "isVictimTranquilized",
            [26] = "VictimKilledByStandardMelee",
            [27] = "VictimMissionEntity",
            [28] = "VictimFleeing",
            [29] = "VictimInCombat",
            [30] = "unknown",
            [31] = "IsSuicide",
            [0] = "damaged entity id"
        }
    },
    [402722103] = {
        name = "EVENT_ENTITY_DAMAGED",
        hash = "0x18010D37",
        datasize = 9,
        group = 0,
        dataelements = {
            [1] = "object (or ped id) that caused damage to the entity ",
            [2] = "weaponHash that damaged the entity ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )",
            [3] = "ammo hash that damaged the entity ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua) )",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [0] = "damaged entity id"
        }
    },
    [-1692828063] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_DISBANDED",
        hash = "0x9B197E61",
        datasize = 23,
        group = 1,
        dataelements = {
            [1] = "unknown (??? posse name)",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "network gamer handle",
            [10] = "unknown",
            [11] = "unknown",
            [12] = "unknown",
            [13] = "unknown",
            [14] = "unknown",
            [15] = "unknown",
            [16] = "unknown",
            [17] = "unknown",
            [18] = "unknown",
            [19] = "unknown",
            [20] = "unknown",
            [21] = "unknown",
            [22] = "unknown",
            [0] = "posse id"
        }
    },
    [-437497832] = {
        name = "EVENT_NETWORK_PLAYER_LEFT_SCRIPT",
        hash = "0xE5EC5018",
        datasize = 41,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown (??? Player id)",
            [9] = "unknown",
            [10] = "unknown",
            [11] = "NumThreads",
            [12] = "unknown",
            [13] = "unknown",
            [14] = "unknown",
            [15] = "unknown",
            [16] = "unknown",
            [17] = "unknown",
            [18] = "unknown",
            [19] = "unknown",
            [20] = "unknown",
            [21] = "unknown",
            [22] = "unknown",
            [23] = "unknown",
            [24] = "unknown",
            [25] = "unknown",
            [26] = "unknown",
            [27] = "unknown",
            [28] = "unknown",
            [29] = "unknown",
            [30] = "unknown",
            [31] = "unknown",
            [32] = "unknown",
            [33] = "unknown",
            [34] = "unknown",
            [35] = "unknown",
            [36] = "unknown",
            [37] = "unknown",
            [38] = "unknown",
            [39] = "unknown",
            [40] = "participant id",
            [0] = "unknown (??? leaving PlayerName)"
        }
    },
    [1268264445] = {
        name = "EVENT_NETWORK_POSSE_JOINED",
        hash = "0x4B982DFD",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "posse id",
            [0] = "isSuccess"
        }
    },
    [-1034120588] = {
        name = "EVENT_HELP_TEXT_REQUEST",
        hash = "0xC25C9274",
        datasize = 4,
        group = 0,
        dataelements = {
            [1] = "tutorial flag hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/tutorial_flags.lua) )",
            [2] = "unknown",
            [3] = "inventory item hash",
            [0] = "unknown"
        }
    },
    [141007368] = {
        name = "EVENT_NETWORK_LOOT_CLAIMED",
        hash = "0x08679A08",
        datasize = 9,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown (??? result code  [list](#award-claimed-result-codes) )",
            [5] = "unknown (??? loot entity model hash)",
            [6] = "unknown",
            [7] = "status",
            [8] = "unknown",
            [0] = "request id"
        }
    },
    [-421353837] = {
        name = "EVENT_NETWORK_POSSE_DISBANDED",
        hash = "0xE6E2A693",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "posse id",
            [0] = "isSuccess"
        }
    },
    [1327216456] = {
        name = "EVENT_PED_WHISTLE",
        hash = "0x4F1BB748",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "whistle type ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/aud_ped_whistle_types.lua))",
            [0] = "whistler ped id"
        }
    },
    [-2001102517] = {
        name = "EVENT_NETWORK_PLAYER_JOIN_SCRIPT",
        hash = "0x88B9994B",
        datasize = 41,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown (??? Player id)",
            [9] = "unknown",
            [10] = "unknown",
            [11] = "NumThreads",
            [12] = "unknown",
            [13] = "unknown",
            [14] = "unknown",
            [15] = "unknown",
            [16] = "unknown",
            [17] = "unknown",
            [18] = "unknown",
            [19] = "unknown",
            [20] = "unknown",
            [21] = "unknown",
            [22] = "unknown",
            [23] = "unknown",
            [24] = "unknown",
            [25] = "unknown",
            [26] = "unknown",
            [27] = "unknown",
            [28] = "unknown",
            [29] = "unknown",
            [30] = "unknown",
            [31] = "unknown",
            [32] = "unknown",
            [33] = "unknown",
            [34] = "unknown",
            [35] = "unknown",
            [36] = "unknown",
            [37] = "unknown",
            [38] = "unknown",
            [39] = "unknown",
            [40] = "participant id",
            [0] = "unknown (??? joining PlayerName)"
        }
    },
    [2099179610] = {
        name = "EVENT_ITEM_PROMPT_INFO_REQUEST",
        hash = "0x7D1EF05A",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "eUnkInventoryItem",
            [0] = "iEntity"
        }
    },
    [-687266558] = {
        name = "EVENT_PICKUP_CARRIABLE",
        hash = "0xD7092502",
        datasize = 4,
        group = 0,
        dataelements = {
            [1] = "carriable entity id",
            [2] = "isPickupDoneFromParent",
            [3] = "carrier mount ped id (parent id)",
            [0] = "carrier ped id"
        }
    },
    [2058130545] = {
        name = "EVENT_NETWORK_PROJECTILE_NO_DAMAGE_IMPACT",
        hash = "0x7AAC9471",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "AmmoUsed hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua))",
            [0] = "ped id"
        }
    },
    [-308071988] = {
        name = "EVENT_NETWORK_POSSE_LEFT",
        hash = "0xEDA331CC",
        datasize = 1,
        group = 1,
        dataelements = {
            [0] = "posse id"
        }
    },
    [-1231347001] = {
        name = "EVENT_VEHICLE_DESTROYED",
        hash = "0xB69B22C7",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = "unknown (??? destroyed vehicle id)"
        }
    },
    [1342634267] = {
        name = "EVENT_NETWORK_PED_HAT_SHOT_OFF",
        hash = "0x5006F91B",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = "DamagerEntityId",
            [2] = "UsedWeapon hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua))",
            [0] = "VictimEntityId"
        }
    },
    [-1509407906] = {
        name = "EVENT_LOOT_VALIDATION_FAIL",
        hash = "0xA608435E",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "looted_entity",
            [0] = "fail reason id ( [list](#event_loot_validation_fail-fail-reason-ids) )"
        }
    },
    [1047667690] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_LEFT",
        hash = "0x3E7223EA",
        datasize = 23,
        group = 1,
        dataelements = {
            [1] = "unknown (??? posse name)",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "network gamer handle",
            [10] = "unknown",
            [11] = "unknown",
            [12] = "unknown",
            [13] = "unknown",
            [14] = "unknown",
            [15] = "unknown",
            [16] = "unknown",
            [17] = "unknown",
            [18] = "unknown",
            [19] = "unknown",
            [20] = "unknown",
            [21] = "unknown",
            [22] = "unknown",
            [0] = "posse id"
        }
    },
    [1830788491] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_JOINED",
        hash = "0x6D1F9D8B",
        datasize = 23,
        group = 1,
        dataelements = {
            [1] = "unknown (??? posse name)",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "network gamer handle",
            [10] = "unknown",
            [11] = "unknown",
            [12] = "unknown",
            [13] = "unknown",
            [14] = "unknown",
            [15] = "unknown",
            [16] = "unknown",
            [17] = "unknown",
            [18] = "unknown",
            [19] = "unknown",
            [20] = "unknown",
            [21] = "unknown",
            [22] = "unknown",
            [0] = "posse id"
        }
    },
    [-857756425] = {
        name = "EVENT_NETWORK_SESSION_MERGE_START",
        hash = "0xCCDFACF7",
        datasize = 1,
        group = 1,
        dataelements = {
            [0] = "session message id ( [list](#event_network_session_merge_start-message-ids))"
        }
    },
    [-454144443] = {
        name = "EVENT_NETWORK_PLAYER_COLLECTED_PICKUP",
        hash = "0xE4EE4E45",
        datasize = 8,
        group = 1,
        dataelements = {
            [1] = "collector player id",
            [2] = "pickup type hash  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/objects/pickup_list.lua) )",
            [3] = "unknown",
            [4] = "pickup entity model hash  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/objects/object_list.lua) )",
            [5] = "pickup ammo amount",
            [6] = "pickup ammo type hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua) )",
            [7] = "unknown",
            [0] = "collected entity id"
        }
    },
    [-1267317510] = {
        name = "EVENT_UI_QUICK_ITEM_USED",
        hash = "0xB47644FA",
        datasize = 6,
        group = 0,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown (??? FitsSlot hash)",
            [5] = "entity id, item was used for",
            [0] = "unknown"
        }
    },
    [-1286831256] = {
        name = "EVENT_PLAYER_HAT_KNOCKED_OFF",
        hash = "0xB34C8368",
        datasize = 5,
        group = 0,
        dataelements = {
            [1] = "ped id who threw off player hat",
            [2] = "hat entity id",
            [3] = "unknown",
            [4] = "unknown",
            [0] = "player ped id"
        }
    },
    [-1500256914] = {
        name = "EVENT_NETWORK_PERMISSION_CHECK_RESULT",
        hash = "0xA693E56E",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "unknown (??? check result)",
            [0] = "unknown (??? PermissionsRequestID)"
        }
    },
    [-2117667982] = {
        name = "EVENT_NETWORK_LASSO_DETACH",
        hash = "0x81C6F372",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "PerpitratorEntityId",
            [0] = "VictimEntityId"
        }
    },
    [1082572570] = {
        name = "EVENT_PLACE_CARRIABLE_ONTO_PARENT",
        hash = "0x4086BF1A",
        datasize = 6,
        group = 0,
        dataelements = {
            [1] = "carriable entity id",
            [2] = "carrier id(parent id)",
            [3] = "unknown",
            [4] = "isCarriedEntityAPelt",
            [5] = "inventory item hash",
            [0] = "perpitrator entity id "
        }
    },
    [1924269094] = {
        name = "EVENT_CRIME_CONFIRMED",
        hash = "0x72B20426",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = "criminal ped id",
            [2] = "witness",
            [0] = "crime type hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/crime_types.lua) )"
        }
    },
    [-1246119244] = {
        name = "EVENT_PED_ANIMAL_INTERACTION",
        hash = "0xB5B9BAB4",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = "animal ped id",
            [2] = "interaction type hash",
            [0] = "ped id"
        }
    },
    [176872144] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_KICKED",
        hash = "0x0A8ADAD0",
        datasize = 23,
        group = 1,
        dataelements = {
            [1] = "unknown (??? posse name)",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "network gamer handle",
            [10] = "unknown",
            [11] = "unknown",
            [12] = "unknown",
            [13] = "unknown",
            [14] = "unknown",
            [15] = "unknown",
            [16] = "unknown",
            [17] = "unknown",
            [18] = "unknown",
            [19] = "unknown",
            [20] = "unknown",
            [21] = "unknown",
            [22] = "unknown",
            [0] = "posse id"
        }
    },
    [-1578459229] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_SET_ACTIVE",
        hash = "0xA1EA9FA3",
        datasize = 23,
        group = 1,
        dataelements = {
            [1] = "unknown (??? posse name)",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "network gamer handle",
            [10] = "unknown",
            [11] = "unknown",
            [12] = "unknown",
            [13] = "unknown",
            [14] = "unknown",
            [15] = "unknown",
            [16] = "unknown",
            [17] = "unknown",
            [18] = "unknown",
            [19] = "unknown",
            [20] = "unknown",
            [21] = "unknown",
            [22] = "unknown",
            [0] = "posse id"
        }
    },
    [-1511724297] = {
        name = "EVENT_LOOT",
        hash = "0xA5E4EAF7",
        datasize = 36,
        group = 0,
        dataelements = {
            [1] = "nRewardHash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/loot_rewards.lua) )",
            [2] = "inventory item hash",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "unknown",
            [10] = "unknown",
            [11] = "unknown",
            [12] = "nNum",
            [13] = "unknown",
            [14] = "unknown",
            [15] = "unknown",
            [16] = "unknown",
            [17] = "unknown",
            [18] = "unknown",
            [19] = "unknown",
            [20] = "unknown",
            [21] = "unknown",
            [22] = "weaponhash( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )",
            [23] = "unknown",
            [24] = "unknown",
            [25] = "unknown",
            [26] = "LooterId",
            [27] = "LootedId",
            [28] = "Looted entity model",
            [29] = "LootedCompositeHashid",
            [30] = "unknown",
            [31] = "unknown",
            [32] = "unknown",
            [33] = "unknown",
            [34] = "unknown",
            [35] = "unknown ",
            [0] = "nNumGivenRewards"
        }
    },
    [-1816722641] = {
        name = "EVENT_PLAYER_ESCALATED_PED",
        hash = "0x93B7032F",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "escalated ped id",
            [0] = "player ped id"
        }
    },
    [-885048077] = {
        name = "EVENT_NETWORK_VEHICLE_LOOTED",
        hash = "0xCB3F3CF3",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = "looted vehicle id",
            [2] = "unknown",
            [0] = "looter ped id"
        }
    },
    [-313265754] = {
        name = "EVENT_ENTITY_BROKEN",
        hash = "0xED53F1A6",
        datasize = 9,
        group = 0,
        dataelements = {
            [1] = "unknown ",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [0] = "broken entity id"
        }
    },
    [-45008988] = {
        name = "EVENT_SCENARIO_ADD_PED",
        hash = "0xFD5137A4",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "unknown",
            [0] = "iScriptUID"
        }
    },
    [218595333] = {
        name = "EVENT_HORSE_BROKEN",
        hash = "0x0D078005",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = "broken horse ped id",
            [2] = "HorseBrokenEventTypeId ( [list](#horse-broken-event-type-ids))",
            [0] = "rider ped id"
        }
    },
    [-617453104] = {
        name = "EVENT_CHALLENGE_REWARD",
        hash = "0xDB3269D0",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [0] = "challenge reward hash"
        }
    },
    [1793200955] = {
        name = "EVENT_NETWORK_PED_DISARMED",
        hash = "0x6AE2133B",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = "DamagerEntityId",
            [2] = "UsedWeapon hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua))",
            [0] = "VictimEntityId"
        }
    },
    [-648745775] = {
        name = "EVENT_NETWORK_GANG",
        hash = "0xD954ECD1",
        datasize = 18,
        group = 1,
        dataelements = {
            [1] = "GangEventType id  ( [list](#gangeventtype-ids) )",
            [2] = "sender network GamerHandle",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "unknown",
            [10] = "unknown (??? remote player name)",
            [11] = "unknown",
            [12] = "unknown",
            [13] = "unknown",
            [14] = "unknown",
            [15] = "unknown",
            [16] = "unknown",
            [17] = "unknown",
            [0] = "unknown (??? GangId)"
        }
    },
    [1194448728] = {
        name = "EVENT_NETWORK_CREW_LEFT",
        hash = "0x4731D758",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [0] = "left crew id"
        }
    },
    [1832265142] = {
        name = "EVENT_NETWORK_VEHICLE_UNDRIVABLE",
        hash = "0x6D3625B6",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = "Damager entity id",
            [2] = "unknown",
            [0] = "vehicle entity id"
        }
    },
    [1626145032] = {
        name = "EVENT_NETWORK_PLAYER_MISSED_SHOT",
        hash = "0x60ED0108",
        datasize = 9,
        group = 1,
        dataelements = {
            [1] = "UsedWeapon hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [0] = "shooter id"
        }
    },
    [-1482146560] = {
        name = "EVENT_NETWORK_PLAYER_JOIN_SESSION",
        hash = "0xA7A83D00",
        datasize = 10,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "player id",
            [9] = "unknown",
            [0] = "unknown (??? player name)"
        }
    },
    [-1308368394] = {
        name = "EVENT_NETWORK_CREW_RANK_CHANGE",
        hash = "0xB203E1F6",
        datasize = 7,
        group = 1,
        dataelements = {
            [1] = "rank order",
            [2] = "promotion",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [0] = "crew id"
        }
    },
    [2013393302] = {
        name = "EVENT_NETWORK_BULLET_IMPACTED_MULTIPLE_PEDS",
        hash = "0x7801F196",
        datasize = 4,
        group = 1,
        dataelements = {
            [1] = "NumImpacted",
            [2] = "NumKilled",
            [3] = "NumIncapacitated",
            [0] = "shooter ped id"
        }
    },
    [1794914733] = {
        name = "EVENT_ENTITY_HOGTIED",
        hash = "0x6AFC39AD",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = "hogtier ped id",
            [2] = "unknown",
            [0] = "hogtied entity id"
        }
    },
    [-2036121834] = {
        name = "EVENT_NETWORK_PROJECTILE_ATTACHED",
        hash = "0x86A33F16",
        datasize = 6,
        group = 1,
        dataelements = {
            [1] = "victim entity id",
            [2] = "projectile hit coord x",
            [3] = "projectile hit coord y",
            [4] = "projectile hit coord z",
            [5] = "weaponhash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua))",
            [0] = "damager entity id"
        }
    },
    [453501714] = {
        name = "EVENT_NETWORK_HUB_UPDATE",
        hash = "0x1B07E312",
        datasize = 1,
        group = 1,
        dataelements = {
            [0] = "updateHash"
        }
    },
    [1731288223] = {
        name = "EVENT_NETWORK_CASHINVENTORY_TRANSACTION",
        hash = "0x67315C9F",
        datasize = 6,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [2] = "failed",
            [3] = "result code",
            [4] = "items amount",
            [5] = "action hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/cashinventory_transition_actions.lua))",
            [0] = "transaction id"
        }
    },
    [1640116056] = {
        name = "EVENT_LOOT_PLANT_START",
        hash = "0x61C22F58",
        datasize = 36,
        group = 0,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "unknown",
            [10] = "unknown",
            [11] = "unknown",
            [12] = "unknown",
            [13] = "unknown",
            [14] = "unknown",
            [15] = "unknown",
            [16] = "unknown",
            [17] = "unknown",
            [18] = "unknown",
            [19] = "unknown",
            [20] = "unknown",
            [21] = "unknown",
            [22] = "unknown",
            [23] = "OriginalTargetSpawnLocation",
            [24] = "unknown",
            [25] = "unknown",
            [26] = "LooterId",
            [27] = "LootedId",
            [28] = "unknown",
            [29] = "LootedCompositeHashId",
            [30] = "LootedPedStatHashName",
            [31] = "LootedEntityWasAnimal",
            [32] = "LootedEntityWasBird",
            [33] = "unknown",
            [34] = "LootingBehaviorType",
            [35] = "unknown ",
            [0] = "NumGivenRewards"
        }
    },
    [1697477512] = {
        name = "EVENT_NETWORK_PLAYER_LEFT_SESSION",
        hash = "0x652D7388",
        datasize = 10,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "player id",
            [9] = "unknown",
            [0] = "unknown (??? player name)"
        }
    },
    [-1102089407] = {
        name = "EVENT_SHOT_FIRED_WHIZZED_BY",
        hash = "0xBE4F7341",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = "entity id that was shot"
        }
    },
    [1784289253] = {
        name = "EVENT_TRIGGERED_ANIMAL_WRITHE",
        hash = "0x6A5A17E5",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "ped id who damaged animal",
            [0] = "animal ped id"
        }
    },
    [-1863021589] = {
        name = "EVENT_VEHICLE_CREATED",
        hash = "0x90F48BEB",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = "vehicle id that was created"
        }
    },
    [415576404] = {
        name = "EVENT_NETWORK_POSSE_DATA_CHANGED",
        hash = "0x18C53154",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [0] = "unknown"
        }
    },
    [1553659161] = {
        name = "EVENT_REVIVE_ENTITY",
        hash = "0x5C9AF519",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = "reviver ped id",
            [2] = "used inventory item hash",
            [0] = "VictimEntityId"
        }
    },
    [2114586158] = {
        name = "EVENT_NETWORK_CREW_DISBANDED",
        hash = "0x7E0A062E",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [0] = "isDisbandingSuccessful"
        }
    },
    [-178091376] = {
        name = "EVENT_PLAYER_COLLECTED_AMBIENT_PICKUP",
        hash = "0xF5628A90",
        datasize = 8,
        group = 0,
        dataelements = {
            [1] = "unknown (??? pickup entity id)",
            [2] = "player id",
            [3] = "pickup model hash",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "collected inventory item quantity",
            [7] = "inventory item hash",
            [0] = "pickup name hash"
        }
    },
    [-97516606] = {
        name = "EVENT_NETWORK_LASSO_ATTACH",
        hash = "0xFA3003C2",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "PerpitratorEntityId",
            [0] = "VictimEntityId"
        }
    },
    [1274067014] = {
        name = "EVENT_NETWORK_PLAYER_COLLECTED_PORTABLE_PICKUP",
        hash = "0x4BF0B846",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = "player id",
            [2] = "unknown",
            [0] = "collected pickup network id"
        }
    },
    [678947301] = {
        name = "EVENT_NETWORK_GANG_WAYPOINT_CHANGED",
        hash = "0x2877E9E5",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [0] = "Gang Waypoint Changing type id ( [list](#gang-waypoint-changing-type-ids) )"
        }
    },
    [-582361627] = {
        name = "EVENT_CARRIABLE_PROMPT_INFO_REQUEST",
        hash = "0xDD49DDE5",
        datasize = 6,
        group = 0,
        dataelements = {
            [1] = "carry action id ( [list](#carry-action-ids) )",
            [2] = "unknown",
            [3] = "vehicle entity id (parent id)",
            [4] = "unknown",
            [5] = "unknown",
            [0] = "CarriableEntityId"
        }
    },
    [797969925] = {
        name = "EVENT_NETWORK_POSSE_EX_INACTIVE_DISBANDED",
        hash = "0x2F900E05",
        datasize = 10,
        group = 1,
        dataelements = {
            [1] = "unknown (??? posse name)",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "unknown",
            [0] = "unknown"
        }
    },
    [-1171710795] = {
        name = "EVENT_NETWORK_REVIVED_ENTITY",
        hash = "0xBA291CB5",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "Reviver entity id",
            [0] = "Victim entity id"
        }
    },
    [2145012826] = {
        name = "EVENT_ENTITY_DESTROYED",
        hash = "0x7FDA4C5A",
        datasize = 9,
        group = 0,
        dataelements = {
            [1] = "object (or ped id) that caused damage to the entity",
            [2] = "weaponHash that damaged the entity  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )",
            [3] = "ammo hash that damaged the entity ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua) )",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [0] = "destroyed entity id"
        }
    },
    [-1241852893] = {
        name = "EVENT_CARRIABLE_VEHICLE_STOW_START",
        hash = "0xB5FAD423",
        datasize = 5,
        group = 0,
        dataelements = {
            [1] = "carriable entity id",
            [2] = "vehicle entity id",
            [3] = "unknown",
            [4] = "unknown",
            [0] = "unknown"
        }
    },
    [-919500771] = {
        name = "EVENT_NETWORK_HOGTIE_END",
        hash = "0xC931881D",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "PerpitratorEntityId",
            [0] = "VictimEntityId"
        }
    },
    [-2119801478] = {
        name = "EVENT_NETWORK_SESSION_MERGE_END",
        hash = "0x81A6657A",
        datasize = 1,
        group = 1,
        dataelements = {
            [0] = "session message id ( [list](#event_network_session_merge_end-message-ids))"
        }
    },
    [-1507090758] = {
        name = "EVENT_SHOT_FIRED_BULLET_IMPACT",
        hash = "0xA62B9EBA",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = "entity id that bullet hit"
        }
    },
    [-843924932] = {
        name = "EVENT_NETWORK_PLAYER_DROPPED_PORTABLE_PICKUP",
        hash = "0xCDB2BA3C",
        datasize = 3,
        group = 1,
        dataelements = {
            [1] = "player id",
            [2] = "unknown",
            [0] = "collected pickup network id"
        }
    },
    [1505348054] = {
        name = "EVENT_INVENTORY_ITEM_REMOVED",
        hash = "0x59B9C9D6",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = "inventory item hash"
        }
    },
    [23105215] = {
        name = "EVENT_NETWORK_POSSE_LEADER_SET_ACTIVE",
        hash = "0x01608EBF",
        datasize = 23,
        group = 1,
        dataelements = {
            [1] = "unknown (??? posse name)",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "network gamer handle",
            [10] = "unknown",
            [11] = "unknown",
            [12] = "unknown",
            [13] = "unknown",
            [14] = "unknown",
            [15] = "unknown",
            [16] = "unknown",
            [17] = "unknown",
            [18] = "unknown",
            [19] = "unknown",
            [20] = "unknown",
            [21] = "unknown",
            [22] = "unknown",
            [0] = "posse id"
        }
    },
    [1417095237] = {
        name = "EVENT_BUCKED_OFF",
        hash = "0x54772845",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = "mount id",
            [2] = "unknown",
            [0] = "rider id"
        }
    },
    [-1126217932] = {
        name = "EVENT_NETWORK_MINIGAME_REQUEST_COMPLETE",
        hash = "0xBCDF4734",
        datasize = 6,
        group = 1,
        dataelements = {
            [1] = "seatRequestData1",
            [2] = "seatRequestData2",
            [3] = "seatRequestData3",
            [4] = "isSuccess",
            [5] = "MinigameErrorCodeHash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/minigame_error_codes.lua ))",
            [0] = "seatRequestData0"
        }
    },
    [353377915] = {
        name = "EVENT_HOGTIED_ENTITY_PICKED_UP",
        hash = "0x15101E7B",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "carrier ped id",
            [0] = "hogtied ped id"
        }
    },
    [-369170747] = {
        name = "EVENT_PLAYER_HAT_EQUIPPED",
        hash = "0xE9FEE6C5",
        datasize = 10,
        group = 0,
        dataelements = {
            [1] = "hat entity id",
            [2] = "hat drawble hash",
            [3] = "hat albedo hash",
            [4] = "hat normal hash",
            [5] = "hat material hash",
            [6] = "hat palette hash",
            [7] = "hat tint1",
            [8] = "hat tint2",
            [9] = "hat tint3",
            [0] = "player ped id"
        }
    },
    [1694142010] = {
        name = "EVENT_NETWORK_BOUNTY_REQUEST_COMPLETE",
        hash = "0x64FA8E3A",
        datasize = 7,
        group = 1,
        dataelements = {
            [2] = "unknown",
            [3] = "unknown",
            [4] = "Result code",
            [5] = "Total Value",
            [6] = "Pay Off Value",
            [0] = "unknown (??? request id)"
        }
    },
    [1234888675] = {
        name = "EVENT_NETWORK_CREW_CREATION",
        hash = "0x499AE7E3",
        datasize = 10,
        group = 1,
        dataelements = {
            [1] = "crew id",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "unknown",
            [0] = "isCreationSuccessful"
        }
    },
    [1028782110] = {
        name = "EVENT_NETWORK_CREW_INVITE_RECEIVED",
        hash = "0x3D51F81E",
        datasize = 11,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [2] = "unknown",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "unknown",
            [10] = "hasMessage",
            [0] = "id"
        }
    },
    [-1130756835] = {
        name = "EVENT_DAILY_CHALLENGE_STREAK_COMPLETED",
        hash = "0xBC9A051D",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = "unknown (???isDailyChallengeStreakCompleted)"
        }
    },
    [753021595] = {
        name = "EVENT_NETWORK_CREW_KICKED",
        hash = "0x2CE2329B",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "primary",
            [0] = "crew id"
        }
    },
    [1081092949] = {
        name = "EVENT_INVENTORY_ITEM_PICKED_UP",
        hash = "0x40702B55",
        datasize = 5,
        group = 0,
        dataelements = {
            [1] = "picked up entity model ",
            [2] = "isItemWasUsed",
            [3] = "isItemWasBought",
            [4] = "picked up entity id",
            [0] = "inventory item hash"
        }
    },
    [1387172233] = {
        name = "EVENT_PLAYER_PROMPT_TRIGGERED",
        hash = "0x52AE9189",
        datasize = 10,
        group = 0,
        dataelements = {
            [1] = "unknown",
            [2] = "target entity id",
            [3] = "unknown (??? discovered inventory item)",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "discoverable entity type id ( [list](#discoverable-entity-type-ids) )",
            [8] = "unknown",
            [9] = "kit_emote_action hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/animations/kit_emotes_list.lua))",
            [0] = "prompt type id ( [list](#prompt-type-ids) )"
        }
    },
    [-569301261] = {
        name = "EVENT_MISS_INTENDED_TARGET",
        hash = "0xDE1126F3",
        datasize = 3,
        group = 0,
        dataelements = {
            [1] = "entity id that was shot",
            [2] = "weaponhash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua))",
            [0] = "shooter ped id"
        }
    },
    [-231935285] = {
        name = "EVENT_NETWORK_POSSE_CREATED",
        hash = "0xF22CF2CB",
        datasize = 10,
        group = 1,
        dataelements = {
            [1] = "posse id",
            [2] = "unknown (??? posse name)",
            [3] = "unknown",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "unknown",
            [9] = "unknown",
            [0] = "isSuccess"
        }
    },
    [-1730772208] = {
        name = "EVENT_OBJECT_INTERACTION",
        hash = "0x98D68310",
        datasize = 10,
        group = 0,
        dataelements = {
            [1] = "interaction entity id ",
            [2] = "inventory item hash",
            [3] = "inventory item quantity",
            [4] = "unknown",
            [5] = "unknown",
            [6] = "unknown",
            [7] = "unknown",
            [8] = "scenario point id",
            [9] = "unknown",
            [0] = "ped id"
        }
    },
    [-456923784] = {
        name = "EVENT_SCENARIO_REMOVE_PED",
        hash = "0xE4C3E578",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "unknown",
            [0] = "iScriptUID"
        }
    },
    [1165534493] = {
        name = "EVENT_HEADSHOT_BLOCKED_BY_HAT",
        hash = "0x4578A51D",
        datasize = 2,
        group = 0,
        dataelements = {
            [1] = "Inflictor entity id",
            [0] = "Victim entity id"
        }
    },
    [1638298852] = {
        name = "EVENT_MOUNT_OVERSPURRED",
        hash = "0x61A674E4",
        datasize = 6,
        group = 0,
        dataelements = {
            [1] = "mount id",
            [2] = "unknown",
            [3] = "the number of times the horse has overspurred",
            [4] = "maximum number or times the horse can be overspurred before buck off rider",
            [5] = "unknown",
            [0] = "rider id"
        }
    },
    [-1315453179] = {
        name = "EVENT_NETWORK_CREW_JOINED",
        hash = "0xB197C705",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "unknown",
            [0] = "unknown"
        }
    },
    [1352063587] = {
        name = "EVENT_CONTAINER_INTERACTION",
        hash = "0x5096DA63",
        datasize = 4,
        group = 0,
        dataelements = {
            [1] = "searched entity id",
            [2] = "unknown",
            [3] = "isContainerClosed after interaction",
            [0] = "searcher ped id"
        }
    },
    [-140551285] = {
        name = "EVENT_ENTITY_EXPLOSION",
        hash = "0xF79F5B8B",
        datasize = 6,
        group = 0,
        dataelements = {
            [1] = "unknown",
            [2] = "weaponhash( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )",
            [3] = "explosion coord x",
            [4] = "explosion coord y",
            [5] = "explosion coord z",
            [0] = "ped id who did explosion"
        }
    },
    [-1065733433] = {
        name = "EVENT_NETWORK_HOGTIE_BEGIN",
        hash = "0xC07A32C7",
        datasize = 2,
        group = 1,
        dataelements = {
            [1] = "PerpitratorEntityId",
            [0] = "VictimEntityId"
        }
    },
    [-1985279805] = {
        name = "EVENT_CALM_PED",
        hash = "0x89AB08C3",
        datasize = 4,
        group = 0,
        dataelements = {
            [1] = "mount ped id",
            [2] = "CalmTypeId ( [list](#calm-type-ids) )",
            [3] = "isFullyCalmed",
            [0] = "calmer ped id"
        }
    }
}
