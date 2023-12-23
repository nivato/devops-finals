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
