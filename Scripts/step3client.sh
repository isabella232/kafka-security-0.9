
name=$HOSTNAME
dirname=securityDemo

rm -rf $dirname
mkdir $dirname
cd $dirname

printf "test1234\ntest1234\n$name\ntest\ntest\ntest\ntest\ntest\nyes\n\n" |  keytool -keystore kafka.client.keystore.jks -alias $name -validity 36 -genkey
printf "test1234\ntest1234\nyes\n" |keytool -keystore kafka.client.keystore.jks -alias $name -certreq -file cert-file

cp cert-file /vagrant/data/cert-file-$name

