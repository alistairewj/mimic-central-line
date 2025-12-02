WITH central_line_individual AS (
    SELECT stay_id
             , CASE WHEN line_type IN (
                 'Multi Lumen','Cordis/Introducer','Sheath (Venous)','Triple Introducer','AVA'
             ) THEN 1 ELSE 0 END AS central_line
             , starttime
             , endtime
    FROM `physionet-data.mimiciv_3_1_derived.invasive_line`
),
central_line_flag AS (
    SELECT stay_id, starttime, endtime,
                 CASE WHEN starttime > prev_max_end THEN 1 ELSE 0 END AS new_group
    FROM (
        SELECT stay_id, starttime, endtime,
                     MAX(endtime) OVER (
                         PARTITION BY stay_id
                         ORDER BY starttime
                         ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                     ) AS prev_max_end
        FROM central_line_individual
        WHERE central_line = 1
    )
),
central_line_contiguous AS (
    SELECT stay_id,
                 MIN(starttime) AS starttime,
                 MAX(endtime)   AS endtime
    FROM (
        SELECT stay_id, starttime, endtime,
                     SUM(new_group) OVER (
                         PARTITION BY stay_id
                         ORDER BY starttime
                         ROWS UNBOUNDED PRECEDING
                     ) AS grp
        FROM central_line_flag
    )
    GROUP BY stay_id, grp
)
SELECT 
icu.hadm_id
, h.stay_id, h.hr
, h.endtime
, COALESCE(ned.norepinephrine_equivalent_dose, 0) as ned
, CASE WHEN cl.stay_id IS NOT NULL THEN 1 ELSE 0 END AS central_line
-- sepsis3 -> impute 0 for missing
, CASE WHEN s3.sepsis3 THEN 1 ELSE 0 END AS sepsis3
-- sofa-derived aggregations
, respiration_24hours
, coagulation_24hours
, liver_24hours
, cardiovascular_24hours
, cns_24hours
, renal_24hours
, sofa_24hours
-- sofa derived features
, COALESCE(pao2fio2ratio_vent, pao2fio2ratio_novent) AS pao2fio2ratio
-- vitals
, heart_rate
, resp_rate
, mbp
, sbp
, dbp
, spo2
, gtbl.gcs
, CASE WHEN rrt_tbl.rrt = 1 THEN 1 ELSE 0 END AS rrt
-- TODO: source covariates for SOFA
-- Lactate
-- Ph
-- Hco3
-- WBC
-- Neutrophils
-- Plt
-- Hgb
-- INR
FROM `physionet-data.mimiciv_3_1_derived.icustay_hourly` h
INNER JOIN `physionet-data.mimiciv_3_1_icu.icustays` icu
ON h.stay_id = icu.stay_id
LEFT JOIN `physionet-data.mimiciv_3_1_derived.norepinephrine_equivalent_dose` ned
ON h.stay_id = ned.stay_id
AND h.endtime > ned.starttime
AND h.endtime <= ned.endtime
LEFT JOIN central_line_contiguous cl
ON h.stay_id = cl.stay_id
AND h.endtime > cl.starttime
AND h.endtime <= cl.endtime
LEFT JOIN `physionet-data.mimiciv_3_1_derived.sofa` sofa
ON h.stay_id = sofa.stay_id
AND h.endtime > sofa.starttime
AND h.endtime <= sofa.endtime
LEFT JOIN `physionet-data.mimiciv_3_1_derived.sepsis3` s3
ON h.stay_id = s3.stay_id
-- below sofa_time was derived from icustay_hourly originally, so we can match endtime here
AND h.endtime = s3.sofa_time
LEFT JOIN `silent-bolt-397621.cvc.vitalsign_hourly` vitalsign
ON h.stay_id = vitalsign.stay_id
AND h.endtime = vitalsign.endtime
LEFT JOIN `silent-bolt-397621.cvc.gcs_hourly` gtbl
ON h.stay_id = gtbl.stay_id
AND h.endtime = gtbl.endtime
LEFT JOIN `silent-bolt-397621.cvc.rrt_hourly` rrt_tbl
ON h.stay_id = rrt_tbl.stay_id
AND h.endtime = rrt_tbl.endtime
WHERE h.hr >= 0
-- lactate, ph, bicarb, wbc count, neutrophil count


-- admission type
