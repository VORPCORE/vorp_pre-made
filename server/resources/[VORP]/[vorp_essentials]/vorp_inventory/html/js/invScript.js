let imageCache = {};

function preloadImages(images) {

    $.each(images, function (index, image) {
        const img = new Image();
        img.onload = () => {
            imageCache[image] = `url("img/items/${image}.png");`;
        };
        img.onerror = () => {
            imageCache[image] = `url("img/items/placeholder.png");`;
        };
        img.src = `img/items/${image}.png`;
    });

}

/* DROP DOWN BUTTONS MAIN AND SECONDARY INVENTORY */
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.dropdownButton[data-type="clothing"], .dropdownButton1[data-type="clothing"]').forEach(button => {
        button.classList.add('active');
    });
});


function bindButtonEventListeners() {
    document.querySelectorAll('.dropdownButton[data-type="itemtype"]').forEach(button => {
        button.addEventListener('mouseenter', function () {
            OverSetTitle(this.getAttribute('data-param'));
            OverSetDesc(this.getAttribute('data-desc'));
        });
        button.addEventListener('mouseleave', function () {
            OverSetTitle(" ");
            OverSetDesc(" ");
        });
    });
}

function bindSecondButtonEventListeners() {
    document.querySelectorAll('.dropdownButton1[data-type="itemtype"]').forEach(button => {
        button.addEventListener('mouseenter', function () {
            OverSetTitleSecond(this.getAttribute('data-param'));
            OverSetDescSecond(this.getAttribute('data-desc'));
        });
        button.addEventListener('mouseleave', function () {
            OverSetTitleSecond(" ");
            OverSetDescSecond(" ");
        });
    });
}

document.addEventListener('DOMContentLoaded', function () {
    bindButtonEventListeners();
    // For the second inventory buttons
    bindSecondButtonEventListeners();

    document.querySelectorAll('.dropdownButton[data-type="clothing"]').forEach(button => {
        button.addEventListener('mouseenter', function () {
            OverSetTitle(this.getAttribute('data-param'));
            OverSetDesc(this.getAttribute('data-desc'));
        });
        button.addEventListener('mouseleave', function () {
            OverSetTitle(" ");
            OverSetDesc(" ");
        });
    });
});

function toggleDropdown(mainButton) {
    const dropdownButtonsContainers = document.querySelectorAll('.dropdownButtonContainer');
    dropdownButtonsContainers.forEach((container) => {
        if (container.classList.contains(mainButton)) {
            const isVisible = container.classList.toggle('showDropdown');
            const parentCarouselContainer = container.closest('.carouselContainer');
            if (parentCarouselContainer) {
                const controls = parentCarouselContainer.querySelectorAll('.carousel-control');
                controls.forEach(control => control.style.visibility = isVisible ? 'visible' : 'hidden');
            }
        } else {
            container.classList.remove('showDropdown');
            const otherParentCarouselContainer = container.closest('.carouselContainer');
            if (otherParentCarouselContainer) {
                const controls = otherParentCarouselContainer.querySelectorAll('.carousel-control');
                controls.forEach(control => control.style.visibility = 'hidden');
            }
        }
    });

    const dropdownContainers = document.querySelectorAll('.dropdownButtonContainer');
    dropdownContainers.forEach(container => {
        container.addEventListener('wheel', function (event) {
            event.preventDefault();
            this.scrollLeft += event.deltaY;
        }, { passive: false });
    });
}

function initializeStaticCarousel() {

    const staticCarouselControls = document.querySelectorAll('.carouselWrapper1 .carousel-control1');
    staticCarouselControls.forEach(control => control.style.visibility = 'visible');
    const staticDropdownContainer = document.querySelector('#staticCarousel');
    if (staticDropdownContainer) {
        staticDropdownContainer.addEventListener('wheel', function (event) {
            event.preventDefault();
            this.scrollLeft += event.deltaY;
        }, { passive: false });
    }
}

document.addEventListener('DOMContentLoaded', initializeStaticCarousel);

function scrollCarousel(carouselId, direction) {
    const container = document.getElementById(carouselId);
    const scrollAmount = 200;
    let newScrollPosition = container.scrollLeft + (scrollAmount * direction);
    container.scrollTo({
        top: 0,
        left: newScrollPosition,
        behavior: 'smooth'
    });
    container.scrollBy({ left: direction * scrollAmount, behavior: 'smooth' });
}

