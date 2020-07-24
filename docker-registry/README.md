# Installation of Docker Registry with external domain and TLS

## Introduction

The installation is mostly automated with Terraform leveraging the Kubernetes and Helm providers.

However, there are still a couple of installation steps that have to get processed on-by-one:

1. Installation of Customer Resource Definitions for the Cert-Manager:

    ```
    kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager.crds.yaml
    ```
   
1. Adding the Helm Repository of the Cert-Manager:

    ```
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    ```
   
1. Generating an encrypted password for the Docker Registry:

    ```
    docker run --entrypoint htpasswd --rm registry:2.6.2 -Bbn [your-docker-registry-username] [your-docker-registry-password] 
    ```
   
1. Install everything else

    ```
    terraform apply \
        -var 'acme-email=[your-acme-registered-email]' \
        -var 'docker-registry-username=[your-docker-registry-username]' \
        -var 'docker-registry-password=[your-docker-registry-password]' \
        -var 'docker-registry-password-encrypted=[your-docker-registry-encrypted-password]' \
        -var 'docker-registry-domain=[your-docker-registry-domain]'
    ```
  
1. Configure your default Service Account to use the new Docker registry.  

    ```
    kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "docker-registry-dockerconfig"}]}'
    ```
