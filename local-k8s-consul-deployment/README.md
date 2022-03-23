## SE Getting Hashicups Up and running locally using K8s

In the following walk through you will create an environment to run HashiCups locally on your machine. 
The initial form of this doc is created for linux/macos users. WSL users should still be fine but may have to tweak a couple things here or there. 

**NOTE** This is deploying HashiCups and Consul in a non-transparent mode.

### Pre-Reqs

* Install [Docker](https://docs.docker.com/get-docker/)
* Install [Helm](https://helm.sh/docs/intro/install/)
* A local Kubernetes cluster. Below are some popular options.
    * [Mikube](https://minikube.sigs.k8s.io/docs/start/)
    * [kind](https://kind.sigs.k8s.io/)
    * [k3s](https://k3s.io/)


## Getting Started

1.  Start your local k8s cluster. This may be kind, minikube, k3s, or any other prefered flavor.

1.  Deploy Consul through the [Consul K8s CLI](https://www.consul.io/docs/k8s/k8s-cli).
    ```
    consul-k8s install -config-file=helm/consul-values.yaml -set global.image=hashicorp/consul:1.11.4
    ```
1.  Deploy HashiCups. Assumption is that you are in the `local-k8s-consul-deployment/` folder.
    ```
    kubectl apply -f k8s/
    ```
1. Expose the HashiCups UI
    ```
    kubectl port-forward deploy/nginx 3000:80
    ```
1. Visit http://localhost:8080

## Visit Consul UI (Optional)
1. Expose the Consul UI
    ```
    kubectl port-forward pods/consul-server-0 8500:8500 --namespace consul
    ```
1. Visit http://localhost:8500

## Clean-up

1. Remove all HashiCups resources
    ```
    kubectl delete -f k8s/
    ```
1. Remove all Consul resources
    ```
    consul-k8s uninstall
    ```
1. Terminate you local kubernetes cluster.