function PostAction(eventName, itemData, id, propertyName) {
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
        autofocus: "true",
      },

      validate: function (value, item, type) {
        if (!value || value <= 0 || value > 200 || !isInt(value)) {
          dialog.close();
          return;
        } else {
          if (!isValidating) {
            processEventValidation();
            $.post(
              `https://${GetParentResourceName()}/${eventName}`,
              JSON.stringify({
                item: itemData,
                type: type,
                number: value,
                [propertyName]: id,
              })
            );
          }
        }
      },
    });
  } else {
    if (!isValidating) {
      processEventValidation();
      $.post(
        `https://${GetParentResourceName()}/${eventName}`,
        JSON.stringify({
          item: itemData,
          type: itemData.type,
          number: 1,
          [propertyName]: id,
        })
      );
    }
  }
}
const ActionTakeList = {
  custom: { action: "TakeFromCustom", id: () => customId, customtype: "id" },
  cart: { action: "TakeFromCart", id: () => wagonid, customtype: "wagon" },
  house: { action: "TakeFromHouse", id: () => houseId, customtype: "house" },
  hideout: {
    action: "TakeFromHideout",
    id: () => hideoutId,
    customtype: "hideout",
  },
  bank: { action: "TakeFromBank", id: () => bankId, customtype: "bank" },
  clan: { action: "TakeFromClan", id: () => clanid, customtype: "clan" },
  steal: { action: "TakeFromsteal", id: () => stealid, customtype: "steal" },
  Container: {
    action: "TakeFromContainer",
    id: () => Containerid,
    customtype: "Container",
  },
  horse: { action: "TakeFromHorse", id: () => horseid, customtype: "horse" },
};

const ActionMoveList = {
  custom: { action: "MoveToCustom", id: () => customId, customtype: "id" },
  cart: { action: "MoveToCart", id: () => wagonid, customtype: "wagon" },
  house: { action: "MoveToHouse", id: () => houseId, customtype: "house" },
  hideout: {
    action: "MoveToHideout",
    id: () => hideoutId,
    customtype: "hideout",
  },
  bank: { action: "MoveToBank", id: () => bankId, customtype: "bank" },
  clan: { action: "MoveToClan", id: () => clanid, customtype: "clan" },
  steal: { action: "MoveTosteal", id: () => stealid, customtype: "steal" },
  Container: {
    action: "MoveToContainer",
    id: () => Containerid,
    customtype: "Container",
  },
  horse: { action: "MoveToHorse", id: () => horseid, customtype: "horse" },
};

