-- Обновление данных в таблице оборудование
update equipment set eq_name = 'ВР' where equipment_id = 1 or equipment_id = 3 or equipment_id = 4 or equipment_id = 5;
update equipment set eq_name = 'ДМК' where equipment_id = 2 or equipment_id = 6 or equipment_id = 7 or equipment_id = 8;

drop function if exists get_parameters_with_errors();

create function get_parameters_with_errors()
returns table (
    "N"                     int,
    "Тип оборудования"      text,
    "Высота метеопоста"     decimal,
    "Температура"           decimal,
    "Давление"              decimal,
    "Направление ветра"     decimal,
    "Скорость ветра"        decimal,
    "Дальность сноса пуль"  decimal,
    "Флаг: Есть ошибка"     boolean,
    "Описание ошибки"       text
)
language plpgsql
stable
as $func$
begin
    return query
    with raw_data as (
        select
            p.pack_id,
            pt.parameter as param_name,
            p.value,
            e.eq_name    as equipment_code
        from parameters p
        join parameter_types pt on p.type_id     = pt.type_id
        join equipment       e  on p.equipment_id = e.equipment_id
    ),
    pivoted as (
        select
            rd.pack_id,
            max(rd.equipment_code) as equipment_code,
            max(case when rd.param_name = 'Температура'          then rd.value end) as temperature,
            max(case when rd.param_name = 'Давление'             then rd.value end) as pressure,
            -- допускаем оба варианта имени параметра
            max(case when rd.param_name in ('Высота', 'Высота метеопоста')
                     then rd.value end)                                          as height,
            max(case when rd.param_name = 'Направление ветра'    then rd.value end) as wind_direction,
            max(case when rd.param_name = 'Скорость ветра'       then rd.value end) as wind_speed,
            max(case when rd.param_name = 'Дальность сноса пуль' then rd.value end) as bullet_deviation
        from raw_data rd
        group by rd.pack_id
    ),
    validated as (
        select
            pv.pack_id,
            pv.equipment_code,
            pv.height,
            pv.temperature,
            pv.pressure,
            pv.wind_direction,
            pv.wind_speed,
            pv.bullet_deviation,
            validate_parameter_pack(
                row(
                    pv.pack_id,
                    pv.equipment_code,
                    pv.height,
                    pv.temperature,
                    pv.pressure,
                    pv.wind_direction,
                    pv.wind_speed,
                    pv.bullet_deviation
                )::param_list
            ) as error_description
        from pivoted pv
    )
    select
        v.pack_id,
        v.equipment_code,
        v.height,
        v.temperature,
        v.pressure,
        v.wind_direction,
        v.wind_speed,
        v.bullet_deviation,
        (v.error_description is not null) as has_error,
        v.error_description
    from validated v
    order by (v.error_description is not null) desc, v.pack_id;
end;
$func$;

comment on function get_parameters_with_errors() is
    'Возвращает параметры пачек с результатом валидации';