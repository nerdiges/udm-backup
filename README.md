# udm-backup
Custom Einstellungen auf der UDM Pro sichern.

Ich habe die Installation meiner UDM PRo etwas angepasst (z.B. Fiewall-Regeln, Containerized Apps, ...). Die Custom-Einstellungen werden dabei nicht vom Standard UnifiOS Backup berücksichtigt. Bei jedem UnifiOS-Update besteht daher das Risiko, dass die Einstellungen dadurch überschrieben werden

## Voraussetzungen
Unifi Dream Machine Pro mit UnifiOS Version >= 4.x. Erfolgreich getestet mit UnifiOS 4.0.6.

## Funktionsweise
Das Script `udm-backup.sh` erzeugt beim Aufruf ein TAR-Archiv des Verzeichnisses /data/custom und speichert dieses in einem Konfigurierbaren Verzeichnis ab. Außerdem wird in dem Verzeichnis auch ein Dump des aktuellen Firewall-Regelwerks und der konfigurierten IP-Sets gespeichert.

## Disclaimer
Änderungen die dieses Script an der Konfiguration der UDM-Pro vornimmt, werden von Ubiquiti nicht offiziell unterstützt und können zu Fehlfunktionen oder Garantieverlust führen. Alle BAÄnderungenkup werden auf eigene Gefahr durchgeführt. Daher vor der Installation: Backup machen nicht vergessen!

## Installation
Nachdem eine Verbindung per SSH zur UDM/UDM Pro hergestellt wurde wird udm-backup folgendermaßen installiert:

**1. Download der Dateien**

```
mkdir -p /data/custom
dpkg -l git || apt install git
git clone https://github.com/nerdiges/udm-backup.git /data/custom/backup
chmod +x /data/custom/backup/udm-backup.sh
```

**2. Parameter im Script anpassen (optional)**

Im Script kann über eine Variablen das Verzeichnis hinterlegt werden, in dem das BAckup gespeichert werden soll:

```
##############################################################################################
#
# Configuration
#

# directory where to store backups files. Each backup will be stored in a seperate subfolder 
# with the current date.
# WARNING:  Make sure the drive, where you want to store the backup has enough space available. 
#           In case the root partition is full, this may affect the availability of the UDM.
backup_dir="/volume1/backups/"

#
# No further changes should be necessary beyond this line.
#
##############################################################################################
```

Dieser Parameter muss in der Regel nicht angepasst weden.

Die Konfiguration kann auch in der Datei udm-backup.conf gespeichert werden, die bei einem Update nicht überschrieben wird.

**3. Einrichten der systemd-Services (optional)**
Soll das Script nur bei Bedarf manuell ausgeführt werden (z.B. vor einem Systemupdate), dann ist die Einrichtung von Services nicht erforderlich.
Sollen allerdings regelmäßig backups erzeugt werden, dann kann das Script entweder über cron oder über systemd regelmäßig gestartet werden.

Beispiel zur Aktivierung des Backups per systemd:

```
# Install udm-backup.service and timer definition file in /etc/systemd/system via:
ln -s /data/custom/backup/udm-backup.service /etc/systemd/system/udm-backup.service
ln -s /data/custom/backup/udm-backup.timer /etc/systemd/system/udm-backup.timer

# Reload systemd, enable and start the service and timer:
systemctl daemon-reload
systemctl enable --now backup.timer

# check status of timer
systemctl status udm-backup.timer 
```

## Update

Das Script kann mit folgenden Befehlen aktualisiert werden:
```
cd /data/custom/backup
git pull origin
```
