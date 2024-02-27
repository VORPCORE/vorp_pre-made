use `vorpv2`;

INSERT IGNORE INTO items (`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES 
                         ('goldnugget', 'Gold Nugget', 50, 1, 'item_standard', 0),
                         ('clay', 'Copper Bar', 50, 1, 'item_standard', 0),
                         ('provision_coal', 'Zinc Bar', 50, 1, 'item_standard', 0),
                         ('copper', 'Titanium Bar', 50, 1, 'item_standard', 0),
                         ('iron', 'Blacksteel Bar', 50, 1, 'item_standard', 0),
                         ('sulfur', 'Brass Bar', 50, 1, 'item_standard', 0),
                         ('stone', 'Lead Bar', 50, 1, 'item_standard', 0),
                         ('pickaxe', 'Pickaxe', 1, 1, 'item_standard', 0);