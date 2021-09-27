#!/bin/zsh

build () {
    (cd ../product-api-go && make build_linux)

    docker build -t product-api:local ../product-api-go

    kind load docker-image product-api:local --name hashicups

    (cd ../public-api && make build_linux)

    docker build -t public-api:local ../public-api

    kind load docker-image public-api:local --name hashicups
}