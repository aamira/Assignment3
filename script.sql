-- sign up 
-- (id,password, name, country provided by user)
-- id must be unique. no two users can have the same id
-- name and country can be null
insert into user (id,password,name,country) values
("aamira123","123",null,null);

-- edit info
-- user can edit info
-- user aamira123 wants to set her name to Aamira
update user
set name = "Aamira"
where id like "aamira123";

-- viewing infos of self (id : aamira123)
select id, password, name, country
from user
where id like "aamira123";

-- sending friend requests
-- id aamira123 wants to send friend request to id aamira

-- 1. check if aamira123 is already friend with aamira/ already sent a request
select idfriend
from friend
where friend_1 like 
(select iduser as friend_1
from user
where id like "aamira123") and friend_2 like 
(select iduser as friend_2
from user
where id like "aamira");


-- 2. check if theres an already pending request from this friend
select idfriend
from friend
where friend_1 like 
(select iduser as friend_1
from user
where id like "aamira") and friend_2 like 
(select iduser as friend_2
from user
where id like "aamira123");

-- if any of those is not null, then return error msg
-- else
insert into friend (friend_1, friend_2, is_accepted)
values ((select iduser
from user
where id like "aamira123"),(select iduser
from user
where id like "aamira"),0);

-- accepting friend request
-- aamira accepts aamira123's request
-- 1. is_accepted changed
update friend
set is_accepted = 1
where friend_1 = (select iduser as friend_1
from user
where id like "aamira123") and friend_2 = (select iduser as friend_2
from user
where id like "aamira");

-- 2. friend created for aamira as well
insert into friend (friend_1, friend_2, is_accepted)
values ((select iduser
from user
where id like "aamira"),(select iduser
from user
where id like "aamira123"),1);

-- aamira can reject aamira123's request
delete from friend
where friend_1 = (select iduser as friend_1
from user
where id like "aamira123") and friend_2 = (select iduser as friend_2
from user
where id like "aamira");

-- friendlist (only showed userid) for aamira
select id
from user
where iduser in (select friend_2 as iduser from friend
where friend_1 = (select iduser as friend_2
from user
where id like "aamira"));

-- aamira writes a post on her timeline
-- post_string = "hi"
-- time =  2015-11-04 13:02:50

insert into post(post_string, post_time, iduser)
values ("hi", "2015-11-04 13:02:50.1", (select iduser
from user
where id like "aamira"));

-- aamira's timeline
select post_string, post_time from post
where iduser = (select iduser from user where id like "aamira");

-- aamira's timeline. visibility (friendlist+self)
select id
from user
where iduser in (select friend_2 as iduser from friend
where friend_1 = (select iduser as friend_2
from user
where id like "aamira"))
union
(select id as friend_2
from user
where id like "aamira");

-- aamira123 wants to like on aamira's post with post id 5
insert into post_like(idpost,liked_by)
values(5, (select iduser from user where id like "aamira123"));

-- aamira123 comments on post with id 5 
insert into post_comment(comment_string, comment_time, iduser,idpost)
values ("hi", "2015-11-04 13:02:50", (select iduser
from user
where id like "aamira123"),5);

-- user id 1 wants to delete post with postid 5
delete from post
where idpost =5;

-- user 1 sends a message to user 2
-- msg string = "this is a message"
-- time =  "2015-11-04 13:02:50"
-- check if there's already a thread
select idthread from thread where ( user_1 = 1 or user_1=2)
and (user_2=2 or user_2=1);

-- if null create one otherwise skip this step
insert into thread (user_1,user_2)
values(1,2);
insert into thread(user_1,user_2)
values(2,1);

-- add message to that thread user 1 sends a message 
insert into message(message_string, message_time, iduser,idthread)
values ("this is a message", "2015-11-04 13:02:51", 1, (select idthread from thread where  user_1 = 1
and user_2=2));
insert into message(message_string, message_time, iduser,idthread)
values ("this is a message", "2015-11-04 13:02:51", 1, (select idthread from thread where  user_1 = 2
and user_2=1));

-- see all messages in a thread (for example user 1 and 2) requested by user_1
select iduser,message_string, message_time from message
where idthread = (select idthread from thread where  user_1 = 1 
and user_2=2 )
order by message_time;

-- delete a conversation thread user 1 wants to delete his thread with user2\
delete from thread
where user_1=1 and user_2=2;


 