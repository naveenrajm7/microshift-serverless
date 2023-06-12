# MicroShift

Attempt to install microshift

## AWS

RHEL 8.7 on t3.small
with 10 GB disk
AMI ami-08900fdabfe86d539


[Community Docs](https://github.com/openshift/microshift/blob/main/docs/getting_started.md)

[RedHat Docs](https://access.redhat.com/documentation/en-us/red_hat_build_of_microshift/4.12/html/installing/microshift-install-rpm)



## Vagrant 

Not supported , failed with errors




## Terraform Commands

```bash
# first , to get all needed modules
terraform init   
# Nicely format all tf files
terraform fmt 
# To validate configs
terraform validate 
# To create infra
terraform apply  
# To destroy infra
terraform destroy

ssh -i priv.cer ec2-user@<public-ip>
```

## RHEL on AWS

[RHEL Subs in EC2](https://repost.aws/questions/QUU_yAGxzgRlygZo49LBYQfw/redhat-instances-on-ec2)
[RHEL AMI in AWS](https://access.redhat.com/solutions/15356)