# MicroShift Serverless

Attempt to install knative in Microshift

## AWS

x86_64 - t3 instance family  
ARM - t4g instance family  

## Vagrant 

Microshift not supported in RHEL vagrant boxes, failed with errors


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

## Ansible commands 

```bash
ansible-playbook -i <public-ip>, playbook.yml 
```

## Resources

* [RHEL Subs in EC2](https://repost.aws/questions/QUU_yAGxzgRlygZo49LBYQfw/redhat-instances-on-ec2)  
* [RHEL AMI in AWS](https://access.redhat.com/solutions/15356)  
* [Microshift Community Docs](https://github.com/openshift/microshift/blob/main/docs/getting_started.md)
* [Microshift RedHat Docs](https://access.redhat.com/documentation/en-us/red_hat_build_of_microshift/4.12/html/installing/microshift-install-rpm)
* [Knative Serving](https://github.com/knative/serving)
* [Openshift Knative](https://github.com/openshift-knative/serverless-operator)
