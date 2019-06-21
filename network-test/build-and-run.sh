#!/bin/bash

function get_logs {
    echo "Port ${1}:"
    docker container exec ${BACKEND_CONTAINER_ID} sh -c "cat /var/log/${1}.log && :>/var/log/${1}.log"
    echo ""
}

function get_all_logs {
    echo "Logs from nginx_backend:"
    get_logs 80
    get_logs 100
    get_logs 200
    echo ""
    echo ""
}

docker stack rm network-test
echo ""
echo ""

echo "Waiting for stack to be destroyed..."
sleep 15
echo "Done"
echo ""
echo ""

docker image build -t nginx-100-200 .
docker image build -t nginx-reverse-proxy -f Dockerfile-rp .

echo ""
echo ""

docker stack deploy -c docker-compose.yaml network-test
echo ""
echo ""

echo "Waiting for stack to deploy..."
sleep 15
echo "Done"
echo ""

BACKEND_CONTAINER_ID=$(docker container ls | grep -i network-test_nginx_backend.1 | cut -d" " -f1)

echo "Mappings:"
echo "1) http://localhost:300/    -> http://nginx-reverse-proxy:300/    -> http://nginx_backend/"
echo "2) http://localhost:300/80  -> http://nginx-reverse-proxy:300/80  -> http://nginx_backend/"
echo "3) http://localhost:300/100 -> http://nginx-reverse-proxy:300/100 -> http://nginx_backend:100/"
echo "4) http://localhost:300/200 -> http://nginx-reverse-proxy:300/200 -> http://nginx_backend:200/"
echo ""
echo ""

echo "-----------------------------------------------------------------------------------------"
echo ""
echo "1) Curling http://localhost:300/"
echo "     -> http://nginx-reverse-proxy:300/"
echo "     -> http://nginx_backend/"
echo ""
echo "Curl Output:"
curl http://localhost:300/
echo ""
get_all_logs
echo ""

echo "-----------------------------------------------------------------------------------------"
echo ""
echo "2) Curling http://localhost:300/80"
echo "     -> http://nginx-reverse-proxy:300/80"
echo "     -> http://nginx_backend/"
echo ""
echo "Curl Output:"
curl http://localhost:300/80
echo ""
get_all_logs
echo ""

echo "-----------------------------------------------------------------------------------------"
echo ""
echo "3) Curling http://localhost:300/100"
echo "     -> http://nginx-reverse-proxy:300/100"
echo "     -> http://nginx_backend:100/"
echo ""
echo "Curl Output:"
curl http://localhost:300/100
echo ""
get_all_logs
echo ""

echo "-----------------------------------------------------------------------------------------"
echo ""
echo "4) Curling http://localhost:300/200"
echo "     -> http://nginx-reverse-proxy:300/200"
echo "     -> http://nginx_backend:200/"
echo ""
echo "Curl Output:"
curl http://localhost:300/200
echo ""
get_all_logs
