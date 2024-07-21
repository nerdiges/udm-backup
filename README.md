# udm-sarp
Statische ARP-Einträge auf der UDM Pro.

In meinem Netzwerk nutze ich unterschiedliche Netzwerke, die mit der UDM Pro voneinander getrennt werden. Damit Systeme im Netzwerk per WOL mittels eines Magic-Packets gestartet werden können, muss die UDM PRo wissen in welches Netzwerksegment die WOL-Pakete weitergeleitet werden müssen. Dazu müssen statische ARP-Einträge angelegt werden, damit der UDM-Pro die MAC-Adresse für das ausgeschaltete System per ARP ermitteln kann.

## Voraussetzungen
Unifi Dream Machine Pro mit UnifiOS Version 3.x. Erfolgreich getestet mit UnifiOS 3.2.12 und Network App 8.0.28.

## Funktionsweise
Das Script `udm-sarp.sh` wird beim Systemstart per systemd ausgeführt und setzt dann die in der Datei sarp.config definierten statische Einträge in der ARP-Tabelle der UDM-Pro. Diese bleiben auch dann erhalten, wenn das entsprechende Systeme für längere Zeit ausgeschaltet ist.

## Disclaimer
Änderungen die dieses Script an der Konfiguration der UDM-Pro vornimmt, werden von Ubiquiti nicht offiziell unterstützt und können zu Fehlfunktionen oder Garantieverlust führen. Alle BAÄnderungenkup werden auf eigene Gefahr durchgeführt. Daher vor der Installation: Backup machen nicht vergessen!

## Installation
Nachdem eine Verbindung per SSH zur UDM/UDM Pro hergestellt wurde wird udm-sarp folgendermaßen installiert:

**1. Download der Dateien**

```
mkdir -p /data/custom
dpkg -l git || apt install git
git clone https://github.com/nerdiges/udm-sarp.git /data/custom/sarp
chmod +x /data/custom/sarp/udm-sarp.sh
```

**2. Parameter im Script anpassen (optional)**

Im Script kann über eine Variablen das Verzeichnis hinterlegt werden, in dem die sarp Config-Files abgelegt werden:

```
##############################################################################################
#
# Configuration
#

# directory with sarp config files. All *.conf files in the directory will be considered 
# as valid static arp entries.
conf_dir="/data/custom/sarp/"

#
# No further changes should be necessary beyond this line.
#
##############################################################################################
```

Dieser Parameter muss in der Regel nicht angepasst weden.

Die Konfiguration kann auch in der Datei udm-sarp.conf gespeichert werden, die bei einem Update nicht überschrieben wird.

**3. Einrichten der systemd-Services**

```
# Install udm-sarp.service definition file in /etc/systemd/system via:
ln -s /data/custom/sarp/udm-sarp.service /etc/systemd/system/udm-sarp.service

# Reload systemd, enable and start the service and timer:
systemctl daemon-reload
systemctl enable udm-sarp.service
systemctl start udm-sarp.service
```

**4. sarp Config-Files**

Damit die statischen ARP-Einträge angelegt werden, müssen die anzulegenden IP-Adresse/MAC-Adress-Kombinationen in der Datei sarp.conf im Verzeichnis `$conf_dir` (siehe oben Punkt 2) abgelegt werden.

## Update

Das Script kann mit folgenden Befehlen aktualisiert werden:
```
cd /data/custom/sarp
git pull origin
```
