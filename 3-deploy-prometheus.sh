#!/bin/bash

export KUBECONFIG=`pwd`/k3s.yaml && echo '[Info] setting KUBECONFIG='$KUBECONFIG

echo "[Info] ...installing tiller"
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
curl -LO https://git.io/get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm init --service-account tiller
kubectl rollout status deployment tiller-deploy -n kube-system

sleep 5

echo "[Info] ...installing promehteus 8.13.0 via helm v2"
helm install stable/prometheus-operator --name promo --version=8.13.0

echo "[Info] deploy alertmessages to the alertmanager"
./blackbox-exporter/alertmanager-config.sh

echo "[Info] setup a namespace for separation"
kubectl apply -f example/1-application-ns.yml

echo "[Info] deploy the scrap configuration"
kubectl apply -f example/2-application-deployment-configmap.yml

echo "[Info] deploy the application"
kubectl apply -f example/3-application-deployment.yml

echo "[Info] deploy the service"
kubectl apply -f example/4-application-service.yml

echo "[Info] deploy prometheus alertrule/s"
kubectl apply -f example/5-application-alertrule.yml

echo "[Info] deploy ServiceMonitors to connect the service with prometheues targetservice"
kubectl apply -f example/6-application-service.yml

echo "[Info] deploy grafana config"
kubectl apply -f grafana/grafana-config.sh

# cleanup
rm get_helm.sh

echo '[Hints] alertmanager fails, remember to set a alert url'