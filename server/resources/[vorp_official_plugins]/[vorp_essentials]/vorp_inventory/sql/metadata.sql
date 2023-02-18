ALTER TABLE items ADD COLUMN IF NOT EXISTS `id` int UNIQUE AUTO_INCREMENT;
ALTER TABLE items ADD COLUMN IF NOT EXISTS `metadata` JSON DEFAULT ('{}');

ALTER TABLE loadout ADD COLUMN IF NOT EXISTS `curr_inv` VARCHAR(100) DEFAULT 'default' NOT NULL;


CREATE TABLE IF NOT EXISTS items_crafted (
    id           int auto_increment primary key,
    character_id int                                 not null,
    item_id      int                                 not null,
    updated_at   timestamp default CURRENT_TIMESTAMP not null,
    metadata     json                                not null,
    constraint ID unique (id)
) COLLATE='utf8mb4_general_ci' ENGINE=InnoDB;

-- Create index to speed up request for each character inventory
CREATE INDEX crafted_item_idx
    ON items_crafted (character_id);


CREATE TABLE IF NOT EXISTS character_inventories
(
    character_id    int                                    null,
    inventory_type  varchar(100) default 'default'         not null,
    item_crafted_id int                                    not null,
    amount          int                                    null,
    created_at      timestamp    default CURRENT_TIMESTAMP null
) COLLATE='utf8mb4_general_ci' ENGINE=InnoDB;

-- Create index to speed up request for each character inventory
CREATE INDEX character_inventory_idx
    ON character_inventories (character_id, inventory_type);



-- If you want to convert the old inventory format to the new one, run this part of the file.
-- It will keep the old inventory in the characters table, but all data will be copied and parsed into the new tables.

-- Convert Json items into separate rows and insert them in items_crafted
INSERT INTO items_crafted (
      character_id,
      item_id,
      metadata)
WITH
  i AS (SELECT id, item FROM items),
  c AS (SELECT charidentifier, inventory FROM characters )
SELECT c.charidentifier, i.id, '{}' as metadata FROM i JOIN c
    WHERE JSON_CONTAINS(JSON_KEYS(c.inventory), JSON_QUOTE(i.item), '$');

-- Assign amount to newly created items and Assign character and inventory type
INSERT INTO character_inventories (
                                   character_id,
                                   inventory_type,
                                   item_crafted_id,
                                   amount
                                   )
WITH
  i AS (SELECT id, item FROM items),
  c AS (SELECT charidentifier, inventory FROM characters),
  ic AS (SELECT id, character_id, item_id FROM items_crafted)
SELECT c.charidentifier, 'default', ic.id, JSON_EXTRACT(c.inventory, CONCAT('$.', i.item)) as amount FROM i JOIN c JOIN ic
    WHERE JSON_CONTAINS(JSON_KEYS(c.inventory), JSON_QUOTE(i.item), '$')
      AND ic.item_id = i.id AND ic.character_id = c.charidentifier
GROUP BY c.charidentifier, ic.id, c.inventory;