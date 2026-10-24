-- Обновление данных в таблице оборудование
update equipment set eq_name = 'ВР' where equipment_id = 1 or equipment_id = 3 or equipment_id = 4 or equipment_id = 5;
update equipment set eq_name = 'ДМК' where equipment_id = 2 or equipment_id = 6 or equipment_id = 7 or equipment_id = 8;

-- Вывод параметров с ошибками
with raw_data as (
    -- Объединение параметров с расшифровками типов и оборудования
    select 
        p.pack_id,
        pt.parameter as param_name,
        p.value,
        e.eq_name as equipment_code
    from parameters p
    join parameter_types pt on p.type_id = pt.type_id
    join equipment e on p.equipment_id = e.equipment_id
),
pivoted as (
    -- Группировка
    select 
        pack_id,
        max(equipment_code) as equipment_code, 
        max(case when param_name = 'Температура' then value end) as temperature,
        max(case when param_name = 'Давление' then value end) as pressure,
        max(case when param_name = 'Высота' then value end) as height,
        max(case when param_name = 'Направление ветра' then value end) as wind_direction,
        max(case when param_name = 'Скорость ветра' then value end) as wind_speed,
        max(case when param_name = 'Дальность сноса пуль' then value end) as bullet_deviation
    from raw_data
    group by pack_id
),
validated as (
    -- Вызов функции валидации
    select 
        pack_id,
        equipment_code,
        height,
        temperature,
        pressure,
        wind_direction,
        wind_speed,
        bullet_deviation,
        validate_parameter_pack(
            row(
                pack_id, 
                equipment_code, 
                height, 
                temperature, 
                pressure, 
                wind_direction, 
                wind_speed, 
                bullet_deviation
            )::param_list
        ) as error_description
    from pivoted
),
flagged as (
    -- Флаг ошибки
    select 
        *,
        (error_description is not null) as has_error,
        count(*) over (partition by (error_description is not null)) as group_count,
        row_number() over (partition by (error_description is not null) order by pack_id) as rn
    from validated
)
-- Вывод данных
select 
    pack_id as "N",
    equipment_code as "Тип оборудования",
    height as "Высота метеопоста",
    temperature as "Температура",
    pressure as "Давление",
    wind_direction as "Направление ветра",
    wind_speed as "Скорость ветра",
    bullet_deviation as "Дальность сноса пуль",
    has_error as "Флаг: Есть ошибка",
    error_description as "Описание ошибки"
from flagged
order by 
    has_error desc, 
    pack_id;