#!/bin/bash
rm -rf privateKey

export IDLE_TIMEOUT=10000

export EC_HOST=$(terraform output -raw ec | jq -r '.address')
export EC_PORT=$(terraform output -raw ec | jq -r '.port')

export RIOT_USER=$(terraform output -raw riot | jq -r '.user')
export RIOT_HOST=$(terraform output -raw riot | jq -r '.host')
export RIOT_BIN=$(terraform output -raw riot | jq -r '.program')

export ACRE_HOST=$(terraform output -raw acre | jq -r '.host')
export ACRE_PORT=$(terraform output -raw acre | jq -r '.port')
export ACRE_PASS=$(terraform output -raw acre | jq -r '.access_key')

echo "Executing RIOT via SSH"
touch privateKey
chmod 600 privateKey
terraform output -raw sensitive | jq -r .private_key_pem >> privateKey
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privateKey "$RIOT_USER"@"$RIOT_HOST" "$RIOT_BIN -h $EC_HOST -p $EC_PORT  replicate -h $ACRE_HOST -p $ACRE_PORT --idle-timeout $IDLE_TIMEOUT --mode live --tls -a $ACRE_PASS"
rm -rf privateKey
