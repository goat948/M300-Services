#!/usr/bin/env bash

echo "---UPDATING SERVER MACHINE---"
sudo apt-get update 

echo "---INSTALLING SAMBA"
sudo apt-get install samba -y
sudo systemctl stop nmbd.service
sudo systemctl disable nmbd.service

echo "---STOPPING SMBD---"
sudo systemctl stop smbd.service

echo "---MOVING SMB.CONF---"
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.orig
sudo cp /vagrant/provision/smb.conf /etc/samba/smb.conf

echo "---CREATING FOLDER STRUCTURE---"
sudo mkdir /samba/
sudo chown :sambashare /samba/
sudo mkdir /samba/lb-user
sudo mkdir /samba/public

echo "---ADDING lb-user---"
sudo adduser --home /samba/lb-user --no-create-home --shell /usr/sbin/nologin --disabled-password --ingroup sambashare lb-user
echo "lb-user:password" | sudo chpasswd

echo "---PERMISSIONS ON FOLDERS---"
sudo chown lb-user:sambashare /samba/lb-user/
sudo chmod 2770 /samba/lb-user/
sudo chmod 777 /samba/public/

echo "---ADDING SMB USER---"
echo -ne "password\npassword\n" |smbpasswd -a -s lb-user
sudo smbpasswd -e lb-user

echo "---STARTING SMBD---"
sudo systemctl start smbd.service
