

Openshift Way:
OperatorGroup & Subscription (Operators) -> Serverless-Operator -> Knative Serving

K8s way:
LoadBalancer -> CRDs & Serving Components -> Networking Layer (Kourier) -> DNS (magic DNS)


Operator in Microshift

Error
```bash
[ec2-user@ip-198-18-60-10 ~]$ oc apply -f serverless-subscription.yaml
namespace/openshift-serverless created
resource mapping not found for name: "serverless-operators" namespace: "openshift-serverless" from "serverless-subscription.yaml": no matches for kind "OperatorGroup" in version "operators.coreos.com/v1"
ensure CRDs are installed first
resource mapping not found for name: "serverless-operator" namespace: "openshift-serverless" from "serverless-subscription.yaml": no matches for kind "Subscription" in version "operators.coreos.com/v1alpha1"
ensure CRDs are installed first
```





```bash

# Metal LB issue

Events:
  Type     Reason        Age                  From                  Message
  ----     ------        ----                 ----                  -------
  Warning  FailedCreate  40s (x17 over 6m8s)  daemonset-controller  Error creating: pods "speaker-" is forbidden: unable to validate against any security context constraint: [provider "anyuid": Forbidden: not usable by user or serviceaccount, provider restricted-v2: .spec.securityContext.hostNetwork: Invalid value: true: Host network is not allowed to be used, spec.containers[0].securityContext.capabilities.add: Invalid value: "NET_RAW": capability may not be added, spec.containers[0].securityContext.hostNetwork: Invalid value: true: Host network is not allowed to be used, spec.containers[0].securityContext.containers[0].hostPort: Invalid value: 7472: Host ports are not allowed to be used, spec.containers[0].securityContext.containers[0].hostPort: Invalid value: 7946: Host ports are not allowed to be used, provider "restricted": Forbidden: not usable by user or serviceaccount, provider "nonroot-v2": Forbidden: not usable by user or serviceaccount, provider "nonroot": Forbidden: not usable by user or serviceaccount, provider "hostmount-anyuid": Forbidden: not usable by user or serviceaccount, provider "hostnetwork-v2": Forbidden: not usable by user or serviceaccount, provider "hostnetwork": Forbidden: not usable by user or serviceaccount, provider "hostaccess": Forbidden: not usable by user or serviceaccount, provider "topolvm-node": Forbidden: not usable by user or serviceaccount, provider "privileged": Forbidden: not usable by user or serviceaccount]

```
