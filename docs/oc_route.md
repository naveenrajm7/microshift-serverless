

### Make Kourier as ClusterIP 


```bash
[mentee@rhel ~]$ oc get svc -n knative-serving-ingress
NAME                     TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)                      AGE
kourier                  LoadBalancer   10.43.77.128   192.168.68.2   80:31450/TCP,443:32573/TCP   21m
kourier-internal         ClusterIP      10.43.167.32   <none>         80/TCP,443/TCP               21m
net-kourier-controller   ClusterIP      10.43.94.187   <none>         18000/TCP                    21m

oc edit svc kourier -n knative-serving-ingress

[mentee@rhel ~]$ oc get svc -n knative-serving-ingress
NAME                     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
kourier                  ClusterIP   10.43.77.128   <none>        80/TCP,443/TCP   43m
kourier-internal         ClusterIP   10.43.167.32   <none>        80/TCP,443/TCP   43m
net-kourier-controller   ClusterIP   10.43.94.187   <none>        18000/TCP        43m
```

Kourier will not be exposed outside cluster 


### Make Openshift Router as NodePort

```bash
oc expose deployment router-default --type NodePort --name router-external-default  --external-ip=192.168.66.3  -n openshift-ingress

naveenrajm@Naveenrajs-Mac-mini ~ % curl -H "Host: hello-microshift-default.apps.example.com" http://192.168.66.3    
Hello Microshift!
```

Openshift router is the single point to contact for traffic from outside the cluster

### Create Openshift route for knative service

```bash
oc expose svc kourier --hostname=hello.default.example.com -n knative-serving-ingress

naveenrajm@Naveenrajs-Mac-mini ~ % curl  -H "Host: hello.default.example.com" http://192.168.68.2 
Hello Serverless!
```

Creating Openshift route for kourier with the same hostname that kourier undersands ( ksvc route / king) makes it possible for Openshift router to resolve request to kourier and the using header information kourier can resolve to knative service.

> curl -> LB -> OpenShift router -> k8s-service kourier in NS knative-serving-ingress -> kourier pod -> activator/QP -> User container