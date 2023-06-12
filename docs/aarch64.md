

# Load Balancer

https://github.com/openshift/microshift/blob/main/docs/howto_load_balancer.md

Image will not work for ARM
https://github.com/openshift/microshift/blob/main/docs/config/nginx-IP-header.yaml


Use https://github.com/nginxinc/docker-nginx-unprivileged/pkgs/container/nginx-unprivileged
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx
data:
  headers.conf: |
    add_header X-Server-IP $server_addr always;
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: ghcr.io/nginxinc/nginx-unprivileged:1.24-bullseye-perl@sha256:e2226e886979315a49b0c72e5fd65bd29cead229ac60518aba8b888744328c66
        imagePullPolicy: Always
        name: nginx
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: nginx-configs
          subPath: headers.conf
          mountPath: /etc/nginx/conf.d/headers.conf
        securityContext:
          allowPrivilegeEscalation: false
          seccompProfile:
            type: RuntimeDefault
          capabilities:
            drop: ["ALL"]
          runAsNonRoot: true
      volumes:
        - name: nginx-configs
          configMap:
            name: nginx
            items:
              - key: headers.conf
                path: headers.conf
```