function initSecondaryInventoryHandlers() {
  $("#inventoryElement").droppable({
    drop: function (event, ui) {
      itemData = ui.draggable.data("item");
      itemInventory = ui.draggable.data("inventory");
      if (itemInventory === "second") {
        if (type in ActionTakeList) {
          const { action, id, customtype } = ActionTakeList[type];
          const Id = id();
          PostAction(action, itemData, Id, customtype);
        } else if (type === "store") {
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
                autofocus: "true",
              },

              validate: function (value, item, type) {
                if (!value) {
                  dialog.close();
                  return;
                }

                if (!isInt(value)) {
                  return;
                }

                if (!isValidating) {
                  processEventValidation();
                  $.post(
                    `https://${GetParentResourceName()}/TakeFromStore`,
                    JSON.stringify({
                      item: itemData,
                      type: type,
                      number: value,
                      price: itemData.price,
                      geninfo: geninfo,
                      store: StoreId,
                    })
                  );
                }
              },
            });
          } else {
            if (!isValidating) {
              processEventValidation();
              $.post(
                `https://${GetParentResourceName()}/TakeFromStore`,
                JSON.stringify({
                  item: itemData,
                  type: itemData.type,
                  number: 1,
                  price: itemData.price,
                  geninfo: geninfo,
                  store: StoreId,
                })
              );
            }
          }
        }
      }
    },
  });

  $("#secondInventoryElement").droppable({
    drop: function (event, ui) {
      itemData = ui.draggable.data("item");
      itemInventory = ui.draggable.data("inventory");

      if (itemInventory === "main") {
        if (type in ActionMoveList) {
          const { action, id, customtype } = ActionMoveList[type];
          const Id = id();
          PostAction(action, itemData, Id, customtype);
        } else if (type === "store") {
          disableInventory(500);
          // this action is different than all the others
          if (itemData.type != "item_weapon") {
            dialog.prompt({
              title: LANGUAGE.prompttitle,
              button: LANGUAGE.promptaccept,
              required: true,
              item: itemData,
              type: itemData.type,
              input: {
                type: "number",
                autofocus: "true",
              },
              validate: function (value, item, type) {
                if (!value) {
                  dialog.close();
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
                        autofocus: "true",
                      },
                      validate: function (value2, item, type) {
                        if (!value2) {
                          dialog.close();
                          return;
                        }

                        if (!isValidating) {
                          processEventValidation();
                          $.post(
                            `https://${GetParentResourceName()}/MoveToStore`,
                            JSON.stringify({
                              item: itemData,
                              type: type,
                              number: value,
                              price: value2,
                              geninfo: geninfo,
                              store: StoreId,
                            })
                          );
                        }
                      },
                    });
                  }
                } else {
                  if (!isValidating) {
                    processEventValidation();
                    $.post(
                      `https://${GetParentResourceName()}/MoveToStore`,
                      JSON.stringify({
                        item: itemData,
                        type: type,
                        number: value,
                        geninfo: geninfo,
                        store: StoreId,
                      })
                    );
                  }
                }
              },
            });
          } else {
            if (geninfo.isowner != 0) {
              dialog.prompt({
                title: LANGUAGE.prompttitle2,
                button: LANGUAGE.promptaccept,
                required: true,
                item: itemData,
                type: itemData.type,
                input: {
                  type: "number",
                  autofocus: "true",
                },
                validate: function (value2, item, type) {
                  if (!value2) {
                    dialog.close();
                    return;
                  }

                  if (!isValidating) {
                    processEventValidation();
                    $.post(
                      `https://${GetParentResourceName()}/MoveToStore`,
                      JSON.stringify({
                        item: itemData,
                        type: itemData.type,
                        number: 1,
                        price: value2,
                        geninfo: geninfo,
                        store: StoreId,
                      })
                    );
                  }
                },
              });
            } else {
              if (!isValidating) {
                processEventValidation();
                $.post(
                  `https://${GetParentResourceName()}/MoveToStore`,
                  JSON.stringify({
                    item: itemData,
                    type: itemData.type,
                    number: 1,
                    geninfo: geninfo,
                    store: StoreId,
                  })
                );
              }
            }
          }
        }
      }
    },
  });
}

function secondInventorySetup(items) {
  $("#inventoryElement").html("");
  $("#secondInventoryElement").html("");
  var divCount = 0;
  $.each(items, function (index, item) {
    divCount = divCount + 1;
  });

  $.each(items, function (index, item) {
    count = item.count;
    if (item.type !== "item_weapon") {
      /* items  */
      if (!item.group) {
        item.group = 1;
      }

      $("#secondInventoryElement").append(`<div data-label='${item.label}' data-group ='${item.group}'
      style='background-image: url(\"img/items/${item.name ? item.name.toLowerCase() : ""
        }.png\"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;'
      id="item-${index}" class='item'> ${count > 0 ? `<div class='count'>${count}</div>` : ``} 
      <div class='text'></div> 
      </div>
      `);
    } else {
      /* weapons */
      var group = 5;
      $("#secondInventoryElement").append(`
        <div data-label='${item.label}' data-group ='${group}'
         style='background-image: url("img/items/${item.name.toLowerCase()
        }.png"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;'
         id='item-${index}' class='item'>
         </div> 
         `);

    }

    $("#item-" + index).data("item", item);
    $("#item-" + index).data("inventory", "second");

    $("#item-" + index).hover(
      function () {
        OverSetTitleSecond(item.label);
      },
      function () {
        OverSetTitleSecond(" ");
      }
    );

    $("#item-" + index).hover(
      function () {
        if (!!item.metadata && !!item.metadata.description) {
          OverSetDescSecond(item.metadata.description);
        } else {
          OverSetDescSecond(!!item.desc ? item.desc : "");
        }
      },
      function () {
        OverSetDescSecond(" ");
      }
    );
  });

  /* in here we ensure that at least all divs are filled */
  if (divCount < 14) {
    var emptySlots = 16 - divCount;
    for (var i = 0; i < emptySlots; i++) {
      $("#secondInventoryElement").append(`
         <div class='item' data-group='0'></div>
        `);
    }
  }
}
