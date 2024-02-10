(function () {
    let MenuTpl = `
    <div id="menu_{{_namespace}}_{{_name}}" class="menu{{#align}} align-{{align}}{{/align}}">
        <div class="head"><span>{{{title}}}</span></div>
        <div class="desciptions">{{{subtext}}}</div>
        <div class="topline"></div>
        <div class="menu-items">
            {{#isGrid}}
            <div class="grid-container">
            {{#elements}}
            <div class="grid-item {{#selected}}selected{{/selected}}">
                {{#image}}<img src="nui://vorp_inventory/html/img/items/{{{image}}}.png"></img>{{/image}}
                {{^image}}
                <div id="item-label" {{#image}}class="image-pad"{{/image}}>{{{label}}}</div>
                {{/image}}
            </div>
            {{/elements}}
            </div>
             {{/isGrid}}
             {{^isGrid}}
            {{#elements}}
            {{#isNotSelectable}}
            <div class="menu-item {{#isSlider}}slider{{/isSlider}}" {{#itemHeight}} style="height:{{{itemHeight}}}!important"{{/itemHeight}}>
            {{/isNotSelectable}}
               {{^isNotSelectable}}
                <div class="menu-item {{#selected}}selected{{/selected}} {{#isSlider}}slider{{/isSlider}}" {{#itemHeight}} style="height:{{{itemHeight}}}!important"{{/itemHeight}}>
                {{/isNotSelectable}}
                    {{#image}}<img class="item-image" src="nui://vorp_inventory/html/img/items/{{{image}}}.png"></img>{{/image}}
                    <div id="item-label" {{#image}}class="image-pad"{{/image}}>{{{label}}}</div>
                    <div class="arrows">
                        {{#isSlider}}<i class="fas fa-arrow-circle-left"></i>{{/isSlider}}
                        <div id="slider-label">{{{sliderLabel}}}</div>
                        {{#isSlider}}<i class="fas fa-arrow-alt-circle-right"></i>{{/isSlider}}
                    </div>
                </div>
            {{/elements}}
          {{/isGrid}}
        </div>
        <div class="scrollbottom"></div>
        {{#elements}}
            {{#selected}}
                <div class="options-amount">{{{list_id}}}/{{{list_max}}}</div>
                <br>
                <div class="desciption">{{{desc}}}</div>
            {{/selected}}
        {{/elements}}
        <br>
    </div>`;

    /*     function scrollToElement(element, block = "nearest", inline = "nearest") {
            element?.scrollIntoView({
                    behavior: "smooth",
                    block: block,
                    inline: inline, 
            });
        } */

    function scrollToElement(element, block = "nearest") {
        if (element) {
            const menuContainer = document.querySelector(".menu .menu-items"); // Replace with your actual menu container's class or ID
            const elementRect = element.getBoundingClientRect();
            const containerRect = menuContainer.getBoundingClientRect();

            if (elementRect.bottom > containerRect.bottom) {
                menuContainer.scrollTop += elementRect.bottom - containerRect.bottom;
            } else if (elementRect.top < containerRect.top) {
                menuContainer.scrollTop -= containerRect.top - elementRect.top;
            }
        }
    }

    window.MenuData = {};
    MenuData.ResourceName = "vorp_menu";
    MenuData.opened = {};
    MenuData.focus = [];
    MenuData.pos = {};
    let lastmenu;


    MenuData.open = function (namespace, name, data) {
        lastmenu = data.lastmenu;
        if (typeof MenuData.opened[namespace] == "undefined") {
            MenuData.opened[namespace] = {};
        }

        if (typeof MenuData.opened[namespace][name] != "undefined") {
            MenuData.close(namespace, name);
        }

        if (typeof MenuData.pos[namespace] == "undefined") {
            MenuData.pos[namespace] = {};
        }

        for (let i = 0; i < data.elements.length; i++) {
            if (typeof data.elements[i].type == "undefined") {
                data.elements[i].type = "default";
            }
        }


        data._index = MenuData.focus.length;
        data._namespace = namespace;
        data._name = name;

        for (let i = 0; i < data.elements.length; i++) {
            data.elements[i]._namespace = namespace;
            data.elements[i]._name = name;
        }
        let selectedIndex = (typeof MenuData.pos[namespace][name] !== "undefined") ? MenuData.pos[namespace][name] : 0;
        for (let i = 0; i < data.elements.length; i++) {
            data.elements[i].selected = (i === selectedIndex);
        }

        MenuData.opened[namespace][name] = data;
        MenuData.pos[namespace][name] = 0;

        for (let i = 0; i < data.elements.length; i++) {
            if (data.elements[i].selected) {
                MenuData.pos[namespace][name] = i;
            } else {
                data.elements[i].selected = false;
            }
        }

        MenuData.focus.push({
            namespace: namespace,
            name: name,
        });

        MenuData.render();
        let selectedElement = $("#menu_" + namespace + "_" + name).find(".menu-item.selected, .grid-item.selected");
        if (selectedElement.length > 0) {
            scrollToElement(selectedElement[0]);
        }
    };

    MenuData.close = function (namespace, name) {
        delete MenuData.opened[namespace][name];

        for (let i = 0; i < MenuData.focus.length; i++) {
            if (
                MenuData.focus[i].namespace == namespace &&
                MenuData.focus[i].name == name
            ) {
                MenuData.focus.splice(i, 1);
                break;
            }
        }

        MenuData.render();
    };

    MenuData.render = function () {
        let menuContainer = document.getElementById("menus");
        let focused = MenuData.getFocused();
        menuContainer.innerHTML = "";
        $(menuContainer).hide();

        for (let namespace in MenuData.opened) {
            for (let name in MenuData.opened[namespace]) {
                let menuData = MenuData.opened[namespace][name];
                let view = JSON.parse(JSON.stringify(menuData));

                for (let i = 0; i < menuData.elements.length; i++) {
                    let element = view.elements[i];

                    switch (element.type) {
                        case "default":
                            element.list_id = i + 1;
                            element.list_max = menuData.elements.length;
                            break;

                        case "slider": {
                            element.isSlider = true;
                            element.list_id = i + 1;
                            element.list_max = menuData.elements.length;
                            element.sliderLabel =
                                typeof element.options == "undefined"
                                    ? element.value
                                    : element.options[element.value];

                            break;
                        }

                        default:
                            element.list_id = i + 1;
                            element.list_max = menuData.elements.length;
                            break;
                    }

                    if (i == MenuData.pos[namespace][name]) {
                        element.selected = true;
                    }
                }

                let menu = $(Mustache.render(MenuTpl, view))[0];
                $(menu).hide();
                menuContainer.appendChild(menu);
            }
        }

        if (typeof focused != "undefined") {
            $("#menu_" + focused.namespace + "_" + focused.name).show();
        }

        $(menuContainer).show();
    };

    MenuData.submit = function (namespace, name, data) {
        if (data == "backup") {
            $.post(
                "https://" + MenuData.ResourceName + "/menu_submit",
                JSON.stringify({
                    _namespace: namespace,
                    _name: name,
                    current: data,
                    trigger: lastmenu,
                    elements: MenuData.opened[namespace][name].elements,
                })
            );
        } else {
            $.post(
                "https://" + MenuData.ResourceName + "/menu_submit",
                JSON.stringify({
                    _namespace: namespace,
                    _name: name,
                    current: data,
                    elements: MenuData.opened[namespace][name].elements,
                })
            );
        }
    };

    MenuData.cancel = function (namespace, name) {
        $.post(
            "https://" + MenuData.ResourceName + "/menu_cancel",
            JSON.stringify({
                _namespace: namespace,
                _name: name,
            })
        );
    };

    MenuData.change = function (namespace, name, data) {
        $.post(
            "https://" + MenuData.ResourceName + "/menu_change",
            JSON.stringify({
                _namespace: namespace,
                _name: name,
                current: data,
                elements: MenuData.opened[namespace][name].elements,
            })
        );
    };

    MenuData.getFocused = function () {
        return MenuData.focus[MenuData.focus.length - 1];
    };

    window.onData = (data) => {
        switch (data.ak_menubase_action) {
            case "openMenu": {
                MenuData.open(
                    data.ak_menubase_namespace,
                    data.ak_menubase_name,
                    data.ak_menubase_data
                );
                break;
            }

            case "closeMenu": {
                MenuData.close(data.ak_menubase_namespace, data.ak_menubase_name);
                break;
            }

            case "controlPressed": {
                switch (data.ak_menubase_control) {
                    case "ENTER": {
                        let focused = MenuData.getFocused();

                        if (typeof focused != "undefined") {
                            let menu = MenuData.opened[focused.namespace][focused.name];
                            let pos = MenuData.pos[focused.namespace][focused.name];
                            let elem = menu.elements[pos];

                            if (menu.elements.length > 0) {
                                MenuData.submit(focused.namespace, focused.name, elem);
                            }
                        }

                        break;
                    }

                    case "BACKSPACE": {
                        let focused = MenuData.getFocused();
                        if (lastmenu == null) {
                            lastmenu = "";
                        }
                        if (lastmenu != "undefined" && lastmenu != "") {
                            let menu = MenuData.opened[focused.namespace][focused.name];
                            let pos = MenuData.pos[focused.namespace][focused.name];
                            let elem = menu.elements[pos];
                            MenuData.submit(focused.namespace, focused.name, "backup");
                        } else if (typeof focused != "undefined") {
                            MenuData.cancel(focused.namespace, focused.name);
                            $.post(
                                "https://" + MenuData.ResourceName + "/closeui",
                                JSON.stringify({})
                            );
                        }
                        break;
                    }

                    case "TOP": {
                        let focused = MenuData.getFocused();

                        if (typeof focused != "undefined") {
                            let menu = MenuData.opened[focused.namespace][focused.name];
                            let pos = MenuData.pos[focused.namespace][focused.name];

                            if (pos > 0) {
                                MenuData.pos[focused.namespace][focused.name]--;
                            } else {
                                MenuData.pos[focused.namespace][focused.name] = menu.elements.length - 1;
                            }

                            let elem = menu.elements[MenuData.pos[focused.namespace][focused.name]];

                            for (let i = 0; i < menu.elements.length; i++) {
                                menu.elements[i].selected = (i == MenuData.pos[focused.namespace][focused.name]);
                            }


                            $.post('https://' + MenuData.ResourceName + '/update_last_selected', JSON.stringify({
                                _namespace: focused.namespace,
                                _name: focused.name,
                                selected: MenuData.pos[focused.namespace][focused.name]
                            }));

                            MenuData.change(focused.namespace, focused.name, elem);
                            MenuData.render();
                            $.post("https://" + MenuData.ResourceName + "/playsound");
                            let selectedElement = $("#menu_" + focused.namespace + "_" + focused.name).find(".menu-item.selected, .grid-item.selected");
                            if (selectedElement.length > 0) {
                                scrollToElement(selectedElement[0]);
                            }
                        }

                        break;
                    }

                    case "DOWN": {
                        let focused = MenuData.getFocused();

                        if (typeof focused != "undefined") {
                            let menu = MenuData.opened[focused.namespace][focused.name];
                            let pos = MenuData.pos[focused.namespace][focused.name];
                            let length = menu.elements.length;

                            if (pos < length - 1) {
                                MenuData.pos[focused.namespace][focused.name]++;
                            } else {
                                MenuData.pos[focused.namespace][focused.name] = 0;
                            }

                            let elem = menu.elements[MenuData.pos[focused.namespace][focused.name]];

                            for (let i = 0; i < menu.elements.length; i++) {
                                if (i == MenuData.pos[focused.namespace][focused.name]) {
                                    menu.elements[i].selected = true;
                                } else {
                                    menu.elements[i].selected = false;
                                }
                            }

                            $.post('https://' + MenuData.ResourceName + '/update_last_selected', JSON.stringify({
                                _namespace: focused.namespace,
                                _name: focused.name,
                                selected: MenuData.pos[focused.namespace][focused.name]
                            }));

                            MenuData.change(focused.namespace, focused.name, elem);
                            MenuData.render();
                            $.post("https://" + MenuData.ResourceName + "/playsound");
                            let selectedElement = $("#menu_" + focused.namespace + "_" + focused.name).find(".menu-item.selected, .grid-item.selected");
                            if (selectedElement.length > 0) {
                                scrollToElement(selectedElement[0]);
                            }

                        }

                        break;
                    }

                    case "LEFT": {
                        let focused = MenuData.getFocused();

                        if (typeof focused != "undefined") {
                            let menu = MenuData.opened[focused.namespace][focused.name];
                            let pos = MenuData.pos[focused.namespace][focused.name];
                            let elem = menu.elements[pos];

                            switch (elem.type) {
                                case "default":
                                    break;

                                case "slider": {
                                    let min = typeof elem.min == "undefined" ? 0 : elem.min;

                                    if (elem.value > min) {
                                        if (typeof elem.hop != "undefined") {
                                            if (Number.isInteger(elem.hop)) {
                                                elem.value = elem.value - elem.hop;
                                            } else {
                                                elem.value = (
                                                    Number(elem.value) - Number(elem.hop)
                                                ).toFixed(1);
                                            }

                                            elem.value = Number(elem.value);

                                            if (elem.value < min) {
                                                elem.value = min;
                                            }
                                        } else {
                                            elem.value--;
                                        }
                                        MenuData.change(focused.namespace, focused.name, elem);
                                        MenuData.submit(focused.namespace, focused.name, elem);
                                    }

                                    MenuData.render();
                                    break;
                                }

                                default:
                                    break;
                            }

                            let selectedElement = $("#menu_" + focused.namespace + "_" + focused.name).find(".menu-item.selected, .grid-item.selected");
                            if (selectedElement.length > 0) {
                                scrollToElement(selectedElement[0]);
                            }
                        }

                        break;
                    }


                    case "RIGHT": {
                        let focused = MenuData.getFocused();

                        if (typeof focused != "undefined") {
                            let menu = MenuData.opened[focused.namespace][focused.name];
                            let pos = MenuData.pos[focused.namespace][focused.name];
                            let elem = menu.elements[pos];

                            switch (elem.type) {
                                case "default":
                                    break;

                                case "slider": {
                                    if (typeof elem.options != "undefined" && elem.value < elem.options.length - 1) {
                                        elem.value++;
                                        MenuData.change(focused.namespace, focused.name, elem);
                                        MenuData.submit(focused.namespace, focused.name, elem);
                                    }

                                    if (typeof elem.max != "undefined" && elem.value < elem.max) {
                                        if (typeof elem.hop != "undefined") {
                                            let min = typeof elem.min == "undefined" ? 0 : elem.min;

                                            if (min > 0 && min == elem.value) {
                                                elem.value = 0;
                                            }

                                            if (Number.isInteger(elem.hop)) {
                                                elem.value = elem.value + elem.hop;
                                            } else {
                                                elem.value = (
                                                    Number(elem.value) + Number(elem.hop)
                                                ).toFixed(1);
                                            }

                                            elem.value = Number(elem.value);

                                            if (elem.value > elem.max) {
                                                elem.value = elem.max;
                                            }
                                        } else {
                                            elem.value++;
                                        }
                                        MenuData.change(focused.namespace, focused.name, elem);
                                        MenuData.submit(focused.namespace, focused.name, elem);
                                    }

                                    MenuData.render();
                                    break;
                                }

                                default:
                                    break;
                            }

                            let selectedElement = $("#menu_" + focused.namespace + "_" + focused.name).find(".menu-item.selected, .grid-item.selected");
                            if (selectedElement.length > 0) {
                                scrollToElement(selectedElement[0]);
                            }
                        }

                        break;
                    }

                    default:
                        break;
                }

                break;
            }
        }
    };

    window.onload = function (e) {
        window.addEventListener("message", (event) => {
            onData(event.data);
        });
    };
})();
