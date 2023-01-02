#!/bin/bash
# Configurer l'IP locale en statique si nécessaire
IP_LOCALE=$(ip addr show | grep 'inet ' | awk '{print $2}' | sed 's/\/.*//')
echo "IP locale : $IP_LOCALE"

if grep -q "static" /etc/network/interfaces; then
  echo "L'IP est déjà statique"
else
  echo "L'IP est dynamique, configurons-la en statique"
  # Modifier ici la configuration de l'interface réseau pour configurer une IP statique
  # Exemple :
  echo "auto eth0" >> /etc/network/interfaces
  echo "iface eth0 inet static" >> /etc/network/interfaces
  echo "address 192.168.1.100" >> /etc/network/interfaces
  echo "netmask 255.255.255.0" >> /etc/network/interfaces
  echo "gateway 192.168.1.1" >> /etc/network/interfaces
  # N'oubliez pas de remplacer les valeurs d'adresse et de masque de sous-réseau par celles qui conviennent à votre réseau
  # Redémarrer l'interface réseau pour appliquer la nouvelle configuration :
  ifdown eth0 && ifup eth0
fi

# Configurer le hostname si nécessaire
HOSTNAME=$(hostname)
echo "Hostname : $HOSTNAME"

# Modifier ici la configuration du hostname si nécessaire
# Exemple :
echo "nouveau_hostname" > /etc/hostname
# N'oubliez pas de remplacer "nouveau_hostname" par le hostname souhaité
# Mettre à jour la résolution de nom pour refléter le nouveau hostname :
echo "127.0.0.1 nouveau_hostname" >> /etc/hosts
# Redémarrer le système pour appliquer le nouveau hostname :
shutdown -r now

# Activer le firewall et configurer les règles si nécessaire
FIREWALL_STATUS=$(ufw status | grep 'Status:')
if echo "$FIREWALL_STATUS" | grep -q "active"; then
  echo "Le firewall est déjà actif"
else
  echo "Le firewall n'est pas actif, activons-le"
  ufw enable
  # Ajouter ici les règles de firewall nécessaires
  # Exemple :
  ufw allow 22/tcp # Autoriser le traffic SSH
  ufw allow 80/tcp # Autoriser le traffic HTTP
  ufw allow 443/tcp # Autoriser le traffic HTTPS
  ufw deny incoming # Refuser tout autre traffic entrant
fi

# Activer et configurer SSH si nécessaire
if service ssh status | grep -q "is running"; then
  echo "SSH est déjà fonctionnel"
else
  echo "SSH n'est pas fonctionnel, activons-le"
  systemctl start ssh
  # Modifier ici la configuration de SSH si nécessaire
  # Exemple :
  sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
  # Désactiver l'authentification par mot de passe et interdire la connexion en tant que root
  systemctl reload ssh
fi

# Configurer l'accès à Internet si nécessaire
if ping -q -c 1 -W 1 google.com > /dev/null; then
  echo "Il y a déjà accès à Internet"
else
  echo "Il n'y a pas d'accès à Internet, configurons-le"
  # Modifier ici la configuration de la connexion Internet si nécessaire
  # Exemple :
  echo "auto eth0" >> /etc/network/interfaces
  echo "iface eth0 inet dhcp" >> /etc/network/interfaces
  # Utiliser DHCP pour obtenir une adresse IP et une route par défaut
  # Redémarrer l'interface réseau pour appliquer la nouvelle configuration :
  ifdown eth0 && ifup eth0
fi

# Configurer la résolution de nom si nécessaire
if host google.com > /dev/null; then
  echo "La résolution de nom fonctionne"
else
  echo "La résolution de nom ne fonctionne pas, configurons-la"
  # Modifier ici la configuration de la résolution de nom si nécessaire
  # Exemple :
  echo "nameserver 8.8.8.8" > /etc/resolv.conf
  # Utiliser le serveur de nom de Google comme serveur de nom
fi

# Activer SELinux en mode "permissive" si nécessaire
SELINUX_STATUS=$(sestatus | grep 'SELinux status:')
if echo "$SELINUX_STATUS" | grep -q "enabled"; then
  echo "SELinux est déjà activé"
else
  echo "SELinux n'est pas activé, activons-le en mode permissive"
  sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
  # Redémarrer le système pour appliquer le changement de mode de SELinux :
  shutdown -r now
fi
