-- INTRODUCING THE FINAL COURSE PROJECT --

/*
THE SITUATION:
There have been some exciting developments for Maven Bear Builders. The company is going
to start offering chat support on the website, and needs your help planning. The company has
also been approached by potential acquirers, and you’ll be asked to help with due diligence. 

THE OBJECTIVE:

• Create a plan for handling chat support, including the database infrastructure, EER
diagrams explaining your plan, and reports to help management understand performance
• Provide support for questions relating to the potential acquisition, to help your CEO keep
them interested and hopefully close the deal 
*/

-- TASKS:
/* 1) Import the latest order_items and order_item_refunds data below into the database, and verify the
order summary trigger you created previously still works:
- 17.order_items_2014_Mar
- 18.order_items_2014_Apr
- 19.order_item_refunds_2014_Mar
- 20.order_item_refunds_2014_Apr. */

USE mavenbearbuilders;

SELECT	COUNT(*) AS total_orders,
		MAX(created_at) AS last_date_in_db
FROM	order_items;

SELECT	COUNT(*) AS total_order_refunds,
		MAX(created_at) AS last_date_in_db
FROM	order_item_refunds;


/* 2) Import the website_sessions and website_pageviews data for March and April, provided below:
- 21.website_session_2014_Mar
- 22.website_session_2014_Apr
- 23.website_pageviews_2014_Mar
- 24.website_pageviews_2014_Apr*/

SELECT	COUNT(*) AS total_sessions,
		MAX(created_at) AS last_date_in_db
FROM	website_sessions;

SELECT	COUNT(*) AS total_pageviews,
		MAX(created_at) AS last_date_in_db
FROM	website_pageviews;

/* 3) The company is adding chat support to the website. You’ll need to design a database plan to track
which customers and sessions utilize chat, and which chat representatives serve each customer */

-- users
	-- user_id
    -- created_at
    -- first_name
    -- last_name

-- support_members
	-- support_memeber_id
	-- created_at
    -- fist_name
    -- last_name

-- chat_sessions
	-- chat_session_id
    -- created_at
    -- user_id
    -- support_memeber_id
    -- website_session_id

-- chat_messages
	-- chat_message_id
    -- created_at
    -- chat_session_id
    -- user_id (will be null for support memebers)
    -- support_member_id (null for users)
    


/* 4) Based on your tracking plan for chat support, create an EER diagram that incorporates your new tables
into the existing database schema (including table relationships) */

/* 5) Create the tables from your chat support tracking plan in the database, and include relationships to
existing tables where applicable */

/* 6) Using the new tables, create a stored procedure to allow the CEO to pull a count of chats handled by
chat representative for a given time period, with a simple CALL statement which includes two dates */

/* 7) Create two Views for the potential acquiring company; one detailing monthly order volume and revenue,
the other showing monthly website traffic. Then create a new User, with access restricted to these Views */

/* 8) The potential acquirer is commissioning a third-party security study, and your CEO wants to get in front
of it. Provide her with a list of your top data security threats and recommendations for mitigating risk */



