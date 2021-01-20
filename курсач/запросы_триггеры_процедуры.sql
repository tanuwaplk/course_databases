
use delivery_club_test;


-- использование промокодов (необходимо ввести ограничение на инсерт использование промокодов)
drop view if exists promocode_current_uses;
create view promocode_current_uses as 
select p.id as promocode_id, p.max_uses as max_uses, count(up.promocode_id ) as number_of_uses from promocodes p
join user_promocode up
on p.id=up.promocode_id 
group by p.id;

-- использование прококодов пользователями (необходимо ввести ограничение на инсерт использование промокодов)
drop view if exists promocode_current_user_uses;
create view promocode_current_user_uses as 
select up.user_id as user_id, up.promocode_id as promocode_id, p.max_uses_user as max_uses, count(up.promocode_id) as user_uses
from user_promocode up
join promocodes p
on up.promocode_id=p.id
group by up.user_id, up.promocode_id;

-- самые популярные блюда в ресторане

DELIMITER //

create procedure restaurant_best_dishes(in restaurant_id INT)
begin
	select id, name from restaurants_menu rm where id in (select * from(
	
		select op.restaurant_menu_id
		from restaurants r
		join restaurant_points rp
		on r.id=rp.restaurant_id
		join orders o
		on o.restaurant_point_id =rp.id
		join ordered_products op
		on  o.id=op.order_id
		where r.id = restaurant_id
		group by r.id, op.restaurant_menu_id
		order by sum(op.total) desc limit 10 ) as t) ;
end
//
DELIMITER ;

call restaurant_best_dishes(20);



-- рестораны с самым высоким рейтингом
select r.id as restaurant_id, r.name as restaurant_name, r.cuisine_type, round(avg(value), 2) as avg_rating
from restaurants r 
join restaurant_points rp
on r.id=rp.restaurant_id
join restaurant_rating rr 
on rp.id=rr.restaurant_point_id 
group by r.id 
order by avg(value) desc;


-- точки ресторанов с самым высоким рейтингом
select r.id as restaurant_id, r.name as restaurant_name, rp.id as restaurant_point, round(avg(value), 2) as avg_rating
from restaurants r 
join restaurant_points rp
on r.id=rp.restaurant_id
join restaurant_rating rr 
on rp.id=rr.restaurant_point_id 
group by rp.id 
order by avg(value) desc;


-- самый популярный ресторан конкретного пользователя
DELIMITER //


create procedure favourite_restaurant(in user_id INT)
begin
	
	select r.id, r.name, count(o.id)
	from restaurants r
	join restaurant_points rp
	on r.id=rp.restaurant_id
	join orders o
	on o.restaurant_point_id =rp.id
	where o.user_id=user_id
	group by r.id 
	order by count(o.id) desc limit 1;
	
end
//
DELIMITER ;

call favourite_restaurant(119);

-- поиск ресторана по названию
DELIMITER //


create procedure search_restaurant(in restaurant_name varchar(50))
begin
	
	select name from restaurants where name like 'restaurant_name%';
	
end
//
DELIMITER ;

call search_restaurant(e);


-- категория стоимости ресторанов (по 5-балльной шкале)


create view price_restaurants as 
select r.id, r.name, avg(price) as avg_price
from restaurants r
join restaurants_menu rm
on r.id=rm.restaurant_id 
group by r.id;


set @min_avg=(select max(avg_price) from price_restaurants); -- не придумала, как обновлять значение при вводе новых данных


select id, name,round(avg_price/@min_avg*5,0)
from price_restaurants;



-- стоимость корзины (со скидкой и без) 

DELIMITER //

create procedure order_price(in order_id INT)
begin
	
	select  order_price from (
		select o.id, sum(rm.price) as order_price
		from orders o
		join ordered_products op
		on o.id=op.order_id
		join restaurants_menu rm
		on op.restaurant_menu_id = rm.id
		where o.id=order_id
		group by o.id) as t ;
	
end
//
DELIMITER ;

call order_price (20);

-- наименее активные пользователи, которым можно предложить промокод, чтобы стимулировать активность

create view users_activity as
select id,
(select count(id) from orders where user_id = users.id) as number_of_orders,
(select count(id) from orders where user_id = users.id and month(created_at)=month(now()) and year(created_at)=year(now())) as number_of_orders_current,
(select count(user_id) from restaurant_rating where user_id = users.id)  as number_of_votes,
(select count(user_id)  from user_promocode where user_id = users.id)  as number_of_promocodes_uses,
(select count(user_id) from users_adress where user_id = users.id) as number_of_address
from users;

select id,
(number_of_orders*0.5 + number_of_orders_current*1+ number_of_votes*0.2 + number_of_promocodes_uses*0.3 + number_of_address*0.4) as activity_score
from users_activity order by activity_score desc limit 10;

-- логи 

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	table_name VARCHAR(45) NOT NULL,
	str_id BIGINT(20) NOT NULL,
	name_value VARCHAR(255) NOT NULL
) ENGINE = ARCHIVE;


DROP TRIGGER IF EXISTS log_users;
delimiter //
CREATE TRIGGER log_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'users', NEW.id, NEW.email);
END //
delimiter ;

DROP TRIGGER IF EXISTS log_restaurants;
delimiter //
CREATE TRIGGER og_restaurants AFTER INSERT ON restaurants 
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'restaurants', NEW.id, NEW.name);
END //
delimiter ;




