# Installation of Monitoring Infrastructure with Prometheus and Grafana

## Introduction

1. Apply the installation with: 

    ```
    terraform apply -var 'namespace=monitoring'
    ```

1. Check successful installation of Prometheus with: 

    ```
    kubectl port-forward service/prometheus-server -n monitoring 2000:80
    ```
   
1. Check successful installation of Prometheus Alertmanager with: 

    ```
    kubectl port-forward service/prometheus-alertmanager -n monitoring 4000:80    
    ```
   
1. Check successful installation of Grafana with: 

    ```
    kubectl port-forward service/grafana 3000:80 -n monitoring  
    ```
    Log into Grafana with username "admin". The password can be obtained like this:
    ```
    kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    ```
    
