#!/bin/bash

%{ if is_k3s_server }
curl -o ${storage_cafile} https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem
%{ endif }

until (curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION='v${install_k3s_version}' INSTALL_K3S_EXEC='${k3s_exec}' K3S_CLUSTER_SECRET='${k3s_cluster_secret}'%{ if !is_k3s_server } K3S_URL='https://${k3s_url}:6443' K3S_STORAGE_CAFILE='${storage_cafile}'%{ endif } sh -); do
  echo 'k3s did not install correctly'
  sleep 2
done

until kubectl get pods -A | grep 'Running';
do
  echo 'Waiting for k3s startup'
  sleep 5
done
