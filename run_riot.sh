#!/bin/bash
rm privateKey

#az login --service-principal --username "$TF_VAR_client_id" --password "$TF_VAR_client_secret" --tenant "$TF_VAR_tenant_id"
#az keyvault secret show --name redisgeekr2dwzktholjk6 --vault-name redisgeekr2dwzktholjk6

export EC_HOST=$(terraform output -raw ec | jq -r .address)
export EC_PORT=$(terraform output -raw ec | jq -r .port)

export RIOT_USER=$(terraform output -raw riot | jq -r .user)
export RIOT_HOST=$(terraform output -raw riot | jq -r .host)
export RIOT_BIN=$(terraform output -raw riot | jq -r .program)

export ACRE_HOST=$(terraform output -raw acre | jq -r .host)
export ACRE_REGION=$(terraform output -raw acre | jq -r .region)
export ACRE_PORT=$(terraform output -raw acre | jq -r .port)
export ACRE_FQDN="$ACRE_HOST.$ACRE_REGION.redisenterprise.cache.azure.net"
export ACRE_PASS="5SJChCSOkcql18etjT2Jkna3AwIQmaUdXY6QHwoHhg0="

echo "Executing RIOT via SSH"
touch privateKey
chmod 600 privateKey
terraform output -raw sensitive | jq -r .private_key_pem >> privateKey
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privateKey "$RIOT_USER"@"$RIOT_HOST" "$RIOT_BIN -h $EC_HOST -p $EC_PORT  replicate -h $ACRE_FQDN -p $ACRE_PORT --idle-timeout 10000 --live --tls --no-verify-peer -a $ACRE_PASS"
