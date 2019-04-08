
USE matching;

select *  from AllHospitals limit 5;
select *  from SomeHospitals limit 5;

select count(*) from AllHospitals;
select count(*) from SomeHospitals;

select count(*) 
from AllHospitals a
join SomeHospitals b
	on a.hName = b.fName
where a.hstate = b.fstate;

# Recap 
USE northwind;
select * from Customer limit 5;
#  What percent of units sold do our top 3 products account for?
	# To get this, I need the total units sold. I can create a separate table, SELECT SUM(Quantity) FROM.... and then merge this table on, or I can put the table code in as a SUBQUERY
# subquery
SELECT SUM(Quantity) FROM OrderItem;
drop view mas639fang.test_subquery;

create temporary table mas639fang.test_subquery3 as
SELECT 
	p.ID, 
    p.ProductName,
    SUM(oi.Quantity) AS 'Units Sold',
    (SELECT SUM(Quantity) FROM OrderItem) AS 'Total Units Sold',
    SUM(oi.Quantity)/(SELECT SUM(Quantity) FROM OrderItem) as 'Proportion'
FROM Product p
JOIN OrderItem oi
	ON p.ID = oi.ProductID
GROUP BY 1
ORDER BY 3 DESC;

select *
from mas639fang.test_subquery2
limit 5;

USE BJJ;
select * from men_black limit 5;
select * from men_blue limit 5;

-- How many fighters are present across all datasets?
-- 1. SUBQUERY as calculated field in the original select statement.
select count(*) +
	(select count(*) from men_blue) + 
    (select count(*) from men_brown) +
    (select count(*) from men_purple) + 
    (select count(*) from men_white) + 
	(select count(*) from women_black) +
	(select count(*) from women_blue) + 
    (select count(*) from women_brown) +
    (select count(*) from women_purple) + 
    (select count(*) from women_white) as number_of_figures
from men_black;

select count(*) from men_blue;

-- 2. Selecting from a subquery (create new table in the FROM statement rather than query from an existing table)
	-- Could have done this with a temporary table: CREATE TABLE AllFighters AS [insert code for UNION'ing all tables here], then SELECT COUNT(*) FROM AllFighters
# union drop duplicate (default), union all don't drop anything
select count(*) as number_of_sth
from (
	select * from men_black union all
	select * from men_blue union all
	select * from men_brown union all
	select * from men_purple union all
	select * from men_white union all
	select * from women_black union all
	select * from women_blue union all
	select * from women_brown union all
	select * from women_purple union all
	select * from women_white
) someTableName;

select count(*) as number_of_sth
from (
	select * from men_black union
	select * from men_blue union
	select * from men_brown union
	select * from men_purple union
	select * from men_white union
	select * from women_black union
	select * from women_blue union
	select * from women_brown union
	select * from women_purple union 
	select * from women_white
) someTableName;

select *
from (
	select * from men_black union all
	select * from men_blue union all
	select * from men_brown union all
	select * from men_purple union all
	select * from men_white union all
	select * from women_black union all
	select * from women_blue union all
	select * from women_brown union all
	select * from women_purple union all
	select * from women_white
) someTableName
group by 1, 2, 3, 4, 5, 6, 7
having count(*) > 1
;

-- Why the mismatch? How can we find the problem?



-- NFL
USE NFL;
SELECT * FROM players LIMIT 5;
SELECT * FROM teams LIMIT 5;
select count(*) from players;
-- Return all players that play for the Miami Dolphins
	-- a) With a join
    -- b) Subquery in JOIN
    -- c) With a subquery in WHERE / IN clause
select count(*)
from teams t
join players p
	on t.id = p.team_id;

# a
select *
from teams t
join players p
	on t.id = p.team_id
where t.name = "Miami Dolphins";

# b
# subquery is good at large number of data, it will be faster
select * 
from players p
join (select * from teams where name = "Miami Dolphins") t 
	on p.team_id = t.id;

# c
select * 
from players
where team_id = (select id from teams where name = "Miami Dolphins");


-- Return all players that play on teams in the AFC
	-- a) with a join
    -- b) with a subquery in WHERE clause
    
# a    
select *
from players p
join teams t
	on p.team_id = t.id
where conference = "AFC";

# b
select * 
from players
where team_id in (select id from teams where conference = "AFC")
order by salary desc;










