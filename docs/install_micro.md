
## RHEL Subs

After up
```bash
# Register System
sudo subscription-manager register --auto-attach
# Allow subs manager to manage repos
sudo subscription-manager config --rhsm.manage_repos=1
# Install prerequisites (firewall and lvm)
sudo dnf install -y firewalld lvm2


# Check 
  lsblk
# Create a volume group using extra EBS physical volume  
# Default EBS root volume will not work (No free blocks)
# (lsblk : to get name blocks)
# https://repost.aws/knowledge-center/create-lv-on-ebs-partition
  # ( use 'w' to save config)
 sudo gdisk /dev/nvme1n1   # n, 1, , , 8e00 , w, Y
  lsblk
  sudo pvcreate /dev/nvme1n1p1
   sudo vgcreate rhel /dev/nvme1n1p1
   sudo vgs


# Configure firewall rules
sudo systemctl enable --now firewalld.service
sudo firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16
sudo firewall-cmd --permanent --zone=trusted --add-source=169.254.169.1
sudo firewall-cmd --reload

# Enable microshift package repos
sudo subscription-manager repos \
    --enable rhocp-4.13-for-rhel-9-$(uname -m)-rpms \
    --enable fast-datapath-for-rhel-9-$(uname -m)-rpms 

# install microshift packages
sudo dnf install -y microshift openshift-clients
sudo systemctl daemon-reload

# get code
# Store in secret.json
vi pull-secret.json
sudo cp pull-secret.json /etc/crio/openshift-pull-secret
sudo systemctl enable --now microshift.service
sudo systemctl status microshift


# 
mkdir ~/.kube
sudo cat /var/lib/microshift/resources/kubeadmin/kubeconfig > ~/.kube/config
```

```bash
[ec2-user@ip-198-18-60-10 ~]$ oc get cs
Warning: v1 ComponentStatus is deprecated in v1.19+
NAME                 STATUS    MESSAGE                         ERROR
controller-manager   Healthy   ok                              
scheduler            Healthy   ok                              
etcd-0               Healthy   {"health":"true","reason":""}   
[ec2-user@ip-198-18-60-10 ~]$ oc get pods -A
NAMESPACE                  NAME                                 READY   STATUS    RESTARTS   AGE
openshift-dns              dns-default-ldmxm                    2/2     Running   0          14m
openshift-dns              node-resolver-jthg6                  1/1     Running   0          15m
openshift-ingress          router-default-5c45f79557-ms6m4      1/1     Running   0          14m
openshift-ovn-kubernetes   ovnkube-master-g2vl6                 4/4     Running   0          15m
openshift-ovn-kubernetes   ovnkube-node-67lpg                   1/1     Running   0          15m
openshift-service-ca       service-ca-d4974fc7b-75mcj           1/1     Running   0          14m
openshift-storage          topolvm-controller-bb8f5b484-22hrr   4/4     Running   0          15m
openshift-storage          topolvm-node-t9j2r                   4/4     Running   0          14m

[ec2-user@ip-198-18-60-10 ~]$ oc get ns
NAME                                 STATUS   AGE
default                              Active   27m
kube-node-lease                      Active   27m
kube-public                          Active   27m
kube-system                          Active   27m
openshift-dns                        Active   26m
openshift-infra                      Active   27m
openshift-ingress                    Active   26m
openshift-kube-controller-manager    Active   27m
openshift-ovn-kubernetes             Active   26m
openshift-route-controller-manager   Active   27m
openshift-service-ca                 Active   26m
openshift-storage                    Active   26m

[ec2-user@ip-198-18-60-10 ~]$ oc version
Client Version: 4.12.0-202304070721.p0.g31aa3e8.assembly.stream-31aa3e8
Kustomize Version: v4.5.7
Kubernetes Version: v1.25.0
```



```bash
sudo dnf install -y microshift openshift-clients
    3  sudo systemctl daemon-reload
    4  sudo firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16
    5  sudo systemctl status firewalld
    6  sudo dnf install -y firewalld
    7  sudo systemctl status firewalld
    8  sudo firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16
    9  sudo systemctl start firewalld
   10  sudo firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16
   11  sudo firewall-cmd --permanent --zone=trusted --add-source=169.254.169.1
   12  sudo firewall-cmd --reload
   13  ls
   14  vi pull-secret.json
   15  sudo cp pull-secret.json /etc/crio/openshift-pull-secret
   16  sudo systemctl enable --now microshift.service
   17  sudo systemctl status microshift
   18  mkdir ~/.kube
   19  sudo cat /var/lib/microshift/resources/kubeadmin/kubeconfig > ~/.kube/config
   20  oc get cs
```






