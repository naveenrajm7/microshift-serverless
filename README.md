# MicroShift Serverless

Attempt to install knative in Microshift



Micorshift          |   |  Knative
:---------------:|:----------:|:-------------------------:
![](img/microshift_logo_white_bg.png) | :heavy_plus_sign: |  ![](img/knative_logo_icon_247901.png)




Platform : [Redhat Microshift](https://github.com/openshift/microshift)  
Source   : [Openshift knative Serving (Mid-stream repo) ](https://github.com/openshift-knative/serving)  
Images   : [Openshift Knative quay repository](https://quay.io/organization/openshift-knative)

## Environment


### Vagrant 

Microshift not supported in RHEL vagrant boxes.

### VirtualBox VM

Configs:
* 2 CPU
* 2 RAM
* Storage
    * 1 Primary Disk for root
    * 1 Secondary Disk for pv of workloads
* Networking 
    * ```NAT``` for internet 
    * ```Host-only``` to connect to VM locally
    * Port forwarding 80 -> 80 ( to reach service from local)
* Installation
    * Minimal Install


See [vbox](microshift.vbox) file for full configuration


### AWS


x86_64 - t3 instance family  
ARM - t4g instance family  


## Provisioning

### Terraform Commands

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


## Installation 
###  Ansible commands 

```bash
ansible-playbook -i 192.168.56.103,  playbook.yml --extra-vars "arch_type=amd64 target_env=local" -kK
```


## Credits

This project was done as part of [LFX Mentorship program - Term 02 Jun-Aug](https://mentorship.lfx.linuxfoundation.org/project/830eb064-cf8a-4a8e-bba3-97d429a6ca79). Check here for project [mid-term](docs/midterm-report.md) report

## Resources

* [RHEL Subs in EC2](https://repost.aws/questions/QUU_yAGxzgRlygZo49LBYQfw/redhat-instances-on-ec2)  
* [RHEL AMI in AWS](https://access.redhat.com/solutions/15356)  
* [Microshift Community Docs](https://github.com/openshift/microshift/blob/main/docs/getting_started.md)
* [Microshift RedHat Docs](https://access.redhat.com/documentation/en-us/red_hat_build_of_microshift/4.12/html/installing/microshift-install-rpm)
* [Knative Serving](https://github.com/knative/serving)
* [Openshift Knative](https://github.com/openshift-knative/serverless-operator)
