#!/bin/bash

# MySQL的docker容器名
container_names=("mysql-1" "mysql-2" "mysql-3")


# 批量更新MGR配置文件
for i in ${!container_names[@]}
do
    docker cp ~/ws/mysql/conf/${container_names[$i]}/my.cnf ${container_names[$i]}:/etc/mysql/conf.d 
done

echo "Configuration update complete!"
