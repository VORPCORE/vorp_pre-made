CREATE TABLE IF NOT EXISTS `jail` (
  `identifier` varchar(100) NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL DEFAULT '0',
  `characterid` varchar(5) NOT NULL DEFAULT '0',
  `time` varchar(100) NOT NULL DEFAULT '0',
  `time_s` varchar(100) NOT NULL DEFAULT '0',
	`jaillocation` varchar(100) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `communityservice` (
  `identifier` varchar(100) NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL DEFAULT '0',
  `characterid` varchar(5) NOT NULL DEFAULT '0',
  `communityservice` varchar(100) NOT NULL DEFAULT '0',
  `servicecount` varchar(100) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `society_ledger` (
  `job` longtext DEFAULT NULL,
  `ledger` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `society_ledger` (`job`, `ledger`) VALUES
	('police', 0);
