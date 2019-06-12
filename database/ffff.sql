-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.1.40-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             10.1.0.5464
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for tinvoice
DROP DATABASE IF EXISTS `tinvoice`;
CREATE DATABASE IF NOT EXISTS `tinvoice` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `tinvoice`;

-- Dumping structure for table tinvoice.accounts_bank
DROP TABLE IF EXISTS `accounts_bank`;
CREATE TABLE IF NOT EXISTS `accounts_bank` (
  `account_bank_id` int(11) NOT NULL AUTO_INCREMENT,
  `account_bank_number` varchar(20) CHARACTER SET utf8 NOT NULL,
  `account_bank_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `account_bank_address` varchar(100) CHARACTER SET utf8 NOT NULL,
  `account_bank_swift` varchar(100) CHARACTER SET utf8 NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`account_bank_id`),
  KEY `FK_accounts_bank_users` (`user_id`),
  CONSTRAINT `FK_accounts_bank_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table tinvoice.accounts_bank: ~2 rows (approximately)
/*!40000 ALTER TABLE `accounts_bank` DISABLE KEYS */;
INSERT INTO `accounts_bank` (`account_bank_id`, `account_bank_number`, `account_bank_name`, `account_bank_address`, `account_bank_swift`, `user_id`) VALUES
	(1, '123', 'ACB', 'Can Tho', '1234', 3),
	(2, '4567', 'BIDV', 'TPHCM', '789', 1);
/*!40000 ALTER TABLE `accounts_bank` ENABLE KEYS */;

-- Dumping structure for table tinvoice.bills
DROP TABLE IF EXISTS `bills`;
CREATE TABLE IF NOT EXISTS `bills` (
  `bill_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `bill_date` date DEFAULT NULL,
  `status_bill_id` int(11) NOT NULL,
  `account_bank_id` int(11) NOT NULL,
  `templates_id` int(11) NOT NULL DEFAULT '1',
  `bills_sum` float DEFAULT NULL,
  `bill_monthly_cost` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`bill_id`),
  KEY `customer_id` (`customer_id`),
  KEY `user_id` (`user_id`),
  KEY `status_bill_id` (`status_bill_id`),
  KEY `account_bank_id` (`account_bank_id`),
  KEY `templates_id` (`templates_id`),
  CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `bills_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `bills_ibfk_3` FOREIGN KEY (`status_bill_id`) REFERENCES `status_bill` (`status_bill_id`),
  CONSTRAINT `bills_ibfk_4` FOREIGN KEY (`account_bank_id`) REFERENCES `accounts_bank` (`account_bank_id`),
  CONSTRAINT `bills_ibfk_5` FOREIGN KEY (`templates_id`) REFERENCES `templates` (`templates_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- Dumping data for table tinvoice.bills: ~5 rows (approximately)
/*!40000 ALTER TABLE `bills` DISABLE KEYS */;
INSERT INTO `bills` (`bill_id`, `customer_id`, `user_id`, `bill_date`, `status_bill_id`, `account_bank_id`, `templates_id`, `bills_sum`, `bill_monthly_cost`) VALUES
	(2, 1, 3, '2019-06-02', 1, 1, 1, 133, '2019-05'),
	(3, 1, 3, '2019-06-03', 1, 2, 1, 11, '2019-02'),
	(4, 2, 3, '2019-06-03', 1, 1, 1, 66, '2019-06'),
	(5, 2, 3, '2019-06-03', 1, 2, 1, 114, '2019-06'),
	(7, 1, 3, '2019-06-04', 1, 2, 1, 34, '2019-06');
/*!40000 ALTER TABLE `bills` ENABLE KEYS */;

-- Dumping structure for table tinvoice.bill_items
DROP TABLE IF EXISTS `bill_items`;
CREATE TABLE IF NOT EXISTS `bill_items` (
  `bill_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `bill_id` int(11) NOT NULL,
  `bill_item_description` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `bill_item_cost` float DEFAULT NULL,
  PRIMARY KEY (`bill_item_id`),
  KEY `bill_id` (`bill_id`),
  CONSTRAINT `bill_items_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`bill_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

-- Dumping data for table tinvoice.bill_items: ~11 rows (approximately)
/*!40000 ALTER TABLE `bill_items` DISABLE KEYS */;
INSERT INTO `bill_items` (`bill_item_id`, `bill_id`, `bill_item_description`, `bill_item_cost`) VALUES
	(3, 2, '11', 111),
	(4, 2, '22', 22),
	(5, 3, '333', 11),
	(6, 4, '1', 11),
	(7, 4, '2', 22),
	(8, 4, '3', 33),
	(9, 5, 'ghfgf', 111),
	(10, 5, 'ww', 3),
	(13, 7, '11', 1),
	(14, 7, '33', 22),
	(15, 7, '11', 11);
/*!40000 ALTER TABLE `bill_items` ENABLE KEYS */;

-- Dumping structure for table tinvoice.customers
DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `customer_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `customer_email` varchar(100) CHARACTER SET utf8 NOT NULL,
  `customer_number_phone` varchar(100) CHARACTER SET utf8 NOT NULL,
  `customer_address` varchar(300) CHARACTER SET utf8 NOT NULL,
  `customer_details_id` int(11) NOT NULL,
  PRIMARY KEY (`customer_id`),
  KEY `customer_details_id` (`customer_details_id`),
  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`customer_details_id`) REFERENCES `customer_details` (`customer_details_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table tinvoice.customers: ~2 rows (approximately)
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` (`customer_id`, `customer_name`, `customer_email`, `customer_number_phone`, `customer_address`, `customer_details_id`) VALUES
	(1, 'Van Toan', 'toan@gmail.com', '0123456778', 'Can Tho', 1),
	(2, 'Van Toan1', 'toa1n@gmail.com', '0123456778111', 'Can Tho1', 2);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;

-- Dumping structure for table tinvoice.customer_details
DROP TABLE IF EXISTS `customer_details`;
CREATE TABLE IF NOT EXISTS `customer_details` (
  `customer_details_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_details_company` varchar(100) CHARACTER SET utf8 NOT NULL,
  `customer_details_project` varchar(100) CHARACTER SET utf8 NOT NULL,
  `customer_details_country` varchar(100) CHARACTER SET utf8 NOT NULL,
  `customer_details_note` varchar(300) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`customer_details_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table tinvoice.customer_details: ~2 rows (approximately)
/*!40000 ALTER TABLE `customer_details` DISABLE KEYS */;
INSERT INTO `customer_details` (`customer_details_id`, `customer_details_company`, `customer_details_project`, `customer_details_country`, `customer_details_note`) VALUES
	(1, 'Toan', 'Toan', 'VN', '94000'),
	(2, 'Toan1', 'Toan1', 'VN', '94000');
/*!40000 ALTER TABLE `customer_details` ENABLE KEYS */;

-- Dumping structure for table tinvoice.groups_user
DROP TABLE IF EXISTS `groups_user`;
CREATE TABLE IF NOT EXISTS `groups_user` (
  `groups_user_id` int(11) NOT NULL AUTO_INCREMENT,
  `groups_user_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `groups_user_description` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`groups_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table tinvoice.groups_user: ~2 rows (approximately)
/*!40000 ALTER TABLE `groups_user` DISABLE KEYS */;
INSERT INTO `groups_user` (`groups_user_id`, `groups_user_name`, `groups_user_description`) VALUES
	(1, 'DG4', ''),
	(2, 'DG3', '');
/*!40000 ALTER TABLE `groups_user` ENABLE KEYS */;

-- Dumping structure for table tinvoice.roles
DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `rode_description` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table tinvoice.roles: ~2 rows (approximately)
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` (`role_id`, `role_name`, `rode_description`) VALUES
	(1, 'Dr. Director', ''),
	(2, 'Director', '');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;

-- Dumping structure for table tinvoice.sessions
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int(11) unsigned NOT NULL,
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table tinvoice.sessions: ~1 rows (approximately)
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` (`session_id`, `expires`, `data`) VALUES
	('S3K7o7MlQEWublC5B1tbTHtIaePHhyX1', 1559707852, '{"cookie":{"originalMaxAge":null,"expires":null,"httpOnly":true,"path":"/"},"flash":{},"passport":{"user":3}}');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;

-- Dumping structure for table tinvoice.status_bill
DROP TABLE IF EXISTS `status_bill`;
CREATE TABLE IF NOT EXISTS `status_bill` (
  `status_bill_id` int(11) NOT NULL AUTO_INCREMENT,
  `status_bill_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `status_bill_description` varchar(300) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`status_bill_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table tinvoice.status_bill: ~2 rows (approximately)
/*!40000 ALTER TABLE `status_bill` DISABLE KEYS */;
INSERT INTO `status_bill` (`status_bill_id`, `status_bill_name`, `status_bill_description`) VALUES
	(1, 'Not Sent', ''),
	(2, 'Sent', ''),
	(3, 'Paid', '');
/*!40000 ALTER TABLE `status_bill` ENABLE KEYS */;

-- Dumping structure for table tinvoice.templates
DROP TABLE IF EXISTS `templates`;
CREATE TABLE IF NOT EXISTS `templates` (
  `templates_id` int(11) NOT NULL AUTO_INCREMENT,
  `templates_logo` varchar(100) CHARACTER SET utf8 NOT NULL,
  `templates_name_company` varchar(100) CHARACTER SET utf8 NOT NULL,
  `templates_address` varchar(100) CHARACTER SET utf8 NOT NULL,
  `templates_phone` varchar(30) CHARACTER SET utf8 NOT NULL,
  `templates_email` varchar(100) CHARACTER SET utf8 NOT NULL,
  `templates_name_form` varchar(100) CHARACTER SET utf8 NOT NULL,
  `templates_monthly_cost_for` varchar(100) CHARACTER SET utf8 NOT NULL,
  `templates_name_on_account` varchar(100) CHARACTER SET utf8 NOT NULL,
  `templates_tel` varchar(100) CHARACTER SET utf8 NOT NULL,
  `templates_fax` varchar(100) CHARACTER SET utf8 NOT NULL,
  `templates_name_cfo` varchar(100) CHARACTER SET utf8 NOT NULL,
  `templates_tel_cfo` varchar(100) CHARACTER SET utf8 NOT NULL,
  `templates_extension_cfo` varchar(100) CHARACTER SET utf8 NOT NULL,
  `templates_email_cfo` varchar(100) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`templates_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Dumping data for table tinvoice.templates: ~0 rows (approximately)
/*!40000 ALTER TABLE `templates` DISABLE KEYS */;
INSERT INTO `templates` (`templates_id`, `templates_logo`, `templates_name_company`, `templates_address`, `templates_phone`, `templates_email`, `templates_name_form`, `templates_monthly_cost_for`, `templates_name_on_account`, `templates_tel`, `templates_fax`, `templates_name_cfo`, `templates_tel_cfo`, `templates_extension_cfo`, `templates_email_cfo`) VALUES
	(1, 'logo.png', 'TUONG MINH SOFTWARE SOLUTIONS COMPANY LIMITED (TMA SOLUTIONS CO., LTD)', '111 Nguyen Dinh Chinh, Phu Nhuan Dist., Ho Chi Minh City, Vietnam', '+84 28 3997 8000', 'tma@tma.com.vn', 'INVOICE', 'Monthly cost for', 'TMA Solutions Co., LTD', '+84-28 38292288', '+84-28 38230530', 'Pham Ngoc Nhu Duong', '+84 28 3997 8000', ' 5211', 'pnnduong@tma.com.vn');
/*!40000 ALTER TABLE `templates` ENABLE KEYS */;

-- Dumping structure for table tinvoice.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_fullname` varchar(100) CHARACTER SET utf8 NOT NULL,
  `user_username` varchar(100) CHARACTER SET utf8 NOT NULL,
  `user_password` varchar(60) CHARACTER SET utf8 NOT NULL,
  `role_id` int(11) NOT NULL,
  `groups_user_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `role_id` (`role_id`),
  KEY `groups_user_id` (`groups_user_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`groups_user_id`) REFERENCES `groups_user` (`groups_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table tinvoice.users: ~2 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`user_id`, `user_fullname`, `user_username`, `user_password`, `role_id`, `groups_user_id`) VALUES
	(1, 'Dang nguyen', 'dang', '$2a$10$dUq5l5UcHYchJ5tYZIX/fOslX6gHMSFhAhH/EZ4740j3MRImr.6O6', 1, 1),
	(2, 'Dang nguyen', 'dangz', '$2a$10$qIJq/QPIXp1V0zXF9OkxdexHYD41o1IOLJ9VkZubOEeP7GF.t/FB2', 2, 1),
	(3, 'Dang nguyen', 'dang1', '$2a$10$nzEO0GHeKI6HbqkH7okVDumU2ZTqDpZPlteebds0M9AEYjExK6KoW', 1, 1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Dumping structure for table tinvoice.users_customers
DROP TABLE IF EXISTS `users_customers`;
CREATE TABLE IF NOT EXISTS `users_customers` (
  `users_customers` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  PRIMARY KEY (`users_customers`),
  KEY `user_id` (`user_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `users_customers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `users_customers_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table tinvoice.users_customers: ~2 rows (approximately)
/*!40000 ALTER TABLE `users_customers` DISABLE KEYS */;
INSERT INTO `users_customers` (`users_customers`, `user_id`, `customer_id`) VALUES
	(1, 3, 1),
	(2, 3, 2);
/*!40000 ALTER TABLE `users_customers` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
