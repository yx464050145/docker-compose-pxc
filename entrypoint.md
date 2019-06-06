### pxc容器启动命令
exec mysqld --user=mysql --wsrep_cluster_name=$CLUSTER_NAME --wsrep_cluster_address="gcomm://$cluster_join" --wsrep_sst_method=xtrabackup-v2 --wsrep_sst_auth="xtrabackup:$XTRABACKUP_PASSWORD" \
 --wsrep-provider-options="ist.recv_bind=0.0.0.0" $CMDARG
 
 --wsrep-provider-options="ist.recv_bind=0.0.0.0"  #监听本来0.0.0.0  重点



version: '2'
services:
  pxc:
    image: percona/percona-xtradb-cluster:5.6
    volumes:
      - ./data/mysql:/var/lib/mysql
      - ./conf:/etc/mysql
      - ./shell:/shell
    entrypoint: [ '/bin/bash', '/shell/entrypoint.sh']
    command: --wsrep_node_address=192.168.188.165            #重点，没有这个加入集群失败
    environment:
      DESYNC: 1
      CLUSTER_JOIN: 192.168.188.150
      CLUSTER_NAME: yanxin
      XTRABACKUP_PASSWORD: yx979150
      MYSQL_ROOT_PASSWORD: yanxin
      TZ: Asia/Shanghai
    ports:
      - 3306:3306
      - 4567:4567
      - 4568:4568
      - 4444:4444
      
      
