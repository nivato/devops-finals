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
