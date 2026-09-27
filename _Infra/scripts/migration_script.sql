-- Удаление таблиц при перезапуске скрипта
drop table if exists measurement_types;
drop table if exists parameter_types;

-- Создание новых таблиц
create table measurement_types(
type_id int,
type text
);
comment on table measurement_types is 'Единицы измерений';
comment on column measurement_types.type_id is 'Уникальный код';
comment on column measurement_types.type is 'Единица измерения';

create table parameter_types(
type_id int,
parameter text,
measurement_id int
);
comment on table parameter_types is 'Список параметров';
comment on column parameter_types.type_id is 'Уникальный код';
comment on column parameter_types.parameter is 'Название параметра';
comment on column parameter_types.measurement_id is 'Код единицы измерения';

-- Вставка данных
insert into measurement_types(type_id, type) values(1, 'C'),
(2, 'F'),
(3, 'Паскаль'),
(4, 'Метров'),
(5, 'Футов'),
(6, 'М/с'),
(7, 'Миль/ч'),
(8, 'Градусов');

insert into parameter_types(type_id, parameter, measurement_id) values(1, 'Температура', 1),
(2, 'Давление', 3),
(3, 'Высота', 4),
(4, 'Направление ветра', 8),
(5, 'Скорость ветра', 6),
(6, 'Дальность сноса пуль', 4);

-- Изменение таблицы 'Параметры'
alter table parameters
-- Удаление ненужных столбцов
drop column if exists equipment_id,
drop column if exists height,
drop column if exists temperature,
drop column if exists pressure,
drop column if exists wind_direction,
drop column if exists wind_speed,
drop column if exists bullet_deviation,
-- Создание новых столбцов
add column if not exists pack_id int,
add column if not exists type_id int,
add column if not exists value decimal,
add column if not exists user_id int,
add column if not exists equipment_id int;
comment on column parameters.pack_id is 'Код пачки';
comment on column parameters.type_id is 'Код параметра';
comment on column parameters.value is 'Значение';
comment on column parameters.user_id is 'Код пользователя';
comment on column parameters.equipment_id is 'Код оборудования';

-- Добавление данных
delete from parameters;
insert into parameters(param_id, pack_id, type_id, value, user_id, equipment_id) values (1, 1, 1, 12, 1, 1),
(2, 2, 2, 750, 2, 2),
(3, 3, 1, 15, 3, 1);

-- Изменение таблицы 'Пачки'
alter table packs
drop column if exists user_id,
drop column if exists param_id;

-- Добавление данных
delete from packs;
insert into packs(pack_id, dat) values (1, '2026-04-28'),
(2, '2026-04-29'),
(3, '2026-04-30');

-- Изменение данных таблицы 'Сотрудники'
delete from users;
insert into users(user_id, name, rank_id) values (1, 'Иванов Иван Иванович', 1),
(2, 'Иванов Иван Иванович', 2),
(3, 'Иванов Иван Иванович', 3);

-- Создание запроса
select dat, parameters.pack_id, name, parameter, type, value from parameters
join packs on parameters.pack_id = packs.pack_id
join users on parameters.user_id = users.user_id
join parameter_types on parameters.type_id = parameter_types.type_id
join measurement_types on parameter_types.measurement_id = measurement_types.type_id
