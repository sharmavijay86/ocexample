#!/bin/bash

unset VALID
read -p "Enter user: " USER

openssl req -nodes -newkey rsa:2048 -keyout $USER.key -out $USER.csr -subj "/C=IN/ST=Maharashtra/L=Pune/O=Mylab local lan/OU=k8s/CN=$USER" > /dev/null

CSR=$(cat $USER.csr | base64 | tr -d "\n")
cat > csr.yaml <<-EOF
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: $USER
spec:
  groups:
  - system:authenticated
  request: $CSR
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF


kubectl create ns $NS
kubectl apply -f csr.yaml
kubectl certificate approve $USER
CERT=$(kubectl get csr $USER -oyaml | grep " certificate:" | awk -F: '{print $2}')
echo $CERT | base64 -d > $USER.crt
kubectl config set-credentials $USER --client-key=$USER.key --client-certificate=$USER.crt --embed-certs=true --kubeconfig=$USER\_config
kubectl config set-context $USER --cluster=$CLUSTER --user=$USER  --kubeconfig=$USER\_config 
kubectl config use-context $USER  --kubeconfig=$USER\_config 
kubectl config set-context --current --namespace=$NS  --kubeconfig=$USER\_config 
kubectl config delete-context $CLUSTER\-admin@$CLUSTER --kubeconfig=$USER\_config 
kubectl config unset users.$CLUSTER\-admin --kubeconfig=$USER\_config 
kubectl create role $USER\-role --verb=* --resource=pods,deployments,replicasets,service,ingress,statefulsets -n $NS
kubectl create rolebinding $USER\-rolebinding --role=$USER\-role --user=$USER -n $NS
rm csr.yaml $USER.* cluster
PWD=$(pwd)

echo "\n"
NC='\033[0m' # No Color
GREEN='\033[0;32m'
echo -e "${GREEN}###########################################################################"

echo -e "${GREEN}Kubeconfig exported at $PWD with name $USER\_config"
echo -e "${GREEN}Rename it to config and copy it to user home directory at ~./kube to use it"
echo -e "${GREEN}Role and Rolebinding also created for namespace $NS"
echo -e "${GREEN}Thanks :) "

echo -e "${GREEN}###########################################################################${NC}"
