/* 
 * which sets have been released more than once? / which sets in the table have the same name?
 * find out the name of set and associated set_num, year, and num_parts
 */
--create extension if not exists plpython3u;


do $$
import pandas as pd

query = plpy.prepare("""
					select name, set_num, year, num_parts
					from lego_sets
					where name in (select name 
										from lego_sets
				 					 group by name 
										having count(name) > 1)
					order by name, year
					""", [])

results = plpy.execute(query)

data = [dict(row) for row in results]
df = pd.DataFrame(data)

df.to_csv('./output/exports/Sets_with_the_same_name.csv', sep=',', index=False)
$$ language plpython3u;