# Healthcare Data Warehouse (PostgreSQL) – Project Requirements

## 1) Business Context
This project simulates the **raw landing zone** of a fictional healthcare network (“North Valley Health”) that operates multiple facilities (hospital, clinics, urgent care, imaging, and specialty practices).

**Primary goals:**
- Land raw source extracts from multiple upstream systems (EHR, Billing, Lab Information System, Payer portal).
- Build a PostgreSQL data warehouse to support:
  - Operational reporting (encounters, providers, facility utilization)
  - Revenue cycle analytics (claims status, allowed vs paid, denial patterns)
  - Clinical quality / population health (basic diagnosis & lab trend slices)
  - Auditability (lineage, late-arriving data handling)

> This dataset contains **no real patient or provider information**. Names, identifiers, addresses, and organizations are fictional/synthetic.

---

## 2) Data Sources (Simulated)
| Source System | Description | Raw Tables |
|---|---|---|
| `EHR_A` | Scheduling + clinical encounter system | patients, encounters, medication_orders, providers, facilities |
| `BILLING_B` | Claims & adjudication | claims |
| `LIS_C` | Lab results | lab_results |
| `PAYER_PORTAL` | Payer/plan reference | payers |

Each raw record includes:
- `source_system`
- `ingested_at_utc` (when the record landed in the lake/warehouse)

---

## 3) Naming Conventions
### 3.1 Table Naming
- Raw/landing tables: `raw_<entity>` (snake_case)
  - Example: `raw_patients`, `raw_claims`
- Staging tables: `stg_<entity>`
- Dimensions: `dim_<entity>`
- Facts: `fct_<process>`
- Aggregate marts: `mart_<domain>_<grain>`

### 3.2 Column Naming
- snake_case for all columns
- Use suffixes consistently:
  - `_id` for surrogate keys and natural keys
  - `_code` for coded values (ICD-10, CPT, LOINC, RxNorm)
  - `_flag` for booleans stored as true/false or Y/N (keep raw as provided)
  - `_amount` for money (numeric(12,2) recommended)
  - `_datetime_utc` for timestamps stored in UTC (timestamptz)
  - `_date` for dates (date)

### 3.3 Primary Keys
- Raw tables are **append-friendly** and may contain duplicates.
- Use a **warehouse surrogate key** later (in staging) if needed.
- In raw, treat `<entity>_id` as the “source primary key” (not guaranteed unique).

---

## 4) Data Quality & Handling Rules
### 4.1 Null & Missing Values
- Keep nulls **as-is** in raw tables.
- Do not impute in raw. Impute in `stg_` or mart layers only.
- Critical fields (expected but may be missing):
  - `patients.email`, `patients.phone`
  - `encounters.discharge_datetime_utc`
  - `claims.allowed_amount`

### 4.2 Duplicates
- Raw data may contain:
  - Duplicate `patient_external_id`
  - Potential duplicate claim IDs over time (re-submissions)
- Strategy:
  - In staging, dedupe using `(source_system, <id>, ingested_at_utc)` and keep latest by ingestion time.

### 4.3 Late-arriving Data
- `claims.ingested_at_utc` may be **weeks/months after** `service_date`.
- Requirement:
  - Incremental loads must support backfills for late-arriving claims (e.g., process last N days + detect late changes).

### 4.4 “Dirty” / Invalid Data Intentionally Included
Examples you should detect/handle downstream:
- Negative `billed_amount`
- `paid_amount` > `allowed_amount`
- Invalid ICD-10 strings (e.g., `ZZZ.999`)
- Some lab `result_value` null or negative
- Rare encounter with `discharge_datetime_utc` earlier than admit

---

## 5) PostgreSQL Recommendations
### 5.1 Schemas
Use separate schemas:
- `raw`  – immutable-ish landing tables
- `stg`  – cleaned, typed, conformed staging
- `dw`   – star schema dims/facts
- `mart` – BI-facing aggregates

### 5.2 Data Types (Suggested)
- IDs: `text` (raw), consider `uuid` in staging if you generate surrogate keys
- Timestamps: `timestamptz`
- Dates: `date`
- Amounts: `numeric(12,2)`
- Flags: `boolean` (staging), keep raw as text if source varies

### 5.3 Indexing (After You Build Staging/DW)
- `raw_claims(service_date)`, `raw_claims(ingested_at_utc)`
- `raw_encounters(admit_datetime_utc)`, `raw_encounters(patient_id)`
- `raw_lab_results(result_datetime_utc)`
- Consider BRIN indexes for large time-series tables on `*_datetime_utc`

---

## 6) Incremental Load Requirements
Your pipeline should support:
- Full load (initial backfill)
- Daily incremental loads based on `ingested_at_utc`
- Reprocessing window for late-arriving data (e.g., last 120 days)

---

## 7) Security & Compliance (For the Project)
- Treat all data as if governed by HIPAA-like controls (even though synthetic).
- Mask or tokenize identifiers in any external exports.
- Never attempt re-identification or merge with any real dataset.

---

## 8) Deliverables Checklist (Suggested)
- DDL scripts for `raw` tables
- COPY commands or ingestion scripts
- Staging transforms:
  - type casting, dedupe, constraint checks
  - conformance of codes
- Star schema:
  - `dim_patient`, `dim_provider`, `dim_facility`, `dim_payer`, `dim_date`
  - `fct_encounter`, `fct_claim`, `fct_lab_result`, `fct_med_order`
- Data quality tests (SQL):
  - null rates, uniqueness checks, range checks
  - late-arriving detection
