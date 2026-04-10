CREATE USER chpg_console_admin WITH CREATEDB CREATEROLE;
GRANT pg_read_all_data, pg_write_all_data, pg_monitor, pg_signal_backend,
    pg_read_all_stats, pg_read_all_settings, pg_checkpoint,
    pg_create_subscription, pg_stat_scan_tables
  TO chpg_console_admin WITH ADMIN OPTION;
GRANT ALL ON DATABASE postgres TO chpg_console_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA public TO chpg_console_admin WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO chpg_console_admin WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SEQUENCES TO chpg_console_admin WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON FUNCTIONS TO chpg_console_admin WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON TYPES TO chpg_console_admin WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO chpg_console_admin WITH GRANT OPTION;

CREATE USER chpg_console_readonly;
GRANT pg_read_all_data TO chpg_console_readonly;
GRANT CONNECT ON DATABASE postgres TO chpg_console_readonly;
GRANT USAGE ON SCHEMA public TO chpg_console_readonly;
