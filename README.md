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

## Image

<p align="center">
  <img src="https://github.com/Symantec/kafka-security-0.9/blob/master/src/main/resources/POC%20Security.jpg" align="center">
</p>
## Installation  and Running (install commands)
### Step1
* git clone https://github.com/Symantec/kafka-security-0.9.git
* cd kafka-security-demo
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
```shell
        sh kafka_2.11-0.9.0.1/bin/kafka-console-producer.sh --broker-list 192.168.70.101:9093 --topic test --producer.config securityDemo/producer.properties
```
    * Java Producer, Go outside the Vagrant box
```Java
           mvn clean package
```
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

* Consumer
   * On the client  c7002
   * Add Consumer group
      * vim securityDemo/producer.properties
      * group.id=group102
   * Run the new consumer
   
```shell
     sh kafka_2.11-0.9.0.1/bin/kafka-console-consumer.sh --bootstrap-server c7001.symantec.dev.com:9093  --topic test --from-beginning --new-consumer --consumer.conf securityDemo/producer.properties
```
    
    
## List important functions with example commands
   * sh kafka_2.11-0.9.0.1/bin/kafka-acls.sh  --authorizer-properties zookeeper.connect=localhost:2181   --list
   * sh kafka_2.11-0.9.0.1/bin/kafka-topics.sh --list --zookeeper localhost:2181

## Contributions

<a href="https://github.com/supermonk">Narendra Bidari</a> </br>
<a href="https://github.com/mahipalj27">Mahipal</a>

## References, Additional Information

* https://msdn.microsoft.com/en-us/library/windows/desktop/aa382479(v=vs.85).aspx
* http://stackoverflow.com/questions/35653128/kafka-ssl-security-setup-causing-issue
* http://kafka.apache.org/documentation.html#security_ssl
* https://www.sslshopper.com/article-most-common-java-keytool-keystore-commands.html
* https://chrisjean.com/change-timezone-in-centos/
* http://docs.confluent.io/2.0.0/kafka/ssl.html
* https://developer.ibm.com/messaging/2016/03/03/message-hub-kafka-java-api/
* http://kafka.apache.org/documentation.html#security_authz
* https://cwiki.apache.org/confluence/display/KAFKA/Security
* 
 


# Contributions
Prior to receiving information from any contributor, Symantec requires that all contributors complete, sign, and submit Symantec Personal Contributor Agreement (SPCA). The purpose of the SPCA is to clearly define the terms under which intellectual property has been contributed to the project and thereby allow Symantec to defend the project should there be a legal dispute regarding the software at some future time. A signed SPCA is required to be on file before an individual is given commit privileges to the Symantec open source project. Please note that the privilege to commit to the project is conditional and may be revoked by Symantec.

If you are employed by a corporation, a Symantec Corporate Contributor Agreement (SCCA) is also required before you may contribute to the project. If you are employed by a company, you may have signed an employment agreement that assigns intellectual property ownership in certain of your ideas or code to your company. We require a SCCA to make sure that the intellectual property in your contribution is clearly contributed to the Symantec open source project, even if that intellectual property had previously been assigned by you.

Please complete the SPCA and, if required, the SCCA and return to Symantec at:

Symantec Corporation Legal Department Attention: Product Legal Support Team 350 Ellis Street Mountain View, CA 94043

Please be sure to keep a signed copy for your records.

# License
Copyright 2016 Symantec Corporation.

Licensed under the Apache License, Version 2.0 (the “License”); you may not use this file except in compliance with the License.

You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
