
/*
Instructions:

	* Write a query to answer each question. 
    * You do not have to additionally write an answer or comment.
    * Alias all column names appropriately.
    * Dollar values should be rounded to the nearest dollar, and formatted as currency (dollar signs, commas)
    * All other numbers should be formatted appropriately and rounded as needed
    

SUBMISSIONS:
	* Rename this file with your name (e.g. DougLehmann.sql)
	* Submit this SQL file to Blackboard
*/

-- Please use the videogames database for questions 1-7

USE videogames;

-- View Tables
SELECT * FROM games LIMIT 5;
SELECT * FROM reviews LIMIT 5;
SELECT * FROM sales LIMIT 5;
SELECT * FROM publishers LIMIT 5;


-- 1 Return a table of total global sales by year (this corresponds with release year), ordered chronologically from most recent to least recent.
select 
    Year,
    sum(global_sales) as total_sales
from
	games g
join sales s
	on g.gameid = s.gameid
group by
	year
order by
	year desc;
	
-- 2 Return a table that lists the best selling game of all time
select Name
from games g
join sales s
	on g.gameid = s.gameid
where global_sales = (select max(global_sales) from sales);

-- 3 Return publiser name and total units sold for publishers that have sold at least 500 million units.
	-- Data is in units of 1 million, e.g. 1 = 1,000,000 units sold
select 
	publisher,
    total_sold * 1000000 as total_units_sold
from 
	publishers p
join (select publisherid, sum(global_sales) as total_sold from games g join sales s on g.gameid = s.gameid 
	group by publisherid having sum(global_sales) >= 500) t
    on p.publisherid = t.publisherid;

-- 4 Games on which platform have the highest average user score?
select 
	platform
from reviews r
join games g
	on r.gameid = g.gameid
group by
	platform
order by
	avg(user_score) desc
limit 1;


-- 5 Which game released in 2008 on the PS3 platform received the highest critic score? 
select Name
from games g
join reviews r
	on g.gameid = r.gameid
where
	year = 2008 and platform = "PS3"
order by 
	critic_score desc
limit 1;
 

-- 6 Return a table that includes each game, the platform it's on, it's critic score, and it's global sales.
	--  Order high to low by units sold
    --  Note that not all games are present in the reviews table, but we want to keep all games with or without a review...
select
	name,
    platform,
    critic_score,
	global_sales
from games g
left join (select gameid, critic_score from reviews) r
	on g.gameid = r.gameid
left join (select gameid, global_sales from sales) s
	on g.gameid = s.gameid
order by
	global_sales desc;


-- 7 Return the total global sales for all publishers that sold at least 500 million units 
	--  Order high to low on units sold
select 
    p.publisher,
    sum(global_sales)  as total_sold 
from 
	(select publisherid, global_sales from games g join sales s on g.gameid = s.gameid) t 
left join publishers p
	on t.publisherid = p.publisherid 
group by t.publisherid 
having total_sold >= 500
order by total_sold desc;

-- Please use the sakila database for questions 8-10
USE sakila;

-- 8 Display the most frequently rented movies in descending order.
	-- SELECT * FROM rental;
	-- SELECT * FROM inventory;
SELECT * FROM rental limit 5;
SELECT * FROM inventory limit 5;

select i.film_id, 
	title as film_name,
	sum(rented_times) as total_rented
from inventory i
join (select inventory_id, count(*) as rented_times from rental group by inventory_id) r
	on i.inventory_id = r.inventory_id
join film f
	on i.film_id = f.film_id
group by film_id
order by total_rented desc;

#select film_id, i.inventory_id, rented_times
#from inventory i
#join (select inventory_id, count(*) as rented_times from rental group by inventory_id) r
#	on i.inventory_id = r.inventory_id;

#select film_id, i.inventory_id, sum(rented_times)
#from inventory i
#join (select inventory_id, count(*) as rented_times from rental group by inventory_id) r
#	on i.inventory_id = r.inventory_id
#group by film_id
#order by film_id;

-- 9 Write a query to display the total revenue each store has brought in.
select * from payment limit 5;
select * from staff limit 5;
select * from rental limit 5;
select * from store limit 5;
select * from customer;
select store_id, revenue_per_staff as total_revenue
from store s
join (select staff_id, sum(amount) as revenue_per_staff from payment group by staff_id) r
	on s.manager_staff_id = r.staff_id;


-- 10 List the top five genres (category table) by gross revenue. 
	-- Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.

#SELECT * FROM category limit 5;
#SELECT * FROM film_category limit 5;
#SELECT * FROM inventory limit 5;
#SELECT * FROM payment limit 100;
#SELECT * FROM rental limit 5;

select 
    name as category_name,
	sum(amount) as gross_revenue
from rental r 
join payment p 
	on r.rental_id = p.rental_id
join inventory i 
	on r.inventory_id = i.inventory_id
join film_category fc
	on fc.film_id = i.film_id
join category c
	on c.category_id = fc.category_id
group by category_name
order by gross_revenue desc
limit 5;
