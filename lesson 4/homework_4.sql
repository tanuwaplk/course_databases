

use vk;

INSERT INTO `profiles` (`user_id`,`gender`, `birthday`, `photo_id`)
VALUES ('1','f','1981-02-18 16:58:27','10516581','1979-02-24 23:46:33','Katelynnmouth'),
('2','m','2007-04-15 16:01:09','0','1972-05-12 01:43:58','North Harry');


INSERT INTO `profiles` VALUES ('1','f','1981-02-18 16:58:27','10516581','1979-02-24 23:46:33','Katelynnmouth'),
('2','m','2007-04-15 16:01:09','0','1972-05-12 01:43:58','North Harry'),
('3','m','2003-08-28 15:08:34','38','2007-06-06 04:42:32','East Tyler'),
('4','m','1972-08-19 17:15:15','911725','1990-10-26 22:13:34','South Karenville'),
('5','f','1970-10-29 05:57:05','3694','2011-07-25 17:05:06','Coltenshire'),
('6','m','1972-12-22 20:30:22','14877','1982-03-06 11:00:56','Port Khalidmouth'),
('7','m','2001-05-27 04:07:45','8192978','1988-02-26 12:35:13','West Hershelstad');

INSERT INTO `profiles`
SET
	gender = 'm',
	birthday = '1981-02-18 16:58:27';

INSERT INTO `profiles` 
	(`user_id`,`gender`, `birthday`, `photo_id`, `created_at`, `hometown`)
select 
 	`user_id`,`gender`, `birthday`, `photo_id`, `created_at`, `hometown`
from vk2.profiles
where id = 59
;

SELECT 10+20;

SELECT distinct gender
FROM profiles;

SELECT *
FROM profiles
LIMIT 2 offset 3;

SELECT *
FROM profiles
WHERE user_id = 3 OR gender = 'f';


UPDATE friend_requests
SET 
	status = 'approved',
	confirmed_at = now()
WHERE
	initiator_user_id = 4 and target_user_id = 6;

delete from profile_likes 
where user_id = 1;


truncate table photo_likes;
























