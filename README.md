### Terraform K3S AWS Cluster

This module supports creating a k3s cluster with a postgres backend in AWS. It allows you to optionally install nginx-ingress, Rancher Server, and cert-manager, or import your K3S cluster into an existing Rancher Server.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| rancher2 | >= 1.10.3 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| aws.r53 | n/a |
| null | n/a |
| rancher2.bootstrap | >= 1.10.3 |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| agent\_image\_id | AMI to use for k3s agent instances | `string` | `null` | no |
| agent\_instance\_ssh\_user | Username for sshing into instances | `string` | `"ubuntu"` | no |
| agent\_instance\_type | n/a | `string` | `"m5.large"` | no |
| agent\_k3s\_exec | exec args to pass to k3s agents | `string` | `null` | no |
| agent\_node\_count | Number of agent nodes to launch | `number` | `3` | no |
| aws\_azs | List of AWS Availability Zones in the VPC | `list(any)` | `null` | no |
| aws\_profile | Name of the AWS Profile to use for authentication | `string` | `null` | no |
| aws\_region | n/a | `string` | `null` | no |
| certmanager\_version | Version of cert-manager to install | `string` | `"1.1.0"` | no |
| create\_external\_nlb | Boolean that defines whether or not to create an external load balancer | `bool` | `true` | no |
| db\_allow\_major\_version\_upgrade | Enable to allow major engine version upgrades when changing engine versions. | `bool` | `true` | no |
| db\_engine\_version | Engine Version for RDS Database | `string` | `"10.11"` | no |
| db\_instance\_type | n/a | `string` | `"db.r5.large"` | no |
| db\_name | Name of database to create in RDS | `string` | `null` | no |
| db\_node\_count | Number of RDS database instances to launch | `number` | `1` | no |
| db\_pass | Password for RDS user | `string` | n/a | yes |
| db\_user | Username for RDS database | `string` | n/a | yes |
| domain | n/a | `string` | `"eng.rancher.space"` | no |
| extra\_agent\_security\_groups | Additional security groups to attach to k3s agent instances | `list(any)` | `[]` | no |
| extra\_server\_security\_groups | Additional security groups to attach to k3s server instances | `list(any)` | `[]` | no |
| install\_certmanager | Boolean that defines whether or not to install Cert-Manager | `bool` | `false` | no |
| install\_k3s\_version | Version of K3S to install | `string` | `"1.19.4+k3s1"` | no |
| install\_nginx\_ingress | Boolean that defines whether or not to install nginx-ingress | `bool` | `false` | no |
| install\_rancher | Boolean that defines whether or not to install Rancher | `bool` | `false` | no |
| k3s\_cluster\_secret | Override to set k3s cluster registration secret | `string` | `null` | no |
| k3s\_datastore\_cafile | Location to download RDS CA Bundle | `string` | `"/srv/rds-combined-ca-bundle.pem"` | no |
| k3s\_datastore\_endpoint | Storage Backend for K3S cluster to use. Valid options are 'sqlite' or 'postgres' | `string` | `"sqlite"` | no |
| k3s\_deploy\_traefik | Configures whether to deploy traefik ingress or not | `bool` | `true` | no |
| k3s\_disable\_agent | Whether to run the k3s agent on the same host as the k3s server | `bool` | `false` | no |
| k3s\_tls\_san | Sets k3s tls-san flag to this value instead of the default load balancer | `string` | `null` | no |
| letsencrypt\_email | LetsEncrypt email address to use | `string` | `"none@none.com"` | no |
| name | Name for deployment | `string` | `"rancher-demo"` | no |
| private\_subnets | List of private subnet ids. | `list(any)` | `[]` | no |
| private\_subnets\_cidr\_blocks | List of cidr\_blocks of private subnets | `list(any)` | `[]` | no |
| public\_subnets | List of public subnet ids. | `list(any)` | `[]` | no |
| public\_subnets\_cidr\_blocks | List of cidr\_blocks of public subnets | `list(any)` | `[]` | no |
| r53\_domain | DNS domain for Route53 zone (defaults to domain if unset) | `string` | `""` | no |
| rancher2\_token\_key | Rancher2 API token for authentication | `string` | `null` | no |
| rancher\_chart | Helm chart to use for Rancher install | `string` | `"rancher-stable/rancher"` | no |
| rancher\_password | Password to set for admin user during bootstrap of Rancher Server | `string` | `""` | no |
| rancher\_version | Version of Rancher to install | `string` | `"2.5.3"` | no |
| rds\_ca\_cert\_identifier | The identifier of the CA certificate for the DB instance. | `string` | `"rds-ca-2019"` | no |
| registration\_command | Registration command to import cluster into Rancher. Should not be used when installing Rancher in this same cluster | `string` | `""` | no |
| server\_image\_id | AMI to use for k3s server instances | `string` | `null` | no |
| server\_instance\_ssh\_user | Username for sshing into instances | `string` | `"ubuntu"` | no |
| server\_instance\_type | n/a | `string` | `"m5.large"` | no |
| server\_k3s\_exec | exec args to pass to k3s server | `string` | `null` | no |
| server\_node\_count | Number of server nodes to launch | `number` | `1` | no |
| skip\_final\_snapshot | Boolean that defines whether or not the final snapshot should be created on RDS cluster deletion | `bool` | `true` | no |
| ssh\_keys | SSH keys to inject into Rancher instances | `list(any)` | `[]` | no |
| subdomain | subdomain to host rancher on, instead of using `var.name` | `string` | `null` | no |
| use\_route53 | Configures whether to use route\_53 DNS or not | `bool` | `true` | no |
| vpc\_id | The vpc id that Rancher should use | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| external\_lb\_dns\_name | n/a |
| k3s\_cluster\_secret | n/a |
| rancher\_admin\_password | n/a |
| rancher\_token | n/a |
| rancher\_url | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# License

Copyright (c) 2014-2019 [Rancher Labs, Inc.](http://rancher.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
