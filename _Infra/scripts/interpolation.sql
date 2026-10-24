do $$
begin
	-- Изменение структуры таблицы virtual_temp
	alter table virtual_temp
	drop column if exists "$t_{0}$",
	drop column if exists "Ниже 0",
	drop column if exists "0 - 5",
	drop column if exists "10 - 15",
	drop column if exists "20",
	drop column if exists "25",
	drop column if exists "30",
	drop column if exists "40",
	add column if not exists id int primary key default nextval('seq_virtual_temp'),
	add column if not exists range numeric,
	add column if not exists virtual numeric;

	comment on column virtual_temp.id is 'Уникальный код';
	comment on column virtual_temp.range is 'Граница';
	comment on column virtual_temp.virtual is 'Виртуальная поправка';

	-- Вставка граничных данных
	insert into virtual_temp(range, virtual) values(0, 0), (5, 0.5), (10, 1), (15, 1), (20, 1.5), (25, 2), (30, 3.5), (40, 4.5);

	-- Удаление типа
	drop type if exists var_interpolation cascade;
	
	-- Создание типа для интерполяции
	create type var_interpolation as (
		x0 numeric,
		y0 numeric,
		x1 numeric,
		y1 numeric
	);
	comment on type var_interpolation is 'Тип данных для интерполяции'; -- Добавить к комментарию

	-- Удаление функций
	drop function if exists interpolation_params(numeric) cascade;
	drop function if exists calculate_interpolation(numeric) cascade;

	-- Создание функции для определения интерполяции по температуре
	create function interpolation_params(temp numeric)
	returns var_interpolation
	language plpgsql
	as $func$
	declare
		interpolation_borders var_interpolation;
	begin
		-- Верхняя граница
		select temperature as x0,
		correction as y0
		into interpolation_borders.x0, interpolation_borders.y0
		from virtual_temp
		where temperature >= temp
		order by temperature desc
		limit 1;

		-- Нижняя граница
		select temperature as x1,
		correction as y1
		into interpolation_borders.x1, interpolation_borders.y1
		from virtual_temp
		where temperature <= temp
		order by temperature desc
		limit 1;
	
		return var_interpolation;
	end;
	$func$;

	-- Создание функции рвсчета интерполяции
	create function calculate_interpolation(x numeric, borders var_interpolation)
	returns numeric
	language plpgsql
	as $func$
	begin
		-- Проверка чтобы не было деления на 0
		if borders.x0 = borders.x1 then
		return borders.y0;

		-- Расчет интерполяции
		elsif x > borders.x1 then
		return borders.y1;
		elsif x < borders.x0 then
		return borders.y0;
		else
		return borders.y0 + (borders.y1 - borders.y0) * (x - borders.x0) / (borders.x1 - borders.x0);
		end if;
	end;
	$func$;
commit;
end $$;