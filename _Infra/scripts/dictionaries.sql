do $$
begin
	drop table if exists avg_temp_deviation cascade;
	drop table if exists avg_wind_speed_dmk cascade;
	drop table if exists avg_wind_speed_bp cascade;

	drop sequence if exists seq_avg_temp_deviation cascade;
	drop sequence if exists seq_avg_wind_speed_dmk cascade;
	drop sequence if exists seq_avg_wind_speed_bp cascade;

	create sequence seq_avg_temp_deviation;
	create sequence seq_avg_wind_speed_dmk;
	create sequence seq_avg_wind_speed_bp;

	create table avg_temp_deviation(
	id int primary key default nextval('seq_avg_temp_deviation'),
	height int not null,
	virtual_temp int not null,
	is_positive bool not null,
	value int not null
	);
	comment on table avg_temp_deviation is 'Среднее отклонение температуры воздуха';
	comment on column avg_temp_deviation.id is 'Уникальный код';
	comment on column avg_temp_deviation.height is 'Высота';
	comment on column avg_temp_deviation.virtual_temp is 'Отклонение приземной виртуальной температуры';
	comment on column avg_temp_deviation.is_positive is 'Является ли значение средней температуры положительным или отрицательным';
	comment on column avg_temp_deviation.value is 'Значение';

	create table avg_wind_speed_dmk(
	id int primary key default nextval('seq_avg_wind_speed_dmk'),
	height int not null,
	wind_speed int not null,
	directional_deg_increase int not null,
	value int not null
	);
	comment on table avg_wind_speed_dmk is 'Скорость среднего ветра для дмк';
	comment on column avg_wind_speed_dmk.id is 'Уникальный код';
	comment on column avg_wind_speed_dmk.height is 'Высота';
	comment on column avg_wind_speed_dmk.wind_speed is 'Скорость ветра';
	comment on column avg_wind_speed_dmk.directional_deg_increase is 'Увеличение дирекционного угла';
	comment on column avg_wind_speed_dmk.value is 'Значение';

	create table avg_wind_speed_bp(
	id int primary key default nextval('seq_avg_wind_speed_bp'),
	height int not null,
	bullet_deviation int not null,
	directional_deg_increase int not null,
	value int not null
	);
	comment on table avg_wind_speed_bp is 'Скорость среднего ветра для вр';
	comment on column avg_wind_speed_bp.id is 'Уникальный код';
	comment on column avg_wind_speed_bp.height is 'Высота';
	comment on column avg_wind_speed_bp.bullet_deviation is 'Дальность сноса ветровых пуль';
	comment on column avg_wind_speed_bp.directional_deg_increase is 'Увеличение дирекционного угла';
	comment on column avg_wind_speed_bp.value is 'Значение';
commit;
end $$;