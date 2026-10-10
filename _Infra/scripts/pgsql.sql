-- Создание автоинкрементов id для таблиц
begin;
create sequence if not exists seq_users;
select setval('seq_users',(select max(user_id) from users));
alter table users
alter column user_id set default nextval('seq_users');
alter sequence
seq_users owned by users.user_id;

create sequence if not exists seq_ranks;
select setval('seq_ranks',(select max(rank_id) from ranks));
alter table ranks
alter column rank_id set default nextval('seq_ranks');
alter sequence
seq_ranks owned by ranks.rank_id;

create sequence if not exists seq_equipment;
select setval('seq_equipment',(select max(equipment_id) from equipment));
alter table equipment
alter column equipment_id set default nextval('seq_equipment');
alter sequence
seq_equipment owned by equipment.equipment_id;

create sequence if not exists seq_measurement_types;
select setval('seq_measurement_types',(select max(type_id) from measurement_types));
alter table measurement_types
alter column type_id set default nextval('seq_measurement_types');
alter sequence
seq_measurement_types owned by measurement_types.type_id;

create sequence if not exists seq_parameter_types;
select setval('seq_parameter_types',(select max(type_id) from parameter_types));
alter table parameter_types
alter column type_id set default nextval('seq_parameter_types');
alter sequence
seq_parameter_types owned by parameter_types.type_id;

create sequence if not exists seq_parameters;
select setval('seq_parameters',(select max(param_id) from parameters));
alter table parameters
alter column param_id set default nextval('seq_parameters');
alter sequence
seq_parameters owned by parameters.param_id;

create sequence if not exists seq_packs;
select setval('seq_packs',(select max(pack_id) from packs));
alter table packs
alter column pack_id set default nextval('seq_packs');
alter sequence
seq_packs owned by packs.pack_id;
commit;

-- Заполнение данными
begin;
-- ---------- ranks ----------
insert into ranks(rank) values
('Генерал-майор'),
('Генерал-лейтенант'),
('Генерал-полковник'),
('Маршал');

-- ---------- users ----------
insert into users(name, rank_id) values
('Соколов Андрей Петрович',       8),
('Павлов Сергей Николаевич',      9),
('Семёнов Виктор Александрович', 10),
('Голубев Олег Викторович',      11),
('Виноградов Иван Сергеевич',     1),
('Богданов Пётр Алексеевич',      2),
('Воробьёв Николай Иванович',     3),
('Фролов Александр Дмитриевич',   4),
('Михайлов Роман Юрьевич',        5),
('Беляев Артём Константинович',   6),
('Тарасов Денис Владимирович',    7),
('Белоусов Максим Игоревич',      1);

-- ---------- equipment ----------
insert into equipment(eq_name) values
('Термометр Т-6'),
('Гигрометр Г-7'),
('Компас К-8');

-- ---------- packs ----------
insert into packs(dat) values
('2026-05-10'),
('2026-05-11'),
('2026-05-12'),
('2026-05-13'),
('2026-05-14'),
('2026-05-15'),
('2026-05-16'),
('2026-05-17'),
('2026-05-18');

insert into parameters(pack_id, type_id, value, user_id, equipment_id) values
-- pack 13
(13, 1, 12.5, 16, 1),
(13, 2, 745,  16, 4),
(13, 4, 60,   16, 3),
(13, 5, 2.3,  16, 3),
-- pack 14
(14, 1, 14.8, 17, 1),
(14, 2, 752,  17, 4),
(14, 4, 105,  17, 3),
(14, 5, 3.1,  17, 3),
-- pack 15
(15, 1, 17.2, 18, 1),
(15, 2, 758,  18, 4),
(15, 3, 130,  18, 5),
(15, 4, 150,  18, 3),
(15, 5, 4.5,  18, 3),
-- pack 16
(16, 1, 19.6, 19, 1),
(16, 2, 762,  19, 4),
(16, 4, 195,  19, 3),
(16, 5, 5.7,  19, 3),
-- pack 17
(17, 1, 21.3, 20, 1),
(17, 2, 755,  20, 4),
(17, 3, 145,  20, 5),
(17, 4, 240,  20, 3),
(17, 5, 6.8,  20, 3),
-- pack 18
(18, 1, 18.7, 21, 1),
(18, 2, 748,  21, 4),
(18, 4, 285,  21, 3),
(18, 5, 7.9,  21, 3),
-- pack 19
(19, 1, 15.1, 22, 1),
(19, 2, 740,  22, 4),
(19, 4, 330,  22, 3),
(19, 5, 4.2,  22, 3),
-- pack 20
(20, 1, 11.4, 23, 1),
(20, 2, 736,  23, 4),
(20, 3, 160,  23, 5),
(20, 4, 45,   23, 3),
(20, 5, 2.1,  23, 3),
-- pack 21
(21, 1,  9.8, 24, 1),
(21, 2, 732,  24, 4),
(21, 6, 14.2, 24, 2),
(21, 4, 90,   24, 3),
(21, 5, 1.3,  24, 3),
-- использование нового оборудования (6–8) и оставшихся пользователей (25–27)
(21, 3, 175,  25, 6),
(20, 3, 155,  26, 6),
(19, 6, 11.5, 27, 7),
(18, 6, 13.9, 27, 8),
commit;

