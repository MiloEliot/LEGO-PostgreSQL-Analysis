create or replace function drop_fk(table_name text) -- specify the data type of input
returns text[] -- specify the data type of output
language plpgsql -- specify the procedure language
as $$ -- the body of the function
declare 
	fk record;
	dropped_fks text[] := '{}'; -- specify the data type and assigned an initial value
begin
	for fk in
		select conname
		  from pg_constraint
		where conrelid=table_name::regclass
		  and contype='f'
	loop
		execute format('alter table %I drop constraint %I', table_name, fk.conname);
		dropped_fks := array_append(dropped_fks, fk.conname);
	end loop;

	return dropped_fks;	
end;
$$;


