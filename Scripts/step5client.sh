name=$HOSTNAME

cd securityDemo
printf "test1234\nyes\n" | keytool -keystore kafka.client.keystore.jks -alias CARoot -import -file /vagrant/data/ca-cert-7001
printf "test1234\nyes\n" | keytool -keystore kafka.client.keystore.jks -alias $name -import -file /vagrant/data/cert-signed-$name



#producer.propeties
rm -rf producer.properties

printf $PWD


echo "bootstrap.servers=localhost:9093" >> producer.properties
echo "security.protocol=SSL" >> producer.properties
echo "ssl.truststore.location=$PWD/kafka.client.keystore.jks">> producer.properties
echo "ssl.truststore.password=test1234">> producer.properties
echo "ssl.keystore.location=$PWD/kafka.client.keystore.jks">> producer.properties
echo "ssl.keystore.password=test1234">> producer.properties
echo "ssl.key.password=test1234">> producer.properties

