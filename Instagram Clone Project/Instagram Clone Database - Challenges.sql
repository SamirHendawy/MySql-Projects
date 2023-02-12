/*We want to reward our users who have been around the longest.  
Find the 5 oldest users.*/
SELECT * 
FROM users
ORDER BY created_at DESC
LIMIT 5;

/*What day of the week do most users register on?
We need to figure out when to schedule an ad campgain*/

SELECT 
DATE_FORMAT(created_at , "%W") AS "Day_of_the_weak",
COUNT(*) AS "total_of_register"
FROM users
GROUP BY 1 -- DATE_FORMAT(created_at , "%w")
ORDER BY 2 DESC 
LIMIT 2; -- TOTAL OF REGESTRETION

/*We want to target our inactive users with an email campaign.
Find the users who have never posted a photo*/

SELECT username
FROM users AS u
LEFT OUTER JOIN photos AS p
ON u.id = p.user_id
WHERE image_url IS NULL;

/*We're running a new contest to see who can get the most likes on a single photo.
WHO WON??!!*/

SELECT  
    photos.id,
    username,
    photos.image_url ,
    count(*) AS "total_likes" 
FROM photos JOIN likes ON likes.photo_id = photos.id
JOIN users ON users.id = photos.user_id
GROUP BY photos.id
ORDER BY total_likes DESC 
LIMIT 1;

/*Our Investors want to know...
How many times does the average user post?*/
/*total number of photos/total number of users*/

SELECT 
	ROUND((SELECT COUNT(*)  FROM photos)  --  TOTAL NUMBER OF PHOTOS => 257 
    /(SELECT COUNT(*)  FROM users),2) AS "AVERAGE USER POST"; -- TOTAL NUMBER OF USER = > 100
    
/*user ranking by postings higher to lower*/

SELECT 
	users.username ,
	COUNT(*) AS NUM_POSTING 
FROM users 
JOIN photos 
	ON users.id = photos.user_id
GROUP BY users.id
ORDER BY NUM_POSTING DESC;

/*Total Posts by users (longer versionof SELECT COUNT(*)FROM photos) */

SELECT ID AS "TOTAL POSTS"  FROM PHOTOS ORDER BY ID DESC LIMIT 1;

/*total numbers of users who have posted at least one time */

SELECT 
	COUNT(DISTINCT(users.id)) AS "total number of users posts"
FROM users
JOIN photos 
	ON users.id = photos.user_id;
    
/*A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/

SELECT
	tags.tag_name ,
    COUNT(*) AS TOTAL
FROM tags
INNER JOIN photo_tags ON tags.id = photo_tags.tag_id
group by tag_name
ORDER BY TOTAL DESC
LIMIT 5;

/*We have a small problem with bots on our site...
Find users who have liked every single photo on the site*/

SELECT 
	username ,
    users.id ,
    count(*) AS total_per_photos

FROM likes 
JOIN users 
	ON likes.user_id = users.id
GROUP BY users.id 
HAVING total_per_photos = (SELECT COUNT(*) FROM photos);


/*We also have a problem with celebrities
Find users who have never commented on a photo*/

with username_not_commented as ( 
	SELECT 
		username , users.id
	FROM USERS 
	LEFT JOIN comments 
		ON comments.user_id = USERS.ID 
	WHERE COMMENT_TEXT IS NULL )

SELECT COUNT(*) AS TOTAL_NUMBER_OF_USER_NOT_COMMENTED 
FROM username_not_commented ; -- username_not_commented is CTE

SELECT username , id -- username and id never commented in photo
FROM username_not_commented;


/*Mega Challenges
Are we overrun with bots and celebrity accounts?
Find the percentage of our users who have either never commented on a photo or have commented on every photo*/


SELECT ((( SELECT COUNT(*)
		FROM USERS 
		LEFT JOIN comments 
		ON comments.user_id = USERS.ID 
		WHERE COMMENT_TEXT IS NULL ) / (SELECT COUNT(*) FROM users )) * 100) AS 'PRESENTAGE_OF_USERS_NEVER_COMMENTED' ,
((SELECT COUNT(DISTINCT(username))
		FROM USERS 
		LEFT JOIN comments 
		ON comments.user_id = USERS.ID 
		WHERE COMMENT_TEXT IS NOT NULL) / (SELECT COUNT(*) FROM users)) * 100 AS "PRESENTAGE_OF_USERS_COMMENTED" ;

/*Find users who have ever commented on a photo*/

SELECT 
	DISTINCT(username) 
FROM USERS 
LEFT JOIN comments 
	ON comments.user_id = USERS.ID 
WHERE COMMENT_TEXT IS NOT NULL;


