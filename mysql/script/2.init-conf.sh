#!/bin/bash

# mysql安装路径
mysql_base_path=~/ws/mysql/conf/

rm -rf ~/ws/mysql/conf/*

# 节点数量和起始IP地址
node_count=3
base_ip="172.20.0.11"

# 将起始IP地址分割成数组
IFS='.' read -ra ADDR <<< "$base_ip"

# 计算最后一个IP片段的起始数字
last_octet=${ADDR[3]}

# 创建配置文件
for ((i=1; i<=node_count; i++))
do
    # 计算每个节点的IP地址
    ip="172.20.0.$((last_octet + i - 1))"
    
    # MySQL配置路径
    conf_path=${mysql_base_path}/mysql-${i}

    # 创建目录
    mkdir -p ${conf_path}

    # 将节点配置写入对应的my.cnf文件
    cat > ${conf_path}/my.cnf <<EOF
[mysqld]
disabled_storage_engines="MyISAM,BLACKHOLE,FEDERATED,ARCHIVE,MEMORY"

server_id=${i}
gtid_mode=ON
enforce_gtid_consistency=ON

plugin_load_add='group_replication.so'

group_replication_group_name="bc946766-0c46-11ef-a8e2-0242ac110002"
group_replication_start_on_boot=off
group_replication_local_address= "${ip}:33061"
group_replication_group_seeds= "172.20.0.$((last_octet)):33061,172.20.0.$((last_octet + 1)):33061,172.20.0.$((last_octet + 2)):33061"
group_replication_bootstrap_group=off
EOF


done
tree ~/ws/mysql/conf 
echo "MGR配置文件创建完毕！"
