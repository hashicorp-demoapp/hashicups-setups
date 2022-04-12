## Terraform ECS + HCP Consul

This solution deploys HashiCups into AWS ECS while using HCP Consul as the service mesh solution.  This solution is different from [terraform-aws-hcp-ecs](../terraform-aws-hcp-ecs/README.md) as it only uses the HashiCups containers. 

For more details on the Terraform code and required values, read [terraform.md](./Terraform.md).

## Requirements

- Terraform 1.0.0+
- AWS Account
- IAM Permissions to deploy
  - ECS Cluster
  - Secrets Manager Secrets
  - Create IAM ECS Task  roles
  - Deploy a VPC


## AWS & HCP Credentials

To deploy this Terraform configuration you will need to setup your AWS and HCP credentials.


HCP Credentials can be set as ENV variables.

```shell
export HCP_CLIENT_ID=124asfd.....
export HCP_CLIENT_SECRET=4gh48as.... 
```

Next, set your AWS credentials as ENV variables.

```shell
export AWS_ACCESS_KEY_ID=48dafde....
export AWS_SECRET_ACCESS_KEY=wJalas.....
export AWS_DEFAULT_REGION=us-east-1
```

**NOTE**: You may have to set the `AWS_SESSION_TOKEN` if your are consuming credentials from AWS STS.



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