let actionsConfigLoaded; // Holds the promise once initialized

function loadActionsConfig() {
    if (!actionsConfigLoaded) {
        actionsConfigLoaded = new Promise((resolve, reject) => {
            fetch(`https://${GetParentResourceName()}/getActionsConfig`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                }
            })
                .then(response => response.json())
                .then(actionsConfig => {
                    window.Actions = actionsConfig;
                    resolve(actionsConfig);
                })
                .catch(error => {
                    reject(error);
                });
        });
    }
    return actionsConfigLoaded;
}

function generateActionButtons(actionsConfig, containerId, inventoryContext, buttonClass) {
    const basePath = "img/itemtypes/";
    const container = document.getElementById(containerId);

    if (container) {
        Object.keys(actionsConfig).forEach(key => {
            const action = actionsConfig[key];
            const button = document.createElement('button');
            button.className = buttonClass;
            button.type = 'button';
            button.setAttribute('data-type', 'itemtype');
            button.setAttribute('data-param', key);
            button.setAttribute('data-desc', action.desc);
            button.setAttribute('onclick', `action('itemtype', '${key}', '${inventoryContext}')`);

            const div = document.createElement('div');
            const img = document.createElement('img');
            img.src = basePath + action.img;
            img.alt = "Image";
            div.appendChild(img);
            button.appendChild(div);
            container.appendChild(button);
        });

        bindButtonEventListeners();
        bindSecondButtonEventListeners();
    } else {
        console.warn(`Container for action buttons not found: ${containerId}`);
    }
}

function action(type, param, inv) {
    if (type === 'itemtype') {
        if (inv === "inventoryElement") {
            document.querySelectorAll('.dropdownButton[data-type="itemtype"]').forEach(btn => btn.classList.remove('active'));
            const activeButtonMain = document.querySelector(`.dropdownButton[data-param="${param}"][data-type="itemtype"]`);
            if (activeButtonMain) activeButtonMain.classList.add('active');
        } else if (inv === "secondInventoryElement") {
            document.querySelectorAll('.dropdownButton1').forEach(btn => {
                if (btn.getAttribute('data-type') === 'itemtype') btn.classList.remove('active');
            });
            const activeButtonSecond = document.querySelector(`.dropdownButton1[data-param="${param}"][data-type="itemtype"]`);
            if (activeButtonSecond) activeButtonSecond.classList.add('active');
        }
        if (param in Actions) {
            const action = Actions[param];
            showItemsByType(action.types, inv);
        } else {
            const defaultAction = Actions['all'];
            showItemsByType(defaultAction.types, inv);
        }
    } else if (type === 'clothing') {
        const clickedButton = document.querySelector(`.dropdownButton[data-param="${param}"][data-type="clothing"], .dropdownButton1[data-param="${param}"][data-type="clothing"]`);
        if (clickedButton) {
            clickedButton.classList.toggle('active');
        }
        $.post(
            `https://${GetParentResourceName()}/ChangeClothing`, JSON.stringify(param)
        );
    }
}

/* FILTER ITEMS BY TYPE */
function showItemsByType(itemTypesToShow, inv) {
    var itemDiv = 0;
    var itemEmpty = 0;
    $(`#${inv} .item`).each(function () {
        const group = $(this).data("group");

        if (itemTypesToShow.length === 0 || itemTypesToShow.includes(group)) {
            if (group != 0) {
                itemDiv = itemDiv + 1;
            } else {
                itemEmpty = itemEmpty + 1;
            }
            $(this).show();
        } else {
            $(this).hide();
        }
    });

    if (itemDiv < 12) {
        if (itemEmpty > 0) {
            for (let i = 0; i < itemEmpty; i++) {
                $(`#${inv} .item[data-group="0"]`).remove();
            }
        }
        /* if itemDiv is less than 12 then create the rest od the divs */
        let emptySlots = 16 - itemDiv;
        for (let i = 0; i < emptySlots; i++) {
            $(`#${inv}`).append(`<div data-group="0" class="item"></div>`);
        }
    }

}

