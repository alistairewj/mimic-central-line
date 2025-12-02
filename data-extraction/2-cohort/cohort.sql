-- This query defines the cohort used for the ALINE study.

-- Inclusion criteria:
--  In ICU for at least 12 hours
--  First hospitalization
--  First ICU admission (merge stay_id)

-- Exclusion criteria:
--  TBD

-- cohort view - used to define other concepts
WITH serv as
(
    select ie.stay_id, se.curr_service
    , ROW_NUMBER() over (partition by ie.stay_id order by se.transfertime DESC) as rn
    from `physionet-data.mimiciv_3_1_icu.icustays` ie
    inner join `physionet-data.mimiciv_3_1_hosp.services` se
      on ie.hadm_id = se.hadm_id
      and se.transfertime < DATETIME_ADD(ie.intime, INTERVAL '2' HOUR)
)
, co as
(
  select
    ie.subject_id, ie.hadm_id, ie.stay_id
    , adm.admittime, adm.dischtime
    , it.intime_hr, it.outtime_hr
    , pat.anchor_age AS age
    , pat.gender

    , al.source_category as admission_source

    -- cohort flags // demographics
    , DATETIME_DIFF(ie.outtime, it.intime_hr, DAY) as icu_los_day
    , DATETIME_DIFF(adm.dischtime, adm.admittime, DAY) as hospital_los_day

    -- will be used to exclude `physionet-data.mimic_core.patients` in CSRU
    -- also only include those in CMED or SURG
    , s.curr_service as service_unit
    , case when s.curr_service like '%SURG' or s.curr_service like '%ORTHO%' then 1
          when s.curr_service = 'CMED' then 2
          when s.curr_service in ('CSURG','VSURG','TSURG') then 3
          else 0
        end
      as service_num

    -- outcome
    , case when adm.deathtime is not null then 1 else 0 end as hosp_exp_flag
    , case when adm.deathtime <= (ie.outtime + INTERVAL '4' HOUR) then 1 else 0 end as icu_exp_flag
    , case when pat.dod <= CAST(DATETIME_ADD(it.intime_hr, INTERVAL 28 DAY) AS DATE) then 1 else 0 end as day_28_flag
    , DATE_DIFF(pat.dod, CAST(adm.admittime AS DATE), DAY) AS mort_day

    , case when pat.dod is null
        then 356 -- assume we have date of death info up to 1 year after hospital stay
        else DATE_DIFF(pat.dod, CAST(adm.admittime AS DATE), DAY)
      end as mort_day_censored
    , case when pat.dod is null then 1 else 0 end as censor_flag

  from `physionet-data.mimiciv_3_1_icu.icustays` ie
  INNER JOIN `physionet-data.mimiciv_3_1_derived.icustay_times` it
    ON ie.stay_id = it.stay_id
  inner join `physionet-data.mimiciv_3_1_hosp.admissions` adm
    on ie.hadm_id = adm.hadm_id
  inner join `physionet-data.mimiciv_3_1_hosp.patients` pat
    on ie.subject_id = pat.subject_id
  left join serv s
    on ie.stay_id = s.stay_id
    and s.rn = 1
  left join `silent-bolt-397621.cvc.admission_location` al
    on ie.stay_id = al.next_transfer_id
)
select
  co.*
from co;