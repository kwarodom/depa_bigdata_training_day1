#!/bin/bash 

#This is the installation file for hadoop: HDFS, Yarn, MapReduce on Ubuntu 17.04 64-bit
#WARNING!!!! DO NOT RUN THIS FILE

#update package
sudo apt-get update

#setup SSH
sudo apt-get install –y openssh-server
ssh-keygen –t dsa –P ''
cat .ssh/id_dsa.pub >> .ssh/authorized_key
ssh localhost

#setup JAVA https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer

#managing JAVA
sudo update-alternatives --config java

#Add environment variable at .bashrc
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export PATH=$PATH:$JAVA_HOME/bin

#setup hadoop
#1.download hadoop 
wget http://mirror.cc.columbia.edu/pub/software/apache/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz

#2.create Folder for Hadoop 
sudo mkdir –p /usr/local/hadoop 
sudo chown arit:arit –R /usr/local/hadoop
sudo mkdir /var/log/hadoop 
sudo chown –R arit:arit /var/log/hadoop
sudo mkdir –p /var/hadoop_data 
sudo mkdir –p /var/hadoop_data/namenode
sudo mkdir –p /var/hadoop_data/datanode
sudo chown arit:arit –R /var/hadoop_data

#3.install hadoop
tar –xvf hadoop-2.7.2.tar.gz
sudo mv ./hadoop-2.7.2/* /usr/local/hadoop
sudo chown arit:arit –R /usr/local/hadoop

#4.setup hadoop variable environment
nano .bashrc

#TODO this has to be added to the file manually, though with bash script can be done 
# export HADOOP_HOME=/usr/local/hadoop
# export PATH=$PATH:$HADOOP_HOME/bin
# export PATH=$PATH:$HADOOP_HOME/sbin 

#5. edit hadoop-env.sh script to set java env
cd /usr/local/hadoop/etc/hadoop
nano hadoop-env.sh

#TODO this has to be added to the file manually, though with bash script can be done 
# export JAVA_HOME=/usr/lib/jvm/java-8-oracle
# export HADOOP_LOG_DIR=/var/log/hadoop

#6. edit yarn-env.sh script to set yarn log dir
nano yarn-env.sh

#TODO this has to be added to the file manually, though with bash script can be done 
# export YARN_LOG_DIR = /var/log/hadoop

#7. format hdfs file system
hdfs namenode -format

#8. start hadoop (at /usr/local/hadoop/etc/hadoop)
#8.1 start HDFS
start-dfs.sh 
#TODO cheeck whether 2 processes: NameNode and DataNode are running 
jps
#8.2 start YARN
start-yarn.sh
#TODO cheeck whether 2 processes: ResourceManager and NodeManager are running 
jps

#9. to stop hadoop 
stop-yarn.sh
stop-dfs.sh
#TODO check hadoop process
jps

#10. install MapReduce 
cd /usr/local/Hadoop/share/hadoop/mapreduce
hadoop jar hadoop-mapreduce-examples-2.7.2.jar pi 10 1000
sudo mkdir /user/lab
sudo nano /user/lab/wc-data.txt
sudo mkdir /user/lab/output

#11. observe terminal screen
hadoop jar hadoop-mapreduce-examples-2.7.2.jar wordcount /user/lab/wc-data.txt /user/lab/output/o2

#12. after successfully installed HDFS, YARN, MapReduce, go to configure the following files in these directory
# Main Package Directory : /usr/local/hadoop
# Data Directory : /var/hadoop_data/namenode
#		 : /var/hadoop_data/datanode
# Log file Directory : /var/log/hadoop
cd /usr/local/Hadoop/etc/hadoop

#12.1 core-site.xml
nano core-site.xml

#TODO add this
<configuration>
        <property>
                <name>fs.defaultFS</name>
                <value>hdfs://localhost:9000</value>
        </property>
        <property>
                <name>hadoop.proxyuser.root.hosts</name>
                <value>*</value>
        </property>
        <property>
                <name>hadoop.proxyuser.root.groups</name>
                <value>*</value>
        </property>
</configuration>

#12.2 hdfs-site.xml
nano hdfs-site.xml

#TODO add this
<configuration>
        <property>
                <name>dfs.replication</name>
                <value>1</value>
        </property>
        <property>
                <name>dfs.namenode.name.dir</name>
                <value>file:/var/hadoop_data/namenode</value>
        </property>
        <property>
                <name>dfs.namenode.data.dir</name>
                <value>file:/var/hadoop_data/datanode</value>
        </property>
        <property>
                <name>dfs.namenode.acls.enabled</name>
                <value>true</value>
        </property>

</configuration>

#12.3 yarn-site.xml
nano yarn-site.xml

#TODO add this
<configuration>
<!-- Site specific YARN configuration properties -->
        <property>
                <name>yarn.resourcemanager.hostname</name>
                <value>localhost</value>
        </property>
        <property>
                <name>yarn.resourcemanager.scheduler.address</name>
                <value>localhost:8030</value>
        </property>
        <property>
                <name>yarn.resourcemanager.resource-tracker.address</name>
                <value>localhost:8031</value>
        </property>
        <property>
                <name>yarn.resourcemanager.address</name>
                <value>localhost:8032</value>
        </property>
        <property>
                <name>yarn.resourcemanager.admin.address</name>
                <value>localhost:8033</value>
        </property>
        <property>
                <name>yarn.resourcemanager.webapp.address</name>
                <value>localhost:8088</value>
        </property>
        <property>
                <name>yarn.nodemanager.aux-services</name>
                <value>mapreduce_shuffle</value>
        </property>
        <property>
                <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class<$
                <value>org.apache.hadoop.mapred.ShuffleHandler</value>
        </property>

</configuration>

#12.4 mapred-site.xml
nano mapred-site.xml

#TODO add this
<configuration>

        <property>
                <name>mapreduce.framework.name</name>
                <value>yarn</value>
        </property>

</configuration>

#13. Initial HDFS : HDFS Formatting
hadoop namenode -format

#14. start hadoop (at /usr/local/hadoop/etc/hadoop)
#14.1 start HDFS
start-dfs.sh 
#TODO cheeck whether 2 processes: NameNode and DataNode are running 
jps
#14.2 start YARN
start-yarn.sh
#TODO cheeck whether 2 processes: ResourceManager and NodeManager are running 
jps

#15. to stop hadoop 
stop-yarn.sh
stop-dfs.sh
#TODO check hadoop process
jps

#16. Post Test Installation
http://< IP >:50070/
http://< IP >:8088
















































