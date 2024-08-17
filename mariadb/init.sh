#!/bin/sh

# Create a new MySQL user for mysqld-exporter with a password set from MYSQLD_EXPORTER_PASSWORD environment variable
# see https://github.com/prometheus/mysqld_exporter?tab=readme-ov-file#required-grants
mariadb \
  --user="root" \
  --password="${MARIADB_ROOT_PASSWORD}" \
  --execute="
    CREATE USER 'exporter'@'%' 
      IDENTIFIED BY '${MYSQLD_EXPORTER_PASSWORD}' 
      WITH MAX_USER_CONNECTIONS 3;
"

mariadb \
  --user="root" \
  --password="${MARIADB_ROOT_PASSWORD}" \
  --execute="
    GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* 
      TO 'exporter'@'%';
"
