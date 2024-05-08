#!/bin/bash
MYSQL_ROOT_PASSWORD=$(<~/ws/mysql/secrets/mysql-root)
docker exec -it mysql-1 mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "
      SELECT * FROM performance_schema.replication_group_members;
    "


