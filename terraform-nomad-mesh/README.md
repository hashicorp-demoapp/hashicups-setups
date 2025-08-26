## Terraform Nomad + Consul Connect

This solution deploys HashiCups into Nomad while using Consul Connect(services communicates via sidecar proxy) and Ingres Gateway. 

## Requirements

- Terraform
- Nomad
- Consul with connect enabled

## Deploy Terraform

Create your own `terraform.tfvars` file to get started.

```shell
touch terraform.tfvars
```

Copy the valus from the `terraform.tfvars.example` file over to your `terraform.tfvars` file. Make changes as you see fit.

Next, initialize the terraform directory.

```shell
terraform init
```

To preview the changes, issue the command `terraform plan`


Lastly, to deploy the solution issue the command below.


```
terraform apply -auto-approve
```


## Clean-up

To remove all resources issue the command below.

```
terraform destroy -auto-approve
```