$(document).ready(function () {

    $(document).on('mouseenter', '.item', function () {

        if ($(this).data('tooltip') && !stopTooltip) {

            var tooltipText = $(this).data('tooltip');
            var $tooltip = $('<div></div>')
                .addClass('tooltip')
                .css('pointer-events', 'none')
                .html(tooltipText)
                .appendTo('body');

            var itemOffset = $(this).offset();
            var tooltipTop = itemOffset.top + $(this).outerHeight() + 10;
            var tooltipLeft = itemOffset.left;

            $tooltip.css({
                'top': tooltipTop,
                'left': tooltipLeft,
                'position': 'absolute',
                'display': 'block'
            });
        }
    });

    $(document).on('mouseleave', '.item', function () {
        $('.tooltip').remove();
    });
});

function moveInventory(inv) {
    var inventoryHud = document.getElementById('inventoryHud');
    if (inv === 'main') {
        inventoryHud.style.left = '25%';
    } else if (inv === 'second') {
        inventoryHud.style.left = '1%';
    }
}

function getColorForDegradation(degradation) {
    if (degradation < 15) {
        return "red";
    } else if (degradation < 40) {
        return "orange";
    } else if (degradation < 70) {
        return "gold";
    } else {
        return "green";
    }
}

function addData(index, item) {

    $("#item-" + index).data("item", item);
    $("#item-" + index).data("inventory", "main");

    var data = [];

    if (Config.DoubleClickToUse) {

        $("#item-" + index).dblclick(function () {

            if (item.used || item.used2) {
                $(this).find('.equipped-icon').hide();
                $.post(`https://${GetParentResourceName()}/UnequipWeapon`, JSON.stringify({
                    item: item.name,
                    id: item.id,
                }));

            } else {

                if (item.type == "item_weapon") {
                    $(this).find('.equipped-icon').show();
                }
                $.post(`https://${GetParentResourceName()}/UseItem`, JSON.stringify({
                    item: item.name,
                    type: item.type,
                    hash: item.hash,
                    amount: item.count,
                    id: item.id,
                }));
            }
        });

    } else {
        if (item.used || item.used2) {
            data.push({
                text: LANGUAGE.unequip,
                action: function () {
                    $(this).find('.equipped-icon').hide();
                    $.post(
                        `https://${GetParentResourceName()}/UnequipWeapon`,
                        JSON.stringify({
                            item: item.name,
                            id: item.id,
                        })
                    );
                },
            });
        } else {
            if (item.type != "item_weapon") {
                lang = LANGUAGE.use;
            } else {
                lang = LANGUAGE.equip;
            }
            data.push({
                text: lang,
                action: function () {
                    if (item.type == "item_weapon") {
                        $(this).find('.equipped-icon').show();
                    }
                    $.post(
                        `https://${GetParentResourceName()}/UseItem`,
                        JSON.stringify({
                            item: item.name,
                            type: item.type,
                            hash: item.hash,
                            amount: item.count,
                            id: item.id,
                        })
                    );
                },
            });
        }
    }

    if (item.canRemove) {
        data.push({
            text: LANGUAGE.give,
            action: function () {
                giveGetHowMany(
                    item.name,
                    item.type,
                    item.hash,
                    item.id,
                    item.metadata,
                    item.count
                );
            },
        });

        data.push({
            text: LANGUAGE.drop,
            action: function () {
                dropGetHowMany(
                    item.name,
                    item.type,
                    item.hash,
                    item.id,
                    item.metadata,
                    item.count
                );
            },
        });
    }
    if (data.length > 0) {
        $("#item-" + index).contextMenu([data], {
            offsetX: 1,
            offsetY: 1,
        });
    }

    $("#item-" + index).hover(
        function () {
            OverSetTitle(item.label);
        },
        function () {
            OverSetTitle(" ");
        }
    );

    $("#item-" + index).hover(
        function () {
            if (!!item.metadata && !!item.metadata.description) {
                OverSetDesc(item.metadata.description);
            } else {
                OverSetDesc(!!item.desc ? item.desc : "");
            }
        },
        function () {
            OverSetDesc(" ");
        }
    );
}

