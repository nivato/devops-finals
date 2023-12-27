FROM node:16-alpine
ARG DEMO_APP_VERSION=4.9.7
LABEL Name="Node.js Demo App" Version=$DEMO_APP_VERSION
LABEL org.opencontainers.image.source = "https://github.com/benc-uk/nodejs-demoapp"
ENV NODE_ENV production
ENV DEMO_APP_VERSION=$DEMO_APP_VERSION
WORKDIR /app

RUN wget https://github.com/benc-uk/nodejs-demoapp/archive/refs/tags/${DEMO_APP_VERSION}.tar.gz && \
    tar -xvzf ${DEMO_APP_VERSION}.tar.gz && \
    rm -rf ${DEMO_APP_VERSION}.tar.gz && \
    cp -r nodejs-demoapp-${DEMO_APP_VERSION}/src/package*.json ./ && \
    npm install --production --silent && \
    apk update && \
    apk add nginx mysql-client

COPY nginx/default.conf /etc/nginx/http.d/

RUN cp -r nodejs-demoapp-${DEMO_APP_VERSION}/src/* . && \
    rm -rf nodejs-demoapp-${DEMO_APP_VERSION}

EXPOSE 80

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["npm start & nginx -g 'daemon off;'"]
