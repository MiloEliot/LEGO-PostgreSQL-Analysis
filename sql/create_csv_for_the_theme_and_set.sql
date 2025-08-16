/* find out the name of children sets for each parent set */

--create extension if not exists plpython3u;

do $$
import pandas as pd
	
query=plpy.prepare("""
				 select a.parent_id, b.name as theme_name, c.theme_id, c.name as set_name, c."year" , c.num_parts 
				 from lego_themes a 
				 join lego_themes b on a.parent_id=b.id
				 join lego_sets c on a.id=c.theme_id 
				 where a.parent_id in (select id
					  		    		from lego_themes
							  		   where parent_id is null)
				order by a.parent_id, c."year"
				""", [])
	
result = plpy.execute(query)
	
data=[dict(row) for row in result]
df = pd.DataFrame(data)
	
df.to_csv('./output/exports/the_name_of_children_sets.csv', sep=';', index=False)
$$ language plpython3u;





