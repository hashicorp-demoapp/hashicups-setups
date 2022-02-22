## SE Getting Hashicups Up and running locally using K8s

In the following walkthrough you will create an environment to run HashiCups locally on your machine. 
The initial form of this doc is created for linux/macos users. WSL users should still be fine but may have to tweak a couple things here or there. 

**NOTE** This is deploying HashiCups and Consul in [transparent mode](https://www.consul.io/docs/connect/transparent-proxy).

### Pre-Reqs

* Install [Docker](https://docs.docker.com/get-docker/)
* Install [Helm](https://helm.sh/docs/intro/install/)
* A local Kubernetes cluster. Below are some popular options.
    * [Minikube](https://minikube.sigs.k8s.io/docs/start/)
    * [kind](https://kind.sigs.k8s.io/)
    * [k3s](https://k3s.io/)


## Getting Started

1.  Start your local k8s cluster. This may be kind, minikube, k3s, or any other preferred flavor.

1.  Deploy Consul through Helm or Consul K8s CLI
    1.  Helm:
        ```
        helm install consul hashicorp/consul --values helm/consul-values.yaml --create-namespace --namespace consul --version "0.40.0"
        ```
    2.  Consul K8s CLI:
        ```
        consul-k8s install -config-file=helm/consul-values.yaml -set global.image=hashicorp/consul:1.11.3
        ```
    3. Verify all Consul resources have been created successfully.
        ```
        kubectl get pods -n consul
        ```
2.  Deploy HashiCups. Assumption is that you are in the `local-k8s-consul-deployment/` folder.
    ```
    kubectl apply -f k8s/
    ```
3. Verify all Hashicups resources have been created successfully.
    ```
    kubectl get pods
    ```
4. Expose the HashiCups UI
    ```
    kubectl port-forward deploy/frontend 8080:3000
    ```
5. Visit http://localhost:8080

## Visit Consul UI (Optional)
1. Expose the Consul UI
    ```
    kubectl port-forward pod/consul-server-0 -n consul 8500:8500
    ```
1. Visit http://localhost:8500

## Clean-up

1. Remove all HashiCups resources
    ```
    kubectl delete -f k8s/
    ```
1. Remove all Consul resources
    ```
    helm delete consul
    ```
1. Terminate your local kubernetes cluster.