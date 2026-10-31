-- Функция расчета метео приближенного
drop function if exists calc_meteo_approx(param_list);

create function calc_meteo_approx(pack param_list)
returns text
language plpgsql
as $func$
declare
    v_ddchhm text;
    v_vvvv text;
    v_bbb text;
    v_tt text;
    v_dh int;
    v_borders var_interpolation;
    v_vt_val numeric;
begin
    -- ДДЧЧМ
    v_ddchhm := to_char(now(), 'DDHH24') || floor(extract(minute from now()) / 10)::text;

    -- ВВВВ
    if pack.height is null then
        v_vvvv := '0000';
    else
        v_vvvv := lpad(round(pack.height)::int::text, 4, '0');
    end if;

    -- БББ
    if pack.pressure is null then
        v_dh := 0;
    else
        v_dh := round(pack.pressure - 750);
    end if;

    if v_dh >= 0 then
        v_bbb := lpad(v_dh::text, 3, '0');
    else
        v_bbb := '5' || lpad(abs(v_dh)::text, 2, '0');
    end if;

    -- ТТ
    if pack.temperature is null then
        v_vt_val := 0;
    else
        v_borders := interpolation_params(pack.temperature);
        v_vt_val := calculate_interpolation(pack.temperature, v_borders);
    end if;

    v_tt := lpad(round(v_vt_val * 10)::int::text, 2, '0');

    -- Сбор итоговой строки
    return v_ddchhm || ' ' || v_vvvv || ' ' || v_bbb || v_tt;
end;
$func$;