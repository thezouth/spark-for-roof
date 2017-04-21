#!/bin/bash
INSTANCE_NUMS=5

# Create a Cluster in East Asia Data Center

az group create -n sparkling-dc2 -l eastasia

az network nsg create --resource-group sparkling-dc2 --name sparkling-nsg --location eastasia

az network nsg rule create --resource-group sparkling-dc2 --nsg-name sparkling-nsg \
    --name ssh-rule --access Allow --protocol TCP  --direction Inbound --priority 100 \
    --source-address-prefix Internet --source-port-range "*" \
    --destination-address-prefix "*" --destination-port-range 22

az network nsg rule create --resource-group sparkling-dc2 --nsg-name sparkling-nsg \
    --name jupyter-notebook-rule --access Allow --protocol TCP --direction Inbound --priority 200 \
    --source-address-prefix Internet --source-port-range "*" \
    --destination-address-prefix "*" --destination-port-range 8888

az network nsg rule create --resource-group sparkling-dc2 --nsg-name sparkling-nsg \
    --name spark-ui-rule --access Allow --protocol TCP  --direction Inbound --priority 300 \
    --source-address-prefix Internet --source-port-range "*" \
    --destination-address-prefix "*" --destination-port-range 4040

az network nsg rule create --resource-group sparkling-dc2 --nsg-name sparkling-nsg \
    --name spark-master-rule --access Allow --protocol TCP  --direction Inbound --priority 400 \
    --source-address-prefix Internet --source-port-range "*" \
    --destination-address-prefix "*" --destination-port-range 8080

for i in `seq 1 $INSTANCE_NUMS`
do
    az vm create --resource-group sparkling-dc2 --name sparkling0$i --image /subscriptions/4af4ecb6-4432-406b-b13e-c585c5d85178/resourceGroups/SPARKLING-SPRINT3R/providers/Microsoft.Compute/images/MyImage \
        --admin-username sprint3r --ssh-key-value ./ssh_keys/id_rsa.pub --storage-sku Standard_LRS \
        --size Standard_F4 --public-ip-address-dns-name dc2a-sparkl0ing$i --nsg sparkling-nsg --no-wait
done