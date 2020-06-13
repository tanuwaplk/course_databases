
USE vk2;


 -- задание 2
 
create view count_messages as 
 SELECT id, from_user_id as friend_id FROM messages WHERE to_user_id = 1 and from_user_id IN ( 
  SELECT initiator_user_id FROM friend_requests WHERE (target_user_id = 1) AND status='approved' 
  union
  SELECT target_user_id FROM friend_requests WHERE (initiator_user_id = 1) AND status='approved' 
)
UNION
SELECT id, to_user_id as friend_id FROM messages WHERE from_user_id = 1 and to_user_id IN (  
  SELECT initiator_user_id FROM friend_requests WHERE (target_user_id = 1) AND status='approved' 
  union
  SELECT target_user_id FROM friend_requests WHERE (initiator_user_id = 1) AND status='approved'
  ) ; 

 select count(id) as number_of_messages, friend_id from count_messages group by friend_id order by count(id) desc limit 1;

 
   -- задание 3
   
select count(id) from likes where 
media_id in (
select id from media where user_id in (
	select * from ( 
		select user_id from profiles order by TIMESTAMPDIFF(YEAR, birthday, NOW()) limit 10) t)
);
 
 -- задание 4
 select count(id),
 (select gender from profiles where user_id=likes.user_id) as gender
 from likes group by gender order by count(id) desc limit 1; 

 -- задание 5

create view users_activity as
select id,
(select count(community_id) from users_communities where user_id = users.id) as number_of_groups,
(select count(id) from media where user_id = users.id) as number_of_posts,
(select count(id) from likes where user_id = users.id) as number_of_likes,
(select
	(select count(initiator_user_id) FROM friend_requests WHERE (target_user_id = users.id) AND status='approved')
	+ 
	(select  count(target_user_id) FROM friend_requests WHERE (initiator_user_id = users.id) AND status='approved') 
) as total_friends,
(select count(id) from messages where from_user_id=users.id or to_user_id=users.id ) as number_of_messages
from users;

select id,
(number_of_groups*0.1 + number_of_posts*0.5 + number_of_likes*0.3 + total_friends*0.2 + number_of_messages*0.4) as activity_score
from users_activity order by activity_score limit 10;

