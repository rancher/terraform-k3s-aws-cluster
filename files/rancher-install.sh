#!/bin/bash
%{ if install_certmanager }
kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
sleep 5
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v${certmanager_version}/cert-manager-no-webhook.yaml

until [ "$(kubectl get pods --namespace cert-manager |grep Running|wc -l)" = "2" ]; do
  sleep 2
done

%{ endif }

%{ if install_rancher }
cat <<EOF > /var/lib/rancher/k3s/server/manifests/rancher.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: cattle-system
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: rancher
  namespace: kube-system
spec:
  chart: https://releases.rancher.com/server-charts/latest/rancher-${rancher_version}.tgz
  targetNamespace: cattle-system
  valuesContent: |-
    hostname: ${rancher_hostname}
    ingress:
      tls:
        source: letsEncrypt
    letsEncrypt:
      email: ${letsencrypt_email}
EOF
%{ endif }
