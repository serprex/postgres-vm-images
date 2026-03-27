CREATE USER chpg_console_admin WITH
  CREATEDB
  CREATEROLE
  ADMIN pg_read_all_data, pg_write_all_data, pg_monitor, pg_signal_backend,
    pg_read_all_stats, pg_read_all_settings, pg_checkpoint,
    pg_create_subscription, pg_stat_scan_tables;
GRANT ALL ON DATABASE postgres TO chpg_console_admin;
GRANT ALL ON SCHEMA public TO chpg_console_admin;
ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO chpg_console_admin;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SEQUENCES TO chpg_console_admin;
ALTER DEFAULT PRIVILEGES GRANT ALL ON FUNCTIONS TO chpg_console_admin;
ALTER DEFAULT PRIVILEGES GRANT ALL ON TYPES TO chpg_console_admin;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO chpg_console_admin;

CREATE USER chpg_console_readonly;
GRANT pg_read_all_data TO chpg_console_readonly;
GRANT CONNECT ON DATABASE postgres TO chpg_console_readonly;
GRANT USAGE ON SCHEMA public TO chpg_console_readonly;
