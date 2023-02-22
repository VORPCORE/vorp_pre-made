USE `vorp`;

INSERT INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES
                    ('soborno', 'Soborno Alcohol', -1, 1, 'item_standard', 0),
                    ('water', 'Wasser', -1, 1, 'item_standard', 1),
	                ('pear', 'Birne', -1, 1, 'item_standard', 1),
                    ('currant', 'Johannisbeere', -1, 1, 'item_standard', 0),
                    ('apple', 'Apfel', -1, 1, 'item_standard', 1),
                    ('blackberry', 'Heidelbeere', -1, 1, 'item_standard', 0),
                    ('tropicalPunchMash', 'Tropical Punch Meische', -1, 1, 'item_standard', 0),
                    ('wildCiderMash', 'Wild Cider Meische', -1, 1, 'item_standard', 0),
                    ('appleCrumbMash', 'Apfel Beeren Meische', -1, 1, 'item_standard', 0),
                    ('tropicalPunchMoonshine', 'Tropical Punch Moonshine', -1, 1, 'item_standard', 0),
                    ('wildCiderMoonshine', 'Wild Cider Moonshine', -1, 1, 'item_standard', 0),
                    ('appleCrumbMoonshine', 'Apfel Beeren Moonshine', -1, 1, 'item_standard', 0),
                    ('mp001_p_mp_still02x', 'Brennerei', 1, 1, 'item_standard', 0),
                    ('p_barrelmoonshine', 'Meische Fass', 1, 1, 'item_standard', 0),
	                ('vanillaFlower', 'Vanille Blume', -1, 1, 'item_standard', 0);