
## terraform init state on an Azure VM with managed identity 

**Prerequistes **(Create a linux vm and storage account). Grant the managed identity of the linux VM access to storage account blob contributor and key operator roles.  

```powershell 
https://docs.microsoft.com/en-us/azure/developer/terraform/create-linux-virtual-machine-with-infrastructure


**Terraform initiatialization 

az login --identity
export ARM_USE_MSI=true
RESOURCE_GROUP_NAME=DefaultResourceGroup-EUS2
STORAGE_ACCOUNT_NAME=prreddystorage
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY

terraform init 
Initializing the backend...
container_name
  The container name.

  Enter a value: terraform

key
  The blob key.

  Enter a value: terraform.tfstate

storage_account_name
  The name of the storage account.

  Enter a value: prreddystorage



### forall deployment steps below 

CD into cloned local folder
Update tfvars and variables.tf file
An example tfvar for each component is in the example folder
Terraform apply 

## Deploy Resource Group


## Deploy Networking


## Deploy Azure Firewall 

Note the private ip of the firewall for the routetable terraform step next. 

Update the terraform tfvar file with network and application rules. The cli example is below. 




az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'apiudp' --protocols 'UDP' --source-addresses '*' --destination-addresses "AzureCloud.$LOC" --destination-ports 1194 --action allow --priority 100
az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'apitcp' --protocols 'TCP' --source-addresses '*' --destination-addresses "AzureCloud.$LOC" --destination-ports 9000
az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'time' --protocols 'UDP' --source-addresses '*' --destination-fqdns 'ntp.ubuntu.com' --destination-ports 123

az network firewall application-rule create -g $RG -f $FWNAME --collection-name 'aksfwar' -n 'fqdn' --source-addresses '*' --protocols 'http=80' 'https=443' --fqdn-tags "AzureKubernetesService" --action allow --priority 100




## Deploy RouteTable with vnetlocal 

Use the cli to update the route table for entries that do not have a next hop. The terrafrom will do the initial route to the firewall private ip only. 

az network route-table route create -g aksdemo_rg --name fwinternet --route-table-name aksdemo_routetable --address-prefix 52.184.219.200/32 --next-hop-type Internet

az network route-table route create -g aksdemo_rg --route-table-name aksdemo_routetable -n internalroute --next-hop-type vnetlocal --address-prefix 10.0.0.0/16



## Deploy AKS

AKS will route traffic to Azure firewall private ip.  

## Deploy Linkerd

Add any outbound ports to bypass the linkerd proxy such as mysql and smtp ports in the main.tf 

## Deploy NGINX

## Deploy akv2k8s 
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

#Create a private endpoint from the AKS vnet to keyvault 

#Create a certificate in the key vault using the following documentation 

https://docs.microsoft.com/en-us/azure/key-vault/certificates/quick-create-portal#add-a-certificate-to-key-vault

# provide AAD SP the permission to get certificates
az keyvault set-policy --name $AKV_NAME --object-id 4a01297f-78b2-4e89-937c-bfc05f85b692 --certificate-permissions get
# provide AAD SP the permission to get secrets
az keyvault set-policy --name $AKV_NAME --object-id 4a01297f-78b2-4e89-937c-bfc05f85b692 --secret-permissions get

#Install akv2k8s on AKS using terraform 
terraform init
terraform apply 

#Sync the certificate with a yaml file. Change the name under vault to your specific key vault name.  

apiVersion: spv.no/v1
kind: AzureKeyVaultSecret
metadata:
  name: cert-sync
  namespace: certsync
spec:
  vault:
    name: preastus2-akv
    object:
      name: nginx
      type: certificate
  output:
    secret:
      name: nginx-cert
      type: kubernetes.io/tls
      
# Create namespace and Apply the yaml file 
kubect create namespace certsync
kubectl apply -f synchcert.yaml

# Deploy sample application 
# the sample YAML file
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpbin
  labels:
    app: httpbin
spec:
  replicas: 1
  selector:
    matchLabels:
      app: httpbin
  template:
    metadata:
      labels:
        app: httpbin
    spec:
      containers:
        - name: httpbin
          image: kennethreitz/httpbin
---
apiVersion: v1
kind: Service
metadata:
  name: realtime
  labels:
    app: httpbin
spec:
  selector:
    app: httpbin
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-akv2k8s
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  tls:
  - hosts:
    - helloworld.info
    secretName: nginx-cert
  rules:
  - host: helloworld.info
    http:
      paths:
      - path: /
        backend:
          serviceName: realtime
          servicePort: 80

#Apply the yaml file
kubectl apply -f sampleapp.yaml -n certsync

#Get the ip address of internal ingress controller

kubectl get service --namespace default

#Exec into the kubernetes node 
kubectl debug node/aks-nodepool1-11952318-vmss000000 -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11

#Check the cert 
openssl s_client -connect 192.168.1.6:443 -servername helloword.info -status -tlsextdebug

#Check the ingress service
curl -vk --resolve helloworld.info:443:192.168.1.6 https://helloworld.info

#Create a pls to the kubernetes-internal load balancer and a pe from the client vm, test again using local private endpoint ip

curl -vk --resolve helloworld.info:443:10.0.0.6 https://helloworld.info

```

## Linkerd with mtls verifcation 
```powershell
https://thatdevopsguy.medium.com/introduction-to-linkerd-for-beginners-13e248fa252d

linkerd viz install | kubectl apply -f -

#Inject each deployment with linkerd 

kubectl get deploy httbin-o yaml | linkerd inject - | kubectl apply -f -
kubectl get deploy playlists-db -o yaml | linkerd inject - | kubectl apply -f -
kubectl get deploy videos-api -o yaml | linkerd inject - | kubectl apply -f -
kubectl get deploy videos-db -o yaml | linkerd inject - | kubectl apply -f -
kubectl get deploy videos-web -o yaml | linkerd inject - | kubectl apply -f -
kubectl -n default get deploy nginx-ingress-controller-ingress-nginx-controller -o yaml | linkerd inject - | kubectl apply -f -

#Verify all pods are communicating using mtls 
linkerd viz -n linkerd edges deployment
```


  

