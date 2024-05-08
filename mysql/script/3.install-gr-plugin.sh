#!/bin/bash

# 用户信息设置
CONTAINER_NAMES=("mysql-1" "mysql-2" "mysql-3")

# 从环境变量读取root密码
MYSQL_ROOT_PASSWORD=$(<~/ws/mysql/secrets/mysql-root)

# 在每个MySQL实例上执行创建用户和设置权限的步骤
for CONTAINER in "${CONTAINER_NAMES[@]}"
do
    docker exec -it $CONTAINER mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "
    install PLUGIN group_replication SONAME 'group_replication.so';
    "
done

echo "Done"
