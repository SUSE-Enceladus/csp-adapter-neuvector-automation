### csp-adapter-neuvector-automation 
CSP Billing Adapter Neuvector Automation

This repo contains deployment of Azure CSP Biilling Adapter NeuVector offer deployment.

### Cluster Deployment using Terraform script
-Provision Azure Kubernetes Service - AKS cluster 


### Install NeuVector and CSP adaptor extension

After cloning this repo
```
$ cd aks-terraform 
$ cp terrafrom.template.tfvars terrafrom.tfvars
Update terraform.tfvars values 


By default admin password is set to "Password1234".
To change the password, Edit admin_pwd.json and change the password.


Run deploy-csp-nv.sh <deployer option>
$ cd ..
$ ./deploy-csp-nv.sh offer 

To destroy delete extension, cluster and remove cluster from kube config
Run destroy-csp-nv.sh
$ cd ..
$ ./destro-csp-nv.sh offer
