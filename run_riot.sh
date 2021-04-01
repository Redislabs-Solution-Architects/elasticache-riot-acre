#!/bin/bash
mkfifo -m=600 privateKey

export EC_HOST=$(terraform output -raw ec | jq -r .host)
export EC_PORT=$(terraform output -raw ec | jq -r .port)

export RIOT_USER=$(terraform output -raw riot | jq -r .user)
export RIOT_HOST=$(terraform output -raw riot | jq -r .host)
export RIOT_BIN=$(terraform output -raw riot | jq -r .program)

export ACRE_HOST=$(terraform output -raw acre | jq -r .host)
export ACRE_REGION=$(terraform output -raw acre | jq -r .region)
export ACRE_PORT=$(terraform output -raw acre | jq -r .port)
export ACRE_FQDN="$ACRE_HOST.$ACRE_REGION.redisenterprise.cache.azure.net"
export ACRE_PASS=

terraform output -raw sensitive | jq -r .private_key_pem >privateKey
ssh -i privateKey /
    "$RIOT_USER"@"$RIOT_HOST" /
    "$RIOT_BIN -h $EC_HOST -p $EC_PORT  replicate -h $ACRE_FQDN -p $ACRE_PORT --idle-timeout 10000 --live --tls --no-verify-peer -a $ACRE_PASS"
