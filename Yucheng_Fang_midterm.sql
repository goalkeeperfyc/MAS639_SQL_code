

-- Instructions:
	-- Any decimals should be rounded to two decimal places
    -- Numbers should be formatted appropriately; dollar signs, commas, percent signs as needed
    -- All column headers should be aliased appropriately; no math, sql code, etc.. in column names
    -- One query per question (Split into multiple queries if needed for partial credit)


-- YOUR NAME: Yucheng Fang
-- YOUR NAME: 
-- YOUR NAME: 

USE chicagocrime;

SELECT * FROM CrimesLastYear order by date desc;
SELECT * FROM CrimeCodes LIMIT 20;

-- 1 How many crimes in the last year were domestic crimes?
select count(*) as sum_of_domestic_crimes
from CrimesLastYear
where domestic = 1;

-- 2 How many of the domestic crimes that occurred in the last year resulted in an arrest?
select count(*) as sum_of_arrests
from CrimesLastYear
where arrest = 1 and domestic = 1;

-- 3 Of the domestic crimes that occurred in the last year, what percent of them resulted in an arrest?
select concat(round(sum(arrest) / count(*) * 100, 2), "%") as percentage
from CrimesLastYear
where domestic = 1;

-- 4 Select all information for crimes that occured on Lake Shore Dr (N/S/E Lake Shore appear in data) in the last year?
select * 
from CrimesLastYear y
join CrimeCodes c
	on y.crimecode = c.crimecode
where block like "%Lake Shore Dr%";

-- 5 Of the crimes occurring on Lake Shore Dr in the last year, how many were on North (N) Lake Shore and how many were on South (S) Lake Shore.
	-- Your resulting table should not include crimes committed on E Lake Shore
select case 
	when block like "%N Lake Shore Dr%" then "North Lake Shore" 
	when block like "%S Lake Shore Dr%" then "South Lake Shore" 
	end as block_name, 
    count(*) as sum_of_crimes
from CrimesLastYear
where block like "%N Lake Shore Dr%" 
	or block like "%S Lake Shore Dr%"
group by block_name;

-- 6 Return the Description, Location, and Block for all Homicides that have yet to result in an arrest
select description, location, block  
from CrimesLastYear y
join CrimeCodes c
	on y.crimecode = c.crimecode
where arrest = 1 and y.crimecode = (select crimecode from CrimeCodes where description = "HOMICIDE");


-- 7 When did the first homicide of 2019 occur?
select date as first_homicide_of_2019
from CrimesLastYear 
where year = 2019 and crimecode = (select crimecode from CrimeCodes where description = "HOMICIDE")
order by date
limit 1;

-- 8 Return the crime description and frequency for all crimes that occurred over 10,000 times last year.
select description, count(*) as frequency
from CrimesLastYear y
join CrimeCodes c
	on y.crimecode = c.crimecode
group by description
having frequency > 10000;

-- 9 Report the Date, number of homicides, and number of arrests (among those homicides) for each day from March 24th-March 30th
	-- Order by day
select left(date, 10) as new_date, 
	count(*) as number_of_homicides, 
    sum(arrest) as number_of_arrest
from CrimesLastYear 
where month(date) = 3 
	and day(date) >= 24 and day(date) <=30
	and crimecode = (select crimecode from CrimeCodes where description = "HOMICIDE")
group by new_date;

-- 10 Is the arrest rate the same for all crimes?
	-- Return a table that lists each crime and the arrest rate associated with it, ordered low to high by arrest rate
select description, round(sum(arrest) / count(arrest), 2) as rate
from CrimesLastYear y
join CrimeCodes c
	on y.crimecode = c.crimecode
group by description
order by rate;
