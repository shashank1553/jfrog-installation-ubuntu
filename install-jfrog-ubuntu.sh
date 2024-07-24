#!/bin/bash

echo "\n################################################################"
echo "#                                                              #"
echo "#                     ***Artisan Tek***                        #"
echo "#                 Artifactory  Installation                    #"
echo "#                                                              #"
echo "################################################################"

# Installing necessary packages
echo "\n\n*****Installing necessary packages"
sudo apt-get update -y > /dev/null 2>&1
sudo apt-get install -y openjdk-17-jre unzip > /dev/null 2>&1
echo "            -> Done"

# Configuring Artifactory as a Service
echo "*****Configuring Artifactory as a Service"
sudo useradd -r -m -U -d /opt/artifactory -s /bin/false artifactory 2>/dev/null
sudo cp artifactory.service /etc/systemd/system/artifactory.service
sudo systemctl daemon-reload 1>/dev/null
echo "            -> Done"

# Downloading JFROG Artifactory 6.9.6 version to OPT folder
echo "*****Downloading JFROG Artifactory 6.9.6 version"
sudo systemctl stop artifactory > /dev/null 2>&1
cd /opt 
sudo rm -rf jfrog* artifactory*
sudo wget -q https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/7.7.3/jfrog-artifactory-oss-7.7.3-linux.tar.gz
sudo tar -xvf -q jfrog-artifactory-oss-7.7.3-linux.tar.gz -d /opt/artifactory 1>/dev/null
sudo chown -R artifactory: /opt/artifactory/*
sudo rm -rf jfrog-artifactory-oss-7.7.3-linux.tar.gz
echo "            -> Done"

# Starting Artifactory Service
echo "*****Starting Artifactory Service"
sudo systemctl start artifactory 1>/dev/null


# Check if Artifactory is working
sudo systemctl is-active --quiet artifactory
echo "\n################################################################ \n"
if [ $? -eq 0 ]; then
	echo "Artifactory installed Successfully"
	echo "Access Artifactory using $(curl -s ifconfig.me):8081"
else
	echo "Artifactory installation failed"
fi
echo "\n################################################################ \n"

