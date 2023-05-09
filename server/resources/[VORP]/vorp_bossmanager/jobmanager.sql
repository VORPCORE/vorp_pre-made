
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


CREATE TABLE `jobmanager` (
  `identifier` varchar(50) NOT NULL,
  `charidentifier` int(11) NOT NULL,
  `jobname` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `jobmanager`
  ADD PRIMARY KEY (`identifier`,`charidentifier`);
COMMIT;

