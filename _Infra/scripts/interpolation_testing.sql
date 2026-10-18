do $$
begin
-- Удаление таблицы для тестовых ответов
drop table if exists testing_interpolation cascade;

-- Удаления счетчика таблицы тестовых ответов
drop sequence if exists seq_testing_inter cascade;

-- Создание счетчика для таблицы тестовых ответов
create sequence seq_testing_inter;

-- Создание таблицы для тестовых ответов
create table testing_interpolation (
test_id int primary key default nextval('seq_testing_inter'),
actual numeric,
expected numeric
);

-- Тесты
insert into testing_interpolation(actual, expected)
select trim_scale(calculate_interpolation(22, row(20,1.5,25,2.0)::var_interpolation))
       as actual,
       1.7::numeric as expected;

insert into testing_interpolation(actual, expected)
select trim_scale(calculate_interpolation(22, row(22,1.7,22,1.7)::var_interpolation))
       as actual,
       1.7::numeric as expected;

insert into testing_interpolation(actual, expected)
select trim_scale(calculate_interpolation(12, row(10,1.0,15,1.0)::var_interpolation))
       as actual,
       1.0::numeric as expected;


insert into testing_interpolation(actual, expected)
select trim_scale(calculate_interpolation(20, row(20,1.5,25,2.0)::var_interpolation))
       as actual,
       1.5::numeric as expected;

insert into testing_interpolation(actual, expected)
select trim_scale(calculate_interpolation(25, row(20,1.5,25,2.0)::var_interpolation))
       as actual,
       2.0::numeric as expected;
end $$;

select * from testing_interpolation;