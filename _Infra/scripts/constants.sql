do $$
begin
	-- Таблицы констант
	drop table if exists const_errors cascade;
	drop table if exists const_validation cascade;
	drop table if exists const_bulletin_types cascade;
	drop table if exists const_param_limits cascade;
	drop sequence if exists seq_const_errors cascade;
	
	create sequence seq_const_errors;
	
	create table const_errors(
	    error_id  int primary key default nextval('seq_const_errors'),
	    code      text not null unique,
	    message   text not null
	);
	comment on table const_errors is 'Справочник сообщений об ошибках';
	comment on column const_errors.error_id is 'Уникальный код';
	comment on column const_errors.message is 'Сообщение ошибки';
	
	insert into const_errors(code, message) values
	('EMPTY_LIST', 'Запись метеобюллетеня не задана'),
	('INVALID_PACK', 'Некорректный код пачки: %s'),
	('INVALID_TYPE', 'Некорректный тип метеобюллетеня: %s'),
	('NULL_VALUE', 'Не заполнено обязательное поле "%s"'),
	('NOT_INTEGER', 'Поле "%s" должно быть целым числом, получено: %s'),
	('INVALID_SCALE', 'Поле "%s" должно иметь не более %s знаков после запятой, получено: %s'),
	('VALUE_OUT_OF_RANGE', 'Значение поля "%s" (%s) вне диапазона [%s, %s]'),
	('REQUIRED_FIELD', 'Поле "%s" обязательно для выбранного типа бюллетеня'),
	('FORBIDDEN_FIELD', 'Поле "%s" не должно заполняться для выбранного типа бюллетеня');
	
	create table const_validation(
	    name  text primary key,
	    value text not null
	);
	comment on table const_validation is 'Справочник констант для валидации';
	comment on column const_validation.name is 'Название константы';
	comment on column const_validation.value is 'Значение константы';
	
	insert into const_validation(name, value) values
	('SEPARATOR', E'\n');
	
	-- Варианты метеобюллетеня
	create table const_bulletin_types(
	    code text primary key,
	    name text not null,
	    requires_wind_speed boolean not null default false,
	    requires_bullet_deviation boolean not null default false
	);
	comment on table const_bulletin_types is 'Типы метеобюллетеней и требования к полям';
	comment on column const_bulletin_types.code is 'Уникальный код ошибки';
	comment on column const_bulletin_types.name is 'Название ошибки';
	comment on column const_bulletin_types.requires_wind_speed is 'Флаг требуется скорость ветра';
	comment on column const_bulletin_types.requires_bullet_deviation is 'Флаг требуется дальность сноса пуль';
	
	insert into const_bulletin_types(code, name, requires_wind_speed, requires_bullet_deviation) values
	('ДМК', 'С использованием ДМК', true, false),
	('ВР', 'С использованием ВР', false, true),
	('ПОЛНЫЙ', 'Полный (ДМК + ВР)', true, true);
	
	-- Допустимые значения параметров
	create table const_param_limits(
	    param_name text primary key,
	    is_integer boolean not null,
	    decimals int,
	    min_value decimal not null,
	    max_value decimal not null
	);
	comment on table const_param_limits is 'Диапазоны и формат числовых параметров';
	comment on column const_param_limits.param_name is 'Название параметра';
	comment on column const_param_limits.is_integer is 'Является ли дробным или целым';
	comment on column const_param_limits.decimals is 'Макс. знаков после запятой';
	comment on column const_param_limits.min_value is 'Нижняя граница';
	comment on column const_param_limits.max_value is 'Верхняя граница';
	
	insert into const_param_limits(param_name, is_integer, decimals, min_value, max_value) values
	('Высота метеопоста', true, 0, -9999, 9999), 
	('Температура', false, 1, -58, 58),
	('Давление', true, 0, 500, 900),
	('Направление ветра', true, 0, 0, 59),
	('Скорость ветра', true, 0, 0, 15),
	('Дальность сноса пуль', true, 0, 0, 150);
	
	-- Функции доступа
	drop function if exists const_error(text);
	drop function if exists const_value(text);
	
	create function const_error(p_code text)
	returns text
	language plpgsql stable
	as $func$
	declare
	    v_message text;
	begin
	    select message into v_message
	      from const_errors
	     where code = p_code;
	
	    if v_message is null then
	        raise exception 'Код ошибки "%" не найден в таблице const_errors', p_code
	            using hint = 'Добавьте запись в const_errors или проверьте код ошибки';
	    end if;
	
	    return v_message;
	end;
	$func$;
	
	create function const_value(p_name text)
	returns text
	language sql stable
	as $func$
	select value from const_validation where name = p_name;
	$func$;
commit;
end $$;