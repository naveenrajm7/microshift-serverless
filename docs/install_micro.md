
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
# Create new disk 
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



# Local Machine

```bash

# install gdisk 

# Create primary partition for unclaimed space
sudo gdisk
# Create physical volume 
sudo pvcreate /dev/sda3

# Add new volume to vg
sudo vgextend rhel /dev/sda3

# If size is issue
sudo pvresize /dev/sda3

```


[Add new partition to LVM](https://www.krenger.ch/blog/linux-lvm-how-to-adding-a-new-partition/)
