

/* DROP DOWN BUTTONS MAIN AND SECONDARY INVENTORY */

function toggleDropdown(mainButton) {
  const dropdownButtonsContainers = document.querySelectorAll('.dropdownButtonContainer');
  dropdownButtonsContainers.forEach((container) => {
    if (container.classList.contains(mainButton)) {
      container.classList.toggle('showDropdown');
    } else {
      container.classList.remove('showDropdown');
    }
  });
}
/* 0 is empty divs 1  is fixed divs like money and ammo */
const Actions = {
  all: { types: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] },
  medical: { types: [0, 2] },
  foods: { types: [0, 3] },
  weapons: { types: [0, 5] },
  ammo: { types: [0, 6] },
  tools: { types: [0, 4] },
  animals: { types: [0, 8] },
  documents: { types: [0, 7] },
  valuables: { types: [0, 9] },
  horse: { types: [0, 10] },
  herbs: { types: [0, 11] },

};

function action(type, param, inv) {
  if (type === 'itemtype') {
    if (param in Actions) {
      const action = Actions[param];
      showItemsByType(action.types, inv);
    } else {
      const defaultAction = Actions['all'];
      showItemsByType(defaultAction.types, inv);
    }
  } else if (type === 'clothing') {
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
      $(`#${inv}`).append(`
          <div data-group="0" class="item"></div>`);

    }
  }

}

function inventorySetup(items) {
  $("#inventoryElement").html("");
  var divAmount = 0;

  // Count the number of items first
  $.each(items, function (index, item) {
    divAmount = divAmount + 1;
  });


  $.each(items, function (index, item) {
    var count = item.count;
    var limit = item.limit;

    if (limit > 0) {
      count = count + " / " + limit;
    };

    if (item.type != "item_weapon") {
      /* items */
      if (!item.group) {
        item.group = 1;
      }

      $("#inventoryElement").append(`
            <div data-label='${item.label}' data-group='${item.group}' style='background-image: url("img/items/${item.name.toLowerCase()}.png"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;' id='item-${index}' class='item'>
                <div class='count'<span style ='color:Black'>${count}</span></div>
                <div class='text'></div>
            </div>
          `);

    } else {
      /* weapons */
      const group = 5;
      $("#inventoryElement").append(`
          <div data-label='${item.label}' data-group='${group}' style='background-image: url("img/items/${item.name.toLowerCase()}.png"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;' id='item-${index}' class='item'></div>
          `);

    }

    $("#item-" + index).data("item", item);
    $("#item-" + index).data("inventory", "main");

    var data = [];

    if (Config.DoubleClickToUse) {
      $("#item-" + index).dblclick(function () {
        if (item.used || item.used2) {
          $.post(
            `https://${GetParentResourceName()}/UnequipWeapon`,
            JSON.stringify({
              item: item.name,
              id: item.id,
            })
          );
        } else {
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
        }
      });
    } else {
      if (item.used || item.used2) {
        data.push({
          text: LANGUAGE.unequip,
          action: function () {
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
            item.metadata
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
            item.metadata
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

  });


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
      "<div data-label='" +
      gunbelt_label +
      "'data-group ='1' style='background-image: url(\"img/items/" +
      gunbelt_item +
      ".png\"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;' id='item-" +
      gunbelt_item +
      "' class='item'><div class='text'></div></div>"
    );

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
      ".png\"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;' id='item-" +
      m_item + "' class='item'><div class='text'></div></div>"
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
        "<div data-label='" + g_label + "'data-group ='1' style='background-image: url(\"img/items/" +
        g_item +
        ".png\"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;' id='item-" +
        g_item +
        "' class='item'><div class='text'></div></div>"
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
