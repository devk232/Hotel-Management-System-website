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
	 `room_category_id` INT NOT NULL,
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
    `start_time` DATE NOT NULL,
    `end_time`  DATE NOT NULL,
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

INSERT INTO `hotels` VALUES (1,'Hotel Ambience',3.9,1212);
INSERT INTO `hotels_location` VALUES (1,'Opposite Platform No. 1 Railway Station Campus', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (1,'0751 404 0341',9876852321);

INSERT INTO `hotels` VALUES (2,'The Vinayak',4.3,1177);
INSERT INTO `hotels_location` VALUES (2,'Maharani Laxmibai Marg', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (2,'0222 123 4567',9404483791);

INSERT INTO `hotels` VALUES (3,'Rama Utsav',5.0,9);
INSERT INTO `hotels_location` VALUES (3,'Near CP colony Seven Square', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (3,'0722 231 949',8975963712);

INSERT INTO `hotels` VALUES (4,'Hotel Sumangal',4.9,517);
INSERT INTO `hotels_location` VALUES (4,'Near Hazira Square', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (4,'0452 471 0849',9432145626);

INSERT INTO `hotels` VALUES (5,'The Imperial Hotel',3.0,1579);
INSERT INTO `hotels_location` VALUES (5,'Near Manmendra School', 'Dabra');
INSERT INTO `hotels_contact` VALUES (5,'0238 964 7531',9075431256);

INSERT INTO `hotels` VALUES (6,'Ram Krishan Home',4.7,865);
INSERT INTO `hotels_location` VALUES (6,'Near Gole ka Mandir', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (6,'0276 891 5347',8929184512);

INSERT INTO `hotels` VALUES (7,'Hotel Golden Square',4.8,1234);
INSERT INTO `hotels_location` VALUES (7,'Roxy Pul', 'Jhansi');
INSERT INTO `hotels_contact` VALUES (7,'0782 431 9654',9077431862);

INSERT INTO `hotels` VALUES (8,'Baghban Residency',3.9,1498);
INSERT INTO `hotels_location` VALUES (8,'Near Millenium Plaza', 'Jhansi');
INSERT INTO `hotels_contact` VALUES (8,'0273 852 0145',9012450360);

INSERT INTO `hotels` VALUES (9,'Hotel Plaza Lodge',4.2,989);
INSERT INTO `hotels_location` VALUES (9,'Near Phool Bagh', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (9,'0730 751 8561',8944563120);

INSERT INTO `hotels` VALUES (10,'Seva Guest House',4.1,973);
INSERT INTO `hotels_location` VALUES (10,'Race Course Road', 'Gwalior');
INSERT INTO `hotels_contact` VALUES (10,'0221 410 2308',9405064517);

INSERT INTO `hotel_images` VALUES (1,'1_1.jpeg','1_2.jpeg','1_3.jpeg','1_4.jpeg');
INSERT INTO `hotel_images` VALUES (2,'2_1.jpeg','2_2.jpeg','2_3.jpeg','2_4.jpeg');
INSERT INTO `hotel_images` VALUES (3,'3_1.jpeg','3_2.jpeg','3_3.jpeg','3_4.jpeg');
INSERT INTO `hotel_images` VALUES (4,'4_1.jpeg','4_2.jpeg','4_3.jpeg','4_4.jpeg');
INSERT INTO `hotel_images` VALUES (5,'5_1.jpeg','5_2.jpeg','5_3.jpeg','5_4.jpeg');
INSERT INTO `hotel_images` VALUES (6,'6_1.jpeg','6_2.jpeg','6_3.jpeg','6_4.jpeg');
INSERT INTO `hotel_images` VALUES (7,'7_1.jpeg','7_2.jpeg','7_3.jpeg','7_4.jpeg');
INSERT INTO `hotel_images` VALUES (8,'8_1.jpeg','8_2.jpeg','8_3.jpeg','8_4.jpeg');
INSERT INTO `hotel_images` VALUES (9,'9_1.jpeg','9_2.jpeg','9_3.jpeg','9_4.jpeg');
INSERT INTO `hotel_images` VALUES (10,'10_1.jpeg','10_2.jpeg','10_3.jpeg','10_4.jpeg');

INSERT INTO `rooms_category` VALUES (1, 'Single with AC');
INSERT INTO `rooms_category` VALUES (2, 'Single without AC');
INSERT INTO `rooms_category` VALUES (3, 'Double with AC');
INSERT INTO `rooms_category` VALUES (4, 'Double without AC');

INSERT INTO `rooms` VALUES (1, 2,989, 30);
INSERT INTO `rooms` VALUES (2, 2,789, 20);
INSERT INTO `rooms` VALUES (3, 2,1499, 20);
INSERT INTO `rooms` VALUES (4, 2,1299, 20);
INSERT INTO `rooms` VALUES (1, 1,999, 2);
INSERT INTO `rooms` VALUES (2, 1,889, 35);
INSERT INTO `rooms` VALUES (2, 3,799, 25);
INSERT INTO `rooms` VALUES (4, 3,999, 25);
INSERT INTO `rooms` VALUES (1, 4,1229, 50);
INSERT INTO `rooms` VALUES (3, 4,1599, 50);
INSERT INTO `rooms` VALUES (1, 5,1099, 25);
INSERT INTO `rooms` VALUES (2, 5,880, 35);
INSERT INTO `rooms` VALUES (3, 5,1370, 20);
INSERT INTO `rooms` VALUES (3, 6,1240, 20);
INSERT INTO `rooms` VALUES (4, 6,940, 30);
INSERT INTO `rooms` VALUES (1, 7,1299, 50);
INSERT INTO `rooms` VALUES (2, 7,999, 50);
INSERT INTO `rooms` VALUES (3, 7,1699, 50);
INSERT INTO `rooms` VALUES (4, 7,1199, 50);
INSERT INTO `rooms` VALUES (2, 8,680, 85);
INSERT INTO `rooms` VALUES (1, 9,1099, 30);
INSERT INTO `rooms` VALUES (3, 9,1399, 50);
INSERT INTO `rooms` VALUES (2, 10,599, 60);
INSERT INTO `rooms` VALUES (4, 10,899, 30);
