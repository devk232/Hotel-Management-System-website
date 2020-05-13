DROP DATABASE IF EXISTS `Hotel_Management`;
CREATE DATABASE `Hotel_Management`; 
USE `Hotel_Management`;

SET NAMES utf8 ;
SET character_set_client = utf8mb4 ;

CREATE TABLE IF NOT EXISTS `customers`(
	`customer_id` INT NOT NULL AUTO_INCREMENT,
	`first_name` varchar(100) NOT NULL,
    `last_name` varchar(100) NOT NULL,
	`email` varchar(255) NOT NULL,
    `mobile_number` bigint NOT NULL,
	`password` varchar(255) NOT NULL,
     PRIMARY KEY (`customer_id`)
);

CREATE TABLE IF NOT EXISTS `hotels`(
	`hotel_id` INT NOT NULL AUTO_INCREMENT,
    `hotel_name` varchar(255) NOT NULL,
	`rating` DECIMAL(2,1) NOT NULL,
    `no_of_reviews` BIGINT NOT NULL default 0,
     PRIMARY KEY (`hotel_id`)
);

CREATE TABLE IF NOT EXISTS `hotels_location`(
	`hotel_id` INT  AUTO_INCREMENT ,
	`address` VARCHAR(255) NOT NULL,
    `city` VARCHAR(50) NOT NULL,
    primary key (`hotel_id`),
    FOREIGN KEY (`hotel_id`) REFERENCES hotels(`hotel_id`)
);

CREATE TABLE IF NOT EXISTS `hotels_contact`(
	`hotel_id` INT AUTO_INCREMENT,
    `telephone_no` VARCHAR(20) NOT NULL,
    `mobile_no` BIGINT NOT NULL,
     PRIMARY KEY (`hotel_id`),
     FOREIGN KEY (`hotel_id`) REFERENCES hotels(`hotel_id`)
);

CREATE TABLE IF NOT EXISTS `rooms_category`(
	`room_category_id` INT AUTO_INCREMENT,
    `category_name` VARCHAR(20),
    PRIMARY KEY (`room_category_id`)
);

CREATE TABLE IF NOT EXISTS `rooms` (
	 `room_category_id` INT AUTO_INCREMENT,
	 `hotel_id` INT NOT NULL,
     `unit_price` INT NOT NULL,
     `available_quantity` INT NOT NULL,
     PRIMARY KEY (`hotel_id`,`room_category_id`),
     FOREIGN KEY (`hotel_id`) REFERENCES hotels(`hotel_id`),
     FOREIGN KEY (`room_category_id`) REFERENCES rooms_category(`room_category_id`)
);

CREATE TABLE if not EXISTS `bookings`(
	`booking_id` INT AUTO_INCREMENT,
    `hotel_id` INT NOT NULL,
    `customer_id` INT NOT NULL,
    `start_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `end_time`  DATETIME NOT NULL,
    `status`  TINYINT DEFAULT 1,
    PRIMARY KEY (`booking_id`),
    FOREIGN KEY (`customer_id`) REFERENCES customers(`customer_id`),
    FOREIGN KEY (`hotel_id`) REFERENCES hotels(`hotel_id`)
);

CREATE TABLE IF NOT EXISTS `hotel_images`(
	`hotel_id` INT AUTO_INCREMENT,
    `image_1` VARCHAR(255) DEFAULT NULL,
    `image_2` VARCHAR(255) DEFAULT NULL,
    `image_3` VARCHAR(255) DEFAULT NULL,
    `image_4` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`hotel_id`),
    FOREIGN KEY (`hotel_id`) REFERENCES hotels(`hotel_id`)
);

CREATE TABLE IF NOT EXISTS `booking_items`(
	`booking_id` INT NOT NULL,
    `room_category_id` INT NOT NULL,
    `quantity` INT NOT NULL,
    PRIMARY KEY (`booking_id`,`room_category_id`),
    FOREIGN KEY (`room_category_id`) REFERENCES rooms_category(`room_category_id`),
    FOREIGN KEY (`booking_id`) REFERENCES bookings(`booking_id`)
);

INSERT INTO `hotels` VALUES (1,'Hotel Ambience',03.90,1212);
INSERT INTO `hotels_location` VALUES (1,'Opposite Platform No. 1 Railway Station Campus', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (1,'0751 404 0341',9876852321);

INSERT INTO `hotels` VALUES (2,'Prince mamma',04.13,1177);
INSERT INTO `hotels_location` VALUES (2,'Near IPS college', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (2,'0222 123 4567',9404483791);

INSERT INTO `hotels` VALUES (3,'Rama Utsav',03.97,903);
INSERT INTO `hotels_location` VALUES (3,'Near CP colony seven square', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (3,'0722 231 949',8975963712);

INSERT INTO `hotels` VALUES (4,'Hotel Sumangal',04.95,517);
INSERT INTO `hotels_location` VALUES (4,'near Hazira Square', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (4,'0452 471 0849',9432145626);

INSERT INTO `hotels` VALUES (5,'The Imperial Hotel',03.07,1579);
INSERT INTO `hotels_location` VALUES (5,'near manmendra school', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (5,'0238 964 7531',9075431256);

INSERT INTO `hotels` VALUES (6,'Ram Krishan Home',04.70,865);
INSERT INTO `hotels_location` VALUES (6,'Near Gole ka Mandir', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (6,'0276 891 5347',8929184512);

INSERT INTO `hotels` VALUES (7,'Hotel Golden Square',05.00,115);
INSERT INTO `hotels_location` VALUES (7,'Roxy pul', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (7,'0782 431 9654',9077431862);

INSERT INTO `hotels` VALUES (8,'Ratnakar Plaza',04.05,779);
INSERT INTO `hotels_location` VALUES (8,'Near Gorki school', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (8,'0217 376 8562',9423415690);

INSERT INTO `hotels` VALUES (8,'Baghban Residency',03.95,1498);
INSERT INTO `hotels_location` VALUES (8,'Near Millenium Plaza', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (8,'0273 852 0145',9012450360);

INSERT INTO `hotels` VALUES (9,'Hotel Plaza Lodge',04.20,989);
INSERT INTO `hotels_location` VALUES (9,'Near phool Bagh', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (9,'0730 751 8561',8944563120);

INSERT INTO `hotels` VALUES (10,'Seva Guest House',04.15,973);
INSERT INTO `hotels_location` VALUES (10,'Race Course Road', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (10,'0221 410 2308',9405064517);





