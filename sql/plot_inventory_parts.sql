/* 
 plot the number of lego parts grouped by either color or category in inventory
 */

create extension if not exists plpython3u;

create or replace function plot_inventory_parts(feature text)
returns void
language plpython3u

as $$
	import pandas as pd
	import matplotlib.pyplot as plt

	query = plpy.prepare("""
						select a.inventory_id, b.name as color, c.name, d.name as category, a.quantity
						from lego_inventory_parts a
						join lego_colors b on a.color_id = b.id
						join lego_parts c on a.part_num = c.part_num 
						join lego_part_categories d on c.part_cat_id = d.id 
						""", [])
	results = plpy.execute(query)
	dat = [dict(row) for row in results]
	df = pd.DataFrame(dat)

	grouped = df.groupby(feature)
	summary = grouped['quantity'].sum().reset_index(name='total_num').sort_values(by='total_num', ascending=True, ignore_index=True)
	

	fig = plt.figure(figsize=(12, 8))
	
	color_list = ['#97d8c4']*(summary.shape[0]-1) + ['#4059ad']
	plt.bar(x=summary[feature], height=summary['total_num'], color=color_list)
	plt.xticks(rotation=90, fontsize=6)
	plt.yticks(fontsize=8)
	plt.tight_layout()
	plt.savefig(f"/output/figures/Lego_parts_by_{feature}.png", dpi=300, transparent=True)
$$;