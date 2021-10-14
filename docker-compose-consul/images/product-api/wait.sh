#!/bin/sh
# Wait for postgres

set -e
  
until psql postgres://postgres:password@product-db:5432/products?sslmode=disable  -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

echo "Postgres is availabe"