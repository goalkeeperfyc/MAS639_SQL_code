
# Check out tutorials on w3schools

# THINGS TO KNOW:
	# JOIN syntax 
	# UNION
    # subqueries


#### JOINS #####
use acrc;
select * from ac limit 10;
select * from rc limit 10;
# left join keeps everything on the left table joining with right table, using more frequent, right join is similar, using less frequent
# Answer 1-4 using the acrc database

# 1 Left join ac and rc tables
select
	ac.customer_id,
    ac.fav_color,
    rc.num_purchases
from ac
left join rc 
	on ac.customer_id = rc.customer_id;
# 2 Right join ac and rc tables
select
	rc.customer_id,
    ac.fav_color,
    rc.num_purchases
from ac
right join rc 
	on ac.customer_id = rc.customer_id;
# 3 Inner join ac and rc tables
select *
from ac
join rc 
	on ac.customer_id = rc.customer_id;

select *
from ac, rc
where ac.customer_id = rc.customer_id;

# 4 Full outer join ac and rc tables (note that MySQL does not have a FULL OUTER option)
select *
from ac
left join rc 
	on ac.customer_id = rc.customer_id
union
select *
from ac
right join rc 
	on ac.customer_id = rc.customer_id;

select ac.customer_id, fav_color, num_purchases
from ac
left join rc 
	on ac.customer_id = rc.customer_id
union
select rc.customer_id, fav_color, num_purchases
from ac
right join rc 
	on ac.customer_id = rc.customer_id;
    
# Answer 5 - 12 using the sakila database
use sakila;
# 5 Return a table that lists each customers first and last name as well as their mailing address

# 6 How many films has Ed Chase been in?
    
# 7 What are those movies?    
    
# 8 Return a table that lists the title, category, and language for each film (note that this will require the film, category, language, and film_category tables)

# 9 Determine the top 5 customers by revenue. Include the customers id, name, and total revenue

# 10 How many rentals has each customer made? Return a table that lists the top 10 customer by name and their number of rentals.

# 11. Which 3 movies have been rented the most times? Need to join 3 tables!




# Use the northwind database for questions 12-14
USE northwind;
SELECT * FROM Customer LIMIT 5;
SELECT * FROM Orders LIMIT 5;
SELECT * FROM OrderItem LIMIT 5;
SELECT * FROM Product LIMIT 5;
SELECT * FROM Supplier LIMIT 5;

# 12 Who are our top 5 Customers by spending?
create view  mas639fang.test_create as 
select 
	concat(firstname," ",lastname) as customer,
    sum(totalamount) as spending
from Customer c
join Orders o
	on c.ID = o.ID
group by
	c.IDtest_create
order by
	sum(totalamount) desc;

select * from mas639fang.test_create;

# 13 What percent of units sold do our top 3 products account for?
	# To get this, I need the total units sold. I can create a separate table, SELECT SUM(Quantity) FROM.... and then merge this table on, or I can put this code in as a SUBQUERY
select sum(quantity) from OrderItem;
# subquery
select 
	productname as product,
	sum(quantity) as units,
    sum(quantity)/(select sum(quantity) from OrderItem) as percentage
from Product p
join OrderItem o
	on p.ID = o.productid
group by p.ID
order by 2 desc;

# 14 What are our 5 highest grossing products and who supplies them? Return a table with the produc name, supplier, and total revenue.







