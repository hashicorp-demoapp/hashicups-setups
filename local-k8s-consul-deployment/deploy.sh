#!/bin/zsh

deploy () {
    helm install -f helm/consul-values.yaml consul hashicorp/consul --version "0.23.1" --wait
    kubectl apply -f k8s
}

destroy () {
    kubectl delete -f k8s
}
