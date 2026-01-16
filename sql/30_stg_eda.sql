SELECT patient_id,
       patient_external_id,
       TRIM(first_name) AS first_name,
       TRIM(last_name) AS last_name,
       date_of_birth::DATE,
       CASE gender_code
           WHEN UPPER('F') THEN 'Female'
           WHEN UPPER('M') THEN 'Male'
           WHEN UPPER('X') THEN 'Non_Binary_or_Other'
           WHEN UPPER('U') THEN 'Unknown'
           ELSE 'Unknown'
       END AS gender_code,
       TRIM(race_code) AS race_code,
       TRIM(ethnicity_code) AS ethnicity_code,
       COALESCE(TRIM(email), 'Unknown') AS email,
       COALESCE(phone, 'Unknown') AS phone,
       TRIM(city) AS city,
       TRIM(state) AS state,
       postal_code,
       deceased_flag::BOOLEAN,
       source_system,
       ingested_at_utc
FROM raw.raw_patients;



SELECT rc.encounter_id,
       re.encounter_type,
       rc.patient_id,
       rc.ingested_at_utc,
       COUNT(*)
FROM raw.raw_claims rc
LEFT JOIN raw.raw_encounters re
    ON rc.patient_id = re.patient_id
GROUP BY rc.encounter_id, re.encounter_type, rc.patient_id, rc.ingested_at_utc
HAVING COUNT(*) > 1;


SELECT *
FROM raw.raw_encounters;

