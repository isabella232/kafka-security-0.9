#vagrant init hashicorp/precise64
rm -rf data
mkdir data
cp Scripts/backup Vagrantfile
cp -R Scripts/*.sh data/
sleep 2
vagrant up
