-- There are multple inventory_id for one set, which makes the stored quantity for each set imprecise. Here are three ways to correct it

/*
-- Aggregate but keep inventory_id as an array
select a.set_num, b.name, b.year, b.theme_id, b.num_parts, count(c.inventory_id) as total_quantity, a.version, 
	array_agg(c.inventory_id order by c.inventory_id) as inventory_ids -- use array_agg to collect all inventory_id 
from lego_inventories a
join lego_sets b on a.set_num = b.set_num
join lego_inventory_sets c on b.set_num = c.set_num
group by a.set_num, b.name, b.year, b.theme_id, b.num_parts, a.version
;
*/


/*
-- Use window function to count the number of each set; no aggregation 
select a.set_num, b.name, b.year, b.theme_id, b.num_parts, c.inventory_id, a.version, 
	count(*) over(partition by a.set_num)as total_quantity -- use window function
from lego_inventories a
join lego_sets b on a.set_num = b.set_num
join lego_inventory_sets c on b.set_num = c.set_num
order by a.set_num, c.inventory_id
;
*/



 -- Two-step approach; make a summary table for counts and join it back
with count_sets as (
	select set_num, count(*) as total_quantity
		from lego_inventory_sets
	group by set_num)


select a.set_num, b.name, b.year, b.theme_id, b.num_parts, c.inventory_id, d.total_quantity, a.version
from lego_inventories a
join lego_sets b on a.set_num = b.set_num
join lego_inventory_sets c on b.set_num = c.set_num
join count_sets d on c.set_num = d.set_num
order by a.set_num, c.inventory_id
;
