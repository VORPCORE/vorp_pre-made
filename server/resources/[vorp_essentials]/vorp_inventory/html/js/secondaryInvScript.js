function initSecondaryInventoryHandlers() {
    $('#inventoryElement').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");



            if (type === "custom" && itemInventory === "second") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },

                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (! isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/TakeFromCustom", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    id: customId
                                }));
                            }

                        }
                    });
                } else {
                    if (! isValidating) {
                         processEventValidation();
                        $.post("http://vorp_inventory/TakeFromCustom", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            id: customId
                        }));
                    }
                }
            
            } else if (type === "horse" && itemInventory === "second") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },

                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/TakeFromHorse", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    horse: horseid
                                }));
                            }

                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/TakeFromHorse", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            horse: horseid
                        }));
                    }
                }
            } else if (type === "store" && itemInventory === "second") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },

                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/TakeFromStore", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    price: itemData.price,
                                    geninfo:geninfo,
                                    store: StoreId
                                }));
                            }

                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/TakeFromStore", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            price: itemData.price,
                            geninfo:geninfo,
                            store: StoreId
                        }));
                    }
                }
            } else if (type === "cart" && itemInventory === "second") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },

                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/TakeFromCart", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    wagon: wagonid,
                                    number: value
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/TakeFromCart", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            wagon: wagonid,
                            number: 1
                        }));
                    }
                }
            } else if (type === "house" && itemInventory === "second") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/TakeFromHouse", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    house: houseId
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/TakeFromHouse", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            house: houseId
                        }));
                    }

                }
            } else if (type === "hideout" && itemInventory === "second") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/TakeFromHideout", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    hideout: hideoutId
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/TakeFromHideout", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            hideout: hideoutId
                        }));
                    }
                }
            } else if (type === "bank" && itemInventory === "second") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }
                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/TakeFromBank", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    bank: bankId
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/TakeFromBank", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            bank: bankId
                        }));
                    }
                }
                
            } else if (type === "clan" && itemInventory === "second") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/TakeFromClan", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    clan: clanid
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/TakeFromClan", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            clan: clanid
                        }));
                    }
                }
            } else if (type === "steal" && itemInventory === "second") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/TakeFromsteal", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    steal: stealid
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/TakeFromsteal", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            steal: stealid
                        }));
                    }
                }
            } else if (type === "Container" && itemInventory === "second") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/TakeFromContainer", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    Container: Containerid
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/TakeFromContainer", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            Container: Containerid
                        }));
                    }
                }
            }
        }
    });

    $('#secondInventoryElement').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");


            if (type === "custom" && itemInventory === "main") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/MoveToCustom", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    id: customId
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/MoveToCustom", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            id: customId
                        }));
                }

                }

            } else if (type === "horse" && itemInventory === "main") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/MoveToHorse", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    horse: horseid
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/MoveToHorse", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            horse: horseid
                        }));
                    }

                }
            } else if (type === "store" && itemInventory === "main") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }
                            if (geninfo.isowner != 0) {
                                if (!isValidating) {
                                    processEventValidation();
                                    dialog.prompt({
                                        title: LANGUAGE.prompttitle2,
                                        button: LANGUAGE.promptaccept,
                                        required: true,
                                        item: itemData,
                                        type: itemData.type,
                                        input: {
                                            type: "number",
                                            autofocus: "true"
                                        },
                                        validate: function (value2, item, type) {
                                            if (!value2) {
                                                dialog.close()
                                                return;
                                            }
                                        
                                            
                                        
                                            if (!isValidating) {
                                                processEventValidation();
                                                $.post("http://vorp_inventory/MoveToStore", JSON.stringify({
                                                    item: itemData,
                                                    type: type,
                                                    number: value,
                                                    price:value2,
                                                    geninfo:geninfo,
                                                    store: StoreId
                                                }));
                                            }
                                        }
                                    });
                                }
                            } else {
                                if (!isValidating) {
                                    processEventValidation();
                                    $.post("http://vorp_inventory/MoveToStore", JSON.stringify({
                                        item: itemData,
                                        type: type,
                                        number: value,
                                        geninfo:geninfo,
                                        store: StoreId
                                    }));
                                }

                            }
                        }
                    });
                   
                } else {
                    if (geninfo.isowner != 0) {
                        if (!isValidating) {
                            processEventValidation();
                            dialog.prompt({
                                title: LANGUAGE.prompttitle2,
                                button: LANGUAGE.promptaccept,
                                required: true,
                                item: itemData,
                                type: itemData.type,
                                input: {
                                    type: "number",
                                    autofocus: "true"
                                },
                                validate: function (value2, item, type) {
                                    if (!value2) {
                                        dialog.close()
                                        return;
                                    }
                                
                                    
                                
                                    if (!isValidating) {
                                        processEventValidation();
                                        $.post("http://vorp_inventory/MoveToStore", JSON.stringify({
                                            item: itemData,
                                            type: itemData.type,
                                            number: 1,
                                            price:value2,
                                            geninfo:geninfo,
                                            store: StoreId
                                        }));
                                    }
                                }
                            });
                        
                        }
                    }else {
                        if (!isValidating) {
                            processEventValidation();
                            $.post("http://vorp_inventory/MoveToStore", JSON.stringify({
                                item: itemData,
                                type: itemData.type,
                                number: 1,
                                geninfo:geninfo,
                                store: StoreId
                            }));
                        }
                    }

                }
            } else if (type === "cart" && itemInventory === "main") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/MoveToCart", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    wagon: wagonid,
                                    number: value
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/MoveToCart", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            wagon: wagonid,
                            number: 1
                        }));
                    }
                }

            } else if (type === "house" && itemInventory === "main") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }
                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/MoveToHouse", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    house: houseId
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/MoveToHouse", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            house: houseId
                        }));
                    }
                }
            } else if (type === "hideout" && itemInventory === "main") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/MoveToHideout", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    hideout: hideoutId
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/MoveToHideout", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            hideout: hideoutId
                        }));
                    }
                }
            } else if (type === "bank" && itemInventory === "main") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }


                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/MoveToBank", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    bank: bankId
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/MoveToBank", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            bank: bankId
                        }));
                    }
                }
            } else if (type === "clan" && itemInventory === "main") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/MoveToClan", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    clan: clanid
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/MoveToClan", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            clan: clanid
                        }));
                    }
                }

            } else if (type === "steal" && itemInventory === "main") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/MoveTosteal", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    steal: stealid
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/MoveTosteal", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            steal: stealid
                        }));
                    }
                }

            } else if (type === "Container" && itemInventory === "main") {
                disableInventory(500);
                if (itemData.type != "item_weapon") {
                    dialog.prompt({
                        title: LANGUAGE.prompttitle,
                        button: LANGUAGE.promptaccept,
                        required: true,
                        item: itemData,
                        type: itemData.type,
                        input: {
                            type: "number",
                            autofocus: "true"
                        },
                        validate: function (value, item, type) {
                            if (!value) {
                                dialog.close()
                                return;
                            }

                            if (!isInt(value)) {
                                return;
                            }

                            if (!isValidating) {
                                processEventValidation();
                                $.post("http://vorp_inventory/MoveToContainer", JSON.stringify({
                                    item: itemData,
                                    type: type,
                                    number: value,
                                    Container: Containerid
                                }));
                            }
                        }
                    });
                } else {
                    if (!isValidating) {
                        processEventValidation();
                        $.post("http://vorp_inventory/MoveToContainer", JSON.stringify({
                            item: itemData,
                            type: itemData.type,
                            number: 1,
                            Container: Containerid
                        }));
                    }
                }

            }
        }
    });
}

