do $$
begin
	drop table if exists parameter_errors cascade;
	drop sequence if exists seq_parameter_errors cascade;
	
	create sequence seq_parameter_errors;
	
	create table parameter_errors(
	error_id int primary key default nextval('seq_parameter_errors'),
	param_pack_id int,
	param_type_id int,
	param_value decimal,
	param_user_id int,
	param_eq_id int,
	error_code text not null,
	error_message text not null,
	created_at timestamp not null default now()
	);
	comment on table  parameter_errors is 'Информация об ошибках входных параметров';
	comment on column parameter_errors.param_pack_id is 'Код пачки';
	comment on column parameter_errors.param_type_id is 'Код типа параметра';
	comment on column parameter_errors.param_value is 'Значение параметра';
	comment on column parameter_errors.param_user_id is 'Код пользователя';
	comment on column parameter_errors.param_eq_id is 'Код оборудования';
	comment on column parameter_errors.error_code is 'Код ошибки';
	comment on column parameter_errors.error_message is 'Текст ошибки';
	comment on column parameter_errors.error_message is 'Время создания ошибки';

	-- Создание типа данных для списка параметров
	drop type if exists param_list cascade;
	
	create type param_list as (
	    pack_id int,
	    equipment_code text,
	    height decimal,
	    temperature decimal,
	    pressure decimal,
		wind_direction decimal,
		wind_speed decimal,
		bullet_deviation decimal
	);
	comment on type param_list is 'Список параметров';

	-- Функция валидации
	drop function if exists validate_parameter_pack(param_list);
	
	create function validate_parameter_pack(pack param_list)
	returns text
	language plpgsql
	as $func$
	declare
	    errors  text := '';
	    eq_up   text;
	    v_bt    const_bulletin_types%rowtype;
	    v_bt_ok boolean := false;
	    v_l     const_param_limits%rowtype;
	begin
	    -- Тип оборудования
	    eq_up := upper(pack.equipment_code);
	    select * into v_bt
	      from const_bulletin_types
	     where code = eq_up;
	    v_bt_ok := found;
	
	    if pack.equipment_code is null then
	        errors := errors || format(const_error('INVALID_TYPE'), 'NULL') || '; ';
	    elsif not v_bt_ok then
	        errors := errors || format(const_error('INVALID_TYPE'), pack.equipment_code) || '; ';
	    end if;
	
	    -- Высота метеопоста
	    select * into v_l from const_param_limits where param_name = 'Высота метеопоста';
	    if pack.height is null then
	        errors := errors || format(const_error('NULL_VALUE'), 'Высота метеопоста') || '; ';
	    elsif v_l.is_integer and pack.height <> trunc(pack.height) then
	        errors := errors || format(const_error('NOT_INTEGER'), 'Высота метеопоста', pack.height) || '; ';
	    elsif pack.height < v_l.min_value or pack.height > v_l.max_value then
	        errors := errors || format(const_error('VALUE_OUT_OF_RANGE'),
	                                   'Высота метеопоста', pack.height,
	                                   v_l.min_value, v_l.max_value) || '; ';
	    end if;
	
	    -- Температура
	    select * into v_l from const_param_limits where param_name = 'Температура';
	    if pack.temperature is null then
	        errors := errors || format(const_error('NULL_VALUE'), 'Температура') || '; ';
	    elsif v_l.decimals is not null
	          and pack.temperature <> round(pack.temperature, v_l.decimals) then
	        errors := errors || format(const_error('INVALID_SCALE'),
	                                   'Температура', v_l.decimals, pack.temperature) || '; ';
	    elsif pack.temperature < v_l.min_value or pack.temperature > v_l.max_value then
	        errors := errors || format(const_error('VALUE_OUT_OF_RANGE'),
	                                   'Температура', pack.temperature,
	                                   v_l.min_value, v_l.max_value) || '; ';
	    end if;
	
	    -- Давление
	    select * into v_l from const_param_limits where param_name = 'Давление';
	    if pack.pressure is null then
	        errors := errors || format(const_error('NULL_VALUE'), 'Давление') || '; ';
	    elsif v_l.is_integer and pack.pressure <> trunc(pack.pressure) then
	        errors := errors || format(const_error('NOT_INTEGER'), 'Давление', pack.pressure) || '; ';
	    elsif pack.pressure < v_l.min_value or pack.pressure > v_l.max_value then
	        errors := errors || format(const_error('VALUE_OUT_OF_RANGE'),
	                                   'Давление', pack.pressure,
	                                   v_l.min_value, v_l.max_value) || '; ';
	    end if;
	
	    -- Направление ветра
	    select * into v_l from const_param_limits where param_name = 'Направление ветра';
	    if pack.wind_direction is null then
	        errors := errors || format(const_error('NULL_VALUE'), 'Направление ветра') || '; ';
	    elsif v_l.is_integer and pack.wind_direction <> trunc(pack.wind_direction) then
	        errors := errors || format(const_error('NOT_INTEGER'), 'Направление ветра', pack.wind_direction) || '; ';
	    elsif pack.wind_direction < v_l.min_value or pack.wind_direction > v_l.max_value then
	        errors := errors || format(const_error('VALUE_OUT_OF_RANGE'),
	                                   'Направление ветра', pack.wind_direction,
	                                   v_l.min_value, v_l.max_value) || '; ';
	    end if;
	
	    -- Скорость ветра — зависит от типа оборудования
	    select * into v_l from const_param_limits where param_name = 'Скорость ветра';
	    if v_bt_ok and v_bt.requires_wind_speed then
	        if pack.wind_speed is null then
	            errors := errors || format(const_error('REQUIRED_FIELD'), 'Скорость ветра') || '; ';
	        elsif v_l.is_integer and pack.wind_speed <> trunc(pack.wind_speed) then
	            errors := errors || format(const_error('NOT_INTEGER'), 'Скорость ветра', pack.wind_speed) || '; ';
	        elsif pack.wind_speed < v_l.min_value or pack.wind_speed > v_l.max_value then
	            errors := errors || format(const_error('VALUE_OUT_OF_RANGE'),
	                                       'Скорость ветра', pack.wind_speed,
	                                       v_l.min_value, v_l.max_value) || '; ';
	        end if;
	    elsif v_bt_ok and not v_bt.requires_wind_speed
	          and pack.wind_speed is not null then
	        errors := errors || format(const_error('FORBIDDEN_FIELD'), 'Скорость ветра') || '; ';
	    end if;
	
	    -- Дальность сноса пуль — зависит от типа оборудования
	    select * into v_l from const_param_limits where param_name = 'Дальность сноса пуль';
	    if v_bt_ok and v_bt.requires_bullet_deviation then
	        if pack.bullet_deviation is null then
	            errors := errors || format(const_error('REQUIRED_FIELD'), 'Дальность сноса пуль') || '; ';
	        elsif v_l.is_integer and pack.bullet_deviation <> trunc(pack.bullet_deviation) then
	            errors := errors || format(const_error('NOT_INTEGER'), 'Дальность сноса пуль', pack.bullet_deviation) || '; ';
	        elsif pack.bullet_deviation < v_l.min_value or pack.bullet_deviation > v_l.max_value then
	            errors := errors || format(const_error('VALUE_OUT_OF_RANGE'),
	                                       'Дальность сноса пуль', pack.bullet_deviation,
	                                       v_l.min_value, v_l.max_value) || '; ';
	        end if;
	    elsif v_bt_ok and not v_bt.requires_bullet_deviation
	          and pack.bullet_deviation is not null then
	        errors := errors || format(const_error('FORBIDDEN_FIELD'), 'Дальность сноса пуль') || '; ';
	    end if;
	
	    return nullif(errors, '');
	end;
	$func$;
commit;
end $$;