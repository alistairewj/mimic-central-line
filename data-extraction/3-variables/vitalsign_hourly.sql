WITH v AS (
    SELECT
        h.stay_id,
        h.endtime,
        vitalsign.charttime,
        vitalsign.heart_rate,
        vitalsign.resp_rate,
        COALESCE(vitalsign.mbp, vitalsign.mbp_ni) AS mbp,
        COALESCE(vitalsign.sbp, vitalsign.sbp_ni) AS sbp,
        COALESCE(vitalsign.dbp, vitalsign.dbp_ni) AS dbp,
        vitalsign.spo2
    FROM `physionet-data.mimiciv_3_1_derived.icustay_hourly` AS h
    LEFT JOIN `physionet-data.mimiciv_3_1_derived.vitalsign` AS vitalsign
        ON h.stay_id = vitalsign.stay_id
     AND vitalsign.charttime > (h.endtime - INTERVAL '1' HOUR)
     AND vitalsign.charttime <= h.endtime
     WHERE h.hr >= 0
)
, v_lagged AS (
SELECT
    stay_id,
    endtime,
    charttime,
    LAST_VALUE(heart_rate IGNORE NULLS) OVER (PARTITION BY stay_id ORDER BY endtime, charttime ROWS BETWEEN 24 PRECEDING AND 1 PRECEDING) AS heart_rate,
    LAST_VALUE(resp_rate IGNORE NULLS) OVER (PARTITION BY stay_id ORDER BY endtime, charttime ROWS BETWEEN 24 PRECEDING AND 1 PRECEDING) AS resp_rate,
    LAST_VALUE(mbp IGNORE NULLS) OVER (PARTITION BY stay_id ORDER BY endtime, charttime ROWS BETWEEN 24 PRECEDING AND 1 PRECEDING) AS mbp,
    LAST_VALUE(sbp IGNORE NULLS) OVER (PARTITION BY stay_id ORDER BY endtime, charttime ROWS BETWEEN 24 PRECEDING AND 1 PRECEDING) AS sbp,
    LAST_VALUE(dbp IGNORE NULLS) OVER (PARTITION BY stay_id ORDER BY endtime, charttime ROWS BETWEEN 24 PRECEDING AND 1 PRECEDING) AS dbp,
    LAST_VALUE(spo2 IGNORE NULLS) OVER (PARTITION BY stay_id ORDER BY endtime, charttime ROWS BETWEEN 24 PRECEDING AND 1 PRECEDING) AS spo2
FROM v
)
-- keep only the latest charttime per (stay_id, endtime)
, v_dedup AS (
    SELECT *
    FROM v_lagged
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY stay_id, endtime
        ORDER BY charttime DESC
    ) = 1
)
SELECT
    stay_id,
    endtime,
    heart_rate,
    resp_rate,
    mbp,
    sbp,
    dbp,
    spo2
FROM v_dedup
WHERE endtime IS NOT NULL;
