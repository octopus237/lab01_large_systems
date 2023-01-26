#!/usr/bin/bash
mkdir containera containerb
touch containera/index.html containerb/index.html containera.dockerfile containerb.dockerfile docker-compose.yaml

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
