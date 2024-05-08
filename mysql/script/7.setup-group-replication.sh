#!/bin/bash

# 用户信息
USER='rpl_user'
PASSWORD=$(<~/ws/mysql/secrets/repl-user)
MYSQL_ROOT_PASSWORD=$(<~/ws/mysql/secrets/mysql-root)

container_names=("mysql-1" "mysql-2" "mysql-3") # 所有容器的名称

for CONTAINER in "${container_names[@]}"
do
  if [ "$CONTAINER" == "mysql-1" ]; then
    # 如果是master容器，执行bootstrapping命令
    echo "Initializing the master ($CONTAINER)..."
    docker exec -it $CONTAINER mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "
      SET GLOBAL group_replication_bootstrap_group=ON;
      START GROUP_REPLICATION USER='$USER', PASSWORD='$PASSWORD';
      SET GLOBAL group_replication_bootstrap_group=OFF;
    "
  else
    # 如果是其它容器，则加入已有集群
    echo "Adding the slave ($CONTAINER) to the group..."
    docker exec -it $CONTAINER mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "
      START GROUP_REPLICATION USER='$USER', PASSWORD='$PASSWORD';
    "
  fi
done



echo "Group replication started for all nodes."



