function processEventValidation(ms = 1000) {
    isValidating = true;
    const timer = setTimeout(() => {
        isValidating = false;
        clearTimeout(timer);
    }, ms);
}

function isInt(n) {
    return n != "" && !isNaN(n) && Math.round(n) == n;
}
function isFloat(n) {
    return Number(n) === n && n % 1 !== 0;
}
function OverSetTitle(title) {
    document.getElementById("information").innerHTML = title;
}

function OverSetTitleSecond(title) {
    document.getElementById("information2").innerHTML = title;
}

function OverSetDesc(title) {
    document.getElementById("description").innerHTML = title;
}

function OverSetDescSecond(desc) {
    document.getElementById("description2").innerHTML = desc;
}

function secondarySetTitle(title) {
    document.getElementById("titleHorse").innerHTML = title;
}
//amount of items
function secondarySetCurrentCapacity(cap) {
    document.getElementById("current-cap-value").innerHTML = cap;
}

//capacty of inventory
function secondarySetCapacity(cap, weight) {
    $(".capacity").show();
    document.getElementById("capacity-value").innerHTML = weight ? weight + " " + Config.WeightMeasure : cap;
}

function getGroupKey(group) {
    let groupKey;
    if (window.Actions && Object.keys(window.Actions).length > 0) {
        groupKey = Object.keys(window.Actions).find(key =>
            key !== "all" && window.Actions[key].types.includes(group)
        );
    }
    return groupKey;
}


