![M300-Banner](picture/Banner_meo.png)

# Inahltsverzeichnis
 1. [Einleitung](#Einleitung)
 
 1. [Umgebung VMs](#Umgebung) 

 2. [Code Beschreibung](#code)

 2. [Ablauf](#ablauf)
    - [SSH](#ssh)
    - [Samba](#samba)
    - [Exit](#exit)
 3. [Fazit](#Fazit)




<div id='Einleitung'/>

# Einleitung

In dieser LB2 lernen wir die Vagrant umgebung kennen und damit zu arbeiten. Das Ziel der Aufgabe ist es mit hilfe von Vagrant eine Dienstleitung mit mehreren VMs zu erstellen. Wir haben dafür einen Fileserver sowie einen Client erzeugt. Eine Servermaschine für den SMB Fileserver und einen Client, der darauf zugreifen kann. Durch das könen alle Geräte die im selben Netzwerk sind auf freigegeben Dateien zugreifein und es können Berechtigungen für die Ordner & Dateien vergeben werden.

<div id='Umgebung'/>

# Umgebung VMs
![M300-Banner](picture/umgebung.png)

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
  ```
<div id='ablauf'/>

# Ablauf
### Hochfahren:

Um die Umgebung hoch zufahren, muss man im Terminal im **gleichen Ordner wie das Vagrantfile** sein und **vagrant up** eingeben. Dies dauert eine Weile, da es die Nötigen Daten herunterladet und die VMs erstellt und konfiguriert.

<a name="herunterfahren"></a>
### Herunterfahren:

Wenn man nun die Umgebung herunterfahren möchte, muss man im Terminal im **gleichen Ordner wie das Vagrantfile** sein und **vagrant halt** eingeben.

<a name="umgebung-löschen"></a>
### Umgebung vom Gerät löschen:

Um die Umgebung vom Gerät nun zu löschen, muss man im Terminal im **gleichen Ordner wie das Vagrantfile** sein und den Befehl **vagrant destroy** eingeben. 
> **NOTE:** Man muss bei den Maschinen die beide Male **"y"** eingeben, um zu bestätigen, dass man die VMs auch wirklich löschen will.

<a name="befehl-tabelle-vagrant"></a>

### Befehl-Tabelle Vagrant:

|Befehl    |Command (im Terminal)                    |
|-------------------------|--------------------------|
|hochfahren / erstellen   |`vagrant up`              |
|herunterfahren           |`vagrant halt`            |
|löschen                  |`vagrant destroy`         |

<a name="ssh"></a>
### SSH
Auf dem LB-Fileserver sowie auf dem LB-Client sind die SSH User Vagrant.
- Benutzername: vagrant
- Passwort: vagrant

<a name="samba"></a>
### SAMBA

Um auf den privaten Samba Share zugreifen zu können, braucht es einen privaten Benutzer: "lb-user"
- Benutzername: lb-user
- Passwort: password 


## Zugreifen auf den privaten Share

Zugreifen auf den Samba Share via Ubuntuclient Terminal:

|welcher Share    |Command (im Terminal)                                    |
|-----------------|---------------------------------------------------------|
|privaten Share   |`smbclient //192.168.9.48/lb-user -U lb-user`              |
|public Share     |`smbclient //192.168.9.48/public`                        |
|Allgemein        |`smbclient //*IP Adresse*/*Ordner* -U *Benutzername*`    |


## Ordner erstellen und anzeigen
Wenn wir Zugriff auf die Shares haben, können wir nun darauf Ordner erstellen.

<a name="exit"></a>
## Exit

### Aus Sambashare

Um den Share zu verlassen, in welchen man sich eingeloggt hat, muss man nur einen Befehl eingeben:
> exit

### Aus SSH

Um die SSH Verbindung (im Terminal von z.B. Visual Studio Code,...) zu trennen, muss man lediglich einen Befehl eingeben:
> exit


<div id='Fazit'/>

# Fazit

Die Lb fand ich sehr spannend da Vagrant für mich komplett neu war. Ich lernte vieles neues dazu und auch das Markdown hat mir sehr spass gemacht zu erstellen und eine neue Art zu Dokumentieren kennen zu lernen. Probleme hatte ich ansich nicht viele es ging einfach eine Zeit bis ich mich in die ganze Umgebung eingelesen habe und mir die ganzen Standart sowie erweiterten Befehle angeübt habe. In Zukunft werde ich glaube ich öfters wieder mal mit Mardown Dokumentieren soweit es gut gebraucht werden könnte und die Kunden oder Lehrer es als Abgabe Form akzeptieren.