-- Создание первичных ключей
begin;
alter table ranks
add constraint pk_ranks
primary key (rank_id);

alter table users
add constraint pk_users
primary key (user_id);

alter table equipment
add constraint pk_equipment
primary key (equipment_id);

alter table packs
add constraint pk_packs
primary key (pack_id);

alter table parameters
add constraint pk_parameters
primary key (param_id);

alter table measurement_types
add constraint pk_measurement_types
primary key (type_id);

alter table parameter_types
add constraint pk_parameter_types
primary key (type_id);
commit;

-- Добавление связей между таблицами
begin;
alter table users
add constraint fk_users_ranks
foreign key (rank_id) references ranks(rank_id);

alter table parameters
add constraint fk_parameters_packs
foreign key (pack_id) references packs(pack_id);

alter table parameters
add constraint fk_parameters_parameter_types
foreign key (type_id) references parameter_types(type_id);

alter table parameter_types
add constraint fk_parameter_types_measurement_types
foreign key (measurement_id) references measurement_types(type_id);

alter table parameters
add constraint fk_parameters_users
foreign key (user_id) references users(user_id);

alter table parameters
add constraint fk_parameters_equipment
foreign key (equipment_id) references equipment(equipment_id);
commit;

-- Добавление столбцов минимальных и максимальных значений в таблицу параметры
begin;
alter table parameters
add column if not exists min_value decimal,
add column if not exists max_value decimal;

update parameters
set min_value = measurement_types.min_value, max_value = measurement_types.max_value
from measurement_types
join parameter_types on measurement_types.type_id = parameter_types.measurement_id
where parameter_types.type_id = parameters.type_id;
commit;

-- Исправление данных выходящих за границы
begin;
update parameters
set value = 59
where type_id = 4 and value > 59;
commit;

-- Добавление проверки значений на диапазонах
begin;
alter table parameters
add constraint chk_values
check (value >= min_value and value <= max_value);
commit;

-- Проверка на null
begin;
alter table users
alter column user_id set not null,
alter column name set not null,
alter column rank_id set not null;

alter table ranks
alter column rank_id set not null,
alter column rank set not null;

alter table parameters
alter column param_id set not null,
alter column pack_id set not null,
alter column type_id set not null,
alter column value set not null,
alter column user_id set not null,
alter column equipment_id set not null;

alter table equipment
alter column equipment_id set not null,
alter column eq_name set not null;

alter table packs
alter column pack_id set not null,
alter column dat set not null;

alter table measurement_types
alter column type_id set not null,
alter column type set not null;

alter table parameter_types
alter column type_id set not null,
alter column parameter set not null,
alter column measurement_id set not null;
commit;

-- Добавление таблицы расчета температуры
begin;
drop table if exists virtual_temp;
create table virtual_temp(
id int primary key,
"$t_{0}$" text,
"Ниже 0" float,
"0 - 5" float,
"10 - 15" float,
"20" float,
"25" float,
"30" float,
"40" float
);

insert into virtual_temp(id, "$t_{0}$", "Ниже 0", "0 - 5", "10 - 15", "20", "25", "30", "40") values(1, '$ΔТ_{V}$', 0, 0.5, 1, 1.5, 2, 3.5, 4.5);
commit;