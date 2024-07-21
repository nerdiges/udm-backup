#!/bin/bash

######################################################################################
#
# Description:
# ------------
#	Backup UDM Pro customisations stored in /data/custom.
#
######################################################################################

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


# set scriptname
me=$(basename $0)

echo "$(dirname $0)/${me%.*}.conf"

# include local configuration if available
[ -e "$(dirname $0)/${me%.*}.conf" ] && source "$(dirname $0)/${me%.*}.conf"

# save current date for filenames
date=$(date +%Y%m%d)

# create target dir for backups
backup_dir=${backup_dir%/}/${date}
mkdir -p ${backup_dir}

# Backup custom directory
cd /
tar cvfz ${backup_dir}/${date}-udmpro-custom-backup.tgz data/custom

# Backup systemd service and timer status
systemctl status udm-* >  ${backup_dir}/${date}-status-udm-services.txt

# Backup systemd service and timer status
machinectl list >  ${backup_dir}/${date}-machinectl.txt

# backup IPv4 rules
xtables-legacy-multi save4 > ${backup_dir}/${date}-udmp-iptables-save.txt
iptables -L -v -n > ${backup_dir}/${date}-udmp-iptables-Lv.txt

# backup IPv6 rules
xtables-legacy-multi save6 > ${backup_dir}/${date}-udmp-ip6tables-save.txt
ip6tables -L -v -n > ${backup_dir}/${date}-udmp-ip6tables-Lv.txt

# ipsets exportieren
ipset -o save list > ${backup_dir}/${date}-udmp-ipset-save.txt
ipset list > ${backup_dir}/${date}-udmp-ipset.txt
