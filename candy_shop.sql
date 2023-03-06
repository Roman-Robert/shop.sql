CREATE DATABASE candy_shop;

USE candy_shop;

CREATE TABLE users (
	user_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(25) NOT NULL,
    user_surname VARCHAR(25) NOT NULL,
    user_phone_number VARCHAR(15) NOT NULL,
    user_address VARCHAR(100) NOT NULL,
    user_email VARCHAR(25) NOT NULL,
    user_personal_discount INT UNSIGNED
);

CREATE TABLE candy_types (
	type_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(10), 
    
    UNIQUE (type_name)
    );
    
/* Only 3 types of candies can be: chocolate, lollipop, gum */
INSERT INTO candy_types(type_name) VALUES
	('chocolate'),
    ('lollipop'),
    ('gum');    

CREATE TABLE candies(
	candy_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    candy_name VARCHAR(50),
    candy_type INT UNSIGNED,
    candy_description VARCHAR(255),
    candy_price DECIMAL(4,2),
    candy_quantity INT UNSIGNED,
    
    UNIQUE (candy_name),
    
    CONSTRAINT fk_candy_type FOREIGN KEY candies(candy_type) REFERENCES candy_types(type_id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
    );
    
CREATE TABLE orders (
	order_number INT UNSIGNED,
    customer_id INT UNSIGNED,
    quantity INT UNSIGNED,
    candy_id INT UNSIGNED,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (order_number,candy_id),
    
    CONSTRAINT fk_candy_id FOREIGN KEY orders(candy_id) REFERENCES candies(candy_id)
		ON DELETE NO ACTION
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_customer_id FOREIGN KEY orders(customer_id) REFERENCES users(user_id)
		ON DELETE NO ACTION
        ON UPDATE CASCADE
    );
    
    
INSERT INTO users (user_name,user_surname,user_phone_number,user_address,user_email,user_personal_discount) VALUES
	('Name1','Surname1','111','aaa','mail1', 0),
	('Name2','Surname2','222','bbb','mail2', 5),
	('Name3','Surname3','333','ccc','mail3', 10),
	('Name4','Surname4','444','ddd','mail4', 10),
	('Name5','Surname5','555','eee','mail5', 0),
	('Name6','Surname6','666','fff','mail6', 2),
	('Name7','Surname7','777','ggg','mail7', 7),
	('Name8','Surname8','888','hhh','mail8', 99);
   
INSERT INTO candies (candy_name,candy_type,candy_description,candy_price,candy_quantity) VALUES
	('AAAAAA',	1,	'chocolate candy',	10,	100),
	('BBBBBB',	2,	'lollipop candy',	20,	200),
	('CCCCCC',	3,	'chocolate candy',	30,	30),
	('DDDDDD',	1,	'lollipop candy',	99,	3),
	('EEEEEE',	3,	'lollipop candy',	3,	300),
	('FFFFFF',	2,	'gum candy',		10,	100),
	('GGGGGG',	1,	'chocolate candy',	12,	50),
	('HHHHHH',	3,	'chocolate candy',	40,	20);

INSERT INTO orders (order_number,customer_id,quantity,candy_id) VALUES
	(1000,	2,	15,	 1),
	(1000,	2,	20,	 3),
	(12,	1,	45,	 1),
	(20,	3,	2,	 2),
	(25,	2,	250, 2),
	(26,	3,	10,	 3),
	(27,	3,	10,	 3),
	(28,	4,	15,	 1),
	(29,	6,	20,	 6),
	(30,	4,	100, 8);


-- SORTING DATABASE FOR PERSONAL ACCOUNT (user id has to be entered)

SELECT
order_date AS 'Date of order',
order_number AS 'Order number',
type_name AS 'Candy type',
quantity AS 'Quantity'
FROM (orders JOIN candy_types ON candy_id=type_id)
WHERE customer_id = 3                              -- enter the user id, please
ORDER BY order_date DESC;


-- SORTING DATA BASE BY TYPE OF SOLD CANDIES

SELECT
candy_types.type_name AS 'Candy type',
SUM(orders.quantity) AS 'Total sold'
FROM
(candy_types JOIN orders ON type_id = candy_id)
GROUP BY candy_types.type_name
ORDER BY SUM(orders.quantity) DESC;


-- SORTING DATA BASE BY PRICE OF CANDIES

SELECT 
candy_name AS 'Name',
type_name AS 'Type',
candy_price 'Price'
FROM (candies LEFT JOIN candy_types ON candy_type = type_id)
ORDER BY candy_price ASC;


-- SORTING DATA BASE BY TYPE OF CANDIES

SELECT
candy_name AS 'Name',
type_name AS 'Type',
candy_price 'Price'
FROM (candies LEFT JOIN candy_types ON candy_type = type_id)
ORDER BY type_name ASC;


-- SEARCHING IN DATA BASE BY NAME(OR PART OF a NAME)

SELECT *
FROM candies
WHERE candy_name LIKE '%CCC%' -- serching by part of a candy name
	OR candy_name LIKE 'BB%'  -- searching by start of a candy name
ORDER BY candy_id ASC;


-- THIS QUERY RETURNS THE NAMES AND THE NUMBER OF ORDERED 10 MOST POPULAR CANDIES FOR CURRENT YEAR, DEPENDING ON THE QUANTITY OF CANDIES IN THE ORDERS.

SELECT
candy_name AS 'Name',
candy_description 'Description',
SUM(quantity) 'Total sold in current year'
FROM
(candies JOIN orders ON candies.candy_id=orders.candy_id)
WHERE YEAR(order_date) = YEAR (CURDATE())
GROUP BY candies.candy_id
ORDER BY SUM(quantity) DESC
LIMIT 10;