function loadInventoryItems(item, index, group, count, limit) {
    if (item.type != "item_weapon") {
        const custom = item.metadata?.tooltip ? "<br>" + item.metadata.tooltip : "";
        const degradation = item.degradation ? `<br>${LANGUAGE.labels.decay}<span style="color: ${getColorForDegradation(item.degradation)}">${item.degradation}%</span>` : "";
        const weight = item.weight ? "<br>" + LANGUAGE.labels.weight + (item.weight * count).toFixed(2) + " " + Config.WeightMeasure : "<br>" + LANGUAGE.labels.weight + (count / 4).toFixed(2) + " " + Config.WeightMeasure;
        const groupKey = getGroupKey(group);
        const groupImg = groupKey ? window.Actions[groupKey].img : 'satchel_nav_all.png';
        const tooltipContent = group > 1 ? `<img src="img/itemtypes/${groupImg}"> ${LANGUAGE.labels.limit + limit + custom + weight + degradation}` : `${LANGUAGE.labels.limit} ${limit}${custom}${weight}${degradation}`;
        const image = item.metadata?.image ? item.metadata.image : item.name ? item.name : "default";
        const url = imageCache[image]

        $("#inventoryElement").append(`
          <div data-group='${group}' data-label='${item.label}' style='background-image: ${url} background-size: 4.5vw 7.7vh; background-repeat: no-repeat; background-position: center;' id='item-${index}' class='item' data-tooltip='${tooltipContent}'> 
           <div class='count'>
            <span style='color:Black'>${count}</span>
           </div>
           <div class='text'></div>
         </div>`);
    }

}

function loadInventoryWeapons(item, index, group, count) {
    if (item.type === "item_weapon") {
        const weight = item.weight ? LANGUAGE.labels.weight + item.weight.toFixed(2) + " " + Config.WeightMeasure : LANGUAGE.labels.weight + (count / 4).toFixed(2) + " " + Config.WeightMeasure;
        const info = item.serial_number ? "<br>" + LANGUAGE.labels.ammo + item.count + "<br>" + LANGUAGE.labels.serial + item.serial_number : "";
        $("#inventoryElement").append(`
       <div data-label='${item.label}' data-group='${group}' style='background-image: url("img/items/${item.name}.png"); background-size: 4.5vw 7.7vh; background-repeat: no-repeat; background-position: center;' id='item-${index}' class='item'       data-tooltip="${weight + info}">
        <div class='equipped-icon' style='display: ${!item.used && !item.used2 ? "none" : "block"};'></div>
       </div>`);
    }

}

