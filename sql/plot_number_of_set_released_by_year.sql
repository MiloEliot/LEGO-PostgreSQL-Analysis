create extension if not exists plpython3u;

create or replace function plot_number_of_set_released_by_year()
returns void
language plpython3u

as $$
	import matplotlib.pyplot as plt
	import pandas as pd
	
	query = plpy.prepare("""
				select count(set_num) as number, year
				from lego_sets
				group by year
				order by year
				 """)
	
	result = plpy.execute(query)

	data = [dict(row) for row in result]
	df=pd.DataFrame(data)

	df.plot(x='year', y='number', kind='line', marker='o', figsize=(8,6))
	plt.savefig('./output/figures/Released_sets_per_year.png')

$$;
