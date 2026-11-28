do $$
begin
	begin
		create sequence seq_facts;
		
		create table facts(
			id int primary key default nextval('seq_facts'),
			document_id int,
			document_type_id int,
			vendor_id int,
			storage_id int,
			product_id int,
			size_id int,
			amount float,
			total_cost float,
			time_id int,
			date_add timestamp default now()
		);
		comment on table facts is 'Таблица фактов учета закупки';
		comment on column facts.id is 'Уникальный код';
		comment on column facts.document_id is 'Код номенклатуры';
		comment on column facts.document_type_id is 'Код группы номенклатуры';
		comment on column facts.vendor_id is 'Код поставщика';
		comment on column facts.storage_id is 'Код склада';
		comment on column facts.product_id is 'Код продукта';
		comment on column facts.size_id is 'Код единицы измерения';
		comment on column facts.amount is 'Количество';
		comment on column facts.total_cost is 'Общая стоимость';
		comment on column facts.time_id is 'Код временного отрезка';
		comment on column facts.date_add is 'Дата добавления';
	end;
commit;
end $$;