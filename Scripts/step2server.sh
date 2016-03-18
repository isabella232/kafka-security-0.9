#reset rm -rf kafka.* ca-* cert-*
name=$HOSTNAME

folder=securityDemo

rm -rf $folder
mkdir $folder
cd $folder
printf "test1234\ntest1234\nc7001.symantec.dev.com\ntest\ntest\ntest\ntest\ntest\nyes\n\n" | keytool -keystore kafka.server.keystore.jks -alias $name  -validity 365 -genkey

printf "te\ntest\ntest\ntest\ntest\nc7001.symantec.dev.com\nasdf@test.com\n" | openssl req -new -x509 -keyout ca-key -out ca-cert -days 365 -passout pass:test1234
echo "done"
printf "test1234\ntest1234\nyes\n" | keytool -keystore kafka.server.truststore.jks -alias CARoot -import -file ca-cert
printf "test1234\ntest1234\nyes\n" | keytool -keystore kafka.client.truststore.jks -alias CARoot -import -file ca-cert
printf "test1234\n" | keytool -keystore kafka.server.keystore.jks -alias $name -certreq -file cert-file
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out cert-signed -days 365 -CAcreateserial -passin pass:test1234
printf "test1234\nyes\n" | keytool -keystore kafka.server.keystore.jks -alias CARoot -import -file ca-cert
printf "test1234\nyes\n" | keytool -keystore kafka.server.keystore.jks -alias $name -import -file cert-signed

#producer.propeties
rm -rf producer.properties

printf $PWD


echo "bootstrap.servers=localhost:9093" >> producer.properties
echo "security.protocol=SSL" >> producer.properties
echo "ssl.truststore.location=$PWD/kafka.client.truststore.jks">> producer.properties
echo "ssl.truststore.password=test1234">> producer.properties
echo "ssl.keystore.location=$PWD/kafka.server.keystore.jks">> producer.properties
echo "ssl.keystore.password=test1234">> producer.properties
echo "ssl.key.password=test1234">> producer.properties

