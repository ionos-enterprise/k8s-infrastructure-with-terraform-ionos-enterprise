# Installation des K8s Dashboard

1. Install Helm Repository
    ```
    helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
    ```
1. Apply terraform file
    ```
    terraform apply -var 'namespace=kube-system' 
    ```
1. Open the dashboard UI with:
    ```
    http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:https/proxy/#/overview?namespace=default
    ```
1. Find the Token of the admin user to login to the UI with the command:
    ```
    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
    ```


