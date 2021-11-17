#!/bin/bash

export VAULT_ADDR=$(cd ../infrastructure && terraform output -raw hcp_vault_public_endpoint)
export VAULT_TOKEN=$(cd ../infrastructure && terraform output -raw hcp_vault_admin_token)
export VAULT_NAMESPACE=$(cd ../infrastructure && terraform output -raw hcp_vault_namespace)