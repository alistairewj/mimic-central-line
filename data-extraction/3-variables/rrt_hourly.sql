WITH interim_table AS (
    SELECT
        h.stay_id,
        h.endtime,
        h.hr,
        tbl.charttime,
        tbl.dialysis_active AS rrt
    FROM `physionet-data.mimiciv_3_1_derived.icustay_hourly` AS h
    LEFT JOIN `physionet-data.mimiciv_3_1_derived.rrt` AS tbl
        ON h.stay_id = tbl.stay_id
     AND tbl.charttime > TIMESTAMP_SUB(h.endtime, INTERVAL 1 HOUR)
     AND tbl.charttime <= h.endtime
    WHERE h.hr >= 0
),
lagged_table AS (
    SELECT
        stay_id,
        endtime,
        charttime,
        LAST_VALUE(rrt IGNORE NULLS) OVER (
            PARTITION BY stay_id
            ORDER BY endtime, charttime
            ROWS BETWEEN 24 PRECEDING AND 1 PRECEDING
        ) AS rrt
    FROM interim_table
)
-- keep only the latest charttime per (stay_id, endtime)
, dedup AS (
    SELECT *
    FROM lagged_table
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY stay_id, endtime
        ORDER BY charttime DESC
    ) = 1
)
SELECT
    stay_id,
    endtime,
    rrt
FROM dedup
WHERE endtime IS NOT NULL;
