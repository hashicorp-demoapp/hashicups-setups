## SE Getting Hashicups Up and running locally using K8s

In the following walk through you will create an environment to run hashicups locally on your machine. The initial form of this doc is created for linux/macos users. WSL users should still be fine but may have to tweak a couple things here or there. 

### Pre-Reqs

* Install [Docker](https://docs.docker.com/get-docker/)
* Install [Golang](https://golang.org/doc/install) 1.11 or newer and configure your $PATH to make sure it includes ```$GOPATH/bin``` . You can do this easily by adding it in your .zshrc or .bash_profile like so... ```export PATH=$PATH:$(go env GOPATH)/bin``` 
* Install [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/) (What will be used for running small/fast k8s instance)
* Install [Helm](https://helm.sh/docs/intro/install/)
* (RECCOMENDED) I'm using ZSH. This should work with bash as well but you can install zsh using Oh-My-ZSH [here](https://ohmyz.sh/#install)

### Initial Setup Instructions

1. Go to your home directory

```
cd $HOME
```

2. Create github folder if you don't already have one. This folder will be used to download all required hashicups repos. 

```
mkdir github
cd github
```

3. Clone all the necessary repos into the github folder we created earlier, if your using the new ```gh``` cli tool you can do so as follows.
```
gh repo clone hashicorp-demoapp/frontend
gh repo clone hashicorp-demoapp/public-api
gh repo clone hashicorp-demoapp/product-api-go
```

4. If you haven't already clone this repo into your github folder. For the remainder of the tutorial you want to execute these commands from the hashicups-se-setup folder.
```
gh repo clone hashicorp-demoapp/hashicups-se-setup
cd hashicups-se-setup
```

5. Now you should simply be able to install using the run.sh script. You may have to make it executable. 
```
chmod +x run.sh; ./run.sh
```

The script is decomposed into seperate files so you can see the steps and jump into each file as needed to see whats happening. Basically a new kind k8s node is created, consul is deployed to k8s using the helm chart and hashicups is deployed. 

6. Finally you should be able to run the following command and navigate to the hashicups UI via localhost!
```
kubectl port-forward deploy/frontend 8080:80
```
Now navigate to localhost:8080 in your browser and hashicups should appear.


