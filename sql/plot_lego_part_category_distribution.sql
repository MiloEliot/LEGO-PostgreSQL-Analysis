-- Enable plpython3u
create extension if not exists plpython3u;

-- create a function plotting the number of top N largest lego part category
create or replace function plot_lego_part_category_distribution(top_n integer) 
returns void
language plpython3u 

as $$
	# import python libraries
	import matplotlib.pyplot as plt
	import pandas as pd

	# query part distribution using sql 
	# plpy.prepare(sql, argtypes) creates a prepared sql statement
	# argtypes is a list of argument data types if placeholders ($1, $2 ...) are used in the query 
	query = plpy.prepare("""
				select c.name as lego_category, count(p.name) as quantity
				from lego_parts p join lego_part_categories c on p.part_cat_id=c.id
				group by c.name
				order by count(p.name) desc
				limit $1
				""", ['integer'])
 	# plpy.execute(query, args, limit) runs the sql query; limit restricts the number of rows
	result = plpy.execute(query, [top_n])
	
	# convert the result into a pandas dataframe
	data = [dict(row) for row in result]
	df=pd.DataFrame(data)
	
	# plot
	df.plot(kind='bar', x='lego_category', y='quantity')
	plt.title(f'Lego parts distribution by category - {top_n}')
	plt.xticks(fontsize=6)
	plt.tight_layout()
	plt.savefig(f'/output/figures/Top_{top_n}_largest_lego_part_category.png', dpi=300)
$$;


