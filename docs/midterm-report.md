# LFX Mentorship Mid Term Report
>Porting Knative Serving to Microshift 

This report details the work done as part of LFX Mentorship program for the project ["Porting Knative Serving to Microshift"](https://mentorship.lfx.linuxfoundation.org/project/830eb064-cf8a-4a8e-bba3-97d429a6ca79). The initial goal of this project was to run [Knative Serving](https://knative.dev/docs/serving/) in [Microshift](https://github.com/openshift/microshift) in both x86 and ARM machines. This involved finding out problems when running knative serving in limited resource environment and solving them.


## Initial Analysis

Our target edge K8s platform was Microshift. Microshift is a optimized Openshift for small form factor and edge devices. 
Since Openshift already has Serverless component called **Openshift Serverless** which uses knative. Now there were two ways to go about installing knative in Microshift. 

1. Openshift way  - [Openshift Serverless Docs](https://docs.openshift.com/serverless/1.29/install/preparing-serverless-install.html)   
    OperatorGroup & Subscription (Operators) -> Serverless-Operator -> Knative Serving

2. K8s way  - [knative Docs](https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/)  
    LoadBalancer -> CRDs & Serving Components -> Networking Layer (Kourier) -> DNS (magic DNS)

We choosed to go with Openshift way for two reasons. firstly, we had issues installing serving components directly on microshift. Issue involving security context etc., since microshift (Openshift) has strict security measures in-place. Secondly, From my mentors advice who themselves work on Openshift-Serverless. They made it clear that there were few pacthes applied to knative inorder to fit in Openshift eco-system like security constrains, networking (routes) etc.,

Since we will go with Openshift way, this work can be treated as a Guide to Install Knative in Microshift, let's call **Microshift-Serverless**!

## Installation Requirements

Since we decided to install Knative the Openshift way. I refered to the [Openshift Serverless Docs](https://docs.openshift.com/serverless/1.29/install/preparing-serverless-install.html) and started the installing. But I ran into below error.

```bash
[ec2-user@ip-198-18-60-10 ~]$ oc apply -f serverless-subscription.yaml
namespace/openshift-serverless created
resource mapping not found for name: "serverless-operators" namespace: "openshift-serverless" from "serverless-subscription.yaml": no matches for kind "OperatorGroup" in version "operators.coreos.com/v1"
ensure CRDs are installed first
resource mapping not found for name: "serverless-operator" namespace: "openshift-serverless" from "serverless-subscription.yaml": no matches for kind "Subscription" in version "operators.coreos.com/v1alpha1"
ensure CRDs are installed first
```

From above output it was clear that Microshift does not come with all the components that are present in Openshift. In particular the Microshift does not have Operator Lifecycle Managment (OLM) , the same component which automates the installation of knative in Openshift. 

So now, we had to manually performan all the operation done by Operator. Which involved installing serving components and changing few things like  namespace from ```kourier-system``` to ```knative-serving-ingress```. 

### Manifest 

We used the manifest that the Openshift-Serverless Operator uses from 
[openshift-knative-operator](https://github.com/openshift-knative/serverless-operator/blob/main/openshift-knative-operator/cmd/operator/kodata/knative-serving/1.9/2-serving-core.yaml)  repo. There were two changes that needed to be made for this yaml in order to make it complete and compatible with microshift .  First one, was to replace the `TO_BE_REPLACED` place holder with corresponding image from the mid-stream image repository [openshift-knative](https://quay.io/organization/openshift-knative).
Secondly, we had to reduce the resources of serving component to make it fit in our microshift node of 4 GB RAM and 2 CPU. 

These manifest required no chnages when we deployed in ARM machines. The manifest with all these changes are available [here](../manifest/) as ansible template, so that same yamls can be used for substituting both x84 and ARM images.


### Images 

While we used [openshift-knative](https://quay.io/organization/openshift-knative) quay image registry to get images. The  mid stream repo does not publish multi-arch images which led us to the below error when we tried the same images in ARM microshift.


#### ARM 

```bash
[ec2-user@ip-198-18-60-10 ~]$ oc logs activator-68ffd8dc6b-cd8r6 -n knative-serving 
exec container process `/ko-app/activator`: Exec format error
```


Hence we Built serving images for ARM using the mid-stream repo 
[openshift-knative/serving](https://github.com/openshift-knative/serving/tree/release-v1.10) , so that we get all the patches required for microshift (Openshift). 

For kourier also same process was followed but using mid-stream [kourier repo](https://github.com/openshift-knative/net-kourier/tree/release-v1.9) , and we used ko to build image for arm 
```bash
ko login quay.io -u naveenrajm -p ****
export KO_DOCKER_REPO=quay.io/naveenrajm/net-kourier-controller
ko build --platform=linux/arm64 --bare --tags 'v1.9-arm64' ./cmd/kourier 
```

All ARM images were published in my personal quay repo https://quay.io/user/naveenrajm/.

Now with both deployment manifest and images available. We can move on to deploying knative serving in Microshift 

## Microshift 

Before we deploy knative serving , we need to prepare edge like node and install microshift. 

I have automated the provisioning of node in AWS EC2 using terraform script [main.tf](../main.tf). 

For local setup , since microshift is not supported in vagrant boxes , I was not able to automate. But I have provided [vbox config](../microshift.vbox) .It can be refered to create VM in virtualbox.

Machine requirements for Microshift.
* 2 CPU
* 4 RAM
* Storage
    * 1 Primary Disk for root
    * 1 Secondary Disk for pv of workloads
* Networking 
    * ```NAT``` for internet 
    * ```Host-only``` to connect to VM locally
    * Port forwarding 80 -> 80 ( to reach service from local)
* Installation
    * RHEL 9.2 Minimal Install


I have also automated the Microshift installation using [ansible playbook](../playbook.yml)


```bash
ansible-playbook -i <microshift_vm-ip>,  playbook.yml --extra-vars "arch_type=amd64 target_env=local" -kK
```

## Knative Serving 

Once you log on to the machine after running ansible playbook . You will have all the yamls needed for serving installation as per the machine architecture. 
You just need to apply all the yamls.

```bash
oc apply -f 1-serving-crds.yaml 
oc apply -f 2-serving-core.yaml 
oc apply -f 0-kourier.yaml
```

### Example

```bash
oc apply -f hello.yaml

oc patch configmap/config-domain \
      --namespace knative-serving \
      --type merge \
      --patch '{"data":{"example.com":""}}'

curl -H "Host: hello.default.example.com" http://198.18.60.10 
```