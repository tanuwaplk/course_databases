drop database if exists example;
Create database example;

use example;

drop table if exists users;
create table users (
id serial primary key,
name varchar(255) comment 'Имя пользователя'
) comment = 'Покупатели';



