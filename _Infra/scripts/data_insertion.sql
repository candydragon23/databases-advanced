-- Добавление границ измерений в таблицу measurement_types
alter table measurement_types
add column min_value decimal,
add column max_value decimal;

comment on column measurement_types.min_value is 'Нижняя граница';
comment on column measurement_types.max_value is 'Верхняя граница';

update measurement_types set type = 'C', min_value = -58, max_value = 58 where type_id = 1;
update measurement_types set type = 'F', min_value = -72.4, max_value = 136.4 where type_id = 2;
update measurement_types set type = 'мм. рт. ст.', min_value = 500, max_value = 900 where type_id = 3;
update measurement_types set type = 'Метров (высота)', min_value = -9999, max_value = 9999 where type_id = 4;
update measurement_types set type = 'Футов (высота)', min_value = -9999, max_value = 9999 where type_id = 5;
update measurement_types set type = 'М/с', min_value = 0, max_value = 15 where type_id = 6;
update measurement_types set type = 'Миль/ч', min_value = 0, max_value = 33.6 where type_id = 7;
update measurement_types set type = 'Градусов', min_value = 0, max_value = 59 where type_id = 8;

insert into measurement_types(type_id, type, min_value, max_value) values (9, 'Метров (дальность)', 0, 150),
(10, 'Футов (дальность)', 0, 492.1);

-- Обновление данных дальности сноса пуль в таблице parameter_types
update parameter_types set parameter = 'Дальность сноса пуль', measurement_id = 9 where measurement_id = 6;

-- ---------- ranks ----------
insert into ranks(rank_id, rank) values
(4, 'Капитан'),
(5, 'Майор'),
(6, 'Подполковник'),
(7, 'Полковник');

-- ---------- users ----------
insert into users(user_id, name, rank_id) values
(4,  'Кузнецов Алексей Владимирович', 4),
(5,  'Смирнов Дмитрий Андреевич',   5),
(6,  'Волков Максим Игоревич',      6),
(7,  'Морозов Артём Олегович',      7),
(8,  'Новиков Егор Дмитриевич',     1),
(9,  'Фёдоров Никита Павлович',     2),
(10, 'Егоров Кирилл Романович',     3),
(11, 'Орлов Даниил Алексеевич',     4),
(12, 'Захаров Матвей Сергеевич',    5),
(13, 'Белов Лев Тимофеевич',        6),
(14, 'Комаров Глеб Маркович',       7),
(15, 'Лебедев Савелий Иванович',    1);

-- ---------- equipment ----------
insert into equipment(equipment_id, eq_name) values
(3, 'Анемометр А-3'),
(4, 'Барометр Б-4'),
(5, 'Дальномер Д-5');

-- ---------- packs ----------
insert into packs(pack_id, dat) values
(4,  '2026-05-01'),
(5,  '2026-05-02'),
(6,  '2026-05-03'),
(7,  '2026-05-04'),
(8,  '2026-05-05'),
(9,  '2026-05-06'),
(10, '2026-05-07'),
(11, '2026-05-08'),
(12, '2026-05-09');

-- ---------- parameters ----------
-- param_id, pack_id, type_id, value, user_id, equipment_id
insert into parameters(param_id, pack_id, type_id, value, user_id, equipment_id) values
(3,  1,  4, 45,   1,  3),
(4,  1,  5, 5.2,  1,  3),

(5,  2,  1, 15.0, 2,  1),
(6,  2,  2, 750,  2,  4),
(7,  2,  4, 90,   2,  3),
(8,  2,  5, 6.1,  2,  3),

(9,  3,  1, 18.3, 3,  1),
(10, 3,  2, 755,  3,  4),
(11, 3,  4, 135,  3,  3),
(12, 3,  5, 4.8,  3,  3),

(13, 4,  1, 20.1, 4,  1),
(14, 4,  3, 120,  4,  5),
(15, 4,  4, 180,  4,  3),
(16, 4,  5, 7.4,  4,  3),

(17, 5,  1, 22.5, 5,  1),
(18, 5,  2, 760,  5,  4),
(19, 5,  4, 225,  5,  3),
(20, 5,  5, 8.0,  5,  3),

(21, 6,  1, 19.8, 6,  1),
(22, 6,  2, 748,  6,  4),
(23, 6,  4, 270,  6,  3),
(24, 6,  5, 9.3,  6,  3),

(25, 7,  1, 16.4, 7,  1),
(26, 7,  2, 742,  7,  4),
(27, 7,  4, 315,  7,  3),
(28, 7,  5, 3.6,  7,  3),

(29, 8,  1, 14.2, 8,  1),
(30, 8,  3, 150,  8,  5),
(31, 8,  4, 30,   8,  3),
(32, 8,  5, 2.9,  8,  3),

(33, 9,  1, 10.7, 9,  1),
(34, 9,  2, 738,  9,  4),
(35, 9,  4, 75,   9,  3),
(36, 9,  5, 1.5,  9,  3),

(37, 10, 1, 8.9,  10, 1),
(38, 10, 2, 735,  10, 4),
(39, 10, 4, 120,  10, 3),
(40, 10, 5, 0.8,  10, 3),

(41, 11, 1, 6.2,  11, 1),
(42, 11, 2, 730,  11, 4),
(43, 11, 6, 12.4, 11, 2),
(44, 11, 5, 1.1,  11, 3),

(45, 12, 1, 4.1,  12, 1),
(46, 12, 2, 728,  12, 4),
(47, 12, 3, 200,  12, 5),
(48, 12, 6, 18.7, 12, 2);