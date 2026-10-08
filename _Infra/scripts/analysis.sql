-- Запрос 1
select users.user_id, users.name, count(parameters.param_id) as count
from users
left join parameters on parameters.user_id = users.user_id
group by users.user_id, users.name
order by users.user_id;

-- Запрос 2
select packs.pack_id, packs.dat
from packs
left join parameters on parameters.pack_id = packs.pack_id
where parameters.param_id is null
order by packs.pack_id;

-- Запрос 3
select packs.pack_id, packs.dat, count(parameters.param_id) as count
from packs
left join parameters on parameters.pack_id = packs.pack_id
group by packs.pack_id, packs.dat
having count(parameters.param_id) <> 5
order by packs.pack_id;

-- Запрос 4
select parameters.param_id, parameters.pack_id, parameters.type_id, parameter_types.parameter, parameters.value, measurement_types.type, measurement_types.min_value, measurement_types.max_value
from parameters
inner join parameter_types on parameter_types.type_id = parameters.type_id
inner join measurement_types on measurement_types.type_id = parameter_types.measurement_id
where parameters.value < measurement_types.min_value
   or parameters.value > measurement_types.max_value
order by parameters.param_id;

-- Запрос 5
select parameters.param_id, parameters.type_id, parameter_types.parameter, parameter_types.measurement_id, measurement_types.type
from parameters
left join parameter_types on parameter_types.type_id = parameters.type_id
left join measurement_types on measurement_types.type_id = parameter_types.measurement_id
where parameter_types.type_id is null
   or measurement_types.type_id is null
order by parameters.param_id;