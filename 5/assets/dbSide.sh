#!/bin/bash
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
if [ $? -eq 0 ]; then
    echo "SELinux désactivé"
else
    echo "SELinux non désactivé"
fi
hostnamectl set-hostname db
apt-get update
dnf install mariadb-server -y
if [ $? -eq 0 ]; then
    echo "MariaDB installé"
else
    echo "MariaDB non installé"
fi
systemctl start mariadb
systemctl enable mariadb
firewall-cmd --add-port=3306/tcp --permanent
firewall-cmd --reload
if [ $? -eq 0 ]; then
    echo "Firewall configuré"
else
    echo "Firewall non configuré"
fi
mysql -u root < script.sql
if [ $? -eq 0 ]; then
    echo "Base de données créée"
else
    echo "Base de données non créée"
fi