function inventorySetup(items) {

    $("#inventoryElement").html("");
    var divAmount = 0;

    $.each(items, function () {
        divAmount = divAmount + 1;
    });

    for (const [index, item] of items.entries()) {
        if (item) {
            var count = item.count;
            var limit = item.limit;
            const group = item.type != "item_weapon" ? !item.group ? 1 : item.group : 5;

            loadInventoryItems(item, index, group, count, limit);
            loadInventoryWeapons(item, index, group, count);
            addData(index, item);
        }
    };

    var gunbelt_item = "gunbelt";
    var gunbelt_label = LANGUAGE.gunbeltlabel;
    var gunbelt_desc = LANGUAGE.gunbeltdescription;

    var data = [];

    let empty = true;
    if (allplayerammo) {
        for (const [ind, tab] of Object.entries(allplayerammo)) {
            if (tab > 0) {
                empty = false;
                data.push({
                    text: `${ammolabels[ind]} : ${tab}`,
                    action: function () {
                        giveammotoplayer(ind);
                    },
                });
            }
        }
    }

    if (empty) {
        data.push({
            text: LANGUAGE.empty,
            action: function () { },
        });
    }

    if (Config.AddAmmoItem) {
        $("#inventoryElement").append(
            "<div data-label='" + gunbelt_label + "'data-group ='1' style='background-image: url(\"img/items/" + gunbelt_item + ".png\"); background-size: 4.5vw 6.7vh; background-repeat: no-repeat; background-position: center;' id='item-" + gunbelt_item + "' class='item'>  <div class='text'></div> </div>");

        $("#item-" + gunbelt_item).contextMenu([data], {
            offsetX: 1,
            offsetY: 1,
        });

        $("#item-" + gunbelt_item).hover(
            function () {
                OverSetTitle(gunbelt_label);
            },
            function () {
                OverSetTitle(" ");
            }
        );

        $("#item-" + gunbelt_item).hover(
            function () {
                OverSetDesc(gunbelt_desc);
            },
            function () {
                OverSetDesc(" ");
            }
        );
        $("#item-" + gunbelt_item).data("item", gunbelt_item);
        $("#item-" + gunbelt_item).data("inventory", "none");
    } else {
        $("#ammobox").contextMenu([data], {
            offsetX: 1,
            offsetY: 1,
        });

        $("#ammobox").hover(
            function () {
                $("#hint").show();
                document.getElementById("hint").innerHTML = gunbelt_label;
            },
            function () {
                $("#hint").hide();
                document.getElementById("hint").innerHTML = "";
            }
        );
    }

    isOpen = true;
    initDivMouseOver();
    //AddMoney
    var m_item = "money";
    var m_label = LANGUAGE.inventorymoneylabel;
    var m_desc = LANGUAGE.inventorymoneydescription;

    var data = [];

    data.push({
        text: LANGUAGE.givemoney,
        action: function () {
            giveGetHowManyMoney();
        },
    });

    data.push({
        text: LANGUAGE.dropmoney,
        action: function () {
            dropGetHowMany(m_item, "item_money", "asd", 0);
        },
    });

    if (Config.AddDollarItem) {
        $("#inventoryElement").append(
            "<div data-label='" + m_label + "'data-group ='1' style='background-image: url(\"img/items/" + m_item +
            ".png\"), url(); background-size: 4.5vw 6.7vh; background-repeat: no-repeat; background-position: center;' id='item-" + m_item + "' class='item'><div class='text'></div></div>"
        );

        $("#item-" + m_item).contextMenu([data], {
            offsetX: 1,
            offsetY: 1,
        });
        $("#item-" + m_item).hover(
            function () {
                OverSetTitle(m_label);
            },
            function () {
                OverSetTitle(" ");
            }
        );

        $("#item-" + m_item).hover(
            function () {
                OverSetDesc(m_desc);
            },
            function () {
                OverSetDesc(" ");
            }
        );

        $("#item-" + m_item).data("item", m_item);
        $("#item-" + m_item).data("inventory", "none");
    } else {
        $("#cash").contextMenu([data], {
            offsetX: 1,
            offsetY: 1,
        });

        $("#cash").hover(
            function () {
                $("#money-value").hide();
                $("#hint-money-value").show();
                $("#hint-money-value").text(m_label);
            },
            function () {
                $("#money-value").show();
                $("#hint-money-value").hide();
            }
        );
    }

    isOpen = true;
    initDivMouseOver();

    if (Config.UseGoldItem) {
        //AddGold
        var g_item = "gold";
        var g_label = LANGUAGE.inventorygoldlabel;
        var g_desc = LANGUAGE.inventorygolddescription;

        var data = [];

        data.push({
            text: LANGUAGE.givegold,
            action: function () {
                giveGetHowManyGold();
            },
        });

        data.push({
            text: LANGUAGE.dropgold,
            action: function () {
                dropGetHowMany(g_item, "item_gold", "asd", 0);
            },
        });

        if (Config.AddGoldItem) {
            $("#inventoryElement").append(
                "<div data-label='" + g_label + "'data-group ='1' style='background-image: url(\"img/items/" + g_item +
                ".png\"), url(); background-size: 4.5vw 6.7vh; background-repeat: no-repeat; background-position: center;' id='item-" + g_item + "' class='item'><div class='text'></div></div>"
            );

            $("#item-" + g_item).contextMenu([data], {
                offsetX: 1,
                offsetY: 1,
            });

            $("#item-" + g_item).hover(
                function () {
                    OverSetTitle(g_label);
                },
                function () {
                    OverSetTitle(" ");
                }
            );

            $("#item-" + g_item).hover(
                function () {
                    OverSetDesc(g_desc);
                },
                function () {
                    OverSetDesc(" ");
                }
            );

            $("#item-" + g_item).data("item", g_item);
            $("#item-" + g_item).data("inventory", "none");
        } else {
            $("#gold").contextMenu([data], {
                offsetX: 1,
                offsetY: 1,
            });

            $("#gold").hover(
                function () {
                    $("#gold-value").hide();
                    $("#hint-gold-value").show();
                    $("#hint-gold-value").text(g_label);
                },
                function () {
                    $("#gold-value").show();
                    $("#hint-gold-value").hide();
                }
            );
        }

        isOpen = true;
        initDivMouseOver();
    }

    /* in here we ensure that at least all divs are filled */
    if (divAmount < 12 && divAmount > 0) {
        var emptySlots = 14 - divAmount;
        for (var i = 0; i < emptySlots; i++) {
            $("#inventoryElement").append(`
          <div class='item' data-group='0'></div> `);
        }
    } else if (divAmount == 0) {
        var emptySlots = 14 - divAmount;
        for (var i = 0; i < emptySlots; i++) {
            $("#inventoryElement").append(`
          <div class='item' data-group='0'></div> `);
        }

    }
}
