/* use self-join to find out the number of children sets of each parent set */

select a.parent_id, b.name, count(a.name)
from lego_themes a join lego_themes b on a.parent_id=b.id
where a.parent_id in (select id
					  from lego_themes
					where parent_id is null)
group by a.parent_id, b.name
order by count(a.name) desc;


