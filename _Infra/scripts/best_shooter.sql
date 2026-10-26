with validated_packs as (
    -- Получение результата работы функции
    select *
    from get_parameters_with_errors()
),
pack_owner as (
    -- Связь пачки с пользователем
    select distinct pack_id, user_id
    from parameters
),
user_stats as (
    -- Подсчет количества ошибок
    select 
        u.user_id,
        u.name as user_name,
        sum(
            case 
                when v."Флаг: Есть ошибка" then 
                    length(v."Описание ошибки") - length(replace(v."Описание ошибки", ';', ''))
                else 0 
            end
        )::bigint as error_count
    from users u
    inner join pack_owner po on po.user_id = u.user_id
    inner join validated_packs v on v."N" = po.pack_id
    group by u.user_id, u.name
),
ranked_stats as (
    -- Ранжировка пользователей
    select 
        user_id,
        user_name,
        error_count,
        rank() over (order by error_count asc) as rank_position
    from user_stats
)
-- Итоговый вывод
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