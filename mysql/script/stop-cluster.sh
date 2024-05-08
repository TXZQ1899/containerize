#!/bin/bash

# MySQL的docker容器名
container_names=("mysql-1" "mysql-2" "mysql-3")

# 批量启动MySQL容器
for i in ${!container_names[@]}
do
    docker stop ${container_names[$i]} 
done

echo "MySQL MGR-Cluster stoped!"
