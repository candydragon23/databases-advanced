-- Информационная схема
select table_name as object_name, 'Таблица' as object_type
from information_schema.tables
where table_schema = 'public'

union all -- Объединение результатов select

select sequence_name as object_name, 'Последовательность' as object_type
from information_schema.sequences
where sequence_schema = 'public'

union all

select constraint_name as object_name, 'Связь' as object_type 
from information_schema.table_constraints
where constraint_schema = 'public'