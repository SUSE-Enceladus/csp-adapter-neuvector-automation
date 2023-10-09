#!/bin/bash
set -e
PATH=$PATH:/usr/local/bin

#Destroy aks-cluster
destroy_cluster()
{
    az k8s-extension delete --cluster-name  
                            --name
                            --cluster-type 
                            --resource-group
    terraform destroy -auto-approve
}

#######################################################
# Main Program
# Usage: destroy-csp-nv.sh <cloud provider name>
# Example: destroy-csp-nv.sh gke
########################################################
if (( $# < 1 )); then
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "Usage: destroy-csp-nv.sh <deployer option>"
    echo "Example: destroy-csp-nv.sh offer 
    echo "Possible deployment values are offer helm 
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    exit 0
fi

cloud_provider=${1}
case "$cloud_provider" in
       (offer)
          cd aks-terraform
	  var_file="$PWD"/terraform.tfvars
	  cluster_name=$(grep 'cluster_name' ${var_file} |awk '{ print $3 }'|tr -d '"')
	  resource_group_name=$(grep 'resource_group_name' ${var_file} |awk '{ print $3 }'|tr -d '"')
          extension_name=$(grep 'extension_name' ${var_file} |awk '{ print $3 }'|tr -d '"')
          echo "Destroying extension"
          az k8s-extension delete --cluster-name ${cluster_name} --name ${extension_name} --resource-group ${resource_group_name} --cluster-type managedClusters
          echo "Destroying Cluster"
          terraform destroy -auto-approve
          echo "Destroying Cluster from kubeconfig"
	  kubectl config delete-cluster ${cluster_name}
          echo "Destroying user from kubeconfig"
	  kubectl config delete-user clusterUser_${resource_group_name}_${cluster_name}
          ;;
       (*)
	  echo "Invalid cloud provider $cloud_provider "
          ;;
esac
