Migrating between [Elasticache] and [Azure Cache for Redis Enterprise (ACRE)] is easy using [RIOT]

This module provides a simple, end to end demonstration of the process.

# Architecture
The system architecture is shown below:

![System Architecture](http://www.plantuml.com/plantuml/png/LOynQmCn38Lt_mfnUpBSc24aX0wP2g5xqSdAsVHi5rbU6lhV6nb3sqMWXxxtdavLKRIbpUNY6IQc-Q22ztiaM3cpe1QP02le2WydJ8fvtHWI9uqixmjd2WdbmsxIuhxTS1BsiK8jJOZ1BzF3ULHSi3BmXbKZ8GKsYicet_mKLq6D9KCeLNju2d-pRzVNDrCb5ZNKqLQQ1_ngml0OJkU-NIna-jVyVBcz68qa_AIDTsc1dSJTqRhK6c3VFlT7U_a0yspAFAGKki8qxdi5PnEUMxViZrzpZMlGGNNznDctjFq0)

(Thanks to [plantuml] for the simple drawings)

The EC2 instances are identical except for the software installed. They use the same ssh key, _default_ VPC, security group etc. etc.

You will need to use the three access points:
- ssh-memtier: run the `memtier_benchmark` traffic generator to generate load into the elasticache databse
- ssh-riot: run the `riot-redis` tool to migrate data from elasticache to ACRE
- redisInsight: run [RedisInsight] to see the keys in ACRE

Connection instructions for these are printed out when you run Terraform (although there is an [issue](#issues) which means not everything is automated, unfortunately).

# Use Instructions
## Setup
### RedisInsight
Ensure you have access to [RedisInsight] - this will be the tool for looking at the ACRE database.

### Terraform
For AWS these terraform variables are required

- `region`: 
- `linux_ami`: 
- `ssh_key_name`: 
- `security_group_id`: 

You need the following secrets:

ENVIRONMENT VARIABLES:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

For Azure these terraform variables are required:

- `tenant_id`: Tenant ID
- `subscription_id`: Subscription ID (also known as Application ID)
- `client_id`: Client ID (aka Service Principal)
- `client_secret` Client Secret: 

If you're doing this locally then the following module definition can be used (filling in for missing values, of course!)
```
module "ec2acre" {
  source = "github.com/Redislabs-Solution-Architects/terraform_aws_azure_ec_to_acre_demo"
  region = 
  linux_ami = 
  instance_type = 
  ssh_key_name = 
  security_group_id =
  subscription_id = 
  client_id = 
  client_secret = 
  tenant_id = 
}
```

Then execute

```
terraform init
```

## Creation
```
terraform apply
```



After you have approved this will take around 15 minutes to complete and will spit out several outputs as shown here (your actual values will differ!):

```
redis_insight-Host = "redisgeek-7l0j.eastus.redisenterprise.cache.azure.net"
redis_insight-Password = "Value must be retrieved by going to Azure Resource Manager, searching for redisgeek-7l0j and selecting the 'Access Keys'}"
redis_insight-Port = 10000
run_memtier = "ssh -i ~/.ssh/toby-kp.pem ec2-user@44.192.49.207 '/usr/local/bin/memtier_benchmark -s source.m5xbzg.0001.use1.cache.amazonaws.com -p 6379'"
run_riot = "ssh -i ~/.ssh/toby-kp.pem ec2-user@3.237.20.67 '/usr/local/bin/riot-redis -h source.m5xbzg.0001.use1.cache.amazonaws.com -p 6379  replicate -h redisgeek-7l0j.eastus.redisenterprise.cache.azure.net -p 10000 --idle-timeout 10000 --live --tls --no-verify-peer -a PASSWORD'"
```

(Note that the `ssh` strings include single quotes `'` - you'll need these to avoid shell parsing issues, so make sure you cut/paste correctly!)

## Operation
Use the `redis_insight_*` outputs to add the ACRE DB to [RedisInsight]. Note that the `redis_insight_Password` is a string containing instructions for how to obtain the password you'll need to access the ACRE DB, and which you'll need for both [RedisInsight] as well as to replace the `PASSWORD` value in the `run_riot` string.

Then use the command strings for `run_memtier` and `run_riot` in separate terminals to pump data into the EC database and have RIOT copy that live to the ACRE DB. (Remember: replace `PASSWORD` with the ACRE password you obtained above!).

You should see the keys etc in [RedisInsight]

You can flush the ACRE DB and repeat; you can run memtier and RIOT in any order you choose. So long as traffic is generated within 10 seconds of starting RIOT then you should have success

## Teardown
- Remove the ACRE DB from [RedisInsight] manually
- Delete the infrastructure using terraform:
```
terraform destroy
```


# Issues
- [Issue 14420] prevents us from automating retrieval of the ACRE DB password
- Requires user to have already setup a default VPC and a subnet. 
- Security Group requires ssh access by user, access from EC2 instances to Elasticache, and egress
- Minimal permissions to run this template are not specified

[Elasticache]: https://aws.amazon.com/elasticache/
[RIOT]: https://developer.redislabs.com/riot/riot-redis.html
[Azure Cache for Redis Enterprise (ACRE)]: https://azuremarketplace.microsoft.com/en-us/marketplace/apps/garantiadata.redis_enterprise_1sp_public_preview?ocid=redisga_redislabs_cloudpartner_cta1
[ACRE]: https://azuremarketplace.microsoft.com/en-us/marketplace/apps/garantiadata.redis_enterprise_1sp_public_preview?ocid=redisga_redislabs_cloudpartner_cta1
[plantuml]: http://www.plantuml.com
[AWS provider]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
[Azure provider]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
[RedisInsight]: https://redislabs.com/redis-enterprise/redis-insight
[Issue 14420]: https://github.com/Azure/azure-sdk-for-go/issues/14420
