SELECT
  subject_id,
  hadm_id,
  transfer_id,
  LEAD(transfer_id) OVER (
    PARTITION BY subject_id, hadm_id
    ORDER BY intime
  ) AS next_transfer_id,
  eventtype,
  careunit,
  intime,
  outtime,


  CASE
    WHEN careunit IN (
      'Emergency Department',
      'Emergency Department Observation'
    ) THEN 'ED'


    WHEN careunit IN (
      'Cardiac Vascular Intensive Care Unit (CVICU)',
      'Coronary Care Unit (CCU)',
      'Intensive Care Unit (ICU)',
      'Medical Intensive Care Unit (MICU)',
      'Medical/Surgical Intensive Care Unit (MICU/SICU)',
      'Neuro Surgical Intensive Care Unit (Neuro SICU)',
      'Surgical Intensive Care Unit (SICU)',
      'Trauma SICU (TSICU)'
    ) THEN 'referral from another ICU'


    WHEN careunit IN (
      'PACU',
      'Cardiac Surgery',
      'Surgery',
      'Surgery/Trauma',
      'Surgery/Vascular/Intermediate',
      'Surgery/Pancreatic/Biliary/Bariatric',
      'Thoracic Surgery',
      'Transplant'
    ) THEN 'OR / Perioperative'


    WHEN careunit LIKE 'Obstetrics%'
      OR careunit = 'Labor & Delivery'
    THEN 'Obstetrics / Peripartum'


    WHEN careunit LIKE '%Nursery%' THEN 'Ward'


    WHEN careunit IN (
      'Cardiology',
      'Cardiology Surgery Intermediate',
      'Hematology/Oncology',
      'Hematology/Oncology Intermediate',
      'Med/Surg',
      'Med/Surg/GYN',
      'Med/Surg/Trauma',
      'Medical/Surgical (Gynecology)',
      'Medicine',
      'Medicine/Cardiology',
      'Medicine/Cardiology Intermediate',
      'Neuro Intermediate',
      'Neuro Stepdown',
      'Neurology',
      'Oncology',
      'Psychiatry',
      'Observation',
      'Discharge Lounge',
      'Vascular'
    ) THEN 'Ward'


    ELSE 'Other / Unknown'
  END AS source_category

FROM `physionet-data.mimiciv_3_1_hosp.transfers`
ORDER BY subject_id, intime;
