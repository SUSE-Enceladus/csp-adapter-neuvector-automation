#!/bin/bash
set -e
PATH=$PATH:/usr/local/bin

#Deploy cluster
cluster_deploy()
{
  echo "Current dir $PWD"
  echo "Deploying Cluster..."
  terraform init
  terraform plan -input=false
  terraform apply -input=false -auto-approve
}

#######################################################
# Main Program
# Usage: deploy-csp-nv.sh <cloud provider name>
# Example: deploy-csp-nv.sh gke 
########################################################
if (( $# < 1 )); then 
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "Usage: deploy-csp-nv.sh <deployer option>"
    echo "Example: deploy-csp-nv.sh offer" 
    echo "Possible values for deployer option offer helm" 
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    exit 0
fi

cloud_provider=${1}
case "$cloud_provider" in
       (offer)
          cd aks-terraform
          #cluster_deploy
	  var_file="$PWD"/terraform.tfvars
          resource_group_name=$(grep 'resource_group_name' ${var_file} |awk '{ print $3 }'|tr -d '"')
          cluster_name=$(grep 'cluster_name' ${var_file} |awk '{ print $3 }'|tr -d '"')
          extension_name=$(grep 'extension_name' ${var_file} |awk '{ print $3 }'|tr -d '"')
          ext_version=$(grep 'ext_version' ${var_file} |awk '{ print $3 }'|tr -d '"')
          ;;
       (*)
       echo "Invalid cloud provider $cloud_provider "
       ;;
esac


#Install Neuvector
#echo "Add neuvector repo and Install Neuvector.."
#helm repo add neuvector https://neuvector.github.io/neuvector-helm/
#helm install neuvector neuvector/core -n neuvector --create-namespace -f "$PWD"/nv-values.yaml

#Install Neuvector using k8s-extenstion
echo ${extension_name}
echo ${cluster_name}
echo ${resource_group_name}
echo ${ext_version}
az k8s-extension create --name ${extension_name} --cluster-name ${cluster_name} --resource-group ${resource_group_name} --cluster-type managedClusters --version ${ext_version} --extension-type com.suse.neuvector.four --plan-name neuvector4 --plan-publisher suse --plan-product kberger-nv-csp-billing-offer --release-train preview --config-file ../admin_pwd.json

#Wait till all pods are ready 
kubectl wait pod --all --for=condition=Ready --namespace=neuvector --timeout=120s

#List all the pods and service 
kubectl get pods -n neuvector
kubectl get svc -n neuvector
service_ip=$(kubectl get svc --namespace neuvector neuvector-service-webui -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

#print NV dashboard access details
echo "Neuvector and Extension ${ext_version} deployed" 
echo "service_ip and port for neuvector webui access ${service_ip}"
echo "https://${service_ip}:8443"
echo "default login admin"


echo "CSP AdapterUsageRecord"
kubectl get CspAdapterUsageRecord  neuvector-usage -n neuvector -oyaml
