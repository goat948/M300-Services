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




<div id='Fazit'/>

# Fazit
