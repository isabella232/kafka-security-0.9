whoami
sleep 2

yum install java -y
yum install openssl -y
#yum install java-1.8.0-openjdk-headless -y
#yum update -y
yum install telnet -y

wget http://ftp.wayne.edu/apache/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz
tar -xvf kafka_2.11-0.9.0.1.tgz
cd kafka_2.11-0.9.0.1/config/

echo "############################# Security  #############################" >>server.properties
echo "listeners=SSL://:9093" >>server.properties
echo "security.inter.broker.protocol=SSL" >> server.properties
echo "ssl.client.auth=required" >> server.properties
echo "ssl.keystore.location=/home/vagrant/securityDemo/kafka.server.keystore.jks" >> server.properties
echo "ssl.keystore.password=test1234" >> server.properties
echo "ssl.key.password=test1234" >> server.properties
echo "ssl.truststore.location=/home/vagrant/securityDemo/kafka.server.truststore.jks" >> server.properties
echo "ssl.truststore.password=test1234" >> server.properties
echo "ssl.enabled.protocols=TLSv1.2,TLSv1.1,TLSv1" >> server.properties
echo "authorizer.class.name=kafka.security.auth.SimpleAclAuthorizer" >> server.properties

cd ../../

wget http://apache.cs.utah.edu/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz
tar -xvf zookeeper-3.4.8.tar.gz 
cp zookeeper-3.4.8/conf/zoo_sample.cfg zookeeper-3.4.8/conf/zoo.cfg

sed '/127.0.0.1*/d' -i /etc/hosts
echo "127.0.0.1  localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/hosts
echo "192.168.70.101 c7001.symantec.dev.com c7001"  >> /etc/hosts
echo "192.168.70.102 c7002.symantec.dev.com c7002"  >> /etc/hosts
echo "192.168.70.103 c7003.symantec.dev.com c7003"  >> /etc/hosts
echo "192.168.70.104 c7004.symantec.dev.com c7004" >> /etc/hosts
