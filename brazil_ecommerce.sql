use brazilecommerce;

# join
select * 
from olist_public
limit 5;

#many ways to get year and month
select
	category as Category,
	year(str_to_date(order_purchase_timestamp, "%Y-%m-%d %T")) as Year,
	month(str_to_date(order_purchase_timestamp, "%Y-%m-%d %T")) as Month,
    substring(order_purchase_timestamp, 1, 4) as Year2,
    left(order_purchase_timestamp, 4) as Year3,
    substring(order_purchase_timestamp, 6, 2) as Month2,
    sum(order_products_value) as sales
from olist_public
where category in ("relogios_presentes", "beleza_saude", "cama_mesa_banho")
#where top 3 products
group by 1;
# %T is for time %H:%M:%S
#substring left right work on str to select letters from str


select
	category as Category,
	year(str_to_date(order_purchase_timestamp, "%Y-%m-%d %T")) as Year,
	month(str_to_date(order_purchase_timestamp, "%Y-%m-%d %T")) as Month,
    round(sum(order_products_value), 2) as sales,
	concat("$", format(sum(order_products_value), 2)) as sales2
from olist_public
where category in ("relogios_presentes", "beleza_saude", "cama_mesa_banho")
#where top 3 products
group by 1, 2 desc, 3 desc
order by order_products_value;


# date_format(str_to_date(order_purchase_timestamp, "%b"))
select
	category as Category,
	year(str_to_date(order_purchase_timestamp, "%Y-%m-%d %T")) as Year,
	month(str_to_date(order_purchase_timestamp, "%Y-%m-%d %T")) as Month,
    case month(str_to_date(order_purchase_timestamp, "%Y-%m-%d %T"))
		when 1 then "Jan"
        when 2 then "Feb"
        when 3 then "Mar"
        when 4 then "Apr"
        when 5 then "May"
        when 6 then "Jun"
 		when 7 then "Jul"
        when 8 then "Oct"
        when 9 then "Sep"
        when 10 then "Oct"
        when 11 then "Dec"
        when 12 then "Nov"       
	end as MonthName,
	concat("$", format(sum(order_products_value), 2)) as sales2
from olist_public
where category in ("relogios_presentes", "beleza_saude", "cama_mesa_banho");


select
	name_english as Category,
	year(str_to_date(order_purchase_timestamp, "%Y-%m-%d %T")) as Year,
	month(str_to_date(order_purchase_timestamp, "%Y-%m-%d %T")) as Month,
    round(sum(order_products_value), 2) as sales,
	concat("$", format(sum(order_products_value), 2)) as sales2
from olist_public op
join category_translations ct
	on op.category = ct.name_portuguese
where category in ("relogios_presentes", "beleza_saude", "cama_mesa_banho")
#where top 3 products
group by 1, 2 desc, 3 desc;


select
	name_english as Category,
	year(str_to_date(order_purchase_timestamp, "%Y-%m-%d %T")) as Year,
	month(str_to_date(order_purchase_timestamp, "%Y-%m-%d %T")) as Month,
    round(sum(order_products_value), 2) as sales,
	concat("$", format(sum(order_products_value), 2)) as sales2,
	case month(str_to_date(order_purchase_timestamp, "%Y-%m-%d %T"))
		when 1 then "Jan"
        when 2 then "Feb"
        when 3 then "Mar"
        when 4 then "Apr"
        when 5 then "May"
        when 6 then "Jun"
 		when 7 then "Jul"
        when 8 then "Oct"
        when 9 then "Sep"
        when 10 then "Oct"
        when 11 then "Dec"
        when 12 then "Nov"       
	end as MonthName
from olist_public op
join category_translations ct
	on op.category = ct.name_portuguese
where category in ("relogios_presentes", "beleza_saude", "cama_mesa_banho")
#where top 3 products
group by 1, 2 desc, 3 desc;
