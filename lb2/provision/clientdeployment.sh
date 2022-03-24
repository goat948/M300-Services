#!/usr/bin/env bash

echo "---UPDATING CLIENT MACHINE---"
sudo apt-get update 

echo "---DOWNLOADING SMBCLIENT---"
sudo apt-get install smbclient -y
