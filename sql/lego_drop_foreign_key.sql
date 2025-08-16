do $$
-- declare two variables to store the name of table and the name of constraint
declare 
    table_name text;
    constraint_name text; 
begin
	for table_name, constraint_name in 
	    SELECT
            cl.relname, -- table name stored in pg_class
            c.conname -- constraint name stored in pg_constraint
        FROM
            pg_constraint c
        JOIN
            pg_class cl ON c.conrelid = cl.oid
        where
            contype='f'
   loop
	   execute format('alter table %I drop constraint %I', table_name, constraint_name);
	   raise notice '% foreign key is dropped from %', constraint_name, table_name;
   end loop;
 end $$;
   
   
