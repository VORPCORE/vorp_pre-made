
local Tables = {
    {
        name = "loadout",
        script = "vorp_inventory",
        sql = [[
            CREATE TABLE IF NOT EXISTS `loadout` (
                `id` INT NOT NULL AUTO_INCREMENT,
                `identifier` VARCHAR(50) NOT NULL,
                `charidentifier` INT NULL,
                `name` VARCHAR(50) NULL DEFAULT NULL,
                `ammo` VARCHAR(255) NOT NULL DEFAULT '{}',
                `components` VARCHAR(255) NOT NULL DEFAULT '[]',
                `dirtlevel` DOUBLE NULL DEFAULT 0,
                `mudlevel` DOUBLE NULL DEFAULT 0,
                `conditionlevel` DOUBLE NULL DEFAULT 0,
                `rustlevel` DOUBLE NULL DEFAULT 0,
                `used` TINYINT NULL DEFAULT 0,
                PRIMARY KEY (`id`),
                INDEX `id` (`id`)
            )
            COLLATE='utf8mb4_general_ci'
            ENGINE=InnoDB
            AUTO_INCREMENT=2;
        ]]
    },
    {
        name = "items",
        script = "vorp_inventory",
        sql = [[
            CREATE TABLE IF NOT EXISTS `items` (
                `item` VARCHAR(50) NOT NULL,
                `label` VARCHAR(50) NOT NULL,
                `limit` INT NOT NULL DEFAULT 1,
                `can_remove` TINYINT NOT NULL DEFAULT 1,
                `type` VARCHAR(50) NULL DEFAULT NULL,
                `usable` TINYINT NULL DEFAULT NULL,
                PRIMARY KEY (`item`) USING BTREE
            )
            COLLATE='utf8mb4_general_ci'
            ENGINE=InnoDB
            ROW_FORMAT=DYNAMIC;
        ]]
    },
    {
        name = "items_crafted",
        script = "vorp_inventory",
        sql = [[
            CREATE TABLE IF NOT EXISTS items_crafted (
                id           int auto_increment primary key,
                character_id int                                 not null,
                item_id      int                                 not null,
                updated_at   timestamp default CURRENT_TIMESTAMP not null,
                metadata     json                                not null,
                constraint ID unique (id),
                INDEX `crafted_item_idx` (`character_id`)
            ) COLLATE='utf8mb4_general_ci' ENGINE=InnoDB;
        ]]
    },
    {
        name = "character_inventories",
        script = "vorp_inventory",
        sql = [[
            CREATE TABLE IF NOT EXISTS character_inventories (
                character_id    int                                    null,
                inventory_type  varchar(100) default 'default'         not null,
                item_crafted_id int                                    not null,
                amount          int                                    null,
                created_at      timestamp    default CURRENT_TIMESTAMP null,
                INDEX `character_inventory_idx` (`character_id`, `inventory_type`)
            ) COLLATE='utf8mb4_general_ci' ENGINE=InnoDB;
        ]]
    }
}

local Updates = {
    {
        name = "dropped",
        script = "vorp_inventoryv",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'loadout'
            AND  Column_Name = 'dropped';
        ]],
        sql = [[
            ALTER TABLE `loadout` ADD COLUMN `dropped` INT NOT NULL DEFAULT 0;
        ]]
    },
    {
        name = "comps",
        script = "vorp_inventoryv",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'loadout'
            AND  Column_Name = 'comps';
        ]],
        sql = [[
            ALTER TABLE `loadout` ADD COLUMN `comps` VARCHAR(5550) NOT NULL DEFAULT '{}';
        ]]
    },
    {
        name = "used2",
        script = "vorp_inventoryv",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'loadout'
            AND  Column_Name = 'used2';
        ]],
        sql = [[
            ALTER TABLE `loadout` ADD COLUMN `used2` tinyint NOT NULL DEFAULT 0;
        ]]
    },
    {
        name = "desc",
        script = "vorp_inventoryv",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'items'
            AND  Column_Name = 'desc';
        ]],
        sql = [[
            ALTER TABLE `items` ADD COLUMN `desc` VARCHAR(5550) NOT NULL DEFAULT 'nice item';
        ]]
    },
    {
        name = "id",
        script = "vorp_inventory",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'items'
            AND  Column_Name = 'id';
        ]],
        sql = [[
            ALTER TABLE items ADD COLUMN `id` int UNIQUE AUTO_INCREMENT;
        ]]
    },
    {
        name = "metadata",
        script = "vorp_inventory",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'items'
            AND  Column_Name = 'metadata';
        ]],
        sql = [[
            ALTER TABLE items ADD COLUMN `metadata` JSON DEFAULT ('{}');
        ]]
    },
    {
        name = "curr_inv",
        script = "vorp_inventory",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'loadout'
            AND  Column_Name = 'curr_inv';
        ]],
        sql = [[
            ALTER TABLE loadout ADD COLUMN IF NOT EXISTS `curr_inv` VARCHAR(100) DEFAULT 'default' NOT NULL;
        ]]
    }
}



local tries = 10
local currentry = 1

local function getCore()
    TriggerEvent("getCore", function(core)
        if not core.dbUpdateAddTables and not core.dbUpdateAddUpdates then
            if currentry < tries then
                currentry = currentry + 1
                getCore()
            end
        else
            core.dbUpdateAddTables(Tables)
            core.dbUpdateAddUpdates(Updates)
        end
    end)
end

Citizen.CreateThread(function()
    getCore()
end)
