DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
 
  

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');


DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, desription, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);



DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

INSERT INTO storehouses VALUES (1,'qui','2013-06-20 19:40:19','1986-01-03 14:35:22'),
(2,'minus','2001-10-27 12:34:54','1980-08-27 02:17:51'),
(3,'minima','2001-02-13 13:45:23','1972-01-15 10:17:23'),
(4,'commodi','1971-11-24 23:32:49','1989-09-01 05:55:20'),
(5,'sequi','1984-06-22 02:17:50','1970-01-28 13:46:43'); 

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products VALUES 
('1','1','1','0','1985-10-14 02:48:36','2010-02-11 00:00:09'),
('2','2','2','54','2006-09-05 04:38:01','2019-06-27 05:14:44'),
('3','3','3','100','2003-07-02 03:21:44','2012-04-14 22:09:35'),
('4','4','4','555','1970-12-08 18:12:20','1992-10-20 02:47:36'),
('5','5','5','444','1971-05-14 18:57:42','2015-05-08 09:40:18'),
('6','1','6','8','1971-01-10 19:02:07','1977-12-30 21:27:10'),
('7','2','7','0','2017-02-25 05:52:06','1998-05-30 00:01:42'),
('8','3','1','7','1988-11-06 08:33:28','1996-04-10 14:48:40'),
('9','4','2','0','1990-12-02 17:18:52','1973-09-20 11:47:49'),
('10','5','3','5','2020-01-02 18:54:04','1973-11-10 04:17:44'); 

 -- “Операторы, фильтрация, сортировка и ограничение” Задание 1
UPDATE users
SET
 	created_at = now(),
 	updated_at = now();
 
 -- “Операторы, фильтрация, сортировка и ограничение” Задание 2
 ALTER TABLE users
 MODIFY created_at DATETIME,
 MODIFY updated_at DATETIME;

 -- “Операторы, фильтрация, сортировка и ограничение” Задание 3
SELECT value FROM storehouses_products
ORDER BY value=0, value;

-- “Операторы, фильтрация, сортировка и ограничение” Задание 4
SELECT name FROM users 
where monthname(birthday_at)='may' or monthname(birthday_at)='august';

-- “Операторы, фильтрация, сортировка и ограничение” Задание 5
SELECT * FROM catalogs WHERE id IN (5, 1, 2) order by field(id, 5,1,2);


-- “Агрегация данных” Задание 1
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS avg_age FROM users;

-- “Агрегация данных” Задание 2
SELECT COUNT(*), DAYNAME(birthday_at+INTERVAL (YEAR(NOW())-YEAR(birthday_at)) YEAR) AS birthday_month FROM users GROUP BY birthday_month;

-- “Агрегация данных” Задание 3
SELECT EXP(SUM(LOG(id))) from storehouses;

