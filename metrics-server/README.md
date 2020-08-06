# Installation of the Metrics Server

1. Install Helm Repository
    ```
    helm repo add stable https://kubernetes-charts.storage.googleapis.com 
    ```
1. Apply terraform file
    ```
    terraform apply -var 'namespace=kube-system'
    ```

