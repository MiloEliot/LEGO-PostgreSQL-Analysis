/* create a bar plot for the number of parts of the largest set in each year*/

do $$

import pandas as pd
import matplotlib.pyplot as plt

query = plpy.prepare("""
				select year, max(num_parts) as largest_set 
				from lego_sets
				group by year
				order by year
				""", [])

result = plpy.execute(query)

data = [dict(row) for row in result]
df = pd.DataFrame(data)

max_set = df[df['largest_set'] == max(df['largest_set'])]
x_position = max_set.iloc[0,0]
y_position = max_set.iloc[0,1]

fig = plt.figure(figsize=(10,6), dpi=300)
plt.bar(x='year', height='largest_set', data=df, color='#17becf')
plt.text(x=x_position, y=y_position+500, s=f'largest set:\n{y_position} pieces', horizontalalignment='center')
plt.arrow(x=x_position, y=y_position+400, dx=0, dy=-300, head_width=1, head_length=50, color='#000000')
plt.ylim((0, 7000))
plt.tight_layout()
plt.savefig('./output/figures/Largest_set.png')
$$ language plpython3u;