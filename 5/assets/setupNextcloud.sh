#!/bin/bash
webMachineIP=$1
webMachineUsername=$2
webMachinePassword=$3
dbMachineIP=$4
dbMachineUsername=$5
dbMachinePassword=$6
sshpass -p $webMachinePassword ssh -o StrictHostKeyChecking=no $webMachineUsername@$webMachineIP << EOF
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
hostnamectl set-hostname web
apt-get update
apt-get install -y httpd
systemctl start httpd
systemctl enable httpd
sed -i '/^#/d' /etc/httpd/conf/httpd.conf
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload
systemctl restart httpd
EOF
sshpass -p $dbMachinePassword ssh -o StrictHostKeyChecking=no $dbMachineUsername@$dbMachineIP << EOF
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
hostnamectl set-hostname db
apt-get update
dnf install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb
firewall-cmd --add-port=3306/tcp --permanent
firewall-cmd --reload
mysql -u root < script.sql
EOF
sshpass -p $webMachinePassword ssh -o StrictHostKeyChecking=no $webMachineUsername@$webMachineIP << EOF
dnf config-manager --set-enabled crb
dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y
dnf module list php -y
dnf module enable php:remi-8.1 -y
dnf install -y php81-php
dnf install -y libxml2 openssl php81-php php81-php-ctype php81-php-curl php81-php-gd php81-php-iconv php81-php-json php81-php-libxml php81-php-mbstring php81-php-openssl php81-php-posix php81-php-session php81-php-xml php81-php-zip php81-php-zlib php81-php-pdo php81-php-mysqlnd php81-php-intl php81-php-bcmath php81-php-gmp
mkdir /var/www/tp5_nextcloud/
cd /var/www/tp5_nextcloud/
curl -O https://download.nextcloud.com/server/prereleases/nextcloud-25.0.0rc3.zip
unzip nextcloud-25.0.0rc3.zip -d /var/www/tp5_nextcloud/
chown -R apache:apache /var/www/tp5_nextcloud/
chmod -R 755 /var/www/tp5_nextcloud/
touch /etc/httpd/conf.d/nextcloud.conf
echo "<VirtualHost *:80>
  # on indique le chemin de notre webroot
  DocumentRoot /var/www/tp5_nextcloud/
  # on précise le nom que saisissent les clients pour accéder au service
  ServerName  web.tp5.linux

  # on définit des règles d'accès sur notre webroot
  <Directory /var/www/tp5_nextcloud/> 
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
" > /etc/httpd/conf.d/nextcloud.conf
systemctl restart httpd
EOF
if [ $? -eq 0 ]; then
    echo "Nextcloud installé"
else
    echo "Nextcloud non installé"
fi