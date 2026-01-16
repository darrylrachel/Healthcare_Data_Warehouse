/*-- ========================================================
Create Database and Schemas
=============================================================

Script Purpose:
    This script creates a new database named 'dwh_healthcare' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the needed schemas are created.

WARNING:
    Running this script will drop the entire 'dwh_healthcare' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
-- ============================================================= */

-- IMPORTANT:
-- You must run the DROP/CREATE DATABASE portion while connected to a DIFFERENT database
-- (commonly "postgres"). You cannot drop the database you're currently connected to.


-- Terminate existing connections to target DB
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'dwh_healthcare'
  AND pid <> pg_backend_pid();

-- Drop & recreate database
DROP DATABASE IF EXISTS dwh_healthcare;
CREATE DATABASE dwh_healthcare;
