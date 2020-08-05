# Installation of Log Aggregation with Elastic Search, Kibana & Fluentd

## Introduction

1. Install Custom Resource Definitions, RBAC rights and Validating Webhooks for Elastic Search

    ```
    kubectl apply -f https://download.elastic.co/downloads/eck/1.1.1/all-in-one.yaml
    ```
   
1. Install Elastic Search, Kibana & Fluentd + some configuration.:

    ```
   terraform apply -var 'namespace=monitoring'
    ```
   
1. Give it a couple of minutes and check the end result with:

    ```
    kubectl port-forward -n monitoring service/elastic-kb-http 5601
    kubectl get secret elastic-es-elastic-user -n monitoring -o=jsonpath='{.data.elastic}' | base64 --decode; echo
    ```