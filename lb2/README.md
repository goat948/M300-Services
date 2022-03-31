![M300-Banner](picture/Banner_meo.png)

# Inahltsverzeichnis
 1. [Einleitung](#Einleitung)
 
 1. [Umgebung VMs](#Umgebung) 

 2. [Code Beschreibung](#code)

 3. [Fazit](#Fazit)




<div id='Einleitung'/>

# Einleitung





<div id='Umgebung'/>

# Umgebung VMs


| Client   |      Server     |
|:----------|:-------------|
| Hostname --> ubuntuclient | Hostname --> ubuntuserver|
| VM Name --> LB-Clinet|    VM Name --> LB-Fileserver  |
| IP:  192.168.9.47  |IP:  192.168.9.48  | 
| | Samba |




### Shares
- **LB-User Share:**
Nur der Benutzer lb-user kann auf diese Freigabe zugreifen. Dazu benötigen Sie ihren Benutzernamen und ihr Passwort, während allen anderen der Zugriff verweigert wird. In dieser Freigabe kann nur der lb-Benutzer Dateien erstellen und löschen und hat vollen Zugriff auf die Freigabe.
> **Hinweis:** Benutzername und Passwort werden bereitgestellt

- **Public Share:**
Jeder kann auf diese Freigabe zugreifen. Hier ist kein Konto erforderlich, jeder hat das Recht, Dateien und Ordner in dieser Freigabe zu löschen


<div id='code'/>

# Code Beschreibung

Im code wird oben zuerst der Hostname definiert, später definieren wir für den Fileserver eine IP Adresse angegeben, diese IP Adresse muss im gleichem Netzwerk wie die vom Client sein, wir haben eine /24 Subnetzmaske (192.168.9.xxx). Bei der VM Konfiguration definieren wir den VM Namen der und Virtual Box anzeigen wird. Bei den letzten Zeilen geben wir nun noch unsere gewünschte Hardware Konfiguration. (CPU & RAM)

VM Server (Samba)
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|

  # Fileserver
  config.vm.define "ubuntuserver" do |fileserver|
    fileserver.vm.hostname = "ubuntuserver"
    fileserver.vm.box = "ubuntu/xenial64"
    
    # Netzwerk Konfigurieren
    fileserver.vm.network "private_network", ip: "192.168.9.48"

    # VM Konfigurieren
    fileserver.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = "LB-Fileserver"

      # VM Hardware
      vb.memory = "2048"
      vb.cpus = "2"
    end

    # Provision Script
    fileserver.vm.provision "shell", path: "provision/serverdeployment.sh"
  end
  
  ```
VM Clinet
```ruby
 # Client VM
  config.vm.define "ubuntuclient" do |client|
    client.vm.hostname = "ubuntuclient"
    client.vm.box = "generic/ubuntu1804"

    # Netzwerk Konfigurationen
    client.vm.network "private_network", ip: "192.168.9.47"

    # VM Konfigurationen
    client.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = "LB-Client"
      
      # VM Hardware
      vb.memory = "4096"
      vb.cpus = "4"
      vb.customize ["modifyvm", :id, "--vram", "128"]
    end

    # Provision Script
    client.vm.provision "shell", path: "provision/clientdeployment.sh"
  end

end

<div id='Fazit'/>

# Fazit
  ```
