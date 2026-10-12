do $$
begin
	-- Удаление таблиц
	drop table if exists users cascade;
	drop table if exists ranks cascade;
	drop table if exists equipment cascade;
	drop table if exists packs cascade;
	drop table if exists parameters cascade;
	drop table if exists measurement_types cascade;
	drop table if exists parameter_types cascade;
	drop table if exists virtual_temp cascade;
	
	-- Удаление последовательностей
	drop sequence if exists seq_users cascade;
	drop sequence if exists seq_ranks cascade;
	drop sequence if exists seq_equipment cascade;
	drop sequence if exists seq_measurement_types cascade;
	drop sequence if exists seq_parameter_types cascade;
	drop sequence if exists seq_parameters cascade;
	drop sequence if exists seq_packs cascade;
	drop sequence if exists seq_virtual_temp cascade;
		
	-- Создание счетчиков
	create sequence seq_users;
	create sequence seq_ranks;
	create sequence seq_equipment;
	create sequence seq_measurement_types;
	create sequence seq_parameter_types;
	create sequence seq_parameters;
	create sequence seq_packs;
	create sequence seq_virtual_temp;

	-- Создание таблиц
	create table users(
	user_id int primary key default nextval('seq_users'),
	name text not null,
	rank_id int not null
	);
	comment on table users is 'Пользователи';
	comment on column users.user_id is 'Уникальный код';
	comment on column users.name is 'ФИО';
	comment on column users.rank_id is 'Код должности';
		
	create table ranks(
	rank_id int primary key default nextval('seq_ranks'),
	rank text not null
	);
	comment on table ranks is 'Должности';
	comment on column ranks.rank_id is 'Уникальный код';
	comment on column ranks.rank is 'Наименование должности';
		
	create table parameters(
	param_id int primary key default nextval('seq_parameters'),
	pack_id int not null,
	type_id int not null,
	value decimal not null,
	user_id int not null,
	equipment_id int not null
	);
	comment on table parameters is 'Измерение параметров';
	comment on column parameters.param_id is 'Уникальный код';
	comment on column parameters.pack_id is 'Код пачки';
	comment on column parameters.type_id is 'Код параметра';
	comment on column parameters.value is 'Значение';
	comment on column parameters.user_id is 'Код пользователя';
	comment on column parameters.equipment_id is 'Код оборудования';
		
	create table equipment(
	equipment_id int primary key default nextval('seq_equipment'),
	eq_name text not null
	);
	comment on table equipment is 'Оборудование';
	comment on column equipment.equipment_id is 'Уникальный код';
	comment on column equipment.eq_name is 'Название оборудования';
	
	create table packs(
	pack_id int primary key default nextval('seq_packs'),
	dat date not null
	);
	comment on table packs is 'Пачки';
	comment on column packs.pack_id is 'Уникальный код';
	comment on column packs.dat is 'Дата измерения';

	create table measurement_types(
	type_id int primary key default nextval('seq_measurement_types'),
	type text not null,
	min_value decimal not null,
	max_value decimal not null
	);
	comment on table measurement_types is 'Единицы измерений';
	comment on column measurement_types.type_id is 'Уникальный код';
	comment on column measurement_types.type is 'Единица измерения';
	comment on column measurement_types.min_value is 'Нижняя граница';
	comment on column measurement_types.max_value is 'Верхняя граница';
		
	create table parameter_types(
	type_id int primary key default nextval('seq_parameter_types'),
	parameter text not null,
	measurement_id int not null
	);
	comment on table parameter_types is 'Список параметров';
	comment on column parameter_types.type_id is 'Уникальный код';
	comment on column parameter_types.parameter is 'Название параметра';
	comment on column parameter_types.measurement_id is 'Код единицы измерения';
	
	create table virtual_temp(
	id int primary key default nextval('seq_virtual_temp'),
	"$t_{0}$" text not null,
	"Ниже 0" float not null,
	"0 - 5" float not null,
	"10 - 15" float not null,
	"20" float not null,
	"25" float not null,
	"30" float not null,
	"40" float not null
	);
	commit;
	
	-- Заполнение данными
	-- ---------- ranks ----------
	insert into ranks(rank) values
	('мл. Лейтенант'),
	('Лейтенант'),
	('ст. Лейтенант'),
	('Капитан'),
	('Майор'),
	('Подполковник'),
	('Полковник'),
	('Генерал-майор'),
	('Генерал-лейтенант'),
	('Генерал-полковник'),
	('Маршал');
		
	-- ---------- users ----------
	insert into users(name, rank_id) values
	('Иванов Иван Иванович', 1),
	('Иванов Иван Иванович', 2),
	('Иванов Иван Иванович', 3),
	('Кузнецов Алексей Владимирович', 4),
	('Смирнов Дмитрий Андреевич',   5),
	('Волков Максим Игоревич',      6),
	('Морозов Артём Олегович',      7),
	('Новиков Егор Дмитриевич',     1),
	('Фёдоров Никита Павлович',     2),
	('Егоров Кирилл Романович',     3),
	('Орлов Даниил Алексеевич',     4),
	('Захаров Матвей Сергеевич',    5),
	('Белов Лев Тимофеевич',        6),
	('Комаров Глеб Маркович',       7),
	('Лебедев Савелий Иванович',    1),
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
	('Компас Т-6'),
	('Барометр Б-1'),
	('Анемометр А-3'),
	('Барометр Б-4'),
	('Дальномер Д-5'),
	('Термометр Т-6'),
	('Гигрометр Г-7'),
	('Компас К-8');
	
	-- ---------- packs ----------
	insert into packs(dat) values
	('2026-04-28'),
	('2026-04-29'),
	('2026-04-30'),
	('2026-05-01'),
	('2026-05-02'),
	('2026-05-03'),
	('2026-05-04'),
	('2026-05-05'),
	('2026-05-06'),
	('2026-05-07'),
	('2026-05-08'),
	('2026-05-09'),
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
	(1,  4, 45,   1,  3),
	(1,  5, 5.2,  1,  3),
	
	(2,  1, 15.0, 2,  1),
	(2,  2, 750,  2,  4),
	(2,  4, 59,   2,  3),
	(2,  5, 6.1,  2,  3),
	
	(3,  1, 18.3, 3,  1),
	(3,  2, 755,  3,  4),
	(3,  4, 59,  3,  3),
	(3,  5, 4.8,  3,  3),
		
	(4,  1, 20.1, 4,  1),
	(4,  3, 120,  4,  5),
	(4,  4, 59,  4,  3),
	(4,  5, 7.4,  4,  3),
		
	(5,  1, 22.5, 5,  1),
	(5,  2, 760,  5,  4),
	(5,  4, 59,  5,  3),
	(5,  5, 8.0,  5,  3),
		
	(6,  1, 19.8, 6,  1),
	(6,  2, 748,  6,  4),
	(6,  4, 59,  6,  3),
	(6,  5, 9.3,  6,  3),
		
	(7,  1, 16.4, 7,  1),
	(7,  2, 742,  7,  4),
	(7,  4, 59,  7,  3),
	(7,  5, 3.6,  7,  3),
		
	(8,  1, 14.2, 8,  1),
	(8,  3, 150,  8,  5),
	(8,  4, 30,   8,  3),
	(8,  5, 2.9,  8,  3),
		
	(9,  1, 10.7, 9,  1),
	(9,  2, 738,  9,  4),
	(9,  4, 59,   9,  3),
	(9,  5, 1.5,  9,  3),
	
	(10, 1, 8.9,  10, 1),
	(10, 2, 735,  10, 4),
	(10, 4, 59,  10, 3),
	(10, 5, 0.8,  10, 3),
	
	(11, 1, 6.2,  11, 1),
	(11, 2, 730,  11, 4),
	(11, 6, 12.4, 11, 2),
	(11, 5, 1.1,  11, 3),
		
	(12, 1, 4.1,  12, 1),
	(12, 2, 728,  12, 4),
	(12, 3, 200,  12, 5),
	(12, 6, 18.7, 12, 2),
	-- pack 13
	(13, 1, 12.5, 16, 1),
	(13, 2, 745,  16, 4),
	(13, 4, 59,   16, 3),
	(13, 5, 2.3,  16, 3),
	-- pack 14
	(14, 1, 14.8, 17, 1),
	(14, 2, 752,  17, 4),
	(14, 4, 59,  17, 3),
	(14, 5, 3.1,  17, 3),
	-- pack 15
	(15, 1, 17.2, 18, 1),
	(15, 2, 758,  18, 4),
	(15, 3, 130,  18, 5),
	(15, 4, 59,  18, 3),
	(15, 5, 4.5,  18, 3),
	-- pack 16
	(16, 1, 19.6, 19, 1),
	(16, 2, 762,  19, 4),
	(16, 4, 59,  19, 3),
	(16, 5, 5.7,  19, 3),
	-- pack 17
	(17, 1, 21.3, 20, 1),
	(17, 2, 755,  20, 4),
	(17, 3, 145,  20, 5),
	(17, 4, 59,  20, 3),
	(17, 5, 6.8,  20, 3),
	-- pack 18
	(18, 1, 18.7, 21, 1),
	(18, 2, 748,  21, 4),
	(18, 4, 59,  21, 3),
	(18, 5, 7.9,  21, 3),
	-- pack 19
	(19, 1, 15.1, 22, 1),
	(19, 2, 740,  22, 4),
	(19, 4, 59,  22, 3),
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
	(21, 4, 59,   24, 3),
	(21, 5, 1.3,  24, 3),
	-- использование нового оборудования (6–8) и оставшихся пользователей (25–27)
	(21, 3, 175,  25, 6),
	(20, 3, 155,  26, 6),
	(19, 6, 11.5, 27, 7),
	(18, 6, 13.9, 27, 8);

	-- -------- measurement types ---------
	insert into measurement_types(type, min_value, max_value) values('C', -58, 58),
	('F', -72.4, 136.4),
	('мм. рт. ст.', 500, 900),
	('Метров', -9999, 9999),
	('Футов', -9999, 9999),
	('М/с', 0, 15),
	('Миль/ч', 0, 33.6),
	('Градусов', 0, 59),
	('Метров (дальность)', 0, 150),
	('Футов (дальность)', 0, 492.1);

	-- -------- parameter types ----------
	insert into parameter_types(parameter, measurement_id) values('Температура', 1),
	('Давление', 3),
	('Высота', 4),
	('Направление ветра', 8),
	('Скорость ветра', 6),
	('Дальность сноса пуль', 9);

	-- -------- virtual temp ---------
	insert into virtual_temp("$t_{0}$", "Ниже 0", "0 - 5", "10 - 15", "20", "25", "30", "40") values ('$ΔТ_{V}$', 0, 0.5, 1, 1.5, 2, 3.5, 4.5);
	commit;
	
	-- Добавление связей между таблицами
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
end $$;