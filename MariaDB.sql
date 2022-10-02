/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `vorpv2` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `vorpv2`;

CREATE TABLE IF NOT EXISTS `banks` (
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bank_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `charidentifier` int(11) NOT NULL,
  `money` double(22,2) DEFAULT 0.00,
  `gold` double(22,2) DEFAULT 0.00,
  `items` longtext DEFAULT '[]',
  `invspace` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  CONSTRAINT `bank` FOREIGN KEY (`name`) REFERENCES `banks` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `banneds` (
  `b_id` int(11) NOT NULL AUTO_INCREMENT,
  `b_steam` varchar(100) NOT NULL,
  `b_license` varchar(255) DEFAULT NULL,
  `b_discord` varchar(100) DEFAULT NULL,
  `b_reason` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `b_banned` varchar(100) NOT NULL,
  `b_unban` varchar(100) NOT NULL,
  `b_permanent` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`b_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` longtext DEFAULT NULL,
  `playername` longtext DEFAULT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `charidentifier` int(11) DEFAULT NULL,
  `issuer` longtext DEFAULT NULL,
  `amount` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `characters` (
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `steamname` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `charidentifier` int(11) NOT NULL AUTO_INCREMENT,
  `group` varchar(10) COLLATE utf8mb4_bin DEFAULT 'user',
  `money` double(11,2) DEFAULT 0.00,
  `gold` double(11,2) DEFAULT 0.00,
  `rol` double(11,2) NOT NULL DEFAULT 0.00,
  `xp` int(11) DEFAULT 0,
  `healthouter` int(4) DEFAULT 500,
  `healthinner` int(4) DEFAULT 100,
  `staminaouter` int(4) DEFAULT 100,
  `staminainner` int(4) DEFAULT 100,
  `hours` float NOT NULL DEFAULT 0,
  `inventory` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `job` varchar(50) COLLATE utf8mb4_bin DEFAULT 'unemployed',
  `status` varchar(140) COLLATE utf8mb4_bin DEFAULT '{}',
  `meta` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '{}',
  `firstname` varchar(50) COLLATE utf8mb4_bin DEFAULT ' ',
  `lastname` varchar(50) COLLATE utf8mb4_bin DEFAULT ' ',
  `skinPlayer` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `compPlayer` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `jobgrade` int(11) DEFAULT 0,
  `coords` varchar(75) COLLATE utf8mb4_bin DEFAULT '{}',
  `isdead` tinyint(1) DEFAULT 0,
  `clanid` int(11) DEFAULT 0,
  `trust` int(11) DEFAULT 0,
  `supporter` int(11) DEFAULT 0,
  `walk` varchar(50) COLLATE utf8mb4_bin DEFAULT 'noanim',
  `crafting` longtext COLLATE utf8mb4_bin DEFAULT '{"medical":0,"blacksmith":0,"basic":0,"survival":0,"brewing":0,"food":0}',
  `info` longtext COLLATE utf8mb4_bin DEFAULT '{}',
  `gunsmith` double(11,2) DEFAULT 0.00,
  `ammo` longtext COLLATE utf8mb4_bin DEFAULT '{}',
  `clan` int(11) DEFAULT 0,
  `discordid` varchar(255) COLLATE utf8mb4_bin DEFAULT '0',
  `lastjoined` longtext COLLATE utf8mb4_bin DEFAULT '[]',
  `motel` varchar(255) COLLATE utf8mb4_bin DEFAULT '0',
  `moonshineenty` longtext COLLATE utf8mb4_bin DEFAULT '{}',
  UNIQUE KEY `identifier_charidentifier` (`identifier`,`charidentifier`) USING BTREE,
  KEY `charidentifier` (`charidentifier`) USING BTREE,
  KEY `clanid` (`clanid`),
  KEY `crafting` (`crafting`(768)),
  KEY `compPlayer` (`compPlayer`(768)),
  KEY `info` (`info`(768)),
  KEY `inventory` (`inventory`(768)),
  KEY `coords` (`coords`),
  KEY `money` (`money`),
  KEY `meta` (`meta`),
  KEY `steamname` (`steamname`),
  CONSTRAINT `FK_characters_users` FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `character_inventories` (
  `character_id` int(11) DEFAULT NULL,
  `inventory_type` varchar(100) NOT NULL DEFAULT 'default',
  `item_crafted_id` int(11) NOT NULL,
  `amount` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  KEY `character_inventory_idx` (`character_id`,`inventory_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `doors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `doorinfo` longtext NOT NULL DEFAULT '[]',
  `job` longtext NOT NULL DEFAULT '[]',
  `item` longtext NOT NULL,
  `break` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `herbalists` (
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `charidentifier` int(11) NOT NULL,
  `location` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`identifier`) USING BTREE,
  UNIQUE KEY `identifier_charidentifier` (`identifier`,`charidentifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `horses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(40) NOT NULL,
  `charid` int(11) NOT NULL,
  `selected` int(11) NOT NULL DEFAULT 0,
  `model` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `components` varchar(5000) NOT NULL DEFAULT '{}',
  `exp` int(11) NOT NULL DEFAULT 0,
  `items` longtext DEFAULT '{}',
  `sex` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `FK_horses_characters` (`charid`),
  KEY `model` (`model`)
) ENGINE=InnoDB AUTO_INCREMENT=397 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `horse_complements` (
  `identifier` varchar(50) NOT NULL,
  `charidentifier` int(11) NOT NULL,
  `complements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  UNIQUE KEY `identifier` (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `housing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) DEFAULT NULL,
  `charidentifier` int(11) NOT NULL,
  `inventory` longtext DEFAULT NULL,
  `furniture` longtext DEFAULT NULL,
  `open` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=50691 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `items` (
  `item` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `limit` int(11) NOT NULL DEFAULT 1,
  `can_remove` tinyint(1) NOT NULL DEFAULT 1,
  `type` varchar(50) DEFAULT NULL,
  `usable` tinyint(1) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{}' CHECK (json_valid(`metadata`)),
  `desc` varchar(5550) NOT NULL DEFAULT 'nice item',
  PRIMARY KEY (`item`) USING BTREE,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=897 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `items_crafted` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `character_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`metadata`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ID` (`id`),
  KEY `crafted_item_idx` (`character_id`)
) ENGINE=InnoDB AUTO_INCREMENT=508 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `jail` (
  `identifier` varchar(100) NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL DEFAULT '0',
  `characterid` varchar(5) NOT NULL DEFAULT '0',
  `time` varchar(100) NOT NULL DEFAULT '0',
  `time_s` varchar(100) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `loadout` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `charidentifier` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `ammo` varchar(255) NOT NULL DEFAULT '{}',
  `components` varchar(255) NOT NULL DEFAULT '{}',
  `dirtlevel` double DEFAULT 0,
  `mudlevel` double DEFAULT 0,
  `conditionlevel` double DEFAULT 0,
  `rustlevel` double DEFAULT 0,
  `used` tinyint(4) DEFAULT 0,
  `used2` tinyint(4) DEFAULT 0,
  `dropped` int(11) NOT NULL DEFAULT 0,
  `comps` longtext NOT NULL DEFAULT '{}',
  `label` varchar(50) DEFAULT NULL,
  `curr_inv` varchar(100) NOT NULL DEFAULT 'default',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2348 DEFAULT CHARSET=utf8mb4;



CREATE TABLE IF NOT EXISTS `mail_inbox` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `adress` int(11) DEFAULT NULL,
  `msgs` longtext DEFAULT NULL,
  `date` longtext DEFAULT NULL,
  `time` longtext DEFAULT NULL,
  `sender` longtext DEFAULT NULL,
  `unred` int(11) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=337 DEFAULT CHARSET=utf8mb4;



CREATE TABLE IF NOT EXISTS `newspaper` (
  `news` longtext DEFAULT '[]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(45) NOT NULL,
  `charidentifier` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `comps` longtext DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=841 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;



CREATE TABLE IF NOT EXISTS `robbery` (
  `name_robbery` varchar(50) COLLATE latin1_general_cs DEFAULT '0',
  `time_robbery` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

CREATE TABLE IF NOT EXISTS `rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `interiorId` int(11) NOT NULL,
  `inventory` longtext DEFAULT NULL,
  `identifier` varchar(60) NOT NULL,
  `charidentifier` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;



CREATE TABLE IF NOT EXISTS `stables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `charidentifier` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `modelname` varchar(70) NOT NULL,
  `type` varchar(11) NOT NULL,
  `status` longtext DEFAULT NULL,
  `xp` int(11) DEFAULT 0,
  `injured` int(11) DEFAULT 0,
  `gear` longtext DEFAULT NULL,
  `isDefault` int(11) NOT NULL DEFAULT 0,
  `inventory` longtext DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `stagecoaches` (
  `identifier` varchar(40) NOT NULL,
  `charid` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `stagecoach` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



CREATE TABLE IF NOT EXISTS `users` (
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `group` varchar(50) DEFAULT 'user',
  `warnings` int(11) DEFAULT 0,
  `banned` tinyint(1) DEFAULT NULL,
  `banneduntil` int(10) DEFAULT 0,
  `char` varchar(50) NOT NULL DEFAULT 'false',
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `wagons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(40) NOT NULL,
  `charid` int(11) NOT NULL,
  `selected` int(11) NOT NULL DEFAULT 0,
  `model` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `items` longtext DEFAULT '{}',
  PRIMARY KEY (`id`),
  KEY `FK_horses_characters` (`charid`),
  KEY `model` (`model`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `wagon_water` (
  `identifier` varchar(255) COLLATE latin1_general_cs DEFAULT '0',
  `charid` varchar(255) COLLATE latin1_general_cs DEFAULT '0',
  `wagon` varchar(255) COLLATE latin1_general_cs DEFAULT '0',
  `water` varchar(255) COLLATE latin1_general_cs DEFAULT '0',
  `wagon_name` varchar(50) COLLATE latin1_general_cs DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

CREATE TABLE IF NOT EXISTS `whitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `firstconnection` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `identifier` (`identifier`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

