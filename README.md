
# terraform-aws-alb
A Terraform module containing common configurations for an AWS new style Load
Balancer (ALB/NLB). Available through the [terraform registry](https://registry.terraform.io/modules/devops-workflow/lb/aws).

**NOTE:** There has been significant changes to the upstream module and this README has not been updated yet.

| Branch | Build status |
| --- | --- |
| master | [![CircleCI](https://circleci.com/gh/devops-workflow/terraform-aws-lb.svg?style=svg)](https://circleci.com/gh/devops-workflow/terraform-aws-lb) |
| master (upstream) | [![TravisCI](https://travis-ci.org/terraform-aws-modules/terraform-aws-alb.svg?branch=master)](https://travis-ci.org/terraform-aws-modules/terraform-aws-alb) |

## Assumptions
* You want to create a set of resources for the ALB: namely an associated target group and listener.
* You've created a Virtual Private Cloud (VPC) + subnets where you intend to put
this ALB.
* You have one or more security groups to attach to the ALB.
* You want to configure a listener for HTTPS/HTTP
* You've uploaded an SSL certificate to AWS IAM if using HTTPS

The module supports both (mutually exclusive):
* Internal IP ALBs
* External IP ALBs

It's recommended you use this module with [terraform-aws-vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws),
[terraform-aws-security-group](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws), and
[terraform-aws-autoscaling](https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/).

## Why ALB instead of ELB?
The use-case presented here appears almost identical to how one would use an ELB
but we inherit a few bonuses by moving to ALB. Those are best outlined in [AWS's
documentation](https://aws.amazon.com/elasticloadbalancing/applicationloadbalancer/).
For an example of using ALB with ECS look no further than the [hashicorp example](https://github.com/terraform-providers/terraform-provider-aws/blob/master/examples/ecs-alb).

## Resources, inputs, outputs
[Resources](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws?tab=resources), [inputs](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws?tab=inputs), and [outputs](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws?tab=outputs) documented in the terraform registry.

## Usage example
A full example leveraging other community modules is contained in the [examples/test_fixtures directory](https://github.com/terraform-aws-modules/terraform-aws-alb/tree/master/examples/test_fixtures). Here's the gist of using it via the Terraform registry:
```
module "alb" {
  source                        = "terraform-aws-modules/alb/aws"
  alb_name                      = "my-alb"
  region                        = "us-east-2"
  alb_security_groups           = ["sg-edcd9784", "sg-edcd9785"]
  vpc_id                        = "vpc-abcde012"
  subnets                       = ["subnet-abcde012", "subnet-bcde012a"]
  alb_protocols                 = ["HTTPS"]
  certificate_arn               = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
  create_log_bucket             = true
  enable_logging                = true
  log_bucket_name               = "logs-us-east-2-123456789012"
  log_location_prefix           = "my-alb-logs"
  health_check_path             = "/"

  tags {
    "Terraform" = "true"
    "Env"       = "${terraform.workspace}"
  }
}
```
3. Always `terraform plan` to see your change before running `terraform apply`.
4. Win the day!

## Testing
This module has been packaged with [awspec](https://github.com/k1LoW/awspec) tests through test kitchen. To run them:
1. Install [rvm](https://rvm.io/rvm/install) and the ruby version specified in the [Gemfile](https://github.com/terraform-aws-modules/terraform-aws-alb/tree/master/Gemfile).
2. Install bundler and the gems from our Gemfile:
```
gem install bundler; bundle install
```
3. Ensure your AWS environment is configured (i.e. credentials and region) for test and set TF_VAR_region to a valid AWS region (e.g. `export TF_VAR_region=${AWS_REGION}`).
4. Test using `kitchen test` from the root of the repo.

## Contributing
Report issues/questions/feature requests on in the [Issues](https://github.com/terraform-aws-modules/terraform-aws-alb/issues) section.

Pull requests are welcome! Ideally create a feature branch and issue for every
individual change made. These are the steps:

1. Fork the repo to a personal space or org.
2. Create your feature branch from master (`git checkout -b my-new-feature`).
4. Commit your awesome changes (`git commit -am 'Added some feature'`).
5. Push to the branch (`git push origin my-new-feature`).
6. Create a new Pull Request and tell us about your changes.

## IAM Permissions
Testing and using this repo requires a minimum set of IAM permissions. Test permissions
are listed in the [test_fixtures README](https://github.com/terraform-aws-modules/terraform-aws-alb/tree/master/examples/test_fixtures/README.md).

## Change log
The [changelog](https://github.com/terraform-aws-modules/terraform-aws-alb/tree/master/CHANGELOG.md) captures all important release notes.

## Authors
Created and maintained by [Brandon O'Connor](https://github.com/brandoconnor) - brandon@atscale.run.
Many thanks to [the contributers listed here](https://github.com/terraform-aws-modules/terraform-aws-alb/graphs/contributors)!

## License
MIT Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-alb/tree/master/LICENSE) for full details.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM GRAPH HOOK -->

### Resource Graph of plan

![Terraform Graph](resource-plan-graph.png)
<!-- END OF PRE-COMMIT-TERRAFORM GRAPH HOOK -->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Suffix name with additional attributes (policy, role, etc.) | list | `<list>` | no |
| backend\_port | The port the service on the EC2 instances listen on. | string | `"80"` | no |
| backend\_protocol | The protocol the backend service speaks. Options: HTTP, HTTPS, TCP, SSL (secure tcp). | string | `"HTTP"` | no |
| bucket\_policy | An S3 bucket policy to apply to the log bucket. If not provided, a minimal policy will be generated from other variables. | string | `""` | no |
| certificate\_additional\_names | List of additional names of SSL Certificates to look up in ACM and use | list | `<list>` | no |
| certificate\_name | The name of the default SSL Certificate to look up in ACM and use | string | `""` | no |
| component | TAG: Underlying, dedicated piece of service (Cache, DB, ...) | string | `"UNDEF-LB"` | no |
| cookie\_duration | If load balancer connection stickiness is desired, set this to the duration in seconds that cookie should be valid (e.g. 300). Otherwise, if no stickiness is desired, leave the default. | string | `"0"` | no |
| create\_log\_bucket | Create the S3 bucket (named with the log_bucket_name var) and attach a policy to allow LB logging. | string | `"false"` | no |
| delimiter | Delimiter to be used between `name`, `namespaces`, `attributes`, etc. | string | `"-"` | no |
| enable\_cross\_zone\_load\_balancing | Enable cross-zone load balancing on NLB | string | `"false"` | no |
| enable\_deletion\_protection | Enable deletion protection. Prevent LB from being deleted | string | `"false"` | no |
| enable\_http2 | Enable HTTP/2 on ALB | string | `"true"` | no |
| enable\_logging | Enable the LB to write log entries to S3. | string | `"false"` | no |
| enabled | Set to false to prevent the module from creating anything | string | `"true"` | no |
| environment | Environment (ex: `dev`, `qa`, `stage`, `prod`). (Second or top level namespace. Depending on namespacing options) | string | n/a | yes |
| force\_destroy\_log\_bucket | If set to true and if the log bucket already exists, it will be destroyed and recreated. | string | `"false"` | no |
| health\_check\_healthy\_threshold | Number of consecutive positive health checks before a backend instance is considered healthy. | string | `"3"` | no |
| health\_check\_interval | Interval in seconds on which the health check against backend hosts is tried. | string | `"10"` | no |
| health\_check\_matcher | The HTTP codes that are a success when checking TG health. | string | `"200-299"` | no |
| health\_check\_path | The URL the ELB should use for health checks. e.g. /health | string | `"/"` | no |
| health\_check\_port | The port used by the health check if different from the traffic-port. | string | `"traffic-port"` | no |
| health\_check\_protocol | The protocol used by the health check. | string | `"HTTP"` | no |
| health\_check\_timeout | Seconds to leave a health check waiting before terminating it and calling the check unhealthy. | string | `"5"` | no |
| health\_check\_unhealthy\_threshold | Number of consecutive positive health checks before a backend instance is considered unhealthy. | string | `"3"` | no |
| idle\_timeout | The time in seconds that the connection is allowed to be idle | string | `"60"` | no |
| instance\_http\_ports | Backend HTTP instance (target group) ports | string | `""` | no |
| instance\_https\_ports | Backend HTTPS instance (target group) ports | string | `""` | no |
| instance\_tcp\_ports | Backend TCP instance (target group) ports | string | `""` | no |
| internal | Boolean determining if the LB is internal or externally facing. | string | `"true"` | no |
| lb\_http\_ports | Frontend HTTP listener ports | string | `""` | no |
| lb\_https\_ports | Frontend HTTPS listener ports | string | `""` | no |
| lb\_protocols | The protocols the LB accepts. e.g.: ["HTTP"] | list | `<list>` | no |
| lb\_tcp\_ports | Frontend TCP listener ports | string | `""` | no |
| log\_bucket\_name | S3 bucket for storing LB access logs. To create the bucket "create_log_bucket" should be set to true. | string | `""` | no |
| log\_location\_prefix | S3 prefix within the log_bucket_name under which logs are stored. | string | `""` | no |
| monitor | TAG: Should resource be monitored | string | `"UNDEF-LB"` | no |
| name | Base name for resource | string | n/a | yes |
| namespace-env | Prefix name with the environment. If true, format is: <env>-<name> | string | `"true"` | no |
| namespace-org | Prefix name with the organization. If true, format is: <org>-<env namespaced name>. If both env and org namespaces are used, format will be <org>-<env>-<name> | string | `"false"` | no |
| organization | Organization name (Top level namespace) | string | `""` | no |
| owner | TAG: Owner of the service | string | `"UNDEF-LB"` | no |
| ports | Default port set. Used fo all instance and LB port sets that are not defined | string | `"80"` | no |
| product | TAG: Company/business product | string | `"UNDEF-LB"` | no |
| security\_groups | The security groups with which we associate the LB. e.g. ["sg-edcd9784","sg-edcd9785"] | list | `<list>` | no |
| security\_policy | The security policy if using HTTPS externally on the LB. See: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html | string | `"ELBSecurityPolicy-2016-08"` | no |
| service | TAG: Application (microservice) name | string | `"UNDEF-LB"` | no |
| subnets | A list of subnets to associate with the LB. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f'] | list | n/a | yes |
| tags | A map of additional tags | map | `<map>` | no |
| target\_group\_only | Only create target group without a load balancer. For when more advanced LB setups are required | string | `"false"` | no |
| target\_type | Type for targets for target group. Can be: instance or ip | string | `"instance"` | no |
| team | TAG: Department/team of people responsible for service | string | `"UNDEF-LB"` | no |
| type | Type of load balancer. (`application` or `network`) | string | `"application"` | no |
| vpc\_id | VPC id where the LB and other resources will be deployed. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of the LB itself. Useful for debug output, for example when attaching a WAF. |
| arn\_suffix | ARN suffix of the LB itself. Useful for debug output, for example when attaching a WAF. |
| dns\_name | The DNS name of the LB presumably to be used with a friendlier CNAME. |
| id | The ID of the LB we created. |
| listener\_arns | ARNs of all the LB Listeners |
| listener\_http\_arns | The ARNs of the HTTP LB Listeners |
| listener\_http\_ids | The IDs of the HTTP LB Listeners |
| listener\_https\_arns | The ARNs of the HTTPS LB Listeners |
| listener\_https\_ids | The IDs of the HTTPS LB Listeners |
| listener\_ids | IDs of all the LB Listeners |
| listener\_tcp\_arns | The ARNs of the network TCP LB Listeners |
| listener\_tcp\_ids | The IDs of the network TCP LB Listeners |
| principal\_account\_id | The AWS-owned account given permissions to write your LB logs to S3. |
| target\_group\_arns | ARNs of all the target groups. Useful for passing to your Auto Scaling group module. |
| target\_group\_arns\_suffix | ARNs suffix of all the target groups. Useful for passing to your Auto Scaling group module. |
| target\_group\_http\_arns | ARNs of the HTTP target groups. Useful for passing to your Auto Scaling group module. |
| target\_group\_http\_ids | IDs of the HTTP target groups |
| target\_group\_https\_arns | ARNs of the HTTPS target groups. Useful for passing to your Auto Scaling group module. |
| target\_group\_https\_ids | IDs of the HTTPS target groups |
| target\_group\_ids | IDs of all the target groups |
| target\_group\_tcp\_arns | ARNs of the TCP target groups. Useful for passing to your Auto Scaling group module. |
| target\_group\_tcp\_ids | IDs of the TCP target groups |
| zone\_id | The zone_id of the LB to assist with creating DNS records. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
