
## Allow additional outbound ports to bypass linkerd proxy
```powershell

#Clone the repo and cd to the aks_linkerd folder 

cd aks_linkerd

#Open the main.tf file 

vi main.tf 

#Go to line 81 

Declare any additional variable ports such as a myql port in variables.tf and add in the value field of line 81. This allows these outbound ports to bypass the linkerd proxy. 

  set {
    name  = "proxyInit.ignoreOutboundPorts"
    type  = "string"
    value = "443\\,${var.bastion_proxy_port_number},${var.mysql_port_number}"
  }
  
 #Update cluster name and resource group in variables.tf  
  
 #Run terraform commands to apply linkerd changes to cluster
 
 terraform init
 terraform apply  
```


## Kubernetes upgrade with zero downtime using temporary node pool
```powershell
# Start with a kubernetes cluster of 2 nodes, running version 1.19.1 
kubectl get nodes

#Output of command below 
#aks-nodepool1-11952318-vmss000000   Ready    agent   54d   v1.19.1
#aks-nodepool1-11952318-vmss000003   Ready    agent   54d   v1.19.1

#Export resource group and cluster name 

export APP_PREFIX=preastus2
export RESOURCE_GROUP=$APP_PREFIX"-aksdemo-rg"
export CLUSTER_NAME=$APP_PREFIX"-aksdemo-aks"

#Create a temporary second nodepool 
az aks nodepool add --resource-group $RESOURCE_GROUP --cluster-name $CLUSTER_NAME --node-vm-size Standard_DS2_v2 --name internal --node-count 2

#Show the nodes with the additional nodepool 
kubectl get nodes 

#aks-internal-11952318-vmss000000    Ready    agent   7m20s   v1.21.2
#aks-internal-11952318-vmss000001    Ready    agent   7m18s   v1.21.2
#aks-nodepool1-11952318-vmss000000   Ready    agent   54d     v1.19.1
#aks-nodepool1-11952318-vmss000003   Ready    agent   54d     v1.19.1

#Drain the nodes in the first node pool. All services will move over to temporary second nodepool  
kubectl drain aks-nodepool1-11952318-vmss000000 --ignore-daemonsets 
kubectl drain aks-nodepool1-11952318-vmss000003 --ignore-daemonsets 

#Get upgrade versions 
az aks get-upgrades --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME

#Pick a version and upgrade the control plane 
az aks upgrade --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --kubernetes-version 1.21.2 --control-plane-only

#After control plane upgrade, upgrade the first node pool 
az aks nodepool upgrade --resource-group $RESOURCE_GROUP --cluster-name $CLUSTER_NAME --kubernetes-version 1.21.2 --name default

#Uncordon the nodes in the node pool default and drain each node in node pool internal 
kubectl uncordon aks-nodepool1-11952318-vmss000000
kubectl uncrodon aks-nodepool1-11952318-vmss000000
kubectl drain aks-internal-11952318-vmss000000
kubectl drain aks-internal-11952318-vmss000001

#Make the system the default node pool and delete the temporary internal node pool 
$ az aks nodepool update --resource-group $RESOURCE_GROUP --cluster-name $CLUSTER_NAME --name default --mode System

$ az aks nodepool delete --resource-group $RESOURCE_GROUP --cluster-name $CLUSTER_NAME --name internal
# Start with a kubernetes cluster of 2 nodes, running version 1.19.1 
kubectl get nodes

#Output of command below 
#aks-nodepool1-11952318-vmss000000   Ready    agent   54d   v1.19.1
#aks-nodepool1-11952318-vmss000003   Ready    agent   54d   v1.19.1

#Export resource group and cluster name 

export APP_PREFIX=preastus2
export RESOURCE_GROUP=$APP_PREFIX"-aksdemo-rg"
export CLUSTER_NAME=$APP_PREFIX"-aksdemo-aks"

#Create a second nodepool 
az aks nodepool add --resource-group $RESOURCE_GROUP --cluster-name $CLUSTER_NAME --node-vm-size Standard_DS2_v2 --name internal --node-count 2

#Show the nodes with the additional nodepool 
kubectl get nodes 

#aks-internal-11952318-vmss000000    Ready    agent   7m20s   v1.21.2
#aks-internal-11952318-vmss000001    Ready    agent   7m18s   v1.21.2
#aks-nodepool1-11952318-vmss000000   Ready    agent   54d     v1.19.1
#aks-nodepool1-11952318-vmss000003   Ready    agent   54d     v1.19.1

#Drain the nodes in the first node pool 
kubectl drain aks-nodepool1-11952318-vmss000000 --ignore-daemonsets 
kubectl drain aks-nodepool1-11952318-vmss000003 --ignore-daemonsets 

#Get upgrade versions 
az aks get-upgrades --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME

#Pick a version and upgrade the control plane 
az aks upgrade --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --kubernetes-version 1.21.2 --control-plane-only

#After control plane upgrade, upgrade the first node pool 
az aks nodepool upgrade --resource-group $RESOURCE_GROUP --cluster-name $CLUSTER_NAME --kubernetes-version 1.21.2 --name default

#Uncordon the nodes in the node pool default and drain each node in node pool internal 
kubectl uncordon aks-nodepool1-11952318-vmss000000
kubectl uncrodon aks-nodepool1-11952318-vmss000000
kubectl drain aks-internal-11952318-vmss000000
kubectl drain aks-internal-11952318-vmss000001

#Make the system the default node pool and delete the temporary internal node pool 
$ az aks nodepool update --resource-group $RESOURCE_GROUP --cluster-name $CLUSTER_NAME --name default --mode System

$ az aks nodepool delete --resource-group $RESOURCE_GROUP --cluster-name $CLUSTER_NAME --name internal
```

## Certificates with Azure Key Vault and nginx ingress controller 

```powershell 
#get the AKS associated service principal

export APP_PREFIX=preastus2
export RESOURCE_GROUP=$APP_PREFIX"-aksdemo-rg"
export CLUSTER_NAME=$APP_PREFIX"-aksdemo-aks"
az aks show -g $RESOURCE_GROUP -n $CLUSTER_NAME | grep identityProfile -A 5

#Note the objectid output from above 

#Create an azure key vault 
export AKV_NAME=$APP_PREFIX"-akv"
export LOCATION=eastus2
az keyvault create -g $RESOURCE_GROUP -l $LOCATION -n $AKV_NAME

#Create a certificate in the key vault using the following documentation 

https://docs.microsoft.com/en-us/azure/key-vault/certificates/quick-create-portal#add-a-certificate-to-key-vault

# provide AAD SP the permission to get certificates
az keyvault set-policy --name $AKV_NAME --object-id 4a01297f-78b2-4e89-937c-bfc05f85b692 --certificate-permissions get
# provide AAD SP the permission to get secrets
az keyvault set-policy --name $AKV_NAME --object-id 4a01297f-78b2-4e89-937c-bfc05f85b692 --secret-permissions get
```



  

