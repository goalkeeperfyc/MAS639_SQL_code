
/*
Instructions:

	* Write a query to answer each question. 
    * You do not have to additionally write an answer or comment.
    * Alias all column names appropriately.
    * Dollar values should be rounded to the nearest dollar, and formatted as currency (dollar signs, commas)
    * All other numbers should be formatted appropriately and rounded to integers

SUBMISSIONS:
	* Rename this file with your name (e.g. DougLehmann.sql)
	* Submit this SQL file to Blackboard
*/





USE sfhomes;
SELECT * FROM homes LIMIT 5;

# 1 Select z_address, neighborhood, lastsolddate, and zestimate from the homes table
select
	z_address,
	neighborhood,
    lastsolddate,
    zestimate as z_estimate
from
	homes;
# 2 Add a column that calculates the price per square foot (zestimate/finishedsqft)
select
	z_address,
	neighborhood,
    lastsolddate,
    finishedsqft,
    zestimate as z_estimate,
    concat("$", format(zestimate/finishedsqft, 2)) as price_per_square_foot
from
	homes;
# 3 How many homes are represented in the data?
select
	count(*) as number_of_homes
from 
	homes;
# 4 How many neighborhoods are represented in the data?
select
	count(distinct(neighborhood)) as number_of_neighbors
from 
	homes;
# 5 Return a list of homes in the Potrero Hill neighborhood
select 
	*
from 
	homes
where
	neighborhood = "Potrero Hill";
# 6 How many homes is that?
select 
	count(*) as number_of_homes
from 
	homes
where
	neighborhood = "Potrero Hill";
# 7 Return a list of homes in the Potrero Hill neighborhood that last sold for over $1.5M dollars
select 
	z_address,
	neighborhood,
    lastsolddate,
	concat("$", format(lastsoldprice, 2)) as last_sold_price,
    zestimate as z_estimate
from 
	homes
where
	neighborhood = "Potrero Hill"
    and lastsoldprice > 1500000;
# 8 Between $1.5-$1.75M?
select 
	z_address,
	neighborhood,
    lastsolddate,
    concat("$", format(lastsoldprice, 2)) as last_sold_price,
    zestimate as z_estimate
from 
	homes
where
	neighborhood = "Potrero Hill"
    and lastsoldprice > 1500000
    and lastsoldprice < 1750000;
# 9 Return a list of Condominiums built after the year 2000 in the Potrero Hill or South of Market neighborhoods with zestimate's less than $1M
select * from homes limit 5;
select * 
from homes
where usecode = "Condominium"
	and yearbuilt > 2000
    and (neighborhood = "Potrero Hill" or neighborhood = "South of Market")
    and zestimate < 1000000;
# 10 How many homes in the Potrero Hill neighborhood last sold in the year 2016?
select 
	count(*) as number_of_homes
from
	homes
where 
	neighborhood = "Potrero Hill"
    and year(str_to_date(lastsolddate, "%m/%d/%Y")) = 2016;
# 11 Return a table of homes sold on Mission Street
select * 
from homes 
where z_address like "%Mission%";
# 12 Return a table of homes sold on the 4XXX block of Mission Street
select * 
from homes 
where z_address like "4____%Mission%";
# 13 Return the z_address, neighborhood, zestimate, and price per square foot, ordered high to low on price per square foot
select
	z_address,
	neighborhood,
    zestimate as z_estimate,
    finishedsqft,
    concat("$", format(zestimate/finishedsqft, 2)) as price_per_square_foot
from
	homes
order by
	price_per_square_foot desc;
# 14 Return a list of homes in the South of Market, Potrero Hill, Bernal Heights, or Oceanview neighborhoods, ordered high to low on zestimate within neighborhood
select
	*
from
	homes
where 
	neighborhood in ("South of Market", "Potrero Hill", "Bernal Heights", "Oceanview")
order by
	neighborhood, zestimate desc;
# 15 What is the average zestimate in this dataset? 
select
	avg(zestimate) as average_zestimate
from
	homes;
# 16 What is the average zestimate by neighborhood?
select
	neighborhood, 
    avg(zestimate) as average_zestimate
from
	homes
group by 
	neighborhood;
