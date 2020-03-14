drop table if exists misc_measurement cascade;
create table misc_measurement as (
    select person_id, 'age' as code
    , datediff(day, date_of_birth, current_date) / 365.25 as value_float
    from demo
    union select person_id, 'ecog', ecog_ps
    from latest_ecog
    union select person_id, 'karnosky', karnofsky_pct
    from latest_karnofsky
    union select person_id, 'lot', n_lot
    from lot
    union select person_id, modality, n_lot
    from modality_lot
);
