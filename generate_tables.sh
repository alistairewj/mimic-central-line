# we use standard SQL and replace a table if it already exists
export BQ_FLAGS="--use_legacy_sql=False --replace"
export PROJECT_ID="silent-bolt-397621"

bq query $BQ_FLAGS --project_id $PROJECT_ID --dataset_id cvc --destination_table=admission_location < data-extraction/1-staging/admission_location.sql

bq query $BQ_FLAGS --project_id $PROJECT_ID --dataset_id cvc --destination_table=cohort < data-extraction/2-cohort/cohort.sql
bq query $BQ_FLAGS --project_id $PROJECT_ID --dataset_id cvc --destination_table=vitalsign_hourly < data-extraction/3-variables/vitalsign_hourly.sql
bq query $BQ_FLAGS --project_id $PROJECT_ID --dataset_id cvc --destination_table=gcs_hourly < data-extraction/3-variables/gcs_hourly.sql
bq query $BQ_FLAGS --project_id $PROJECT_ID --dataset_id cvc --destination_table=elixhauser < data-extraction/3-variables/elixhauser.sql
bq query $BQ_FLAGS --project_id $PROJECT_ID --dataset_id cvc --destination_table=rrt_hourly < data-extraction/3-variables/rrt_hourly.sql

bq query $BQ_FLAGS --project_id $PROJECT_ID --dataset_id cvc --destination_table=data < data-extraction/4-merge/data.sql