

# You should be VERY VERY comfortable with each of these statements:
	# SELECT - defines the columns you want in your final table
    # FROM - what table(s) are you using
    # WHERE - subset or filter data for rows that meet one or more conditions
    # GROUP BY - determines level of aggregation, or what each row represents	
    # HAVING - subset groups (if used, must appear after the GROUP BY statement), similar to WHERE but for groups instead of individuals observations
    # ORDER BY

-- Just knowing these will get you pretty far! If this was all I knew, I could extract the data I needed and do all the cleaning in
-- my software of choice (R, Excel, SAS, Python, etc...).
-- We'll work through these clauses, and add in a few functions as needed (for math, working with dates, working with strings, etc..)

-- Stay organized, keep your code clean, space appropriately!


-- 0 Use the zoo table inside the zoo schema/database
use zoo;


# SELECT/FROM

-- 1 Select all of the data
SELECT * FROM zoo;
#don't limit in most situation
select * from zoo limit 5;

-- 2 Select only the common name, taxonomy class, and median life expectancy variables
select 
	commonname, 
    taxonclass, 
    medlifeexp 
from 
	zoo;
	-- ALIASING
-- 3 Give each column a better formatted header (proper english headers, not code)
#select aliasing(commonname) from zoo;
#rename variable name, space is possible unless it is in the double quote 
select 
	commonname as common_name, 
    taxonclass as taxon_class, 
    medlifeexp as med_life_exp
from 
	zoo;

select 
	commonname as "common_name", 
    taxonclass as "taxon_class", 
    medlifeexp as "med life exp"
from 
	zoo;	
    -- COUNT
-- 4 How many animals are represented in the table?
select count(scientificname) from zoo;
select count(*) from zoo;
select count(*), count(scientificname) from zoo;
	-- DISTINCT
-- 5 Which taxonomy classes are represented in the table?
select * from zoo;
select distinct(taxonclass) from zoo;
select distinct(commonname) from zoo;
select distinct(taxonclass) as "unique taxon class" from zoo;
select count(distinct(taxonclass)) as "number of classes" from zoo; 
-- 6 How many taxonomy classes are represented in the table?
select * from zoo limit 5;
select * from zoo where CIlower >= 10;
select * from zoo where CIlower between 10 and 20;

# WHERE
	# =
    # !=
    # >, >=
    # <, <=
#you can't use abbr in where because as doesn't change the variable name in database
select commonname, taxonclass, medlifeexp as mle from zoo where medlifeexp >= 30;
select commonname, taxonclass, medlifeexp as mle from zoo where medlifeexp >= 30 order by mle; 
    # IN
    # BETWEEN ... AND..., NOT BETWEEN... AND...
    # LIKE, NOT LIKE
    # IS NULL, IS NOT NULL
#select all the null data
select commonname, taxonclass, medlifeexp as mle from zoo where medlifeexp is null;

-- Construct multiple conditions / more complex conditions using AND or OR
-- Be careful when mixing AND's and OR's, it's easy to lose track of the logic.

-- 7 Return a table that gives the name and taxonomy class for all animals with median life expectancies... 
	-- a) greater than 20 years
    -- b) less than 2 years
    -- c) between 5 and 6 years
    -- d) that are missing in the data
select commonname, medlifeexp, taxonclass from zoo where medlifeexp > 20;
select commonname, medlifeexp, taxonclass from zoo where medlifeexp between 5 and 6;
-- 8 Return a table that gives the name and taxonomy class for all animals in which males have higher median life expectancies than females

-- 9 Return the name and median life expectancy for all...
	-- a) Mammalia
    -- b) Mammalia and Aves
    -- c) Mammalia, Aves, and Reptilia
    -- d) animals not in the Mammalia class

select commonname, medlifeexp from zoo where taxonclass = "Mammalia";

select 
	commonname, medlifeexp 
from 
	zoo 
where 
	taxonclass = "Mammalia" 
    or 
	taxonclass = 'Aves';
    
select 
	commonname, medlifeexp, taxonclass
from 
	zoo 
where 
	taxonclass in ("Mammalia", "Aves", "Reptilia");

select 
	commonname, medlifeexp, taxonclass
from 
	zoo 
where 
	taxonclass != "Mammalia";
-- 10 Return the name, class, and life expectancy for all...
	-- a) Mammalia with median life expectancies statistically equivalent to 5 years
    -- b) animals in the Mammalia class with life expectancies greater than 20 years or in the Reptilia class with life expectancies less than 10 years
select 
	commonname,
    taxonclass,
    medlifeexp
from
	zoo
where taxonclass = "Mammalia" and medlifeexp = 5;

select 
	commonname,
    taxonclass,
    medlifeexp,
    CIlower,
    CIupper
from
	zoo
where taxonclass = "Mammalia" and CIlower < 5 and CIupper > 5;

select 
	commonname,
    taxonclass,
    medlifeexp,
    CIlower,
    CIupper
from
	zoo
where (taxonclass = "Mammalia" and medlifeexp > 20) or 
	(taxonclass = "Reptilia" and  medlifeexp < 10);

select 
	commonname,
    taxonclass,
    medlifeexp,
    CIlower,
    CIupper
from
	zoo
where taxonclass = "Mammalia" and medlifeexp > 20;

select 
	commonname,
    taxonclass,
    medlifeexp,
    CIlower,
    CIupper
from
	zoo
where taxonclass = "Reptilia" and  medlifeexp < 10;

# Wildcard filtering
		-- % for "anything, any number of times"
        -- _ for "anything, one time"
        
-- 11 How long does your favorite zoo animal live?
select * from zoo where commonname like "%tiger%";
select * from zoo where commonname like "tiger%";
select * from zoo where commonname like "%tiger";
-- 12 How many
	-- a) animals in the table have common names that start with the letter b?
    -- b) bears are in the table?
    -- c) large cats are in the table?
select * from zoo where commonname like "b%";
select count(*) from zoo where commonname like "b%";
select * from zoo where commonname like "bear%";
select * from zoo where commonname like "%tiger%" or commonname like "%lion%";

-- 13 What is the... 
	-- a) average median life expectancy in the data?
    -- b) max and min median life expectancy in the data?
select 
	avg(medlifeexp) as avg_life, 
    min(medlifeexp), 
    max(medlifeexp),
    sum(samplesize)/count(samplesize) as avg_size
	from zoo;
-- 14 What is the average median life expectancy among bears?
	-- Could you do a weighted average if you wanted?

# GROUP BY
-- 15 How many animals...
	-- a) are represented in the Mammalia class?
    -- b) are represented in each taxonomy class?
select count(*) from zoo where taxonclass = "Mammalia";
select taxonclass, count(*) from zoo group by taxonclass;

-- 16 What is the average median life expectancy in each taxonomy class?
select taxonclass, count(*), avg(medlifeexp) from zoo group by taxonclass;

-- 17 Return the average median life expectancy by taxonomy class for classes... 
	-- a) with average median life expectancies less than 15 years
    -- b) with at least 100 animals represented in the class
    -- c) with less than 10 animals represented in the class but average median life expectancies above 10 years


# ORDER BY
-- 18 Return a table with the name, class, and life expectancy ordered...
	-- low to high on median life expectancy
    -- high to low on median life expectancy
    -- high to low within taxonomy class
   

-- 19 Which 3 animals lives the longest? (Return only those 3 rows using LIMIT clause)


# HAVING
-- 20 Which taxonomy class has the highest average median life expectancy? (Return only 1 row)


    
    
    
    
    
    
    
    
    
    