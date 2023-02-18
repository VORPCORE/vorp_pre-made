function processEventValidation(ms = 1000) {
    isValidating = true;
    const timer = setTimeout(() => {
        isValidating = false;
        clearTimeout(timer);
    }, ms)
}

function isInt(n) {
    return n != "" && !isNaN(n) && Math.round(n) == n;
}
function isFloat(n){
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

function secondarySetCurrentCapacity(cap) {
    document.getElementById('current-cap-value').innerHTML = cap
}

function secondarySetCapacity(cap) {
    secondaryCapacityAvailable = true
    $(".capacity").show();
    document.getElementById('capacity-value').innerHTML = cap
    secondarySetCurrentCapacity('0')
}

function hideSecondaryCapacity() {
    secondaryCapacityAvailable = false
    $(".capacity").hide();
}

function initiateSecondaryInventory(id, title, capacity) {
    $("#secondInventoryHud").fadeIn();
    secondarySetTitle(title);

    if (capacity) {
        secondarySetCapacity(capacity);
    } else {
        // Backwards compatible, inventory capacity will not show
        hideSecondaryCapacity();
    }
}

function initDivMouseOver() {
    if (isOpen === true) {
        var div = document.getElementById("inventoryElement");
        div.mouseIsOver = false;
        div.onmouseover = function () {
            this.mouseIsOver = true;
            $.post("http://vorp_inventory/sound");
        };
        div.onmouseout = function () {
            this.mouseIsOver = false;


        }
        div.onclick = function () {
            if (this.mouseIsOver) {


            }
        }
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

/*function selectPlayerToGive(data) {
    const timer = setTimeout(() => {
        clearTimeout(timer);
        dialog.prompt({
            title: LANGUAGE.toplayerpromptitle,
            button: LANGUAGE.toplaterpromptaccept,
            required: false,
            item: data,
            type: data.type,
            select: true,
            validate: function (value, data, player) {
                $.post("http://vorp_inventory/GiveItem", JSON.stringify({
                    player: player,
                    data: data
                }));
                return true;
            }
        });
    }, 300);
}*/

function validatePlayerSelection(player) {
    const data = objToGive;

    $.post("http://vorp_inventory/GiveItem", JSON.stringify({
        player: player,
        data: data
    }));
    $('#character-selection').hide();

    // reset obj to give, for security
    objToGive = {}
}

/**
 * @param {object} data
 }**/
function selectPlayerToGive(data)
{
    objToGive = data; // save obj to give during process
    const characters = data.players;

    $('#character-select-title').html(LANGUAGE.toplayerpromptitle);
    characters.sort((a, b) => a.label.toString().localeCompare(b.label.toString()));

    $('#character-list').html('');
    characters.forEach(character => {
        $('#character-list').append(`<li class="list-item" id="character-${character.player}" data-player="${character.player}" onclick="validatePlayerSelection(${character.player})">${character.label}</li>`)
    })
    $('#character-selection').show();
}

function closeCharacterSelection() {
    // reset obj to give, for security
    objToGive = {}
    $('#character-selection').hide();
}

function dropGetHowMany(item, type, hash, id, metadata) {
    if (type != "item_weapon") {
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
                if (!value) {
                    dialog.close()
                    return;
                }
                if (!isInt(value)) {
                        return;
                } 
                $.post("http://vorp_inventory/DropItem", JSON.stringify({
                    item: item,
                    id: id,
                    type: type,
                    number: value,
                    metadata: metadata
                }));
                return true;
            }
        });
    } else {
        $.post("http://vorp_inventory/DropItem", JSON.stringify({
            item: item,
            type: type,
            hash: hash,
            id: parseInt(id)
        }));
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
                autofocus: "true"
            },
            validate: function (value, item, type) {
                if (!value) {
                    console.log('[giveGetHowMany] Error: given value is nil or 0. Closing Dialog');
                    dialog.close()
                    return;
                }
                if (!isInt(value)) {
                    console.log('[giveGetHowMany] Error: given value is not an integer. Closing Dialog');
                    dialog.close()
                    return;
                }
                $.post("http://vorp_inventory/GetNearPlayers", JSON.stringify({
                    type: type,
                    what: "give",
                    item: item,
                    id: id,
                    count: value,
                    metadata: metadata
                }));
                return true;
            }
        });
    } else {
        $.post("http://vorp_inventory/GetNearPlayers", JSON.stringify({
            type: type,
            what: "give",
            item: item,
            hash: hash,
            id: parseInt(id)
        }));
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
            autofocus: "true"
        },
        validate: function (value, item, type) {
            if (!value) {
                dialog.close()
                return;
            }
            $.post("http://vorp_inventory/GetNearPlayers", JSON.stringify({
                type: type,
                what: "give",
                item: item,
                count: value
            }));
            return true;
        }
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
            $.post("http://vorp_inventory/GetNearPlayers", JSON.stringify({
                type: type,
                what: "give",
                item: item,
                count: value
            }));
            return true;
        }
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
            autofocus: "true"
        },
        validate: function(value, item, type) {
            if (!value) {
                dialog.close()
                return;
            }
            $.post("http://vorp_inventory/GetNearPlayers", JSON.stringify({
                type: type,
                what: "give",
                item: item,
                count: value
            }));
            return true;
        }
    });

}

function closeInventory() {
    $.post("http://vorp_inventory/NUIFocusOff", JSON.stringify({}));
    isOpen = false;
}