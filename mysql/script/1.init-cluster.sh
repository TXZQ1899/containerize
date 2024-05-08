#!/bin/bash

# MySQL的docker容器名
container_names=("mysql-1" "mysql-2" "mysql-3")

# MySQL宿主机端口
host_ports=(3306 3307 3308)
host_ports_x=(13306 13307 13308)
container_ips=("172.20.0.11" "172.20.0.12" "172.20.0.13")

# 批量创建MySQL容器
for i in ${!container_names[@]}
do
    docker run --name ${container_names[$i]} \
    --net mysql-mgr --ip ${container_ips[$i]} \
    -d -p ${host_ports[$i]}:3306 -p ${host_ports_x[$i]}:33061 \
    -v ~/ws/mysql/data/${container_names[$i]}:/var/lib/mysql \
    -v ~/ws/mysql/secrets:/run/secrets \
    -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/mysql-root \
    mysql:latest
    
    echo "Mysql container : ${container_names[$i]} has been created!"
done

echo "Step 1: MySQL Cluster Initialization Completed!"
