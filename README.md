## Deploy AKS cluster with Azure Firewall 
```powershell 
#Set configuration variables 
PREFIX="aks-egress"
RG="${PREFIX}-rg"
LOC="eastus"
PLUGIN=azure
AKSNAME="${PREFIX}"
VNET_NAME="${PREFIX}-vnet"
AKSSUBNET_NAME="aks-subnet"
# DO NOT CHANGE FWSUBNET_NAME - This is currently a requirement for Azure Firewall.
FWSUBNET_NAME="AzureFirewallSubnet"
FWNAME="${PREFIX}-fw"
FWPUBLICIP_NAME="${PREFIX}-fwpublicip"
FWIPCONFIG_NAME="${PREFIX}-fwconfig"
FWROUTE_TABLE_NAME="${PREFIX}-fwrt"
FWROUTE_NAME="${PREFIX}-fwrn"
FWROUTE_NAME_INTERNET="${PREFIX}-fwinternet"

#Create a virtual network with multiple subnets
# Create Resource Group

az group create --name $RG --location $LOC
# Dedicated virtual network with AKS subnet

az network vnet create \
    --resource-group $RG \
    --name $VNET_NAME \
    --location $LOC \
    --address-prefixes 10.42.0.0/16 \
    --subnet-name $AKSSUBNET_NAME \
    --subnet-prefix 10.42.1.0/24

# Dedicated subnet for Azure Firewall (Firewall name cannot be changed)

az network vnet subnet create \
    --resource-group $RG \
    --vnet-name $VNET_NAME \
    --name $FWSUBNET_NAME \
    --address-prefix 10.42.2.0/24
    
#Create and set up an Azure Firewall with a UDR

az network public-ip create -g $RG -n $FWPUBLICIP_NAME -l $LOC --sku "Standard"
# Install Azure Firewall preview CLI extension

az extension add --name azure-firewall

# Deploy Azure Firewall

az network firewall create -g $RG -n $FWNAME -l $LOC --enable-dns-proxy true
# Configure Firewall IP Config

az network firewall ip-config create -g $RG -f $FWNAME -n $FWIPCONFIG_NAME --public-ip-address $FWPUBLICIP_NAME --vnet-name $VNET_NAME

# Capture Firewall IP Address for Later Use

FWPUBLIC_IP=$(az network public-ip show -g $RG -n $FWPUBLICIP_NAME --query "ipAddress" -o tsv)
FWPRIVATE_IP=$(az network firewall show -g $RG -n $FWNAME --query "ipConfigurations[0].privateIpAddress" -o tsv)

# Create a UDR with hop to firewall

az network route-table create -g $RG -l $LOC --name $FWROUTE_TABLE_NAME
az network route-table route create -g $RG --name $FWROUTE_NAME --route-table-name $FWROUTE_TABLE_NAME --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance --next-hop-ip-address $FWPRIVATE_IP --subscription $SUBID
az network route-table route create -g $RG --name $FWROUTE_NAME_INTERNET --route-table-name $FWROUTE_TABLE_NAME --address-prefix $FWPUBLIC_IP/32 --next-hop-type Internet

# Add FW Network Rules

az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'apiudp' --protocols 'UDP' --source-addresses '*' --destination-addresses "AzureCloud.$LOC" --destination-ports 1194 --action allow --priority 100
az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'apitcp' --protocols 'TCP' --source-addresses '*' --destination-addresses "AzureCloud.$LOC" --destination-ports 9000
az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'time' --protocols 'UDP' --source-addresses '*' --destination-fqdns 'ntp.ubuntu.com' --destination-ports 123

# Add FW Application Rules

az network firewall application-rule create -g $RG -f $FWNAME --collection-name 'aksfwar' -n 'fqdn' --source-addresses '*' --protocols 'http=80' 'https=443' --fqdn-tags "AzureKubernetesService" --action allow --priority 100

# Associate route table with next hop to Firewall to the AKS subnet

az network vnet subnet update -g $RG --vnet-name $VNET_NAME --name $AKSSUBNET_NAME --route-table $FWROUTE_TABLE_NAME

# Create SP and Assign Permission to Virtual Network

az ad sp create-for-rbac -n "${PREFIX}sp" --skip-assignment

SUBNETID=$(az network vnet subnet show -g $RG --vnet-name $VNET_NAME --name $AKSSUBNET_NAME --query id -o tsv)

az aks create -g $RG -n $AKSNAME -l $LOC \
  --node-count 3 --generate-ssh-keys \
  --network-plugin $PLUGIN \
  --outbound-type userDefinedRouting \
  --service-cidr 10.41.0.0/16 \
  --dns-service-ip 10.41.0.10 \
  --docker-bridge-address 172.17.0.1/16 \
  --vnet-subnet-id $SUBNETID \
  --enable-managed-identity  \
  --enable-private-cluster \
  

```
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



  

