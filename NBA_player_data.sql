use nba;
select * from playerofweek limit 10;
select * from playerofweek where season = "2017-2018";
# average height of the player per year
# prepare for trans
select
	right(Date, 4) as year,
    height,
	left(height, 1),
    substring(height, 3, 1)
from 
	playerofweek
order by 1 desc;

select
	right(Date, 4) as year,
    height,
	substring_index(height, '-' , 1),
    substring_index(height, '-' , -1)
from 
	playerofweek
order by 1 desc;

# trans height
select
	right(Date, 4) as year,
    height,
    case right(height, 2)
		when 
			"cm" then left(height, 3) * 0.393701
		else
			substring_index(height, '-' , 1) * 11 + substring_index(height, '-' , -1)
	end as height_in_foot
from 
	playerofweek
order by 1 desc;

select
	right(Date, 4) as year,
    height,
    case right(height, 2)
		when 
			"cm" then left(height, 3) * 0.393701
		else
			left(height, 1) * 11 + substring(height, 3, 1)
	end as average_height
from 
	playerofweek
group by 1
order by 1 desc;

# average height of the player per year
# first version
select
	right(Date, 4) as year,
    format(avg(case right(height, 2)
		when 
			"cm" then left(height, 3) * 0.393701
		else
			left(height, 1) * 11 + substring(height, 3, 1)
	end), 2) as average_height
from 
	playerofweek
group by 1
order by 1 desc;

# second version
# maybe the right version
select
	right(Date, 4) as year,
    format(avg(case right(height, 2)
		when 
			"cm" then left(height, 3) * 0.393701
		else
			substring_index(height, '-' , 1) * 11 + substring_index(height, '-' , -1)
	end), 2) as average_height
from 
	playerofweek
group by 1
order by 1 desc;



# number of player under 5-10 every year
# my version
select
	season,
    count(height)
from 
	playerofweek
where
	substring_index(height, '-' , 1) < 6 and substring_index(height, '-' , 2) < 11
group by
	season;

# second version
    select
	right(Date, 4) as year,
    height,
    case right(height, 2)
		when 
			"cm" then left(height, 3) * 0.393701
		else
			left(height, 1) * 11 + substring(weight, 3, 1)
	end as average_height
from 
	playerofweek
group by 1
order by 1 desc;