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

## Installation  

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

We used the manifest that the Openshift-Serverless Operator uses  
[openshift-knative-operator](https://github.com/openshift-knative/serverless-operator/blob/main/openshift-knative-operator/cmd/operator/kodata/knative-serving/1.9/2-serving-core.yaml)




### Images 



#### ARM 

```bash
[ec2-user@ip-198-18-60-10 ~]$ oc logs activator-68ffd8dc6b-cd8r6 -n knative-serving 
exec container process `/ko-app/activator`: Exec format error
```


Built ARM images using the mid-stream repo 
[openshift-knative/serving](https://github.com/openshift-knative/serving/tree/release-v1.10) , so that we get all the patches. 