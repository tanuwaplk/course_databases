

-- задание 1 Транзакции, переменные, представления
START TRANSACTION;

select name, birthday_at from sample.users where id=1;

INSERT INTO shop.users (name, birthday_at) 
select name,birthday_at from sample.users where id=1;

DELETE FROM sample.users WHERE id=1;

select * from shop.users;

COMMIT;

-- задание 2 Транзакции, переменные, представления
use shop;

create view product_types (product, product_type) as
select p.name, c.name FROM products p
join catalogs c on c.id=p.catalog_id;

select * from  product_types;


-- задание 1 Хранимые процедуры и функции, триггеры

DELIMITER //

drop function if exists hello//

CREATE FUNCTION hello ()
RETURNS TEXT DETERMINISTIC
BEGIN
	set @i = DATE_FORMAT(now(), "%H:%i"); 
	IF (@i >= '06:00' and @i < '12:00') THEN
		set @text =  'Доброе утро';
	ELSEIF (@i >= '12:00' and @i < '18:00') THEN
	 	set @text = 'Добрый день';
	ELSEIF (@i >= '18:00' and @i <= '23:59') THEN
		set @text =  'Добрый вечер';
	ELSEIF (@i >= '00:00' and @i < '06:00') THEN
 		set @text =  'Доброй ночи';
	END IF;
return @text;
END//


select hello()//


-- задание 2 Хранимые процедуры и функции, триггеры



CREATE TRIGGER check_product_features_int BEFORE INSERT ON products
FOR EACH ROW BEGIN
  IF (new.name is null and new.desription is null) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
  END IF;
END//

CREATE TRIGGER check_product_feature_upd BEFORE UPDATE ON products
FOR EACH ROW BEGIN
  IF (new.name is null and new.desription is null) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled';
  END IF;
END//