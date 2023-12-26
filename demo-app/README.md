# demo-app

Dockerized Node.js application based on **[Node.js - Demo Web Application](https://github.com/benc-uk/nodejs-demoapp)**
project

Build Image
-----------
```shell
docker stop demo-app && docker rm demo-app && docker rmi demo-app
docker build --tag=demo-app --build-arg DEMO_APP_VERSION=4.9.7 --file=./Dockerfile . && docker run -d --name demo-app -p 9090:80 demo-app
docker exec -it demo-app /bin/sh
```
