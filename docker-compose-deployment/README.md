## Docker Compose Local Setup

This deploys HashiCups locally through Docker Compose. HashiCups is unsecured by default. If you are looking for a secure version of HashiCups please see the folder [docker-compose-consul](../docker-compose-consul/README.md)


## Deploying HashiCups
Navigate to this folder using your cli and run 

```
docker compose up -d
```

## Clean-up

To clean up and remove the HashiCups resources use the command below.

```
docker compose down
```

