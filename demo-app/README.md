# demo-app

Dockerized Node.js application based on **[Node.js - Demo Web Application](https://github.com/benc-uk/nodejs-demoapp)**
project

Build Image
-----------
```shell
docker stop demo-app && docker rm demo-app && docker rmi devops-finals
docker build --tag=devops-finals --build-arg DEMO_APP_VERSION=4.9.7 --file=./Dockerfile . && docker run -d --name demo-app -p 9090:80 devops-finals
docker exec -it demo-app /bin/sh
```

