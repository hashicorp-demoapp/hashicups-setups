#!/bin/bash

if [ $SERVICE != product-db ]; then
   mkdir -p /opt/consul
   echo "Starting Consul..."
   nohup consul agent -config-dir=/config/ > /tmp/consul.out 2>&1 &
fi

if [ $SERVICE == payments ]; then
 echo "Starting the payment application..."
  java -jar /bin/spring-boot-payments-0.0.12.jar > /spring_boot.out 2>&1 &
  sleep 3
  echo "Registering the service..."
  if [ consul services register /tmp/svc_payments.hcl ]; then
      if [ $SECONDARY == false ]; then 
         consul config write /tmp/payments.hcl
         nohup consul connect envoy -sidecar-for $SERVICE > /tmp/proxy.log 2>&1
      else
         consul config write /tmp/payments.hcl
         nohup consul connect envoy -sidecar-for ${SERVICE}-secondary > /tmp/proxy.log 2>&1
      fi
      
   else 
      sleep 2
      consul services register /tmp/svc_payments.hcl
      consul config write /tmp/payments.hcl
        if [ $SECONDARY == false ]; then 
         nohup consul connect envoy -sidecar-for $SERVICE > /tmp/proxy.log 2>&1
         else
            nohup consul connect envoy -sidecar-for ${SERVICE}-secondary > /tmp/proxy.log 2>&1
        fi
        
  fi
  
fi


if [ $SERVICE == public-api ]; then
 echo "Starting the Public-API application..."
   nohup /bin/public-api > /api.out 2>&1 &
   sleep 3

   if [ consul services register /config/svc_public_api.hcl ]; then
      consul config write /tmp/default-intentions.hcl
         if [ $SECONDARY == false ]; then 
            consul config write /tmp/public-api.hcl
            nohup consul connect envoy -sidecar-for $SERVICE > /tmp/proxy.log 2>&1
         else
            consul config write /tmp/public-api.hcl
            nohup consul connect envoy -sidecar-for ${SERVICE}-secondary > /tmp/proxy.log 2>&1
         fi
   else
      sleep 2
      consul services register /config/svc_public_api.hcl
      consul config write /tmp/default-intentions.hcl
      consul config write /tmp/public-api.hcl
      if [ $SECONDARY == false ]; then 
         nohup consul connect envoy -sidecar-for $SERVICE > /tmp/proxy.log 2>&1
      else
         nohup consul connect envoy -sidecar-for ${SERVICE}-secondary > /tmp/proxy.log 2>&1
      fi
   fi
   

fi


if [ $SERVICE == product-api ]; then
   echo "Starting the Product-API application..."
    if [ $SECONDARY == false ]; then
         if [ consul services register /config/svc_product_api.hcl ]; then
            nohup /bin/product-api > /api.out 2>&1 &
            consul config write /tmp/product-api.hcl
            nohup consul connect envoy -sidecar-for $SERVICE > /tmp/proxy.log 2>&1 
         else 
            sleep 1
            consul services register /config/svc_product_api.hcl
            nohup /bin/product-api > /api.out 2>&1 &
            consul config write /tmp/product-api.hcl
            nohup consul connect envoy -sidecar-for $SERVICE > /tmp/proxy.log 2>&1 
         fi
    fi


    if [ $SECONDARY == true ]; then
         if [ consul services register /config/svc_product_api.hcl ]; then
            nohup /bin/product-api > /api.out 2>&1 &
            consul config write /tmp/product-api.hcl
            nohup consul connect envoy -sidecar-for $SERVICE > /tmp/proxy.log 2>&1 
         else 
            sleep 1
            echo "echo after secondary sleep"
            consul services register /config/svc_product_api.hcl
            nohup /bin/product-api > /api.out 2>&1 &
            consul config write /tmp/product-api.hcl
            nohup consul connect envoy -sidecar-for ${SERVICE}-secondary > /tmp/proxy.log 2>&1 
         fi

    fi
fi

if [ $SERVICE == product-db ]; then

   if [ $SECONDARY == false ]; then
      sudo mv /tmp/pg_hba.conf /var/lib/postgresql/data/
      # Killing postgress
      echo "Terminating postgress..."
      pkill postgres
      sleep 3
      echo "Starting postgres DB.."
      nohup postgres 2>&1 &
      echo "Starting Consul..."
      sudo mkdir -p /opt/consul
      sudo nohup consul agent -config-dir=/config/ > /tmp/consul.out 2>&1 &
      echo "Registering the service..."
      sleep 2
      echo "Populate table.."
      
         if [ psql postgres://postgres:password@localhost:5432/products?sslmode=disable -f /docker-entrypoint-initdb.d/products.sql ]; then
               consul services register /tmp/svc_db.hcl
               consul config write /tmp/product-db.hcl
               sudo nohup consul connect envoy -sidecar-for $SERVICE > /tmp/proxy.log 2>&1 
         else
            sleep 2
            psql postgres://postgres:password@localhost:5432/products?sslmode=disable -f /docker-entrypoint-initdb.d/products.sql
            consul services register /tmp/svc_db.hcl
            consul config write /tmp/product-db.hcl
            sudo nohup consul connect envoy -sidecar-for $SERVICE > /tmp/proxy.log 2>&1 
         fi

   fi

   if [ $SECONDARY == true ]; then
      # Killing postgress
      echo "Terminating postgress..."
      pkill postgres
      sleep 3
      echo "Starting postgres DB.."
      rm -rfv tmp/data/
      mkdir tmp/data/
      su - postgres -c '/usr/lib/postgresql/13/bin/initdb -D tmp/data/'
      sudo cp tmp/pg_hba.conf tmp/data/
      su - postgres -c '/usr/lib/postgresql/13/bin/pg_ctl -D tmp/data/ start 2>&1 &'
      echo "Starting Consul..."
      sudo mkdir -p /opt/consul
      sudo nohup consul agent -config-dir=/config/ > /tmp/consul.out 2>&1 &
      echo "Registering the service..."
      sleep 2
      echo "Populate table.."
      psql postgres://postgres:password@0.0.0.0:5432?sslmode=disable -f /docker-entrypoint-initdb.d/products.sql

      echo "Starting Consul service"
      consul services register /tmp/svc_db.hcl
      consul config write /tmp/product-db.hcl
      sudo nohup consul connect envoy -sidecar-for ${SERVICE}-secondary > /tmp/proxy.log 2>&1
   fi


fi

if [ $SERVICE == frontend ]; then
  echo "Starting the Frontend application..."
  sleep 3
  if [ -f /tmp/svc_frontend_secondary.hcl ]; then
      consul services register /tmp/svc_frontend_secondary.hcl && \
      consul config write /tmp/frontend_secondary.hcl
   else
      echo "In primary"
      consul services register /tmp/svc_frontend.hcl && \
      consul config write /tmp/frontend.hcl
  fi
   
   if [ $SECONDARY == false ]; then 
      nohup consul connect envoy -sidecar-for $SERVICE > /tmp/proxy.log 2>&1 &
   else
      nohup consul connect envoy -sidecar-for ${SERVICE}-secondary > /tmp/proxy.log 2>&1 &
   fi

sleep 1
echo "Starting nginx...."
nginx
while true; do sleep 1; done 

fi

