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

