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
