FROM httpd:2.4-alpine

RUN apk add apache2-proxy

COPY ${PWD}/ /usr/local/apache2/
RUN mkdir -p /app
WORKDIR /app

