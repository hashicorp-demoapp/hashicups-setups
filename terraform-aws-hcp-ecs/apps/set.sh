#!/bin/bashå

export VAULT_ADDR=$(cd ../infrastructure && terraform output -raw hcp_vault_public_endpoint)
export VAULT_TOKEN=$(cd ../infrastructure && terraform output -raw hcp_vault_admin_token)
export VAULT_NAMESPACE=$(cd ../infrastructure && terraform output -raw hcp_vault_namespace)

export CONSUL_HTTP_ADDR=$(cd ../infrastructure && terraform output -raw hcp_consul_public_endpoint)
export CONSUL_HTTP_TOKEN=$(cd ../infrastructure && terraform output -raw hcp_consul_root_token)


mkdir -p secrets/
vault read hashicups/database/creds/product -format=json > secrets/product.json