# 17 Return a table that lists the neighborhood, number of homes, and average sale price by neighborhood for homes that last sold in 2016
select
	neighborhood,
    count(z_address) as number_of_homes,
    format(avg(lastsoldprice), 2) as average_sold_price
from
	homes
where
	year(str_to_date(lastsolddate, "%m/%d/%Y")) = 2016
group by
	neighborhood;
# 18 For the Potrero Hill and South of Market neighborhoods, return a table that lists the number of homes sold since 2010
select
    count(z_address) as number_of_homes
from
	homes
where
	year(str_to_date(lastsolddate, "%m/%d/%Y")) > 2010
    and (neighborhood = "Potrero Hill" or neighborhood = "South of Market");
# 19 Return the average zestimate by neighborhood, but only include neighborhoods with average zestimates below $1M
select
    neighborhood,
    round(avg(zestimate), 2) as average_zestimate
from
	homes
group by
	neighborhood
having
	average_zestimate < 1000000;
# 20 What are the top 3 most expensive neighborhoods
select
    neighborhood,
    round(avg(lastsoldprice), 2) as average_sold_price
from
	homes
group by
	neighborhood
order by
	average_zestimate desc
limit 3;


USE world;
select * from city limit 5;
select * from country limit 5;
select * from language limit 5;
# 21 - Return a table that includes the CountryCode, language, and number of speakers for each language in each country
select 
    name,
	countrycode,
    language,
    Population
from 
	language
join country
	on language.countrycode = country.code;

# 22 - How many languages are spoken worldwide (according to this data source...)?
select 
	count(distinct(language)) as number_of_languange
from
	language;
# 23 - Write a query to verify that there are no duplicates in the country table

# 24 - Return Name, Population, and GNP for countries in Europe or Asia with populations between 50 and 100 million, ordered high to low on GNP
select 
	name,
    Population,
    GNP
from 
	country
where 
	(continent = "Asia" or continent = "Europe")
    and (population > 50000000 and population < 100000000)
order by
	GNP desc;
# 25 - How many countries is that?
select 
	count(*) as number_of_country
from 
	country
where 
	(continent = "Asia" or continent = "Europe")
    and (population > 50000000 and population < 100000000);
# 26 - Return continent, country name and GNP for each country, ordered high to low on GNP within each each continent
select
	continent,
    name,
    GNP
from 
	country
group by
	continent, GNP desc;
# 27 - What is the total worlwide population?
select
	sum(population) as total_worldwide_population
from
	country;
# 28 - Return the total population by continent, and order the results high to low
select
	continent, 
    sum(population) as total_worldwide_population
from
	country
group by
	continent
order by
	total_worldwide_population desc;
# 29 - Which language is spoken in 15 different countries?
select
	Language,
    count(language) as total
from 
	language
group by
	language
having
	total = 15;
# 30 - Calculate the number of speakers worldwide for each language, ordered high to low by number of speakers (30-35 require a JOIN)
select
    language,
	sum(population * percentage) as total_speakers
from language
left join country
	on language.CountryCode = country.Code
group by 
	language
order by
	total_speakers desc;
# 31 - Return a table that lists each language and number of speakers worldwide, ordered high to low on number of speakers, but only include languages that have > 200,000,000 speakers? 
select
	language,
    sum(population * percentage) as total_speakers
from language
join country
	on language.CountryCode = country.Code
group by 
	language
having
	total_speakers > 200000000
order by
	total_speakers desc;

# 32 - Which Countries speak 10 or more languages? Return the country name and number of languages for these countries.
select
	Name as country_name,
	count(language) as total_languages
from country
join language
	on country.code = language.CountryCode
group by
	Name
having
	total_languages >= 10;
    
# 33 Which countries have 3 or more official languages? Return the country name and # of official languages for these countries.
select * from language limit 5;
select 
	Name as country_name,
    count(language) as total_office_languages
from language
join country
	on language.CountryCode = country.code
where isofficial = "T"
group by 
	country_name
having
	total_office_languages >=3;
# 34 - What are the 3 most spoken languages worldwide?
select
	language,
    count(Name) as number_of_country
from language
join country
	on language.countrycode = country.Code
group by
	language
order by
	number_of_country desc
limit 3;
# 35 What year does this data come from?
select * from city limit 20;
select * from country limit 20;
select * from language limit 20;
select
	max(indepyear) as the_possible_year
from
	country;

