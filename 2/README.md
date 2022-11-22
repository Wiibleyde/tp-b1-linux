# TP2 : Appréhender l'environnement Linux

# Sommaire

- [TP2 : Appréhender l'environnement Linux](#tp2--appréhender-lenvironnement-linux)
- [Sommaire](#sommaire)
  - [Checklist](#checklist)
- [I. Service SSH](#i-service-ssh)
  - [1. Analyse du service](#1-analyse-du-service)
  - [2. Modification du service](#2-modification-du-service)
- [II. Service HTTP](#ii-service-http)
  - [1. Mise en place](#1-mise-en-place)
  - [2. Analyser la conf de NGINX](#2-analyser-la-conf-de-nginx)
  - [3. Déployer un nouveau site web](#3-déployer-un-nouveau-site-web)
- [III. Your own services](#iii-your-own-services)
  - [1. Au cas où vous auriez oublié](#1-au-cas-où-vous-auriez-oublié)
  - [2. Analyse des services existants](#2-analyse-des-services-existants)
  - [3. Création de service](#3-création-de-service)

🌞 **S'assurer que le service `sshd` est démarré**

```bash
[nathan@localhost ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-11-22 15:51:30 CET; 2min 59s ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 721 (sshd)
      Tasks: 1 (limit: 5905)
     Memory: 5.6M
        CPU: 189ms
     CGroup: /system.slice/sshd.service
             └─721 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
```

🌞 **Analyser les processus liés au service SSH**

```bash
[nathan@localhost ~]$ ps -ef | grep sshd
root         721       1  0 15:51 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         883     721  0 15:52 ?        00:00:00 sshd: nathan [priv]
nathan       889     883  0 15:52 ?        00:00:00 sshd: nathan@pts/0
nathan       928     890  0 15:55 pts/0    00:00:00 grep --color=auto sshd
```

🌞 **Déterminer le port sur lequel écoute le service SSH**

```bash
[nathan@localhost ~]$ ss | grep ssh
tcp   ESTAB  0      0                    192.168.60.16:ssh       192.168.60.1:37426 
```

🌞 **Consulter les logs du service SSH**

```bash
[nathan@localhost ~]$ sudo tail /var/log/secure
Nov 22 15:48:46 localhost sudo[32888]:  nathan : TTY=pts/0 ; PWD=/home/nathan ; USER=root ; COMMAND=/bin/nano /etc/selinux/config
Nov 22 15:48:46 localhost sudo[32888]: pam_unix(sudo:session): session opened for user root(uid=0) by nathan(uid=1000)
Nov 22 15:48:52 localhost sudo[32888]: pam_unix(sudo:session): session closed for user root
Nov 22 15:51:30 localhost sshd[721]: Server listening on 0.0.0.0 port 22.
Nov 22 15:51:30 localhost sshd[721]: Server listening on :: port 22.
Nov 22 15:51:56 localhost systemd[851]: pam_unix(systemd-user:session): session opened for user nathan(uid=1000) by (uid=0)
Nov 22 15:51:56 localhost login[731]: pam_unix(login:session): session opened for user nathan(uid=1000) by (uid=0)
Nov 22 15:51:57 localhost login[731]: LOGIN ON tty1 BY nathan
Nov 22 15:52:27 localhost sshd[883]: Accepted password for nathan from 192.168.60.1 port 37426 ssh2
Nov 22 15:52:27 localhost sshd[883]: pam_unix(sshd:session): session opened for user nathan(uid=1000) by (uid=0)
```

## 2. Modification du service

🌞 **Identifier le fichier de configuration du serveur SSH**

```bash
[nathan@localhost ~]$ sudo find /etc/ssh/ -name "*config*"
/etc/ssh/ssh_config.d
/etc/ssh/sshd_config.d
/etc/ssh/sshd_config
/etc/ssh/ssh_config
```

🌞 **Modifier le fichier de conf**

- exécutez un `echo $RANDOM` pour demander à votre shell de vous fournir un nombre aléatoire
  - simplement pour vous montrer la petite astuce et vous faire manipuler le shell :)
- changez le port d'écoute du serveur SSH pour qu'il écoute sur ce numéro de port
  - dans le compte-rendu je veux un `cat` du fichier de conf
  - filtré par un `| grep` pour mettre en évidence la ligne que vous avez modifié
- gérer le firewall
  - fermer l'ancien port
  - ouvrir le nouveau port
  - vérifier avec un `firewall-cmd --list-all` que le port est bien ouvert
    - vous filtrerez la sortie de la commande avec un `| grep TEXTE`

```bash
[nathan@localhost ~]$ echo $RANDOM
29876
[nathan@localhost ~]$ sudo nano /etc/ssh/sshd_config
[nathan@localhost ~]$ sudo firewall-cmd --permanent --add-port=29876/tcp
success
[nathan@localhost ~]$ sudo firewall-cmd --permanent --remove-port=22/tcp
success
[nathan@localhost ~]$ sudo firewall-cmd --reload
success
[nathan@localhost ~]$ sudo firewall-cmd --list-all | grep 29876
29876/tcp
```

🌞 **Redémarrer le service**

```bash
[nathan@localhost ~]$ sudo systemctl restart sshd
```

🌞 **Effectuer une connexion SSH sur le nouveau port**

```bash
ssh 192.168.60.16 -p 29876
```

# II. Service HTTP

## 1. Mise en place

🌞 **Installer le serveur NGINX**

```bash
[nathan@localhost ~]$ sudo dnf install nginx
[sudo] password for nathan: 
Last metadata expiration check: 0:28:35 ago on Tue 22 Nov 2022 03:42:59 PM CET.
Dependencies resolved.
============================================================================================================================================================================================================================================
 Package                                                       Architecture                                       Version                                                       Repository                                             Size
============================================================================================================================================================================================================================================
Installing:
 nginx                                                         x86_64                                             1:1.20.1-10.el9                                               appstream                                             594 k
Installing dependencies:
 nginx-filesystem                                              noarch                                             1:1.20.1-10.el9                                               appstream                                              11 k
 rocky-logos-httpd                                             noarch                                             90.11-1.el9                                                   appstream                                              24 k

Transaction Summary
============================================================================================================================================================================================================================================
Install  3 Packages

Total download size: 629 k
Installed size: 1.8 M
Is this ok [y/N]: y
Downloading Packages:
(1/3): nginx-filesystem-1.20.1-10.el9.noarch.rpm                                                                                                                                                             78 kB/s |  11 kB     00:00    
(2/3): rocky-logos-httpd-90.11-1.el9.noarch.rpm                                                                                                                                                             129 kB/s |  24 kB     00:00    
(3/3): nginx-1.20.1-10.el9.x86_64.rpm                                                                                                                                                                       1.9 MB/s | 594 kB     00:00    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                                       882 kB/s | 629 kB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                    1/1 
  Running scriptlet: nginx-filesystem-1:1.20.1-10.el9.noarch                                                                                                                                                                            1/3 
  Installing       : nginx-filesystem-1:1.20.1-10.el9.noarch                                                                                                                                                                            1/3 
  Installing       : rocky-logos-httpd-90.11-1.el9.noarch                                                                                                                                                                               2/3 
  Installing       : nginx-1:1.20.1-10.el9.x86_64                                                                                                                                                                                       3/3 
  Running scriptlet: nginx-1:1.20.1-10.el9.x86_64                                                                                                                                                                                       3/3 
  Verifying        : rocky-logos-httpd-90.11-1.el9.noarch                                                                                                                                                                               1/3 
  Verifying        : nginx-filesystem-1:1.20.1-10.el9.noarch                                                                                                                                                                            2/3 
  Verifying        : nginx-1:1.20.1-10.el9.x86_64                                                                                                                                                                                       3/3 

Installed:
  nginx-1:1.20.1-10.el9.x86_64                                            nginx-filesystem-1:1.20.1-10.el9.noarch                                            rocky-logos-httpd-90.11-1.el9.noarch                                           

Complete!
```

🌞 **Démarrer le service NGINX**

```bash
[nathan@localhost ~]$ sudo systemctl start nginx
```

🌞 **Déterminer sur quel port tourne NGINX**

```bash
[nathan@localhost ~]$ sudo firewall-cmd --permanent --add-port=80/tcp
success
```

```bash
[nathan@localhost ~]$ sudo netstat -tulpn | grep nginx
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      1177/nginx: master  
tcp6       0      0 :::80                   :::*                    LISTEN      1177/nginx: master 
```


🌞 **Déterminer les processus liés à l'exécution de NGINX**

- vous devez filtrer la sortie de la commande utilisée pour n'afficher que les lignes demandées
    
```bash
[nathan@localhost ~]$ sudo ps aux | grep nginx
root        1177  0.0  0.0  10084   944 ?        Ss   16:14   0:00 nginx: master process /usr/sbin/nginx
nginx       1178  0.0  0.4  13852  4824 ?        S    16:14   0:00 nginx: worker process
nathan      1186  0.0  0.2   6412  2152 pts/0    S+   16:15   0:00 grep --color=auto nginx
```


🌞 **Euh wait**

```bash
nathan@nathan-SSD-Linux:~/Documents/Github/tp-b1-linux$ curl http://192.168.60.16:80 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
100  7620  100  7620    0     0  3771k      0 --:--:-- --:--:-- --:--:-- 7441k
curl: (23) Failed writing body
```


## 2. Analyser la conf de NGINX

🌞 **Déterminer le path du fichier de configuration de NGINX**

```bash
[nathan@localhost ~]$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

🌞 **Trouver dans le fichier de conf**

```bash
[nathan@localhost /]$ sudo cat /etc/nginx/nginx.conf | grep server -A 10
[sudo] password for nathan: 
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
--
# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }

[nathan@localhost /]$ sudo cat /etc/nginx/nginx.conf | grep include
    include /etc/nginx/mime.types;
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/default.d/*.conf;
```

## 3. Déployer un nouveau site web

🌞 **Créer un site web**
```bash
[nathan@localhost tp2_linux]$ cat index.html 
<h1>MEOW MEOW C MON SITE DE OUF</h1>
```

🌞 **Adapter la conf NGINX**

```bash
[nathan@localhost /]$ cat /etc/nginx/nginx.conf | grep -i '^# *Include'
#        include /etc/nginx/default.d/*.conf;
```

🌞 **Visitez votre super site web**

```bash
nathan@nathan-SSD-Linux:~/Documents/Github/tp-b1-linux$ curl http://192.168.60.16:80 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    37  100    37    0     0  22275      0 --:--:-- --:--:-- --:--:-- 37000
<h1>MEOW MEOW C MON SITE DE OUF</h1>
```

# III. Your own services

## 2. Analyse des services existants

Un service c'est quoi concrètement ? C'est juste un processus, que le système lance, et dont il s'occupe après.

Il est défini dans un simple fichier texte, qui contient une info primordiale : la commande exécutée quand on "start" le service.

Il est possible de définir beaucoup d'autres paramètres optionnels afin que notre service s'exécute dans de bonnes conditions.

🌞 **Afficher le fichier de service SSH**

- vous pouvez obtenir son chemin avec un `systemctl status <SERVICE>`
- mettez en évidence la ligne qui commence par `ExecStart=`
  - encore un `cat <FICHIER> | grep <TEXTE>`
  - c'est la ligne qui définit la commande lancée lorsqu'on "start" le service
    - taper `systemctl start <SERVICE>` ou exécuter cette commande à la main, c'est (presque) pareil

🌞 **Afficher le fichier de service NGINX**

- mettez en évidence la ligne qui commence par `ExecStart=`

## 3. Création de service

![Create service](./pics/create_service.png)

Bon ! On va créer un petit service qui lance un `nc`. Et vous allez tout de suite voir pourquoi c'est pratique d'en faire un service et pas juste le lancer à la min.

Ca reste un truc pour s'exercer, c'pas non plus le truc le plus utile de l'année que de mettre un `nc` dans un service n_n

🌞 **Créez le fichier `/etc/systemd/system/tp2_nc.service`**

- son contenu doit être le suivant (nice & easy)

```service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l <PORT>
```

> Vous remplacerez `<PORT>` par un numéro de port random obtenu avec la même méthode que précédemment.

🌞 **Indiquer au système qu'on a modifié les fichiers de service**

- la commande c'est `sudo systemctl daemon-reload`

🌞 **Démarrer notre service de ouf**

- avec une commande `systemctl start`

🌞 **Vérifier que ça fonctionne**

- vérifier que le service tourne avec un `systemctl status <SERVICE>`
- vérifier que `nc` écoute bien derrière un port avec un `ss`
  - vous filtrerez avec un `| grep` la sortie de la commande pour n'afficher que les lignes intéressantes
- vérifer que juste ça marche en vous connectant au service depuis votre PC

➜ Si vous vous connectez avec le client, que vous envoyez éventuellement des messages, et que vous quittez `nc` avec un CTRL+C, alors vous pourrez constater que le service s'est stoppé

- bah oui, c'est le comportement de `nc` ça ! 
- le client se connecte, et quand il se tire, ça ferme `nc` côté serveur aussi
- faut le relancer si vous voulez retester !

🌞 **Les logs de votre service**

- mais euh, ça s'affiche où les messages envoyés par le client ? Dans les logs !
- `sudo journalctl -xe -u tp2_nc` pour visualiser les logs de votre service
- `sudo journalctl -xe -u tp2_nc -f ` pour visualiser **en temps réel** les logs de votre service
  - `-f` comme follow (on "suit" l'arrivée des logs en temps réel)
- dans le compte-rendu je veux
  - une commande `journalctl` filtrée avec `grep` qui affiche la ligne qui indique le démarrage du service
  - une commande `journalctl` filtrée avec `grep` qui affiche un message reçu qui a été envoyé par le client
  - une commande `journalctl` filtrée avec `grep` qui affiche la ligne qui indique l'arrêt du service

🌞 **Affiner la définition du service**

- faire en sorte que le service redémarre automatiquement s'il se termine
  - comme ça, quand un client se co, puis se tire, le service se relancera tout seul
  - ajoutez `Restart=always` dans la section `[Service]` de votre service
  - n'oubliez pas d'indiquer au système que vous avez modifié les fichiers de service :)
