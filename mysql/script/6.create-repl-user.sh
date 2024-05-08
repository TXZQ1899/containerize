#!/bin/bash

# 用户信息设置
USER='rpl_user'
PASSWORD=$(<~/ws/mysql/secrets/repl-user)
CONTAINER_NAMES=("mysql-1" "mysql-2" "mysql-3")

# 从环境变量读取root密码
MYSQL_ROOT_PASSWORD=$(<~/ws/mysql/secrets/mysql-root)

# 在每个MySQL实例上执行创建用户和设置权限的步骤
for CONTAINER in "${CONTAINER_NAMES[@]}"
do
    docker exec -it $CONTAINER mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "
    SET SQL_LOG_BIN=0;

    CREATE USER IF NOT EXISTS '$USER'@'%' IDENTIFIED BY '$PASSWORD';
    GRANT REPLICATION SLAVE, CONNECTION_ADMIN, BACKUP_ADMIN ON *.* TO '$USER'@'%';
    GRANT GROUP_REPLICATION_STREAM ON *.* TO '$USER'@'%';
    FLUSH PRIVILEGES;

    SET SQL_LOG_BIN=1;
        
    CHANGE REPLICATION SOURCE TO SOURCE_USER='$USER',
        SOURCE_PASSWORD='$PASSWORD' FOR CHANNEL 'group_replication_recovery';
    "
done

echo "Done"