function initiateSecondaryInventory(title, capacity, weight) {

    $("#secondInventoryHud").append(
        `<div class='controls'><div class='controls-center'><input type='text' id='secondarysearch' placeholder='${LANGUAGE.inventorysearch}'/></div></div>`
    );

    $("#secondarysearch").bind("input", function () {
        var searchFor = $("#secondarysearch").val().toLowerCase();
        $("#secondInventoryElement .item").each(function () {
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

    $("#secondInventoryHud").fadeIn();
    secondarySetTitle(title);

    if (capacity) {
        secondarySetCapacity(capacity, weight);
    } else {
        secondarySetCapacity("0")
    }
}

function initDivMouseOver() {
    if (isOpen === true) {
        var div = document.getElementById("inventoryElement");
        div.mouseIsOver = false;
        div.onmouseover = function () {
            this.mouseIsOver = true;
            $.post(`https://${GetParentResourceName()}/sound`);
        };
        div.onmouseout = function () {
            this.mouseIsOver = false;
        };
        div.onclick = function () {
            if (this.mouseIsOver) {
            }
        };
    }
}

function Interval(time) {
    var timer = false;
    this.start = function () {
        if (this.isRunning()) {
            clearInterval(timer);
            timer = false;
        }

        timer = setInterval(function () {
            disabled = false;
        }, time);
    };
    this.stop = function () {
        clearInterval(timer);
        timer = false;
    };
    this.isRunning = function () {
        return timer !== false;
    };
}

function disableInventory(ms) {
    disabled = true;

    if (disabledFunction === null) {
        disabledFunction = new Interval(ms);
        disabledFunction.start();
    } else {
        if (disabledFunction.isRunning()) {
            disabledFunction.stop();
        }

        disabledFunction.start();
    }
}

function validatePlayerSelection(player) {
    const data = objToGive;
    secureCallbackToNui("vorp_inventory", "GiveItem", {
        player: player,
        data: data,
    });

    $("#disabler").hide();
    $("#character-selection").hide();

    // reset obj to give, for security
    objToGive = {};
}

/**
 * @param {object} data
 }**/
function selectPlayerToGive(data) {
    $("#disabler").show();
    objToGive = data; // save obj to give during process
    const characters = data.players;

    $("#character-select-title").html(LANGUAGE.toplayerpromptitle);
    characters.sort((a, b) =>
        a.label.toString().localeCompare(b.label.toString())
    );

    $("#character-list").html("");
    characters.forEach((character) => {
        $("#character-list").append(
            `<li class="list-item" id="character-${character.player}" data-player="${character.player}" onclick="validatePlayerSelection(${character.player})">${character.label}</li>`
        );
    });
    $("#character-selection").show();
}

function closeCharacterSelection() {
    // reset obj to give, for security
    objToGive = {};
    $("#disabler").hide();
    $("#character-selection").hide();
}

function dropGetHowMany(item, type, hash, id, metadata, count) {
    if (type != "item_weapon") {
        if (count && count === 1) {
            secureCallbackToNui("vorp_inventory", "DropItem", {
                item: item,
                id: id,
                type: type,
                number: 1,
                metadata: metadata,
            });
        } else {
            dialog.prompt({
                title: LANGUAGE.prompttitle,
                button: LANGUAGE.promptaccept,
                required: true,
                item: item,
                type: type,
                input: {
                    type: "number",
                    autofocus: "true",
                },
                validate: function (value, item, type) {
                    if (!value || value <= 0) {
                        dialog.close();
                        return;
                    }

                    if (type !== "item_money" && type !== "item_gold") {
                        if (!isInt(value)) {
                            return;
                        }
                    }

                    secureCallbackToNui("vorp_inventory", "DropItem", {
                        item: item,
                        id: id,
                        type: type,
                        number: value,
                        metadata: metadata,
                    });

                    return true;
                },
            });
        }
    } else {
        secureCallbackToNui("vorp_inventory", "DropItem", {
            item: item,
            type: type,
            hash: hash,
            id: parseInt(id),
        });
    }
}

function giveGetHowMany(item, type, hash, id, metadata) {
    if (type != "item_weapon") {
        dialog.prompt({
            title: LANGUAGE.prompttitle,
            button: LANGUAGE.promptaccept,
            required: false,
            item: item,
            type: type,
            input: {
                type: "number",
                autofocus: "true",
            },
            validate: function (value, item, type) {
                if (!value || value <= 0) {
                    dialog.close();
                    return;
                }
                if (!isInt(value)) {
                    dialog.close();
                    return;
                }
                $.post(
                    `https://${GetParentResourceName()}/GetNearPlayers`,
                    JSON.stringify({
                        type: type,
                        what: "give",
                        item: item,
                        id: id,
                        count: value,
                        metadata: metadata,
                    })
                );
                return true;
            },
        });
    } else {
        $.post(
            `https://${GetParentResourceName()}/GetNearPlayers`,
            JSON.stringify({
                type: type,
                what: "give",
                item: item,
                hash: hash,
                id: parseInt(id),
            })
        );
    }
}

function giveGetHowManyMoney() {
    dialog.prompt({
        title: LANGUAGE.prompttitle,
        button: LANGUAGE.promptaccept,
        required: true,
        item: "money",
        type: "item_money",
        input: {
            type: "number",
            autofocus: "true",
        },
        validate: function (value, item, type) {
            if (!value || value <= 0) {
                dialog.close();
                return;
            }
            $.post(
                `https://${GetParentResourceName()}/GetNearPlayers`,
                JSON.stringify({
                    type: type,
                    what: "give",
                    item: item,
                    count: value,
                })
            );
            return true;
        },
    });
}

function giveammotoplayer(ammotype) {
    dialog.prompt({
        title: LANGUAGE.prompttitle,
        button: LANGUAGE.promptaccept,
        required: true,
        item: ammotype,
        type: "item_ammo",
        input: {
            type: "number",
            autofocus: "true",
        },
        validate: function (value, item, type) {
            if (!value || value <= 0) {
                dialog.close();
                return;
            }
            if (!isInt(value)) {
                return;
            }
            $.post(
                `https://${GetParentResourceName()}/GetNearPlayers`,
                JSON.stringify({
                    type: type,
                    what: "give",
                    item: item,
                    count: value,
                })
            );
            return true;
        },
    });
}

function giveGetHowManyGold() {
    dialog.prompt({
        title: LANGUAGE.prompttitle,
        button: LANGUAGE.promptaccept,
        required: true,
        item: "gold",
        type: "item_gold",
        input: {
            type: "number",
            autofocus: "true",
        },
        validate: function (value, item, type) {
            if (!value || value <= 0) {
                dialog.close();
                return;
            }
            $.post(
                `https://${GetParentResourceName()}/GetNearPlayers`,
                JSON.stringify({
                    type: type,
                    what: "give",
                    item: item,
                    count: value,
                })
            );
            return true;
        },
    });
}

function closeInventory() {
    $('.tooltip').remove();
    $.post(`https://${GetParentResourceName()}/NUIFocusOff`, JSON.stringify({}));
    isOpen = false;
}
