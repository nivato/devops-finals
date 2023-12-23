# devops-finals
DevOps Program 2023 (AWS) Final Task

Setup Infrastructure (approx. 15 min)
-------------------------------------

### 1. Install Terraform

1. Install Terraform on the Ubuntu 22.04:
```shell
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

terraform --version
# > Terraform v1.6.3
# > on linux_amd64
```

2. Create `terraform` User in the AWS Console and Include it into th `DevOps` Group

3. In order to safely configure Terraform access to the AWS Account, we will need to install AWS CLI and configure AWS Credentials and Profile:
* Install AWS CLI v2:
```shell
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip  # if needed
unzip awscliv2.zip
sudo ./aws/install

which aws
aws --version
# > aws-cli/2.13.31 Python/3.11.6 Linux/5.4.0-128-generic exe/x86_64.ubuntu.20 prompt/off
rm -rf awscliv2.zip aws
```
* Configure AWS CLI (with the `terraform` profile):
```shell
aws configure --profile terraform
AWS Access Key ID [None]: YOUR_ACCESS_KEY_ID
AWS Secret Access Key [None]: YOUR_SECRET_ACCESS_KEY
Default region name [None]: eu-central-1
Default output format [None]: json
```

### 2. Deploy AWS Infrastructure
```shell
cd infra/
terraform init
terraform plan
terraform apply
```

### 3. Connect to the EKS Cluster with `kubectl`
1. Install `kubectl`:
```shell
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
# Download the public signing key for the Kubernetes package repositories
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# Add the appropriate Kubernetes apt repository
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
kubectl version --client
```
2. Now, configure `kubectl` to connect to our `devops-finals-cluster` EKS Cluster:
```shell
aws eks update-kubeconfig --region eu-central-1 --name devops-finals-cluster --profile terraform
# > Added new context arn:aws:eks:eu-central-1:YOUR_AWS_ACCOUNT_ID:cluster/devops-finals-cluster to /home/user/.kube/config
kubectl get nodes
# > NAME                                           STATUS   ROLES    AGE   VERSION
# > ip-10-10-2-185.eu-central-1.compute.internal   Ready    <none>   48m   v1.28.3-eks-e71965b
# > ip-10-10-3-243.eu-central-1.compute.internal   Ready    <none>   48m   v1.28.3-eks-e71965b
```

### 4. Install **[Ingress-NGINX](https://kubernetes.github.io/ingress-nginx/)** Ingress Controller
* Installation: **[AWS](https://kubernetes.github.io/ingress-nginx/deploy/#aws)**
```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/aws/deploy.yaml
# Check if new ingress components were successfully created
# > kubectl get pods --all-namespaces | grep ingress-nginx
# > ingress-nginx   ingress-nginx-admission-create-mr6rv        0/1     Completed   0          57s
# > ingress-nginx   ingress-nginx-admission-patch-vnzs2         0/1     Completed   0          57s
# > ingress-nginx   ingress-nginx-controller-8558859656-hvll4   1/1     Running     0          57s
kubectl get services --all-namespaces | grep ingress-nginx
# > NAME            TYPE                                 CLUSTER-IP     EXTERNAL-IP                                                                                         PORT(S)                      AGE
# > ingress-nginx   ingress-nginx-controller             LoadBalancer   172.20.153.196   a2b71c20936a14504b0b890c54a97fed-f1400b59f472c94e.elb.eu-central-1.amazonaws.com   80:30090/TCP,443:32681/TCP   101s
# > ingress-nginx   ingress-nginx-controller-admission   ClusterIP      172.20.159.89    <none>                                                                             443/TCP                      101s```
```
* Add all availability zones (and subnets) to the `ingress-nginx` Load Balancer:
    * `AWS Console` > `EC2` > `Load Balancing` > `Load Balancers` > [Load Balancer of the `ingress-nginx`] > `Network mapping` > `Edit subnets`:
        * Zone: `eu-central-1a` - Subnet: `devops-finals-public-subnet`
        * Zone: `eu-central-1b` - Subnet: `devops-finals-1st-private-subnet`
        * Zone: `eu-central-1c` - Subnet: `devops-finals-2nd-private-subnet`
* Open in browser http://a2b71c20936a14504b0b890c54a97fed-f1400b59f472c94e.elb.eu-central-1.amazonaws.com/ (URL of the `ingress-nginx` Load Balancer):
    * We should see `404 Not Found - nginx` page

Teardown the Infrastructure (approx. 15 min)
--------------------------------------------

### 1. Delete all the Kubernetes resources created in the `devops-finals-cluster` EKS Cluster

### 2. Delete **[Ingress-NGINX](https://kubernetes.github.io/ingress-nginx/)** Ingress Controller
```shell
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/aws/deploy.yaml
```

### 3. Unset `kubeconfig`
```shell
kubectl config unset clusters
kubectl config unset users
kubectl config unset contexts
kubectl config unset current-context
cat ~/.kube/config
```

### 4. Delete the Infrastructure
```shell
cd infra/
terraform destroy
```
