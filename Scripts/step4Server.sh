name=c7002.symantec.dev.com

openssl x509 -req -CA /home/vagrant/securityDemo/ca-cert -CAkey /home/vagrant/securityDemo/ca-key -in /vagrant/data/cert-file-$name  -out /vagrant/data/cert-signed-$name  -days 36 -CAcreateserial -passin pass:test1234

cp /home/vagrant/securityDemo/ca-cert /vagrant/data/ca-cert-7001

