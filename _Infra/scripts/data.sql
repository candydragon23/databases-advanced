drop table if exists users;
drop table if exists ranks;
drop table if exists parameters;
drop table if exists equipment;
drop table if exists packs;

create table users(
user_id int,
name text,
rank_id int
);

create table ranks(
rank_id int,
rank text
);

create table parameters(
param_id int,
equipment_id int,
height int,
temperature decimal(3, 1),
pressure int,
wind_direction int,
wind_speed int,
bullet_deviation int,
check (temperature between -58.0 and 58.0),
check (pressure between 500 and 900),
check (wind_direction between 0 and 59),
check (wind_speed between 0 and 15),
check (bullet_deviation between 0 and 150)
);

create table equipment(
equipment_id int,
eq_name text
);

create table packs(
pack_id int,
dat date,
user_id int,
param_id int
);

insert into users(user_id, name, rank_id) values (1, 'Иванов', 1);
insert into users(user_id, name, rank_id) values (2, 'Иванов', 2);
insert into users(user_id, name, rank_id) values (3, 'Иванов', 3);

insert into ranks(rank_id, rank) values (1, 'мл. Лейтенант');
insert into ranks(rank_id, rank) values (2, 'Лейтенант');
insert into ranks(rank_id, rank) values (3, 'ст. Лейтенант');

insert into equipment(equipment_id, eq_name) values (1, 'Оборудование 1');
insert into equipment(equipment_id, eq_name) values (2, 'Оборудование 2');

insert into parameters(param_id, equipment_id, height, temperature, pressure, wind_direction, wind_speed, bullet_deviation)
values (1, 1, 100, 1.4, 650, 32, 7, 45);
insert into parameters(param_id, equipment_id, height, temperature, pressure, wind_direction, wind_speed, bullet_deviation)
values (2, 2, 100, 15.0, 750, 0, 0, 0);

insert into packs(pack_id, dat, user_id, param_id) values (1, '2026-04-28', 1, 1);
insert into packs(pack_id, dat, user_id, param_id) values (2, '2026-04-29', 2, 2);
insert into packs(pack_id, dat, user_id, param_id) values (3, '2026-04-30', 3, 1);

select pack_id, dat, name, rank, eq_name, height, temperature, pressure, wind_direction, wind_speed, bullet_deviation from packs
join users on users.user_id = packs.user_id
join ranks on users.rank_id = ranks.rank_id
join parameters on parameters.param_id = packs.param_id
join equipment on equipment.equipment_id = parameters.equipment_id;