#  遇到的问题
### 权限问题
1. 授权mysql用户的uid                 chown -R UID:UID （1001），负责会报错没有权限
### 数据一致性
It may not be safe to bootstrap the cluster from this node. It was not the last one to leave the cluster and may not contain all the updates. To force cluster bootstrap with this node, edit the grastate.dat file manually and set safe_to_bootstrap to 1
使用 mysqld --wsrep-recover检测Recovered positio，选择最大的并且把grastate.dat safe_to_bootstrap: 1
这是因为集群会认为本节点不是最后一个退出集群的节点，可能数据不全，所有不会当做主节点启动，必须修改配置方可启动
### 32错误
mysqld --user=mysql --wsrep_cluster_name=$CLUSTER_NAME --wsrep_node_name=$hostname \
    --wsrep_cluster_address="gcomm://$cluster_join" --wsrep_sst_method=xtrabackup-v2 \
    --wsrep_sst_auth="xtrabackup:$XTRABACKUP_PASSWORD" \
    --wsrep-provider-options="ist.recv_bind=0.0.0.0" \
    --wsrep_node_address="$ipaddr" $CMDARG

--wsrep-provider-options="ist.recv_bind=0.0.0.0" \
    --wsrep_node_address="$ipaddr" $CMDARG 重点，必须这样设置，负责无限报32错误
### 加入集群
主节点在down机后，需要修改compose文件，添加join
### 集群添加新节点
集群添加新节点使用IST，避免使用SST方法。  IST 增量同步，SST全量同步
思路： 
先搭建主从复制，然后将从库加入PXC集群中。

具体步骤： 
选择集群中任意一个节点A，xtrabackup生成备份。 
利用xtrabackup备份搭建从库B。 
测试主从同步是否成功。 
从库上stop slave，记录此时对应的主库binlog位置。 
通过主库上的binlog位置获取数据库xid。 
将主库A库grastate.dat拷贝到B库并修改seqno为对应的xid。 
开启B库PXC相关配置（wsrep）。 
B库start加入集群。
