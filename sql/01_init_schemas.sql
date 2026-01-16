-- --------------------
-- Schemas (these will be created inside the current DB: dwh_healthcare)
-- --------------------
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS stg;
CREATE SCHEMA IF NOT EXISTS dw;
CREATE SCHEMA IF NOT EXISTS mart;

-- Optional but recommended: avoid accidental use of public schema
ALTER DATABASE dwh_healthcare
SET search_path = raw, stg, dw, mart;

-- Optional hardening (do this only if you want to block use of public)
-- REVOKE ALL ON SCHEMA public FROM PUBLIC;