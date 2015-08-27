#!/bin/bash
#
# Sets up /var/www/meza1/htdocs as a shared drive via samba
#

echo "Installing samba"
yum -y install samba samba-client samba-common

chkconfig smb on
chkconfig nmb on

echo "Setting up iptables rules"
iptables -I INPUT 4 -m state --state NEW -m udp -p udp --dport 137 -j ACCEPT
iptables -I INPUT 5 -m state --state NEW -m udp -p udp --dport 138 -j ACCEPT
iptables -I INPUT 6 -m state --state NEW -m tcp -p tcp --dport 139 -j ACCEPT
service iptables save


cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
rm /etc/samba/smb.conf
touch /etc/samba/smb.conf


cat > /etc/samba/smb.conf <<- EOM
#======================= Global Settings =====================================
[global]
workgroup = WORKGROUP
security = share
map to guest = bad user
#============================ Share Definitions ==============================
[MyShare]
path = /var/www/meza1/htdocs
browsable =yes
writable = yes
guest ok = yes
read only = no
EOM

# restart samba services
service smb restart
service nmb restart


chmod -R 0777 /var/www/meza1/htdocs