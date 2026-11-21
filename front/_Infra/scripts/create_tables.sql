create database front;

do $$
begin
	begin
		-- storage operations types
		create sequence seq_storage_operations_types;
		
		create table storage_operations_types (
			id int primary key default nextval('seq_storage_operations_types'),
			external_id int,
			description text,
			factor int
		);

		-- journal document types
		create sequence seq_journal_document_types;
		
		create table journal_document_types (
			id int primary key default nextval('seq_journal_document_types'),
			external_id int,
			description text,
			journal_id int,
			isparent int
		);

		-- journal types
		create sequence seq_journal_types;

		create table journal_types (
			id int primary key default nextval('seq_journal_types'),
			external_id int,
			name text
		);

		-- products
		create sequence seq_products;

		create table products(
			id int primary key default nextval('seq_products'),
			external_id int,
			product_id int,
			name text,
			vendor_id int,
			category_id int,
			size_id int,
			isused int
		);

		-- vendors
		create sequence seq_vendors;

		create table vendors (
			id int primary key default nextval('seq_vendors'),
			external_id int,
			vendor_id text,
			vendor_group int,
			name text,
			isuse int
		);

		-- storages
		create sequence seq_storages;

		create table storages (
			id int primary key default nextval('seq_storages'),
			external_id int,
			name text
		);

		-- employees
		create sequence seq_employees;

		create table employees (
			id int primary key default nextval('seq_employees'),
			external_id int,
			firstname text,
			lastname text,
			middlename text,
			security_access int
		);

		-- size
		create sequence seq_size;

		create table size(
			id int primary key default nextval('seq_size'),
			external_id int,
			name text,
			factor float
		);
		
		-- trans types
		create sequence seq_trans_types;

		create table trans_types(
			id int primary key default nextval('seq_trans_types'),
			external_id int,
			group_id int,
			preview_group_type text,
			description text
		);

		-- vendors groups
		create sequence seq_vendors_groups;

		create table vendors_groups(
			id int primary key default nextval('seq_vendors_groups'),
			description text
		);
	end;
commit;
end $$;