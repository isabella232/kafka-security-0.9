## Pragmatic Kafka Security 0.9, Setup and Java Producer

- Jump Start  Kafka Security implementation.
- SSL for Authentication, ACL for Authorization
- The below steps will provide 4 vms with Kafka Zookeeper installed on all of them via Vagrant
- SSL authentication will be enabled between the Consumers and Brokers
- ACL is also enabled


## Prerequisites
- Vagrant : Vagrant installation  https://www.vagrantup.com/downloads.html 
- Maven
- Basic Java / Kafka Understanding.
- git

# Note
- New Console Consumer adds Group.id by default.
- Main Commands. Vagrant suspend, Vagrant resume --no-provision , Vagrant destroy
- To clean up all, just run vagrant destroy -f (everything will get cleaned)

## Installation  and Running (install commands)
### Step1
* git clone http://ddd.cicd.ash2.symcpe.net/r/kaka-security-demo
* cd kaka-security-demo
* Run Start.sh     and go for coffee or just read along documentation ( 10 - 15 min)
    * (internally runs  sh /vagrant/data/step1-all.sh       => update software, install java, kafka, zoo)
    * (internally runs  sh /vagrant/data/step2server.sh     => Become CA root, generate public and private key)
    * (internally runs  sh /vagrant/data/step3client.sh     =>  generates ca request and puts in shared folder /vagrant/data)
    
### Step 2 :
* open a new terminal same path ($PWD), run the below commands
    * vagrant ssh c7001                             => Login to Box
    * sudo su                                       => Login as root
    * sh /vagrant/data/step4Server.sh               =>Sign the cert-request from C700* and put signed request to /vagrant/data/ and also copy the root-ca
        * Edit the file, update the hostname for each client, default to c7002
    
* In the New terminal same path ($PWD),
    * vagrant ssh c7002,3,4 (one bo)                =>Login to Box
    * sudo su                                       =>Login as root
    * sh /vagrant/data/step5client.sh               =>Install both root Ca and signed Certificate

### Step 3 :
* start Zookeeper on server 
    * sh zookeeper-3.4.8/bin/zkServer.sh start
* start kafka on server

```shell
sh kafka_2.11-0.9.0.1/bin/kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 --operation All --allow-principal User:*--allow-host 192.168.70.101 --add --cluster
    This will allow local server machine all ACL
nohup sh kafka_2.11-0.9.0.1/bin/kafka-server-start.sh kafka_2.11-0.9.0.1/config/server.properties & (Run in background)
```

* Create Topic
```shell
sh kafka_2.11-0.9.0.1/bin/kafka-topics.sh --create --zookeeper 192.168.70.101:2181 --replication-factor 1 --partitions 1 --topic test
sh kafka_2.11-0.9.0.1/bin/kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 --operation Write --allow-principal User:* --allow-host 192.168.70.101 --add --topic test
```

* Enter data, Two Options
    * manual Producer
        *
```shell
        sh kafka_2.11-0.9.0.1/bin/kafka-console-producer.sh --broker-list 192.168.70.101:9093 --topic test --producer.config securityDemo/producer.properties
```
    * Java Producer, Go outside the Vagrant box
        * 
```Java
           mvn clean package
```
        *
```shell
         cp src/main/resources/Producer.Properties data/
         cp target/kafka-security-demo-1.0.0-jar-with-dependencies.jar data/
```
        * Login into Server, Vagrant ssh c7001 and run below
```Java
         java -cp /vagrant/data/kafka-security-demo-1.0.0-jar-with-dependencies.jar com.symantec.cpe.KafkaProducer /vagrant/data/Producer.Properties
```
    * Allow c7002 to read data
```shell
        sh kafka_2.11-0.9.0.1/bin/kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 --operation Read --allow-principal User:* --allow-host 192.168.70.102 --add --topic test --group group102
```
*Consumer
    * On the client  c7002
    * Add Consumer group
        * vim securityDemo/producer.properties
        * group.id=group102
    * Run the new consumer
```shell
     sh kafka_2.11-0.9.0.1/bin/kafka-console-consumer.sh --bootstrap-server c7001.symantec.dev.com:9093  --topic test --from-beginning --new-consumer --consumer.conf securityDemo/producer.properties
```
    
    
## List important functions with example commands
sh kafka_2.11-0.9.0.1/bin/kafka-acls.sh  --authorizer-properties zookeeper.connect=localhost:2181   --list
sh kafka_2.11-0.9.0.1/bin/kafka-topics.sh --list --zookeeper localhost:2181

## Running project

## Configuration (config commands)

## List important functions with example commands

## Download

## Contributions
 
