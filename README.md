# devops-finals
DevOps Program 2023 (AWS) Final Task

### Docker Hub: **[nazarivato/devops-finals](https://hub.docker.com/r/nazarivato/devops-finals)**
[![Docker Hub](https://opennebula.io/wp-content/uploads/2020/05/DockerHub.png "Docker Hub")](https://hub.docker.com/r/nazarivato/devops-finals)

Final Task Execution Walk-Through
---------------------------------

### 1. Created Infrastructure (output of `terraform apply` command):
![Created Infrastructure](./docs/images/01-terraform-apply.png "Created Infrastructure")

### 2. Created Ingress-NGINX Controller:
![Created Ingress-NGINX Controller](./docs/images/02-kubectl-apply-ingress-nginx.png "Created Ingress-NGINX Controller")

### 3. VPC Resource Map:
![VPC Resource Map](./docs/images/03-vpc-resource-map.png "VPC Resource Map")

### 4. Created Subnets:
![Created Subnets](./docs/images/04-subnets.png "Created Subnets")

### 5. Created EKS Cluster:
![Created EKS Cluster](./docs/images/05-eks-cluster-networking.png "Created EKS Cluster")

### 6. Created EKS Node Group:
![Created EKS Node Group](./docs/images/06-eks-node-group.png "Created EKS Node Group")

### 7. Created MySQL RDS Instance:
![Created MySQL RDS Instance](./docs/images/07-mysql-rds-instance.png "Created MySQL RDS Instance")

### 8. Created Ingress-NGINX Load Balancer:
![Created MySQL RDS Instance](./docs/images/08-ingress-nginx-load-balancer.png "Created MySQL RDS Instance")

### 9. `build-devops-finals` Jenkins Pipeline:
![build-devops-finals Jenkins Pipeline](./docs/images/09-build-devops-finals-jenkins-pipeline.png "build-devops-finals Jenkins Pipeline")

### 10. "Docker Build" Stage:
![Docker Build Stage](./docs/images/10-docker-build-stage.png "Docker Build Stage")

### 11. "Test Image" Stage:
![Test Image Stage](./docs/images/11-test-image-stage.png "Test Image Stage")

### 12. "Publish Image" Stage:
![Publish Image Stage](./docs/images/12-publish-image-stage.png "Publish Image Stage")

### 13. "Deploy to EKS" Stage:
![Deploy to EKS Stage](./docs/images/13-deploy-to-eks-stage.png "Deploy to EKS Stage")

### 14. `kubectl describe deployment` Example Output:
![kubectl describe deployment](./docs/images/14-kubectl-describe-north-deployment.png "kubectl describe deployment")

### 15. **[nazarivato/devops-finals](https://hub.docker.com/r/nazarivato/devops-finals)** Image on Docker Hub:
![devops-finals Image on Docker Hub](./docs/images/15-devops-finals-image-on-docker-hub.png "devops-finals Image on Docker Hub")

### 16. Ingress Controller - `/` Path:
![Ingress Controller - / Path](./docs/images/16-ingress-root-path.png "Ingress Controller - / Path")

### 17. "Node.js Demo App" Deployed:
![Node.js Demo App Deployed](./docs/images/17-ingress-node-js-app-running.png "Node.js Demo App Deployed")

### 18. Ingress Controller - `/north` Path:
![Ingress Controller - /north Path](./docs/images/18-ingress-north-info.png "Ingress Controller - /north Path")

### 19. Ingress Controller - `/south` Path:
![Ingress Controller - /south Path](./docs/images/19-ingress-south-info.png "Ingress Controller - /south Path")

### 20. Ingress Controller - `/west` Path:
![Ingress Controller - /west Path](./docs/images/20-ingress-west-info.png "Ingress Controller - /west Path")

### 21. Ingress Controller - `/east` Path:
![Ingress Controller - /east Path](./docs/images/21-ingress-east-info.png "Ingress Controller - /east Path")

### 22. MySQL Access to RDS Instance from pod:
![MySQL Access to RDS Instance from pod](./docs/images/22-mysql-access-to-rds-instance-from-pod.png "MySQL Access to RDS Instance from pod")
