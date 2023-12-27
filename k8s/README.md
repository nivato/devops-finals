# k8s

Definitions of all Kubernetes resources reside here

Deploy k8s resources
--------------------

### 1. Install **[j2cli](https://pypi.org/project/j2cli/)**
* Locally:
```shell
pip install j2cli
j2 --version
# > j2cli 0.3.10, Jinja2 3.1.2
```
* On Jenkins:
```shell
sudo -H pip install --force-reinstall j2cli
j2 --version
# > j2cli 0.3.10, Jinja2 3.1.2
```

### 2. Generate yaml manifest
```shell
export INGRESS_LOAD_BALANCER_URL=a2b71c20936a14504b0b890c54a97fed-f1400b59f472c94e.elb.eu-central-1.amazonaws.com
j2 ingress-service-deployment.yaml.j2 > ingress-service-deployment.yaml
```

### 3. Apply manifest
```shell
kubectl apply -f ingress-service-deployment.yaml
```

Useful Examples
---------------
1. Connect to running pod:
```shell
kubectl get pods --namespace prod
kubectl exec -it west-deployment-865cd6b4cf-7jvsk --namespace prod -- /bin/sh
```
2. Connect to RDS Instance from pod:
```shell
rds_host="mysql-db-wordpress.ckrlhms1oqdq.eu-central-1.rds.amazonaws.com"
admin_user="..."
admin_password="..."
mysql --user="$admin_user" --host="$rds_host" --password="$admin_password"
> show databases;
```
