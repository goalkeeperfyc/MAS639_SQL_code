# https://stackoverflow.com/questions/2577174/join-vs-sub-query
# https://www.quora.com/Which-is-faster-joins-or-subqueries



# Calculating total costs
USE healthcare; 
# 1. Put together by joining ALREADY AGGREGATED DATA
		# COALESCE( ColumnName , 0) to replace missing values with 0, this will allow me to add everything together without missing values causing a problem
		# In the end, I want Patient ID, First Name, Last Name, and Costs, Total Costs
        # Make it a view, to quickly grab most/least costly individuals
select * from dental limit 5;
select * from medical limit 5;
select count(*) from medical limit 5;
select * from patients limit 5;
select count(*) from patients;
select * from rx limit 5;
select * from vision limit 5;

select 
	first_name,
    last_name,
    p.patient_id,
    medCosts
from 
	patients p
	left join (select patient_id, sum(amount) as medCosts from medical group by 1) m
    on p.patient_id = m.patient_id
order by 1;

# may cause duplicate
select 
	first_name,
    last_name,
    p.patient_id,
    sum(amount) as medCosts
from 
	patients p
left join medical m
	on p.patient_id = m.patient_id
group by
	p.patient_id
order by 1;


select 
	p.patient_id, first_name, last_name,
    medCosts, dentalCosts, visionCosts, rxCosts,
    coalesce(medCosts, 0) + coalesce(dentalCosts, 0) + coalesce(visionCosts, 0) + coalesce(rxCosts, 0) as totalCosts
from patients p
left join (select patient_id, sum(amount) as medCosts from medical group by 1) m
    on p.patient_id = m.patient_id
left join (select patient_id, sum(amount) as dentalCosts from dental group by 1) d
    on p.patient_id = d.patient_id
left join (select patient_id, sum(amount) as rxCosts from rx group by 1) r
    on p.patient_id = r.patient_id
left join (select patient_id, sum(amount) as visionCosts from vision group by 1) v
    on p.patient_id = v.patient_id;


# create view doesn't allow subquery you have to create view for each subquery
create view mas639fang.medCosts as select patient_id, sum(amount) as medCosts from medical group by 1;
create view mas639fang.dentalCosts as select patient_id, sum(amount) as dentalCosts from medical group by 1;
create view mas639fang.rxCosts as select patient_id, sum(amount) as rxCosts from medical group by 1;
create view mas639fang.visionCosts as select patient_id, sum(amount) as visionCosts from medical group by 1;
create view mas639fang.TotalCost as
select 
	p.patient_id, first_name, last_name,
    medCosts, dentalCosts, visionCosts, rxCosts,
    coalesce(medCosts, 0) + coalesce(dentalCosts, 0) + coalesce(visionCosts, 0) + coalesce(rxCosts, 0) as totalCosts
from patients p
left join mas639fang.medCosts m
    on p.patient_id = m.patient_id
left join mas639fang.dentalCosts d
    on p.patient_id = d.patient_id
left join mas639fang.rxCosts r
    on p.patient_id = r.patient_id
left join mas639fang.visionCosts v
    on p.patient_id = v.patient_id;



# 2 Cohort Analysis
USE cohortanalysis;
SELECT * FROM cohort1 LIMIT 10;

	# First find when their first purchase is
	# Second get size of cohort
	# Merge everything together, group by start month and transaction month, get total and average rev
	# Clean results...
create table mas639fang.first_tx as 
select customer_id, min(date) as first_ts
from cohort1
group by 1;

create table mas639fang.cohort_size as 
select 
	substring(first_tx, 1, 7) as cohort,
    month(first_tx) as cohort_month,
    count(*) as num
from first_tx
group by cohort;

create table mas639fang.results as 
select 
	cohort,
    cohort_month,
    month(date) as tx_month,
    num,
    sum(amount) as month_rev,
    sum(amount) / num as RevPerCustomer
from cohort1 c1
join first_tx f
	on c1.customer_id = f.customer_id
join cohort_size c2
	on c2.cohort = left(f.first_tx, 7)
group by cohort, tx_month;
    
    
select * from results;