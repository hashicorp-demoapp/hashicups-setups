#!/bin/bash

cd apps && terraform destroy -auto-approve
cd ../vault && terraform destroy -auto-approve
cd ../boundary && terraform destroy -auto-approve

cd ..

export VAULT_ADDR=$(cd infrastructure && terraform output -raw hcp_vault_public_endpoint)
export VAULT_TOKEN=$(cd infrastructure && terraform output -raw hcp_vault_admin_token)
export VAULT_NAMESPACE=$(cd infrastructure && terraform output -raw hcp_vault_namespace)
vault lease revoke -f -prefix hashicups/database/creds

cd infrastructure && terraform destroy -auto-approve

cd ..

rm -rf apps/secrets/ database/secrets/