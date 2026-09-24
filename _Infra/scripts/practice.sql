create table soldiers(
name text,
rank text
);

alter table soldiers add rank_id int;
alter table soldiers add soldier_id int;

select * from soldiers;
select * from soldiers where rank_id is not null;

select soldiers.name || ' - ' || ranks.name as full_name from soldiers, ranks where soldiers.rank_id = ranks.id;

select * from soldiers, ranks where soldiers.rank_id = ranks.id;

update soldiers set rank_id = 1 where rank like 'мл%';
update soldiers set rank_id = 2 where rank = 'Лейтенант';
update soldiers set rank_id = 3 where rank = 'ст. Лейтенант';
update soldiers set soldier_id = 2 where rank like 'младший%';
update soldiers set soldier_id = 1 where rank like 'мл.%';
update soldiers set soldier_id = 4 where rank = 'ст. Лейтенант';
update soldiers set soldier_id = 3 where rank = 'Лейтенант';

create table ranks(
id int,
name text
);

insert into ranks(id, name) values (2, 'Лейтенант');
insert into ranks(id, name) values (1, 'мл. Лейтенант');
insert into ranks(id, name) values (3, 'ст. Лейтенант');

select * from ranks;

select * from soldiers where rank like 'мл%';

insert into soldiers(name, rank) values ('Иванов', 'Лейтенант');
insert into soldiers(name, rank) values ('Иванов', 'мл. Лейтенант');
insert into soldiers(name, rank) values ('Иванов', 'ст. Лейтенант');
insert into soldiers(name, rank) values ('Иванов', 'младший Лейтенант');