#!/bin/sh
kubectl delete secret alertmanager-promo-prometheus-operator-alertmanager --namespace=default

sleep 5

kubectl create secret generic alertmanager-promo-prometheus-operator-alertmanager --from-file=./blackbox-exporter/alertmanager.yaml --namespace=default 
kubectl label secret alertmanager-promo-prometheus-operator-alertmanager app=prometheus-operator-alertmanager --namespace=default
kubectl label secret alertmanager-promo-prometheus-operator-alertmanager release=promo --namespace=default

# for debuging set the loglevel of the alertmanager to debug and take a look at the logs