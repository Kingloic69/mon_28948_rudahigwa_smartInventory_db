CREATE PLUGGABLE DATABASE mon_28948_rudahigwa_smartInventory_db
ADMIN USER admin_user IDENTIFIED BY rudahigwa
FILE_NAME_CONVERT = ('/pdbseed/', '/mon_28948_rudahigwa_smartInventory_db/');

ALTER PLUGGABLE DATABASE mon_28948_rudahigwa_smartInventory_db OPEN;

ALTER SESSION SET CONTAINER = mon_28948_rudahigwa_smartInventory_db;

CREATE TABLESPACE inventory_data
DATAFILE 'inventory_data01.dbf' SIZE 500M
AUTOEXTEND ON NEXT 100M MAXSIZE 2G
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE inventory_index
DATAFILE 'inventory_index01.dbf' SIZE 200M
AUTOEXTEND ON NEXT 50M MAXSIZE 1G
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TEMPORARY TABLESPACE inventory_temp
TEMPFILE 'inventory_temp01.dbf' SIZE 100M
AUTOEXTEND ON NEXT 50M MAXSIZE 500M;

CREATE UNDO TABLESPACE inventory_undo
DATAFILE 'inventory_undo01.dbf' SIZE 200M
AUTOEXTEND ON NEXT 50M MAXSIZE 1G;

CREATE USER inventory_user
IDENTIFIED BY rudahigwa
DEFAULT TABLESPACE inventory_data
TEMPORARY TABLESPACE inventory_temp
QUOTA UNLIMITED ON inventory_data
QUOTA UNLIMITED ON inventory_index;

GRANT CONNECT, RESOURCE TO inventory_user;
GRANT CREATE SESSION TO inventory_user;
GRANT CREATE TABLE TO inventory_user;
GRANT CREATE SEQUENCE TO inventory_user;
GRANT CREATE PROCEDURE TO inventory_user;
GRANT CREATE TRIGGER TO inventory_user;
GRANT CREATE VIEW TO inventory_user;
GRANT CREATE SYNONYM TO inventory_user;

SELECT name, open_mode FROM v$pdbs WHERE name = 'MON_28948_RUDAHIGWA_SMARTINVENTORY_DB';

SELECT tablespace_name, status, contents FROM dba_tablespaces 
WHERE tablespace_name LIKE 'INVENTORY%';

SELECT username, default_tablespace, temporary_tablespace 
FROM dba_users 
WHERE username = 'INVENTORY_USER';
