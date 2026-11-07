do $$
begin
	-- Создание таблиц
	begin
		drop sequence if exists height_correction_seq cascade;
		drop sequence if exists correction_types_seq cascade;
		drop sequence if exists correction_seq cascade;
		drop sequence if exists descriptions_seq cascade;
		
		drop table if exists height_correction cascade;
		drop table if exists correction_types cascade;
		drop table if exists correction cascade;
		drop table if exists descriptions cascade;
		
		-- Таблица стандартных высот
		create sequence height_correction_seq;
		create table height_correction
		(
		        id int primary key not null default nextval('height_correction_seq'),
		        height int not null
		);
		comment on table height_correction is 'Таблица стандартных высот';
		comment on column height_correction.id is 'Уникальный код';
		comment on column height_correction.height is 'Высота';
	
		-- Справочник типов таблиц корректировок
		create sequence correction_types_seq;
		create table correction_types
		(
		        id int not null primary key default nextval('correction_types_seq'),
		        parent_id int,
		        equipment_id int,
		        description_id int,
		        header_values int[]
		);
		comment on table correction_types is 'Справочник типов таблиц с собственными заголовками';
		comment on column correction_types.id is 'Уникальный код';
		comment on column correction_types.parent_id is 'Уникальный код владельца - тип таблицы';
		comment on column correction_types.equipment_id is 'Тип оборудования';
		comment on column correction_types.description_id is 'Код описания таблицы';
		comment on column correction_types.header_values is 'Значения в заголовке таблице';

		-- Универсальная таблица корректировок
		create sequence correction_seq;
		create table correction
		(
		        id integer not null primary key default nextval('correction_seq'),
		        height_id integer not null,
		        table_type_id integer not null,
		        row_values integer[]
		);
		comment on table correction is 'Универсальная таблица корректировок';
		comment on column correction.id is 'Уникальный код';
		comment on column correction.height_id is 'Код высоты';
		comment on column correction.table_type_id is 'Код типа таблиц';
		comment on column correction.row_values is 'Значения с корректировками';

		-- Таблица заголовков справочников
		create sequence descriptions_seq;
		create table descriptions
		(
			id int not null primary key default nextval('descriptions_seq'),
			description text not null
		);
	end;	

	-- Добавление данных
	begin
		insert into descriptions(description)
		values('Таблица 2'), -- 1
		('Таблица 3, скорость среднего ветра'), -- 2
		('Таблица 3, направление среднего ветра'), -- 3
		('Таблица 3, Скорость среднего ветра (ВР)'), -- 4
		('Таблица 3, Направление среднего ветра (ВР)'), -- 5
		('Таблица 3, Скорость среднего ветра (ДМК)'), -- 6
		('Таблица 3, Направление среднего ветра (ДМК)'), -- 7
		('Таблица 2, Положительные температуры'), -- 8
		('Таблица 2, Отрицательные температуры'); -- 9
		
		insert into height_correction(height)
		values(200),(400),(800),(1200),(1600),(2000),(2400),(3000),(4000);
		
		insert into correction_types(description_id, header_values)
		values(1, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50]), -- 1
		(2, null), -- 2
		(3, null); -- 3

		insert into correction_types(description_id, parent_id, equipment_id, header_values)
		values
		(4, 2, 2, array[40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150]), -- 4
		(5, 3, 2, array[40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150]), -- 5
		(6, 2, 1, array[3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]), -- 6
		(7, 3, 1, array[3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]); -- 7
		
		insert into correction_types(description_id, parent_id)
		values(8, 1), -- 8
		(9, 1); -- 9

		insert into correction(height_id, table_type_id, row_values)
		-- Таблица 2, отрицательные значения
		values(1, 9, array[0, -1, -2, -3, -4, -5, -6, -7, -8, -8, -9, -20, -29, -39, -49]), -- 200
		(2, 9, array[0, -1, -2, -3, -4, -5, -6, -6, -7, -8, -9, -19, -29, -39, -48]), -- 400
		(3, 9, array[0, -1, -2, -3, -4, -5, -6, -6, -7, -7, -8, -18, -28, -37, -46]), -- 800
		(4, 9, array[0, -1, -2, -3, -4, -4, -5, -5, -6, -7, -8, -17, -26, -35, -44]), -- 1200
		(5, 9, array[0, -1, -2, -3, -3, -4, -4, -5, -6, -7, -7, -17, -25, -34, -42]), -- 1600
		(6, 9, array[0, -1, -2, -3, -3, -4, -4, -5, -6, -6, -7, -16, -24, -32, -40]), -- 2000
		(7, 9, array[0, -1, -2, -2, -3, -4, -4, -5, -5, -6, -7, -15, -23, -31, -38]), -- 2400
		(8, 9, array[0, -1, -2, -2, -3, -4, -4, -4, -5, -5, -6, -15, -22, -30, -37]), -- 3000
		(9, 9, array[0, -1, -2, -2, -3, -4, -4, -4, -4, -5, -6, -14, -20, -27, -34]), -- 4000
		-- Таблица 2, положительные значения
		(1, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 200
		(2, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 400
		(3, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 800
		(4, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 1200
		(5, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 1600
		(6, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 2000
		(7, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 2400
		(8, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 3000
		(9, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 4000
		-- Таблица 3, Скорость среднего ветра (ВР)
		(1, 4, array[3, 4, 5, 6, 7, 7, 8, 9, 10, 11, 12, 12]), -- 200
		(2, 4, array[4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 ,15]), -- 400
		(3, 4, array[4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15 ,16]), -- 800
		(4, 4, array[4, 5, 7, 8, 8, 9, 11, 12, 13, 15 ,15, 16]), -- 1200
		(5, 4, array[4, 6, 7, 8, 9, 10, 11, 13, 14, 15 ,17, 17]), -- 1600
		(6, 4, array[4, 6, 7, 8, 9, 10, 11, 13, 14, 16 ,17, 18]), -- 2000
		(7, 4, array[4, 6, 8, 9, 9, 10, 12, 14, 15, 16 ,18, 19]), -- 2400
		(8, 4, array[5, 6, 8, 9, 10, 11, 12, 14, 15, 17 ,18, 19]), -- 3000
		(9, 4, array[5, 6, 8, 9, 10, 11, 12, 14, 16, 18 ,19, 20]), -- 4000
		-- Таблица 3, Направление среднего ветра (ВР)
		(1, 5, array[0]), -- 200
		(2, 5, array[1]), -- 400
		(3, 5, array[2]), -- 800
		(4, 5, array[2]), -- 1200
		(5, 5, array[3]), -- 1600
		(6, 5, array[3]), -- 2000
		(7, 5, array[3]), -- 2400
		(8, 5, array[4]), -- 3000
		(9, 5, array[4]), -- 4000
		-- Таблица 3,Скорость среднего ветра (ДМК)
		(1, 6, array[4,6,8,9,10,12,14,15,16,18,20,21,22]), -- 200
		(2, 6, array[5,7,10,11,12,14,17,18,20,22,23,25,27]), -- 400
		(3, 6, array[5,8,10,11,13,15,18,19,21,23,25,27,28]), -- 800
		(4, 6, array[5,8,11,12,13,16,19,20,23,24,26,28,30]), -- 1200
		(5, 6, array[6,8,11,13,14,17,20,21,23,25,27,29,32]), -- 1600
		(6, 6, array[6,9,11,13,14,17,20,21,24,26,28,30,32]), -- 2000
		(7, 6, array[6,9,12,14,15,18,21,22,25,27,29,32,34]), -- 2400
		(8, 6, array[6,9,12,14,15,18,21,23,25,28,30,32,36]), -- 3000
		(9, 6, array[6,10,12,14,16,19,22,24,26,29,32,34,36]), -- 4000
		-- Таблица 3, Направление среднего ветра (ДМК)
		(1, 7, array[1]), -- 200
		(2, 7, array[2]), -- 400
		(3, 7, array[3]), -- 800
		(4, 7, array[3]), -- 1200
		(5, 7, array[4]), -- 1600
		(6, 7, array[4]), -- 2000
		(7, 7, array[4]), -- 2400
		(8, 7, array[5]), -- 3000
		(9, 7, array[5]); -- 4000
	end;
	commit;
end $$;
	