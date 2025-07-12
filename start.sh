#!/bin/bash

# Inicia PostgreSQL
service postgresql start

# Espera un momento para asegurar que PostgreSQL esté completamente levantado
sleep 3

# Cambia contraseña del usuario postgres
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '12303122';"

# Crea usuario "user"
sudo -u postgres psql -c "DO \$\$ BEGIN IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'user') THEN CREATE ROLE \"user\" WITH LOGIN PASSWORD '12303122'; END IF; END \$\$;"

# Modifica pg_hba.conf y postgresql.conf para aceptar conexiones remotas
PG_CONF_DIR=$(find /etc/postgresql -name pg_hba.conf | xargs dirname)
sed -i "s/^#listen_addresses =.*/listen_addresses = '*'/g" "$PG_CONF_DIR/postgresql.conf"
sed -i "s/peer/md5/g" "$PG_CONF_DIR/pg_hba.conf"
sed -i "s/scram-sha-256/md5/g" "$PG_CONF_DIR/pg_hba.conf"
echo "host    all             all             0.0.0.0/0               md5" >> "$PG_CONF_DIR/pg_hba.conf"

# Reinicia PostgreSQL con la nueva configuración
service postgresql restart

# Ejecuta el servidor SSH en primer plano
exec /usr/sbin/sshd -D