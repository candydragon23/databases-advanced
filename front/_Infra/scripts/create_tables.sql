create database front;

do $$
begin
	begin
		-- storage operations
		create sequence seq_storage_operations;
		
		create table storage_operations (
			id bigint primary key default nextval('seq_storage_operations'),
			external_id bigint,
			document_id int,
			operation_id int,
			product_id int,
			vendor_id int,
			storage_id int,
			range_id int,
			count float,
			price float,
			pricecost float,
			total_price float,
			taxed_percent float,
			taxed_amount float,
			date_add timestamp default now()
		);

		-- document headers
		create sequence seq_document_headers;

		create table document_headers (
			id bigint primary key default nextval('seq_document_headers'),
			external_id int,
			document_type_id int,
			journal_id int,
			document_sum float,
			person_id int,
			shift_id int,
			date_add timestamp default now()
		);

		-- storage operations types
		create sequence seq_storage_operations_types;
		
		create table storage_operations_types (
			id bigint primary key default nextval('seq_storage_operations_types'),
			external_id int,
			description text,
			factor int
		);

		-- journal document types
		create sequence seq_journal_document_types;
		
		create table journal_document_types (
			id bigint primary key default nextval('seq_journal_document_types'),
			external_id int,
			description text,
			journal_id int,
			isparent int
		);

		-- journal types
		create sequence seq_journal_types;

		create table journal_types (
			id bigint primary key default nextval('seq_journal_types'),
			external_id int,
			name text
		);

		-- products
		create sequence seq_products;

		create table products(
			id bigint primary key default nextval('seq_products'),
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
			id bigint primary key default nextval('seq_vendors'),
			external_id int,
			vendor_id text,
			vendor_group int,
			name text,
			isuse int
		);

		-- storages
		create sequence seq_storages;

		create table storages (
			id bigint primary key default nextval('seq_storages'),
			external_id int,
			name text
		);

		-- employees
		create sequence seq_employees;

		create table employees (
			id bigint primary key default nextval('seq_employees'),
			external_id int,
			firstname text,
			lastname text,
			middlename text,
			security_access int
		);

		-- journal
		create sequence seq_journal;

		create table journal (
			id bigint primary key default nextval('seq_journal'),
			external_line_id int,
			line_type int,
			receipt int,
			cost float,
			amount float,
			total_cost float,
			item_id int,
			description text,
			discount_percent float,
			discount_amount float,
			employee_id int
		);

		-- size
		create sequence seq_size;

		create table size(
			id bigint primary key default nextval('seq_size'),
			external_id int,
			name text,
			factor float
		);

		-- journal details
		create sequence seq_journal_details;

		create table journal_details(
			id bigint primary key default nextval('seq_journal_details'),
			external_id int,
			line_id int,
			product_id int,
			dish_id int,
			weight_brutto float,
			amount float,
			range_id int,
			range_amount float,
			ticket_number int,
			size_id int,
			storage_id int
		);
		
		-- trans types
		create sequence seq_trans_types;

		create table trans_types(
			id bigint primary key default nextval('seq_trans_types'),
			external_id int,
			group_id int,
			preview_group_type text,
			description text
		);

		-- pricelist
		create sequence seq_pricelist;

		create table pricelist(
			id bigint primary key default nextval('seq_pricelist'),
			external_id int,
			document_id int,
			cost float,
			group_id int,
			product_id int
		);

		-- vendors groups
		create sequence seq_vendors_groups;

		create table vendors_groups(
			id bigint primary key default nextval('seq_vendors_groups'),
			description text
		);

		insert into vendors_groups(description) values ('Поставщики'), ('Без названия');

		-- employee access
		create sequence seq_employee_access;

		create table employee_access(
			id bigint primary key default nextval('seq_employee_access'),
			external_id int,
			employee_id int,
			object_id int,
			isuse int
		);
	end;
commit;
end $$;