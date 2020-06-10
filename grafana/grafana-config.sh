#!/bin/sh
kubectl delete secret promo-grafana --namespace=default

sleep 5

kubectl apply -f ./grafana/grafana-config.yaml
