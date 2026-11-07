-- Пересоздание типа для входных параметров
drop type if exists input_params cascade;

create type input_params as (
	height decimal,
	temperature decimal,
	pressure decimal,
	wind_direction decimal,
	wind_speed decimal,
	bullet_deviation decimal
);

-- Создание хранимой процедуры вычисления
drop procedure if exists calculation;

create procedure calculation(params input_params, equipment_id int)
language plpgsql
as $func$
declare
	v_pres decimal; -- Отклонение давления
	v_int_temp decimal; -- Интерполированная виртуальная поправка температуры
	v_virt_temp decimal; -- Отклонение виртуальной температуры
	v_virt_temp_round int; -- Округленное отклонение виртуальной температуры
	v_virt_temp_tens int; -- Позиция десяток отклонения виртуальной температуры
	v_virt_temp_ones int; -- Позиция единиц отклонения виртуальной температуры
	v_avg_temp decimal; -- Отклонение средней температуры
	v_head_wind_speed int; -- Позиция хедера для скорости ветра
	v_wind_speed decimal; -- Скорость ветра
	v_wind_dir decimal; -- Направление ветра
	r record;
begin
	-- Валидация параметров
	validate_parameter_pack(params);
	
	-- Расчет отклонения давления
	v_pres := params.pressure - 750;

	-- Расчет виртуальной поправки температуры
	v_int_temp := calculate_interpolation(params.temperature, interpolation_params(params.temperature));

	-- Расчет отклонения виртуальной температуры
	v_virt_temp := params.temperature + v_int_temp - 15.9;

	-- Расчет отклонения средней температуры
	v_virt_temp_round := round(v_virt_temp);
	v_virt_temp_tens := array_position((select header_values from correction_types where description_id = 1), abs(v_virt_temp_round / 10 * 10));
	v_virt_temp_ones := array_position((select header_values from correction_types where description_id = 1), abs(v_virt_temp_round % 10));
	if v_virt_temp_round > 0 then
		v_avg_temp := (select row_values[v_virt_temp_tens] from correction where table_type_id = 8 and height_id = (select id from height_correction where height = params.height))
		+ (select row_values[v_virt_temp_ones] from correction where table_type_id = 8 and height_id = (select id from height_correction where height = params.height));
	else
		v_avg_temp := (select row_values[v_virt_temp_tens] from correction where table_type_id = 9 and height_id = (select id from height_correction where height = params.height))
		+ (select row_values[v_virt_temp_ones] from correction where table_type_id = 9 and height_id = (select id from height_correction where height = params.height));
		v_avg_temp := abs(v_avg_temp) + 50;
	end if;

	-- Расчет скорости ветра
	if equipment_id = 1 then -- ВР
		if params.bullet_deviation < 40 then
			v_wind_speed := 0;
		else
			v_head_wind_speed := array_position((select header_values from correction_types where description_id = 4), params.bullet_deviation);
			v_wind_speed := (select row_values[v_head_wind_speed] from correction where table_type_id = 4 and height_id = (select id from height_correction where height = params.height));
		end if;
	else -- ДМК
		if params.wind_speed < 3 then
			v_wind_speed := 0;
		else
			v_head_wind_speed := array_position((select header_values from correction_types where description_id = 6), params.wind_speed);
			v_wind_speed := (select row_values[v_head_wind_speed] from correction where table_type_id = 6 and height_id = (select id from height_correction where height = params.height));
		end if;
	end if;

	-- Расчет направления ветра
	if equipment_id = 1 then -- ВР
		if params.height > 4000 then
			v_wind_dir := (select row_values[1] from correction where table_type_id = 5 and height_id = (select id from height_correction where height = 4000))
			+ params.wind_direction;
		elsif params.height < 200 then
			v_wind_dir := (select row_values[1] from correction where table_type_id = 5 and height_id = (select id from height_correction where height = 200))
			+ params.wind_direction;
		else
			v_wind_dir := (select row_values[1] from correction where table_type_id = 5 and height_id = (select id from height_correction where height = params.height))
			+ params.wind_direction;
		end if;
	else -- ДМК
		if params.height > 4000 then
			v_wind_dir := (select row_values[1] from correction where table_type_id = 7 and height_id = (select id from height_correction where height = 4000))
			+ params.wind_direction;
		elsif params.height < 200 then
			v_wind_dir := (select row_values[1] from correction where table_type_id = 7 and height_id = (select id from height_correction where height = 200))
			+ params.wind_direction;
		else
			v_wind_dir := (select row_values[1] from correction where table_type_id = 7 and height_id = (select id from height_correction where height = params.height))
			+ params.wind_direction;
		end if;
	end if;

	-- Вывод данных
    for r in select v_pres, v_virt_temp, v_avg_temp, v_wind_speed, v_wind_dir
             loop
        raise notice 'Отклонение давления = %, Отклонение виртуальной температуры = %, Среднее отклонение температуры = %, Скорость ветра = %, Направление ветра = %',
                     r.v_pres, r.v_virt_temp, r.v_avg_temp, r.v_wind_speed, r.v_wind_dir;
    end loop;
end;
$func$;