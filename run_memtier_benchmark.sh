#!/bin/bash
rm -rf ./privateKey

export EC_HOST=$(terraform output -raw ec | jq -r '.address')
export EC_PORT=$(terraform output -raw ec | jq -r '.port')

export MEMTIER_USER=$(terraform output -raw memtier | jq -r '.user')
export MEMTIER_HOST=$(terraform output -raw memtier | jq -r '.host')
export MEMTIER_BIN=$(terraform output -raw memtier | jq -r '.program')

echo "Executing Memtier Benchmark via SSH - Random Keys - 50:1 - 60s"
touch privateKey
chmod 600 privateKey
terraform output -raw sensitive | jq -r .private_key_pem >> privateKey
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privateKey "$MEMTIER_USER"@"$MEMTIER_HOST" "nohup $MEMTIER_BIN -s $EC_HOST -p $EC_PORT --randomize -R --ratio=50:1 --test-time=60 > /dev/null 2>&1 &" 
rm -rf privateKey
