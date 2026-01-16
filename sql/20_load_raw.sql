CREATE TABLE IF NOT EXISTS raw.raw_claims (
    claim_id TEXT,
    encounter_id TEXT,
    patient_id TEXT,
    facility_id TEXT,
    payer_id TEXT,
    service_date TEXT,
    claim_status TEXT,
    billed_amount TEXT,
    allowed_amount TEXT,
    paid_amount TEXT,
    patient_responsibility_amount TEXT,
    adjudication_date TEXT,
    source_system TEXT,
    ingested_at_utc TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS raw.raw_encounters (
    encounter_id TEXT,
    patient_id TEXT,
    provider_id	TEXT,
    facility_id	TEXT,
    encounter_type TEXT,
    status TEXT,
    admit_datetime_utc TEXT,
    discharge_datetime_utc TEXT,
    primary_diagnosis_icd10 TEXT,
    secondary_diagnosis_icd10_csv TEXT,
    source_system TEXT,
    ingested_at_utc TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS raw.raw_facilities (
    facility_id TEXT,
    facility_name TEXT,
    facility_type TEXT,
    city TEXT,
    state TEXT,
    timezone TEXT,
    source_system TEXT,
    ingested_at_utc TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS raw.raw_lab_results (
    lab_result_id TEXT,
    encounter_id TEXT,
    patient_id TEXT,
    loinc_code TEXT,
    test_description TEXT,
    result_value TEXT,
    result_unit TEXT,
    reference_range TEXT,
    abnormal_flag TEXT,
    result_datetime_utc TEXT,
    source_system TEXT,
    ingested_at_utc TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS raw.raw_medication_orders (
    med_order_id TEXT,
    encounter_id TEXT,
    patient_id TEXT,
    rxnorm_code TEXT,
    med_description TEXT,
    route TEXT,
    quantity TEXT,
    days_supply TEXT,
    ordered_datetime_utc TEXT,
    source_system TEXT,
    ingested_at_utc TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS raw.raw_patients (
    patient_id TEXT,
    patient_external_id TEXT,
    first_name TEXT,
    last_name TEXT,
    date_of_birth TEXT,
    gender_code TEXT,
    race_code TEXT,
    ethnicity_code TEXT,
    email TEXT,
    phone TEXT,
    city TEXT,
    state TEXT,
    postal_code TEXT,
    deceased_flag TEXT,
    source_system TEXT,
    ingested_at_utc TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS raw.raw_payers (
    payer_id TEXT,
    payer_name TEXT,
    plan_type TEXT,
    source_system TEXT,
    ingested_at_utc TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS raw.raw_providers (
    provider_id TEXT,
    npi TEXT,
    provider_first_name TEXT,
    provider_last_name TEXT,
    specialty TEXT,
    primary_facility_id TEXT,
    active_flag TEXT,
    source_system TEXT,
    ingested_at_utc TIMESTAMPTZ
);



-- --------------------
-- Truncating tables
-- --------------------
TRUNCATE TABLE raw.raw_claims;
TRUNCATE TABLE raw.raw_encounters;
TRUNCATE TABLE raw.raw_facilities;
TRUNCATE TABLE raw.raw_lab_results;
TRUNCATE TABLE raw.raw_medication_orders;
TRUNCATE TABLE raw.raw_patients;
TRUNCATE TABLE raw.raw_payers;
TRUNCATE TABLE raw.raw_providers;

-- --------------------
-- Load CSVs (server-side COPY)
-- --------------------

COPY raw.raw_claims
    FROM '/datasets/raw_claims.csv'
    WITH (
        FORMAT csv,
        HEADER  true,
        DELIMITER ',',
        NULL '',
        ENCODING 'UTF-8');


COPY raw.raw_encounters
    FROM '/datasets/raw_encounters.csv'
    WITH (
        FORMAT csv,
        HEADER  true,
        DELIMITER ',',
        NULL '',
        ENCODING 'UTF-8');


COPY raw.raw_facilities
    FROM '/datasets/raw_facilities.csv'
    WITH (
        FORMAT csv,
        HEADER  true,
        DELIMITER ',',
        NULL '',
        ENCODING 'UTF-8');


COPY raw.raw_lab_results
    FROM '/datasets/raw_lab_results.csv'
    WITH (
        FORMAT csv,
        HEADER  true,
        DELIMITER ',',
        NULL '',
        ENCODING 'UTF-8');


COPY raw.raw_medication_orders
    FROM '/datasets/raw_medication_orders.csv'
    WITH (
        FORMAT csv,
        HEADER  true,
        DELIMITER ',',
        NULL '',
        ENCODING 'UTF-8');


COPY raw.raw_patients
    FROM '/datasets/raw_patients.csv'
    WITH (
        FORMAT csv,
        HEADER  true,
        DELIMITER ',',
        NULL '',
        ENCODING 'UTF-8');


COPY raw.raw_payers
    FROM '/datasets/raw_payers.csv'
    WITH (
        FORMAT csv,
        HEADER  true,
        DELIMITER ',',
        NULL '',
        ENCODING 'UTF-8');


COPY raw.raw_providers
    FROM '/datasets/raw_providers.csv'
    WITH (
        FORMAT csv,
        HEADER  true,
        DELIMITER ',',
        NULL '',
        ENCODING 'UTF-8');

