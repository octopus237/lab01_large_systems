#!/usr/bin/bash

mkdir containera containerb

wget https://raw.githubusercontent.com/octopus237/lab01_large_systems/cc35665d66123d4a75d500e9c8c78f8797314be5/containera/index.html -P ./containera
wget https://raw.githubusercontent.com/octopus237/lab01_large_systems/cc35665d66123d4a75d500e9c8c78f8797314be5/containerb/index.html -P ./containerb

touch containera.dockerfile containerb.dockerfile docker-compose.yaml

cat << EOF > containera.dockerfile
FROM nginx:1.23.3
WORKDIR /usr/share/nginx/html
EXPOSE 80
EOF

cat containera.dockerfile > containerb.dockerfile

cat << EOF > docker-compose.yaml
version: "3.9"
services:
  containera:
    build:
      context: ./
      dockerfile: containera.dockerfile
    ports:
      - "8080:80"
    volumes:
      - "./containera/:/usr/share/nginx/html:ro"

  containerb:
    build:
      context: ./
      dockerfile: containerb.dockerfile
    ports:
      - "9090:80"
    volumes:
      - "./containerb/:/usr/share/nginx/html:ro"
EOF

docker-compose up -d

echo "ContainerA is accessible on  http://localhost:8080 and containerB on http://localhost:9090"
