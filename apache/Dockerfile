FROM httpd:2.4-alpine

RUN apk add apache2-proxy

COPY ${PWD}/conf /usr/local/apache2/conf
RUN mkdir -p /app
WORKDIR /app