```
[ec2-user@ip-198-18-60-10 ~]$ cat /etc/*release*
NAME="Red Hat Enterprise Linux"
VERSION="8.7 (Ootpa)"
ID="rhel"
ID_LIKE="fedora"
VERSION_ID="8.7"
PLATFORM_ID="platform:el8"
PRETTY_NAME="Red Hat Enterprise Linux 8.7 (Ootpa)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:redhat:enterprise_linux:8::baseos"
HOME_URL="https://www.redhat.com/"
DOCUMENTATION_URL="https://access.redhat.com/documentation/red_hat_enterprise_linux/8/"
BUG_REPORT_URL="https://bugzilla.redhat.com/"

REDHAT_BUGZILLA_PRODUCT="Red Hat Enterprise Linux 8"
REDHAT_BUGZILLA_PRODUCT_VERSION=8.7
REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux"
REDHAT_SUPPORT_PRODUCT_VERSION="8.7"
Red Hat Enterprise Linux release 8.7 (Ootpa)
Red Hat Enterprise Linux release 8.7 (Ootpa)
cpe:/o:redhat:enterprise_linux:8::baseos
[ec2-user@ip-198-18-60-10 ~]$ 

[ec2-user@ip-198-18-60-10 ~]$ lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              2
On-line CPU(s) list: 0,1
Thread(s) per core:  2
Core(s) per socket:  1
Socket(s):           1
NUMA node(s):        1
Vendor ID:           GenuineIntel
CPU family:          6
Model:               85
Model name:          Intel(R) Xeon(R) Platinum 8259CL CPU @ 2.50GHz
Stepping:            7
CPU MHz:             2499.996
BogoMIPS:            4999.99
Hypervisor vendor:   KVM
Virtualization type: full
L1d cache:           32K
L1i cache:           32K
L2 cache:            1024K
L3 cache:            36608K
NUMA node0 CPU(s):   0,1
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid mpx avx512f avx512dq rdseed adx smap clflushopt clwb avx512cd avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves ida arat pku ospke
```


[MicrShift Getting Started](https://github.com/openshift/microshift/blob/main/docs/getting_started.md)

[RHEL Microshift](https://access.redhat.com/documentation/en-us/red_hat_build_of_microshift)
With developer subscription



ARM Error

```bash
Error: 'rhocp-4.12-for-rhel-8-aarch64-rpms' does not match a valid repository ID. Use "subscription-manager repos --list" to see valid repositories.
Error: 'fast-datapath-for-rhel-8-aarch64-rpms' does not match a valid repository ID. Use "subscription-manager repos --list" to see valid repositories.
```




9.0 Error
```bash
8:28:56.479439   16602 pod_workers.go:965] "Error syncing pod, skipping" err="failed to \"StartContainer\" for \"service-ca-controller\" with CrashLoopBackOf>
8:29:04.478472   16602 scope.go:115] "RemoveContainer" containerID="9136a5c534f8f0a4ce4f133bb7219c60765870f357e4a914daa282a117d836d4"
8:29:04.479273   16602 pod_workers.go:965] "Error syncing pod, skipping" err="failed to \"StartContainer\" for \"router\" with CrashLoopBackOff: \"back-off 5>
8:29:07.870032   16602 reconciler_common.go:228] "operationExecutor.MountVolume started for volume \"metrics-tls\" (UniqueName: \"kubernetes.io/secret/44b498>
8:29:07.870205   16602 secret.go:194] Couldn't get secret openshift-dns/dns-default-metrics-tls: secret "dns-default-metrics-tls" not found
8:29:07.870270   16602 nestedpendingoperations.go:348] Operation for "{volumeName:kubernetes.io/secret/44b4986a-e8ff-4160-a923-a1300f579260-metrics-tls podNa>
8:29:07.899449   16602 kubelet.go:1841] "Unable to attach or mount volumes for pod; skipping pod" err="unmounted volumes=[metrics-tls], unattached volumes=[c>
8:29:07.899496   16602 pod_workers.go:965] "Error syncing pod, skipping" err="unmounted volumes=[metrics-tls], unattached volumes=[config-volume kube-api-acc>
8:29:10.478880   16602 scope.go:115] "RemoveContainer" containerID="33e4a4270680739af9788e1cb8b845032fcfcefbb27889da7b11d2852b037ded"
8:29:10.479291   16602 pod_workers.go:965] "Error syncing pod, skipping" err="failed to \"StartContainer\" for \"service-ca-controller\" with CrashLoopBackOf>

```


```
  Type     Reason       Age                  From               Message
  ----     ------       ----                 ----               -------
  Normal   Scheduled    16m                  default-scheduler  Successfully assigned openshift-dns/dns-default-5h7v9 to ip-198-18-60-10.ec2.internal
  Warning  FailedMount  6m33s (x3 over 14m)  kubelet            Unable to attach or mount volumes: unmounted volumes=[metrics-tls], unattached volumes=[config-volume kube-api-access-blmdj metrics-tls]: timed out waiting for the condition
  Warning  FailedMount  4m29s                kubelet            Unable to attach or mount volumes: unmounted volumes=[metrics-tls], unattached volumes=[kube-api-access-blmdj metrics-tls config-volume]: timed out waiting for the condition
  Warning  FailedMount  27s (x16 over 16m)   kubelet            MountVolume.SetUp failed for volume "metrics-tls" : secret "dns-default-metrics-tls" not found
  Warning  FailedMount  23s (x4 over 10m)    kubelet            Unable to attach or mount volumes: unmounted volumes=[metrics-tls], unattached volumes=[metrics-tls config-volume kube-api-access-blmdj]: timed out waiting for the condition
```