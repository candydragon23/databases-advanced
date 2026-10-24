-- Вывод лучших стрелков
with user_base as (
    select 
        user_id, 
        name as user_name 
    from users
),
param_data as (
    -- Объединение параметров с типами, оборудованием и справочником ограничений
    select 
        p.user_id,
        pt.parameter as param_name,
        p.value,
        upper(e.eq_name) as equipment_code,
        l.is_integer,
        l.min_value,
        l.max_value
    from parameters p
    join parameter_types pt on pt.type_id = p.type_id
    join equipment e on e.equipment_id = p.equipment_id
    left join const_param_limits l on l.param_name = case 
        when pt.parameter = 'Высота' then 'Высота метеопоста' 
        else pt.parameter 
    end
),
param_checks as (
    -- Определение ошибок в записи параметра
    select 
        user_id,
        case
            when value < min_value or value > max_value then 'OUT_OF_RANGE'
            when is_integer and value <> trunc(value) then 'NOT_INTEGER'
            when equipment_code = 'ДМК' and param_name = 'Дальность сноса пуль' then 'FORBIDDEN_FOR_DMK'
            when equipment_code = 'ВР' and param_name = 'Скорость ветра' then 'FORBIDDEN_FOR_VR'
            else null
        end as error_type
    from param_data
),
user_stats as (
    -- Группировка
    select 
        u.user_id,
        u.user_name,
        count(c.error_type) as error_count 
    from user_base u
    inner join param_checks c on c.user_id = u.user_id 
    group by u.user_id, u.user_name
),
ranked_stats as (
    -- Ранжирование пользователей
    select 
        user_id,
        user_name,
        error_count,
        rank() over (order by error_count asc) as rank_position
    from user_stats
)
-- Итоговый результат
select 
    rank_position as "Место",
    user_id as "Код пользователя",
    user_name as "ФИО",
    error_count as "Количество ошибок",
    case 
        when error_count = 0 then 'Лучший стрелок'
        else 'Есть ошибки'
    end as "Статус"
from ranked_stats
order by 
    rank_position asc, 
    user_id asc;