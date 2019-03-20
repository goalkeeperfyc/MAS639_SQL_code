use emergencycalls;
select * from calls;

select 
	timestamp,
    str_to_date(timestamp, "%Y-%m-%d") as "str_date"
from calls
order by timestamp
limit 5;

select
    str_to_date(timestamp, "%Y-%m-%d") as "str_date",
    count(*)
from calls
group by str_date;

select count(*) from calls;