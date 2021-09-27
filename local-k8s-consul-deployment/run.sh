#!/bin/zsh

source ./build.sh
source ./deploy.sh

destroy

kind delete cluster --name hashicups

kind create cluster --name hashicups

build
deploy

