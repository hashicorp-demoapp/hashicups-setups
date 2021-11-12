#!/bin/bash

export BOUNDARY_ADDR=$(cd ../infrastructure && terraform output -raw boundary_endpoint)

mkdir -p secrets/
vault read hashicups/database/creds/boundary -format=json > secrets/boundary.json

boundary authenticate password -login-name=developer \
		-password $(cd ../boundary && terraform output -raw boundary_products_password) \
		-auth-method-id=$(cd ../boundary && terraform output -raw boundary_auth_method_id)

export PGPASSWORD=$(cat secrets/boundary.json | jq -r .data.password)

boundary connect postgres \
		-target-id $(cd ../boundary && terraform output -raw boundary_target_postgres) \
		-dbname products -username $(cat secrets/boundary.json | jq -r .data.username) \
        -- -f products.sql