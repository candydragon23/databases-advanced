do $$
begin
	-- Переименовывание таблиц и изменение колонок. Добавление таблицы заголовков
	begin
		alter table calc_correction_heights rename to height_correction;
		
		alter table calc_correction_types rename to correction_types;
		alter table correction_types rename column measurment_equipment_id to equipment_id;
		alter table correction_types drop column description;
		alter table correction_types add column description_id integer;
		comment on column correction_types.description_id is 'Код заголовка';

		alter table calc_correction rename to correction;
		alter table correction rename column type_id to table_type_id;

		create sequence descriptions_seq;
		create table descriptions(
			id integer not null primary key default nextval('descriptions_seq'),
			description text not null
		);
	end;

	-- Исправление данных и добавление недостающих данных
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

		do $loop$
		declare
		    r int;
		begin
		    for r in 1..9 loop
		        update correction_types
		        set description_id = r
		        where id = r;
		    end loop;
		end $loop$;

		update correction set table_type_id = 9 where table_type_id = 8;
		
		do $loop$
		declare
			r int;
		begin
			for r in 5..8 loop
				update correction
				set table_type_id = 8
				where id = r;
			end loop;
		end $loop$;

		update correction set row_values = array_prepend(0, row_values) where table_type_id = 8;
		update correction set row_values = array_prepend(0, row_values) where table_type_id = 9;

		insert into correction(height_id, table_type_id, row_values) values
		-- Таблица 2, отрицательные значения
		(5, 9, array[0, -1, -2, -3, -3, -4, -4, -5, -6, -7, -7, -17, -25, -34, -42]), -- 1600
		(6, 9, array[0, -1, -2, -3, -3, -4, -4, -5, -6, -6, -7, -16, -24, -32, -40]), -- 2000
		(7, 9, array[0, -1, -2, -2, -3, -4, -4, -5, -5, -6, -7, -15, -23, -31, -38]), -- 2400
		(8, 9, array[0, -1, -2, -2, -3, -4, -4, -4, -5, -5, -6, -15, -22, -30, -37]), -- 3000
		(9, 9, array[0, -1, -2, -2, -3, -4, -4, -4, -4, -5, -6, -14, -20, -27, -34]), -- 4000
		-- Таблица 2, положительные значения
		(5, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 1600
		(6, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 2000
		(7, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 2400
		(8, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 3000
		(9, 8, array[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 4000
		-- Таблица 3, Скорость среднего ветра (ВР)
		(5, 4, array[4, 6, 7, 8, 9, 10, 11, 13, 14, 15 ,17, 17]), -- 1600
		(6, 4, array[4, 6, 7, 8, 9, 10, 11, 13, 14, 16 ,17, 18]), -- 2000
		(7, 4, array[4, 6, 8, 9, 9, 10, 12, 14, 15, 16 ,18, 19]), -- 2400
		(8, 4, array[5, 6, 8, 9, 10, 11, 12, 14, 15, 17 ,18, 19]), -- 3000
		(9, 4, array[5, 6, 8, 9, 10, 11, 12, 14, 16, 18 ,19, 20]), -- 4000
		-- Таблица 3, Направление среднего ветра (ВР)
		(5, 5, array[3]), -- 1600
		(6, 5, array[3]), -- 2000
		(7, 5, array[3]), -- 2400
		(8, 5, array[4]), -- 3000
		(9, 5, array[4]), -- 4000
		-- Таблица 3,Скорость среднего ветра (ДМК)
		(5, 6, array[6,8,11,13,14,17,20,21,23,25,27,29,32]), -- 1600
		(6, 6, array[6,9,11,13,14,17,20,21,24,26,28,30,32]), -- 2000
		(7, 6, array[6,9,12,14,15,18,21,22,25,27,29,32,34]), -- 2400
		(8, 6, array[6,9,12,14,15,18,21,23,25,28,30,32,36]), -- 3000
		(9, 6, array[6,10,12,14,16,19,22,24,26,29,32,34,36]), -- 4000
		-- Таблица 3, Направление среднего ветра (ДМК)
		(5, 7, array[4]), -- 1600
		(6, 7, array[4]), -- 2000
		(7, 7, array[4]), -- 2400
		(8, 7, array[5]), -- 3000
		(9, 7, array[5]); -- 4000
	end;
	commit;
end $$;