FROM node:16-alpine
LABEL Name="Node.js Demo App" Version=4.9.7
LABEL org.opencontainers.image.source = "https://github.com/benc-uk/nodejs-demoapp"
ENV NODE_ENV production
WORKDIR /app 

# For Docker layer caching do this BEFORE copying in rest of app
COPY src/package*.json ./
RUN npm install --production --silent && \
    apk update && \
    apk add nginx

COPY nginx/default.conf /etc/nginx/http.d/

# NPM is done, now copy in the rest of the project to the workdir
COPY src/. .

# Port 3000 for our Express server 
# EXPOSE 3000
EXPOSE 80

# ENTRYPOINT ["npm", "start"]
ENTRYPOINT ["/bin/sh", "-c"]

CMD ["npm start & nginx -g 'daemon off;'"]