function secondInventorySetup(items) {
    $("#inventoryElement").html("");
    $("#secondInventoryElement").html("");

    $.each(items, function (index, item) {
        count = item.count;

        if (item.type !== "item_weapon") {
            $("#secondInventoryElement").append(`
                <div data-label="${item.label}"' 
                style='background-image: url(\"img/items/${item.name.toLowerCase()}.png\"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;'
                id="item-${index}" class='item'>
                    ${count > 0 ? `<div class='count'>${count}</div>` : ``}
                    <div class='text'></div>
                </div>
            `)
        } else {
            $("#secondInventoryElement").append("<div data-label='" + item.label +
            "' style='background-image: url(\"img/items/" + item.name.toLowerCase() +
            ".png\"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;' id='item-" +
            index + "' class='item'></div></div>")
        }

        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "second");

        $("#item-" + index).hover(
            function () {
                OverSetTitleSecond(item.label);
            },
            function () {
                OverSetTitleSecond(" ");
            }
        );

        $("#item-" + index).hover(
            function() {
                if (item.type !== "item_weapon") {
                    OverSetDescSecond(!!item.metadata && !!item.metadata.description ? item.metadata.description : '');
                } else {
                    OverSetDescSecond(!!item.desc ? item.desc : '');
                }
            },
            function() {
                OverSetDescSecond(" ");
            }
        );

    });
}
