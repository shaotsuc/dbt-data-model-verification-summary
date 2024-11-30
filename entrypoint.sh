#!/usr/bin/env bash

echo "Running \"$1\""

case "$1" in
build-db)
  until pg_isready -h postgres -d verification -U admin; do
    echo "Waiting for database to startup..."
    sleep 1
  done
  psql -h postgres -d verification -U admin -f ../sql/setup.sql

  num_rows=$(psql -h postgres -d verification -U admin -t -A -X -q -c "select count(1) from prod.roles;")

  if [ "$num_rows" -gt 0 ]; then
    echo "Database already populated."
  else
    psql -h postgres -d verification -U admin -c "\copy prod.roles FROM '../data/roles.csv' DELIMITER ',' CSV"
    psql -h postgres -d verification -U admin -c "\copy prod.employees FROM '../data/employees.csv' DELIMITER ',' CSV"
    psql -h postgres -d verification -U admin -c "\copy prod.regions FROM '../data/regions.csv' DELIMITER ',' CSV"
    psql -h postgres -d verification -U admin -c "\copy prod.countries FROM '../data/countries.csv' DELIMITER ',' CSV"
    psql -h postgres -d verification -U admin -c "\copy crm.account_managers FROM '../data/account_managers.csv' DELIMITER ',' CSV"
    psql -h postgres -d verification -U admin -c "\copy crm.accounts FROM '../data/accounts.csv' DELIMITER ',' CSV"
    psql -h postgres -d verification -U admin -c "\copy prod.clients FROM '../data/clients.csv' DELIMITER ',' CSV"
    psql -h postgres -d verification -U admin -c "\copy prod.verification_sessions FROM '../data/verification_sessions.csv' DELIMITER ',' CSV"
    psql -h postgres -d verification -U admin -c "\copy prod.documents FROM '../data/documents.csv' DELIMITE