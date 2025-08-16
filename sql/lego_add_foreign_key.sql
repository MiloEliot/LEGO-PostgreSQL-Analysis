alter table lego_inventory_parts 
add foreign key (color_id)
references lego_colors(id);

alter table lego_inventory_parts 
add foreign key (inventory_id)
references lego_inventories(id);

alter table lego_parts 
add foreign key (part_cat_id)
references lego_part_categories(id);

alter table lego_inventory_sets 
add foreign key (set_num)
references lego_sets(set_num);

alter table lego_inventories
add foreign key (set_num)
references lego_sets(set_num);

alter table lego_sets 
add foreign key (theme_id)
references lego_themes(id);


/* part_num=40082 in lego_inventory_parts does not exist in lego_parts.
 * Therefore, NOT VALID is included to prevent checking current rows.
 */
ALTER TABLE lego_inventory_parts
ADD CONSTRAINT part_num_fkey
FOREIGN KEY (part_num)
REFERENCES lego_parts(part_num)
NOT VALID;



