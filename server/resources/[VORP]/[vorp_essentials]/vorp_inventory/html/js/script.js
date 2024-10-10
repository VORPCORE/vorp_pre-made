$("document").ready(function () {

    $("#secondInventoryHud").draggable();
    $("#inventoryHud").draggable();

    $("#inventoryHud").hide();
    $("#secondInventoryHud").hide();
    $('#character-selection').hide();
    $('#disabler').hide();

    $("body").on("keyup", function (key) {
        if (Config.closeKeys.includes(key.which)) {
            if ($('#character-selection').is(":visible")) {
                $('#character-selection').hide();
                $('#disabler').hide();
            } else {
                closeInventory();
                document.querySelectorAll('.dropdownButton[data-type="itemtype"], .dropdownButton1[data-type="itemtype"]').forEach(btn => btn.classList.remove('active'));
                document.querySelector(`.dropdownButton[data-param="all"][data-type="itemtype"], .dropdownButton1[data-param="all"][data-type="itemtype"]`)?.classList.add('active');
            }
        }
    });

    initSecondaryInventoryHandlers();
});


window.onload = initDivMouseOver;

let stopTooltip = false;

window.addEventListener('message', function (event) {

    if (event.data.action == "cacheImages") {
        preloadImages(event.data.info);
    }

    if (event.data.action == "initiate") {
        LANGUAGE = event.data.language
        LuaConfig = event.data.config
        Config.UseGoldItem = LuaConfig.UseGoldItem;
        Config.AddGoldItem = LuaConfig.AddGoldItem;
        Config.AddDollarItem = LuaConfig.AddDollarItem;
        Config.AddAmmoItem = LuaConfig.AddAmmoItem;
        Config.DoubleClickToUse = LuaConfig.DoubleClickToUse;
        Config.UseRolItem = LuaConfig.UseRolItem;
        Config.WeightMeasure = LuaConfig.WeightMeasure;
        // Fetch the Actions configuration from Lua
        loadActionsConfig().then(actionsConfig => {
            generateActionButtons(actionsConfig, 'carousel1', 'inventoryElement', 'dropdownButton');
            generateActionButtons(actionsConfig, 'staticCarousel', 'secondInventoryElement', 'dropdownButton1');
        }).catch(error => {
            console.error("Failed to load or process the Actions configuration:", error);
        });

        if (!Config.UseGoldItem) {
            $("#inventoryHud").addClass("NoGoldBackground")
        }
    }

    if (event.data.action == "reclabels") {
        ammolabels = event.data.labels
    }

    if (event.data.action == "updateammo") {
        if (event.data.ammo) {
            allplayerammo = event.data.ammo
        }
    }

    if (event.data.action == "updateStatusHud") {

        if (event.data.money || event.data.money === 0) {
            $("#money-value").text(event.data.money.toFixed(2) + " ");
        }

        if (Config.UseGoldItem) {
            if (event.data.gold || event.data.gold === 0) {
                $("#gold-value").text(event.data.gold.toFixed(2) + " ");
            }
        }
        if (Config.UseRolItem) {
            if (event.data.rol || event.data.rol === 0) {
                $("#rol-value").text(event.data.rol.toFixed(2) + " ");
            }
        }


        if (event.data.id) {
            $("#id-value").text("ID " + event.data.id);
        }

    } else if (event.data.action == "transaction") {
        let t = event.data.type
        if (t == 'started') {
            let displaytext = event.data.text
            $('#loading-text').html(displaytext)
            $('#transaction-loader').show()
        }
        if (t == 'completed') {
            $('#transaction-loader').hide()
        }
    }

    //main inv update weight
    if (event.data.action == "changecheck") {
        checkxy = event.data.check
        infoxy = event.data.info

        $('#check').html('')
        $("#check").append(`<button id='check'>${checkxy}/${infoxy + " " + Config.WeightMeasure}</button>`);
    }

    //main inv
    if (event.data.action == "display") {
        stopTooltip = false;
        moveInventory("main");
        if (event.data.type != 'main') {
            moveInventory("second");
        }
        $("#inventoryHud").fadeIn();
        $(".controls").remove();
        $("#inventoryHud").append(
            `<div class='controls'><div class='controls-center'><input type='text' id='search' placeholder='${LANGUAGE.inventorysearch}'/input><button id='check'>${checkxy}/${infoxy + " " + Config.WeightMeasure}</button></div><button id='close'>${LANGUAGE.inventoryclose}</button></div></div>`
        );

        $("#search").bind("input", function () {
            var searchFor = $("#search").val().toLowerCase();
            $("#inventoryElement .item").each(function () {
                var label = $(this).data("label");
                if (label) {
                    label = label.toLowerCase();
                    if (label.indexOf(searchFor) < 0) {
                        $(this).hide();
                    } else {
                        $(this).show();
                    }
                }
            });
        });

        type = event.data.type

        if (event.data.type == "player") {
            playerId = event.data.id;

            initiateSecondaryInventory(event.data.title, event.data.capacity)
        }

        if (event.data.type == "custom") {
            customId = event.data.id;
            initiateSecondaryInventory(event.data.title, event.data.capacity, event.data.weight)
        }

        if (event.data.type == "horse") {
            horseid = event.data.horseid;
            initiateSecondaryInventory(event.data.title, event.data.capacity)
        }

        if (event.data.type == "cart") {
            wagonid = event.data.wagonid;
            initiateSecondaryInventory(event.data.title, event.data.capacity)
        }

        if (event.data.type == "house") {
            houseId = event.data.houseId;
            initiateSecondaryInventory(event.data.title, event.data.capacity)
        }
        if (event.data.type == "hideout") {
            hideoutId = event.data.hideoutId;
            initiateSecondaryInventory(event.data.title, event.data.capacity)
        }
        if (event.data.type == "bank") {
            bankId = event.data.bankId;
            initiateSecondaryInventory(event.data.title, event.data.capacity)
        }
        if (event.data.type == "clan") {
            clanid = event.data.clanid;
            initiateSecondaryInventory(event.data.title, event.data.capacity)
        }
        if (event.data.type == "store") {
            StoreId = event.data.StoreId;
            geninfo = event.data.geninfo;
            initiateSecondaryInventory(event.data.title, event.data.capacity)
        }
        if (event.data.type == "steal") {
            stealid = event.data.stealId;
            initiateSecondaryInventory(event.data.title, event.data.capacity)
        }
        if (event.data.type == "Container") {
            Containerid = event.data.Containerid;
            initiateSecondaryInventory(event.data.title, event.data.capacity)
        }


        disabled = false;

        if (event.data.autofocus == true) {
            $(document).on('keydown', function (event) {
                if (!(event.target && event.target.id === 'secondarysearch')) {
                    $("#search").focus();
                }
            });
        }

        $("#close").on('click', function (event) {
            closeInventory();
        });

    } else if (event.data.action == "hide") {
        $('.tooltip').remove();
        $("#inventoryHud").fadeOut();
        $(".controls").fadeOut();
        $(".site-cm-box").remove();
        $("#secondInventoryHud").fadeOut();
        $(".controls").fadeOut();
        $(".site-cm-box").remove();
        if ($('#character-selection').is(":visible")) {
            $('#character-selection').hide();
            $('#disabler').hide();
        }
        dialog.close();
        stopTooltip = true;
    } else if (event.data.action == "setItems") {

        inventorySetup(event.data.itemList);

        if (type != "main") {

            $('.item').draggable({
                helper: 'clone',
                appendTo: 'body',
                zIndex: 99999,
                revert: 'invalid',
                start: function (event, ui) {

                    if (disabled) {
                        return false;
                    }
                    stopTooltip = true;
                    itemData = $(this).data("item");
                    itemInventory = $(this).data("inventory");

                    if (itemInventory === "main") {
                        $("#inventoryHud").fadeOut();
                    } else if (itemInventory === "second") {
                        $("#secondInventoryHud").fadeOut();
                    }

                },
                stop: function () {
                    stopTooltip = false;
                    itemData = $(this).data("item");
                    itemInventory = $(this).data("inventory");

                    if (itemInventory === "main") {
                        $("#inventoryHud").fadeIn();
                    } else if (itemInventory === "second") {
                        $("#secondInventoryHud").fadeIn();
                    }


                }
            });
        }
    } else if (event.data.action == "setSecondInventoryItems") {
        secondInventorySetup(event.data.itemList, event.data.info);

        let l = event.data.itemList.length
        let itemlist = event.data.itemList
        let total = 0
        let p = 0
        for (p; p < l; p++) {
            total += Number(itemlist[p].count)
        }
        let weight = null
        //amount of items in Inventory
        secondarySetCurrentCapacity(total, weight)
    } else if (event.data.action == "nearPlayers") {
        if (event.data.what == "give") {
            selectPlayerToGive(event.data);
        }
    }
});

window.addEventListener("offline", function () {
    closeInventory()
});

//for gold cash and ID
