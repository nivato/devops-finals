def appDir = 'demo-app'
def dockerRepo = 'nazarivato/devops-finals'
def dockerTag = ''
def dockerImage = ''

@NonCPS
def listChanges() {
    def changes = []
    def changeLogSets = currentBuild.changeSets;
    for (int i = 0; i < changeLogSets.size(); i++) {
        def entries = changeLogSets[i].items
        for (int j = 0; j < entries.length; j++) {
            def entry = entries[j]
            def files = new ArrayList(entry.affectedFiles)
            for (int k = 0; k < files.size(); k++) {
                def file = files[k]
                changes.push(file.path)
            }
        }
    }
    return changes
}

@NonCPS
def changesInDir(appDirectoryName) {
    def result = false;
    def files = listChanges();
    for (int i = 0; i < files.size(); i++) {
        def filePath = files[i];
        if (filePath.startsWith("${appDirectoryName}/")) {
            result = true;
            break;
        }
    }
    echo "changesInDir(${appDirectoryName}): ${result}"
    return result;
}

@NonCPS
def changesInAnyOfDirs(directoryNames) {
    def result = false;
    def files = listChanges();
    for (int i = 0; i < files.size(); i++) {
        def file = files[i];
        for (int j = 0; j < directoryNames.size(); j++) {
            def appDirectoryName = directoryNames[j];
            if (file.startsWith("${appDirectoryName}/")) {
                result = true;
                break;
            }
        }
        if (result){
            break;
        }
    }
    echo "changesInAnyOfDirs(${directoryNames}): ${result}"
    return result;
}

def containerIp(container) {
    sh(
        script: "docker inspect -f {{.NetworkSettings.IPAddress}} ${container.id}",
        returnStdout: true,
    ).trim()
}

pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }
    triggers {
        pollSCM 'H/5 * * * *'
    }
    stages {
        stage('Debug Info'){
            when {
                expression {
                    changesInDir(appDir)
                }
            }
            steps {
                script {
                    try {
                        sh 'date'
                        sh 'env'
                        sh 'pwd'
                        sh 'ls -lah'
                        sh 'find . -type f -not -path "*/.git/*"'
                        sh 'docker --version'
                        sh "aws --version"
                        sh "kubectl version --client"
                        sh "j2 --version"
                    } catch (err) {
                        echo "${err.getMessage()}"
                        error("'Debug Info' Stage Failed - ${err.getMessage()}")
                    }
                }
            }
        }
        stage('Docker Build'){
            when {
                expression {
                    changesInDir(appDir)
                }
            }
            steps {
                script {
                    try {
                        dir(appDir){
                            dockerTag = "v1.0.${env.BUILD_NUMBER}"
                            dockerImage = docker.build(
                                "${dockerRepo}:${dockerTag}",
                                "--build-arg DEMO_APP_VERSION=4.9.7 -f ./Dockerfile ."
                            )
                            sh 'docker images'
                        }
                    } catch (err) {
                        echo "${err.getMessage()}"
                        error("'Docker Build' Stage Failed - ${err.getMessage()}")
                    }
                }
            }
        }
        stage('Test Image'){
            when {
                expression {
                    changesInDir(appDir)
                }
            }
            steps {
                script {
                    try {
                        dockerImage.withRun('-p 9090:80') { cntr ->
                            sleep 5  // seconds
                            def ipAddress = containerIp(cntr)
                            def expectedServer = "Server: nginx"
                            def expectedContents = "This is a simple Node.js web app using the Express framework and EJS templates."
                            def errorLog = "/var/log/nginx/error.log"
                            def internalPortResponse = sh(
                                script: "wget -q -S -O - http://${ipAddress}:80/ 2>&1",
                                returnStdout: true,
                            ).trim()
                            echo "internalPortResponse: ${internalPortResponse}"
                            if (!(internalPortResponse && internalPortResponse.contains(expectedServer) && internalPortResponse.contains(expectedContents))){
                                sh "docker exec ${cntr.id} /bin/sh -c 'cat ${errorLog}'"
                                sh "docker logs ${cntr.id}"
                                error("Invalid response when calling 'http://${ipAddress}:80/' URL")
                            }
                            def mappedPortResponse = sh(
                                script: "wget -q -S -O - http://127.0.0.1:9090/ 2>&1",
                                returnStdout: true,
                            ).trim()
                            echo "mappedPortResponse: ${mappedPortResponse}"
                            if (!(mappedPortResponse && mappedPortResponse.contains(expectedServer) && mappedPortResponse.contains(expectedContents))){
                                sh "docker exec ${cntr.id} /bin/sh -c 'cat ${errorLog}'"
                                sh "docker logs ${cntr.id}"
                                error("Invalid response when calling 'http://127.0.0.1:9090/' URL")
                            }
                            sh "docker logs ${cntr.id}"
                        }
                        sh 'docker ps -a'
                    } catch (err) {
                        echo "${err.getMessage()}"
                        error("'Test Image' Stage Failed - ${err.getMessage()}")
                    }
                }
            }
        }
        stage('Publish Image'){
            when {
                expression {
                    changesInDir(appDir)
                }
            }
            steps {
                script {
                    try {
                        docker.withRegistry('', 'dockerhub_nazarivato') {
                            dockerImage.push()
                            dockerImage.push('v1.0')
                            dockerImage.push('latest')
                        }
                    } catch (err) {
                        echo "${err.getMessage()}"
                        error("'Publish Image' Stage Failed - ${err.getMessage()}")
                    }
                }
            }
        }
        stage('Deploy to EKS'){
            when {
                expression {
                    changesInAnyOfDirs([appDir, 'k8s'])
                }
            }
            steps {
                script {
                    try {
                        dir('k8s'){
                            withAWS(credentials: 'terraform-aws-user'){
                                sh "aws eks update-kubeconfig --region eu-central-1 --name devops-finals-cluster"
                                def ingressLoadBalancerUrl = sh(
                                    script: '''
                                        kubectl get services --all-namespaces | grep ingress-nginx | grep LoadBalancer | awk '{print $5}'
                                    ''',
                                    returnStdout: true,
                                ).trim()
                                echo "ingressLoadBalancerUrl: ${ingressLoadBalancerUrl}"
                                sh """
                                    export INGRESS_LOAD_BALANCER_URL=${ingressLoadBalancerUrl}
                                    j2 ingress-service-deployment.yaml.j2 > ingress-service-deployment.yaml
                                """
                                sh "cat ingress-service-deployment.yaml"
                                sh "kubectl apply -f ingress-service-deployment.yaml"
                                sh "kubectl get services --namespace=prod"
                                echo "Load Balancer URL: http://${ingressLoadBalancerUrl}"
                            }
                        }
                    } catch (err) {
                        echo "${err.getMessage()}"
                        error("'Deploy to EKS' Stage Failed - ${err.getMessage()}")
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                try {
                    if (changesInDir(appDir)){
                        sh "docker rmi ${dockerRepo}:${dockerTag} || true"
                        sh "docker rmi ${dockerRepo}:v1.0 || true"
                        sh "docker rmi ${dockerRepo}:latest || true"
                        sh 'docker images'
                    }
                    if (changesInDir('k8s')){
                        sh "kubectl config unset clusters || true"
                        sh "kubectl config unset users || true"
                        sh "kubectl config unset contexts || true"
                        sh "kubectl config unset current-context || true"
                    }
                } catch (err) {
                    echo "${err.getMessage()}"
                    error("'Cleanup' Stage Failed - ${err.getMessage()}")
                }
            }
        }
    }
}
