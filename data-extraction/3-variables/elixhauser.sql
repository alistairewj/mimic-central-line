WITH eliflg_icd9 as
(
select hadm_id, seq_num, icd9_code
, CASE
  when icd9_code in ('39891','40201','40211','40291','40401','40403','40411','40413','40491','40493') then 1
  when SUBSTR(icd9_code, 1, 4) in ('4254','4255','4257','4258','4259') then 1
  when SUBSTR(icd9_code, 1, 3) in ('428') then 1
  else 0 end as chf       /* Congestive heart failure */

, CASE
  when icd9_code in ('42613','42610','42612','99601','99604') then 1
  when SUBSTR(icd9_code, 1, 4) in ('4260','4267','4269','4270','4271','4272','4273','4274','4276','4278','4279','7850','V450','V533') then 1
  else 0 end as arrhy

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('0932','7463','7464','7465','7466','V422','V433') then 1
  when SUBSTR(icd9_code, 1, 3) in ('394','395','396','397','424') then 1
  else 0 end as valve     /* Valvular disease */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('4150','4151','4170','4178','4179') then 1
  when SUBSTR(icd9_code, 1, 3) in ('416') then 1
  else 0 end as pulmcirc  /* Pulmonary circulation disorder */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('0930','4373','4431','4432','4438','4439','4471','5571','5579','V434') then 1
  when SUBSTR(icd9_code, 1, 3) in ('440','441') then 1
  else 0 end as perivasc  /* Peripheral vascular disorder */

, CASE
  when SUBSTR(icd9_code, 1, 3) in ('401') then 1
  else 0 end as htn       /* Hypertension, uncomplicated */

, CASE
  when SUBSTR(icd9_code, 1, 3) in ('402','403','404','405') then 1
  else 0 end as htncx     /* Hypertension, complicated */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('3341','3440','3441','3442','3443','3444','3445','3446','3449') then 1
  when SUBSTR(icd9_code, 1, 3) in ('342','343') then 1
  else 0 end as para      /* Paralysis */

, CASE
  when icd9_code in ('33392') then 1
  when SUBSTR(icd9_code, 1, 4) in ('3319','3320','3321','3334','3335','3362','3481','3483','7803','7843') then 1
  when SUBSTR(icd9_code, 1, 3) in ('334','335','340','341','345') then 1
  else 0 end as neuro     /* Other neurological */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('4168','4169','5064','5081','5088') then 1
  when SUBSTR(icd9_code, 1, 3) in ('490','491','492','493','494','495','496','500','501','502','503','504','505') then 1
  else 0 end as chrnlung  /* Chronic pulmonary disease */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('2500','2501','2502','2503') then 1
  else 0 end as dm        /* Diabetes w/o chronic complications*/

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('2504','2505','2506','2507','2508','2509') then 1
  else 0 end as dmcx      /* Diabetes w/ chronic complications */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('2409','2461','2468') then 1
  when SUBSTR(icd9_code, 1, 3) in ('243','244') then 1
  else 0 end as hypothy   /* Hypothyroidism */

, CASE
  when icd9_code in ('40301','40311','40391','40402','40403','40412','40413','40492','40493') then 1
  when SUBSTR(icd9_code, 1, 4) in ('5880','V420','V451') then 1
  when SUBSTR(icd9_code, 1, 3) in ('585','586','V56') then 1
  else 0 end as renlfail  /* Renal failure */

, CASE
  when icd9_code in ('07022','07023','07032','07033','07044','07054') then 1
  when SUBSTR(icd9_code, 1, 4) in ('0706','0709','4560','4561','4562','5722','5723','5724','5728','5733','5734','5738','5739','V427') then 1
  when SUBSTR(icd9_code, 1, 3) in ('570','571') then 1
  else 0 end as liver     /* Liver disease */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('5317','5319','5327','5329','5337','5339','5347','5349') then 1
  else 0 end as ulcer     /* Chronic Peptic ulcer disease (includes bleeding only if obstruction is also present) */

, CASE
  when SUBSTR(icd9_code, 1, 3) in ('042','043','044') then 1
  else 0 end as aids      /* HIV and AIDS */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('2030','2386') then 1
  when SUBSTR(icd9_code, 1, 3) in ('200','201','202') then 1
  else 0 end as lymph     /* Lymphoma */

, CASE
  when SUBSTR(icd9_code, 1, 3) in ('196','197','198','199') then 1
  else 0 end as mets      /* Metastatic cancer */

, CASE
  when SUBSTR(icd9_code, 1, 3) in
  (
     '140','141','142','143','144','145','146','147','148','149','150','151','152'
    ,'153','154','155','156','157','158','159','160','161','162','163','164','165'
    ,'166','167','168','169','170','171','172','174','175','176','177','178','179'
    ,'180','181','182','183','184','185','186','187','188','189','190','191','192'
    ,'193','194','195'
  ) then 1
  else 0 end as tumor     /* Solid tumor without metastasis */

, CASE
  when icd9_code in ('72889','72930') then 1
  when SUBSTR(icd9_code, 1, 4) in ('7010','7100','7101','7102','7103','7104','7108','7109','7112','7193','7285') then 1
  when SUBSTR(icd9_code, 1, 3) in ('446','714','720','725') then 1
  else 0 end as arth              /* Rheumatoid arthritis/collagen vascular diseases */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('2871','2873','2874','2875') then 1
  when SUBSTR(icd9_code, 1, 3) in ('286') then 1
  else 0 end as coag      /* Coagulation deficiency */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('2780') then 1
  else 0 end as obese     /* Obesity      */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('7832','7994') then 1
  when SUBSTR(icd9_code, 1, 3) in ('260','261','262','263') then 1
  else 0 end as wghtloss  /* Weight loss */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('2536') then 1
  when SUBSTR(icd9_code, 1, 3) in ('276') then 1
  else 0 end as lytes     /* Fluid and electrolyte disorders */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('2800') then 1
  else 0 end as bldloss   /* Blood loss anemia */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('2801','2808','2809') then 1
  when SUBSTR(icd9_code, 1, 3) in ('281') then 1
  else 0 end as anemdef  /* Deficiency anemias */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('2652','2911','2912','2913','2915','2918','2919','3030','3039','3050','3575','4255','5353','5710','5711','5712','5713','V113') then 1
  when SUBSTR(icd9_code, 1, 3) in ('980') then 1
  else 0 end as alcohol /* Alcohol abuse */

, CASE
  when icd9_code in ('V6542') then 1
  when SUBSTR(icd9_code, 1, 4) in ('3052','3053','3054','3055','3056','3057','3058','3059') then 1
  when SUBSTR(icd9_code, 1, 3) in ('292','304') then 1
  else 0 end as drug /* Drug abuse */

, CASE
  when icd9_code in ('29604','29614','29644','29654') then 1
  when SUBSTR(icd9_code, 1, 4) in ('2938') then 1
  when SUBSTR(icd9_code, 1, 3) in ('295','297','298') then 1
  else 0 end as psych /* Psychoses */

, CASE
  when SUBSTR(icd9_code, 1, 4) in ('2962','2963','2965','3004') then 1
  when SUBSTR(icd9_code, 1, 3) in ('309','311') then 1
  else 0 end as depress  /* Depression */
from `physionet-data.mimiciii_clinical.diagnoses_icd` icd
where seq_num != 1 -- we do not include the primary icd-9 code
)
, eliflg_icd10 AS (
SELECT
    hadm_id,
    
    -- 1. Congestive Heart Failure
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('I43','I50') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('I099','I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','P290') THEN 1
        ELSE 0 END AS congestive_heart_failure,

    -- 2. Cardiac Arrhythmias
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('I47','I48','I49') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('I441','I442','I443','I456','I459','R000','R001','R008','T821','Z450','Z950') THEN 1
        ELSE 0 END AS cardiac_arrhythmias,

    -- 3. Valvular Disease
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('I05','I06','I07','I08','I34','I35','I36','I37','I38','I39') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('A520','I091','I098','Q230','Q231','Q232','Q233','Z952','Z953','Z954') THEN 1
        ELSE 0 END AS valvular_disease,

    -- 4. Pulmonary Circulation Disorders
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('I26','I27') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('I280','I288','I289') THEN 1
        ELSE 0 END AS pulmonary_circulation,

    -- 5. Peripheral Vascular Disorders
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('I70','I71') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('I731','I738','I739','I771','I790','I792','K551','K558','K559','Z958','Z959') THEN 1
        ELSE 0 END AS peripheral_vascular,

    -- 6. Hypertension Uncomplicated
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('I10') THEN 1
        ELSE 0 END AS hypertension_uncomplicated,

    -- 7. Hypertension Complicated
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('I11','I12','I13','I15') THEN 1
        ELSE 0 END AS hypertension_complicated,

    -- 8. Paralysis
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('G81','G82') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('G041','G114','G801','G802','G830','G831','G832','G833','G834','G839') THEN 1
        ELSE 0 END AS paralysis,

    -- 9. Other Neurological Disorders
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('G10','G11','G12','G13','G20','G21','G22','G32','G35','G36','G37','G40','G41','R56') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('G254','G255','G312','G318','G319','G931','G934','R470') THEN 1
        ELSE 0 END AS other_neurological,

    -- 10. Chronic Pulmonary Disease
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('I278','I279','J684','J701','J703') THEN 1
        ELSE 0 END AS chronic_pulmonary,

    -- 11. Diabetes Uncomplicated
    CASE WHEN SUBSTR(icd_code, 1, 4) IN ('E100','E101','E109','E110','E111','E119','E120','E121','E129','E130','E131','E139','E140','E141','E149') THEN 1
        ELSE 0 END AS diabetes_uncomplicated,

    -- 12. Diabetes Complicated
    CASE WHEN SUBSTR(icd_code, 1, 4) IN ('E102','E103','E104','E105','E106','E107','E108','E112','E113','E114','E115','E116','E117','E118','E122','E123','E124','E125','E126','E127','E128','E132','E133','E134','E135','E136','E137','E138','E142','E143','E144','E145','E146','E147','E148') THEN 1
        ELSE 0 END AS diabetes_complicated,

    -- 13. Hypothyroidism
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('E00','E01','E02','E03') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('E890') THEN 1
        ELSE 0 END AS hypothyroidism,

    -- 14. Renal Failure
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('N18','N19') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('I120','I131','N250','Z490','Z491','Z492','Z940','Z992') THEN 1
        ELSE 0 END AS renal_failure,

    -- 15. Liver Disease
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('B18','I85','K70','K72','K73','K74') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('I864','I982','K711','K713','K714','K715','K717','K760','K762','K763','K764','K765','K766','K767','K768','K769','Z944') THEN 1
        ELSE 0 END AS liver_disease,

    -- 16. Peptic Ulcer Disease
    CASE WHEN SUBSTR(icd_code, 1, 4) IN ('K257','K259','K267','K269','K277','K279','K287','K289') THEN 1
        ELSE 0 END AS peptic_ulcer,

    -- 17. AIDS/HIV
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('B20','B21','B22','B24') THEN 1
        ELSE 0 END AS aids,

    -- 18. Lymphoma
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('C81','C82','C83','C84','C85','C88','C96') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('C900','C902') THEN 1
        ELSE 0 END AS lymphoma,

    -- 19. Metastatic Cancer
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('C77','C78','C79','C80') THEN 1
        ELSE 0 END AS metastatic_cancer,

    -- 20. Solid Tumor without Metastasis
    CASE WHEN SUBSTR(icd_code, 1, 3) IN (
            'C00','C01','C02','C03','C04','C05','C06','C07','C08','C09',
            'C10','C11','C12','C13','C14','C15','C16','C17','C18','C19',
            'C20','C21','C22','C23','C24','C25','C26','C30','C31','C32',
            'C33','C34','C37','C38','C39','C40','C41','C43','C45','C46',
            'C47','C48','C49','C50','C51','C52','C53','C54','C55','C56',
            'C57','C58','C60','C61','C62','C63','C64','C65','C66','C67',
            'C68','C69','C70','C71','C72','C73','C74','C75','C76','C97'
        ) THEN 1
        ELSE 0 END AS solid_tumor,

    -- 21. Rheumatoid Arthritis/collagen
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('M05','M06','M08','M30','M32','M33','M34','M35','M45') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('L940','L941','L943','M120','M123','M310','M311','M312','M313','M461','M468','M469') THEN 1
        ELSE 0 END AS rheumatoid_arthritis,

    -- 22. Coagulopathy
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('D65','D66','D67','D68') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('D691','D693','D694','D695','D696') THEN 1
        ELSE 0 END AS coagulopathy,

    -- 23. Obesity
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('E66') THEN 1
        ELSE 0 END AS obesity,

    -- 24. Weight Loss
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('E40','E41','E42','E43','E44','E45','E46','R64') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('R634') THEN 1
        ELSE 0 END AS weight_loss,

    -- 25. Fluid and Electrolyte Disorders
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('E86','E87') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('E222') THEN 1
        ELSE 0 END AS fluid_electrolyte,

    -- 26. Blood Loss Anemia
    CASE WHEN SUBSTR(icd_code, 1, 4) IN ('D500') THEN 1
        ELSE 0 END AS blood_loss_anemia,

    -- 27. Deficiency Anemia
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('D51','D52','D53') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('D508','D509') THEN 1
        ELSE 0 END AS deficiency_anemias,

    -- 28. Alcohol Abuse
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('F10','E52','T51') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('G621','I426','K292','K700','K703','K709','Z502','Z714','Z721') THEN 1
        ELSE 0 END AS alcohol_use,

    -- 29. Drug Abuse
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('F11','F12','F13','F14','F15','F16','F18','F19') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('Z715','Z722') THEN 1
        ELSE 0 END AS drug_use,

    -- 30. Psychoses
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('F20','F22','F23','F24','F25','F28','F29') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('F302','F312','F315') THEN 1
        ELSE 0 END AS psychoses,

    -- 31. Depression
    CASE WHEN SUBSTR(icd_code, 1, 3) IN ('F32','F33') THEN 1
        WHEN SUBSTR(icd_code, 1, 4) IN ('F204','F313','F314','F315','F341','F412','F432') THEN 1
        ELSE 0 END AS depression

FROM `physionet-data.mimiciv_3_1_hosp.diagnoses_icd`
-- Assumes DIAGNOSES_ICD has ICD10 codes. If there's a version flag, add a WHERE clause here.
-- WHERE seq_num <> 1 -- Optional: exclude primary diagnosis if logic requires it (SAS macro didn't explicitly exclude logic wise, but Sample SQL did)
),
eligrp AS (
    SELECT
        adm.hadm_id,
        MAX(GREATEST(COALESCE(e9.chf, 0), COALESCE(e10.congestive_heart_failure, 0))) AS congestive_heart_failure,
        MAX(GREATEST(COALESCE(e9.arrhy, 0), COALESCE(e10.cardiac_arrhythmias, 0))) AS cardiac_arrhythmias,
        MAX(GREATEST(COALESCE(e9.valve, 0), COALESCE(e10.valvular_disease, 0))) AS valvular_disease,
        MAX(GREATEST(COALESCE(e9.pulmcirc, 0), COALESCE(e10.pulmonary_circulation, 0))) AS pulmonary_circulation,
        MAX(GREATEST(COALESCE(e9.perivasc, 0), COALESCE(e10.peripheral_vascular, 0))) AS peripheral_vascular,
        MAX(GREATEST(COALESCE(e9.htn, 0), COALESCE(e10.hypertension_uncomplicated, 0))) AS hypertension_uncomplicated,
        MAX(GREATEST(COALESCE(e9.htncx, 0), COALESCE(e10.hypertension_complicated, 0))) AS hypertension_complicated,
        MAX(GREATEST(COALESCE(e9.para, 0), COALESCE(e10.paralysis, 0))) AS paralysis,
        MAX(GREATEST(COALESCE(e9.neuro, 0), COALESCE(e10.other_neurological, 0))) AS other_neurological,
        MAX(GREATEST(COALESCE(e9.chrnlung, 0), COALESCE(e10.chronic_pulmonary, 0))) AS chronic_pulmonary,
        MAX(GREATEST(COALESCE(e9.dm, 0), COALESCE(e10.diabetes_uncomplicated, 0))) AS diabetes_uncomplicated,
        MAX(GREATEST(COALESCE(e9.dmcx, 0), COALESCE(e10.diabetes_complicated, 0))) AS diabetes_complicated,
        MAX(GREATEST(COALESCE(e9.hypothy, 0), COALESCE(e10.hypothyroidism, 0))) AS hypothyroidism,
        MAX(GREATEST(COALESCE(e9.renlfail, 0), COALESCE(e10.renal_failure, 0))) AS renal_failure,
        MAX(GREATEST(COALESCE(e9.liver, 0), COALESCE(e10.liver_disease, 0))) AS liver_disease,
        MAX(GREATEST(COALESCE(e9.ulcer, 0), COALESCE(e10.peptic_ulcer, 0))) AS peptic_ulcer,
        MAX(GREATEST(COALESCE(e9.aids, 0), COALESCE(e10.aids, 0))) AS aids,
        MAX(GREATEST(COALESCE(e9.lymph, 0), COALESCE(e10.lymphoma, 0))) AS lymphoma,
        MAX(GREATEST(COALESCE(e9.mets, 0), COALESCE(e10.metastatic_cancer, 0))) AS metastatic_cancer,
        MAX(GREATEST(COALESCE(e9.tumor, 0), COALESCE(e10.solid_tumor, 0))) AS solid_tumor,
        MAX(GREATEST(COALESCE(e9.arth, 0), COALESCE(e10.rheumatoid_arthritis, 0))) AS rheumatoid_arthritis,
        MAX(GREATEST(COALESCE(e9.coag, 0), COALESCE(e10.coagulopathy, 0))) AS coagulopathy,
        MAX(GREATEST(COALESCE(e9.obese, 0), COALESCE(e10.obesity, 0))) AS obesity,
        MAX(GREATEST(COALESCE(e9.wghtloss, 0), COALESCE(e10.weight_loss, 0))) AS weight_loss,
        MAX(GREATEST(COALESCE(e9.lytes, 0), COALESCE(e10.fluid_electrolyte, 0))) AS fluid_electrolyte,
        MAX(GREATEST(COALESCE(e9.bldloss, 0), COALESCE(e10.blood_loss_anemia, 0))) AS blood_loss_anemia,
        MAX(GREATEST(COALESCE(e9.anemdef, 0), COALESCE(e10.deficiency_anemias, 0))) AS deficiency_anemias,
        MAX(GREATEST(COALESCE(e9.alcohol, 0), COALESCE(e10.alcohol_use, 0))) AS alcohol_use,
        MAX(GREATEST(COALESCE(e9.drug, 0), COALESCE(e10.drug_use, 0))) AS drug_use,
        MAX(GREATEST(COALESCE(e9.psych, 0), COALESCE(e10.psychoses, 0))) AS psychoses,
        MAX(GREATEST(COALESCE(e9.depress, 0), COALESCE(e10.depression, 0))) AS depression
    FROM `physionet-data.mimiciv_3_1_hosp.admissions` adm 
    LEFT JOIN eliflg_icd9 e9
        ON adm.hadm_id = e9.hadm_id
    LEFT JOIN eliflg_icd10 e10
        ON adm.hadm_id = e10.hadm_id
    GROUP BY hadm_id
)
, final AS (
    SELECT
        eli.hadm_id,
        eli.congestive_heart_failure,
        eli.cardiac_arrhythmias,
        eli.valvular_disease,
        eli.pulmonary_circulation,
        eli.peripheral_vascular,
        -- Combining Hypertension logic similar to Sample SQL or keeping distinct?
        -- Provided SAS logic keeps them distinct. Sample SQL had one.
        -- We will keep them distinct here as per the ICD10 definitions provided.
        eli.hypertension_uncomplicated,
        eli.hypertension_complicated,
        eli.paralysis,
        eli.other_neurological,
        eli.chronic_pulmonary,
        
        -- Diabetes Hierarchy: If Complicated, Uncomplicated = 0
        CASE WHEN eli.diabetes_complicated=1 THEN 0
            WHEN eli.diabetes_uncomplicated=1 THEN 1
            ELSE 0 END AS diabetes_uncomplicated,
            
        eli.diabetes_complicated,
        eli.hypothyroidism,
        eli.renal_failure,
        eli.liver_disease,
        eli.peptic_ulcer,
        eli.aids,
        eli.lymphoma,
        eli.metastatic_cancer,
        
        -- Tumor Hierarchy: If Metastatic, Solid Tumor = 0
        CASE WHEN eli.metastatic_cancer=1 THEN 0
            WHEN eli.solid_tumor=1 THEN 1
            ELSE 0 END AS solid_tumor,
            
        eli.rheumatoid_arthritis,
        eli.coagulopathy,
        eli.obesity,
        eli.weight_loss,
        eli.fluid_electrolyte,
        eli.blood_loss_anemia,
        eli.deficiency_anemias,
        eli.alcohol_use,
        eli.drug_use,
        eli.psychoses,
        eli.depression
    FROM `physionet-data.mimiciv_3_1_hosp.admissions` adm
    LEFT JOIN eligrp eli
        ON adm.hadm_id = eli.hadm_id
)
SELECT * FROM final