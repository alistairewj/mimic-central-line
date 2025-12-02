WITH gcs_table AS (
    SELECT
        h.stay_id,
        h.endtime,
        h.hr,
        g.charttime,
        g.gcs
    FROM `physionet-data.mimiciv_3_1_derived.icustay_hourly` AS h
    LEFT JOIN `physionet-data.mimiciv_3_1_derived.gcs` AS g
        ON h.stay_id = g.stay_id
     AND g.charttime > TIMESTAMP_SUB(h.endtime, INTERVAL 1 HOUR)
     AND g.charttime <= h.endtime
    WHERE h.hr >= 0
),
gcs_lagged AS (
    SELECT
        stay_id,
        endtime,
        charttime,
        LAST_VALUE(gcs IGNORE NULLS) OVER (
            PARTITION BY stay_id
            ORDER BY endtime, charttime
            ROWS BETWEEN 24 PRECEDING AND 1 PRECEDING
        ) AS gcs
    FROM gcs_table
)
-- keep only the latest charttime per (stay_id, endtime)
, gcs_dedup AS (
    SELECT *
    FROM gcs_lagged
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY stay_id, endtime
        ORDER BY charttime DESC
    ) = 1
)
SELECT
    stay_id,
    endtime,
    gcs
FROM gcs_dedup
WHERE endtime IS NOT NULL;
