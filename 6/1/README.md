# Module 1 : Reverse Proxy

## Sommaire

- [Module 1 : Reverse Proxy](#module-1--reverse-proxy)
  - [Sommaire](#sommaire)
- [I. Setup](#i-setup)
- [II. HTTPS](#ii-https)

# I. Setup

🌞 **On utilisera NGINX comme reverse proxy**

- installer le paquet `nginx`
- démarrer le service `nginx`
- utiliser la commande `ss` pour repérer le port sur lequel NGINX écoute
- ouvrir un port dans le firewall pour autoriser le trafic vers NGINX
- utiliser une commande `ps -ef` pour déterminer sous quel utilisateur tourne NGINX
- vérifier que le page d'accueil NGINX est disponible en faisant une requête HTTP sur le port 80 de la machine

```bash
[nathan@proxy ~]$ sudo dnf install nginx
[sudo] password for nathan: 
Rocky Linux 9 - BaseOS                                                                                                                                                                                      1.5 MB/s | 1.7 MB     00:01    
Rocky Linux 9 - AppStream                                                                                                                                                                                   5.4 MB/s | 6.4 MB     00:01    
Rocky Linux 9 - Extras                                                                                                                                                                                      7.4 kB/s | 7.7 kB     00:01    
Last metadata expiration check: 0:00:01 ago on Mon 02 Jan 2023 03:30:44 PM CET.
Package nginx-1:1.20.1-13.el9.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
```

```bash
[nathan@proxy ~]$ sudo systemctl start nginx
```

```bash
[nathan@proxy ~]$ sudo ss -tulpn | grep nginx
tcp   LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=11484,fd=6),("nginx",pid=11483,fd=6))
tcp   LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=11484,fd=7),("nginx",pid=11483,fd=7))
```

```bash
[nathan@proxy ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
Warning: ALREADY_ENABLED: 80:tcp
success
```

```bash
[nathan@proxy ~]$ sudo ps -ef | grep nginx
root       11483       1  0 15:47 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      11484   11483  0 15:47 ?        00:00:00 nginx: worker process
nathan     11493    1231  0 15:48 pts/0    00:00:00 grep --color=auto nginx
```

```bash
[nathan@proxy ~]$ curl http://localhost | head -n 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/
      
      html {
100  7620  100  7620    0     0   413k      0 --:--:-- --:--:-- --:--:--  413k
curl: (23) Failed writing body
```


🌞 **Configurer NGINX**

- NextCloud est un peu exigeant, et il demande à être informé si on le met derrière un reverse proxy
  - y'a donc un fichier de conf NextCloud à modifier
  - c'est un fichier appelé `config.php`

```bash
[nathan@proxy ~]$ sudo cat /etc/nginx/conf.d/proxy.conf 
server {
    # On indique le nom que client va saisir pour accéder au service
    # Pas d'erreur ici, c'est bien le nom de web, et pas de proxy qu'on veut ici !
    server_name web.tp5.linux;

    # Port d'écoute de NGINX
    listen 80;

    location / {
        # On définit des headers HTTP pour que le proxying se passe bien
        proxy_set_header  Host $host;
        proxy_set_header  X-Real-IP $remote_addr;
        proxy_set_header  X-Forwarded-Proto https;
        proxy_set_header  X-Forwarded-Host $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

        # On définit la cible du proxying 
        proxy_pass http://10.105.1.11:80;
    }

    # Deux sections location recommandés par la doc NextCloud
    location /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }

    location /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }
}
```


```bash
[nathan@proxy ~]$ sudo systemctl restart nginx
```

```bash
[nathan@web config]$ sudo cat config.php 
<?php
$CONFIG = array (
  'instanceid' => 'ocq5z8w9sser',
  'passwordsalt' => 'ZeuErnMz/kPYBU7j6nrxxyjm0HNXVV',
  'secret' => 'hIPpj3NDVUoTZW48+YIytH9tYC8V9TbNsgZa7GhzlKS1J8rj',
  'trusted_domains' => 
  array (
          0 => 'web.tp5.linux',
          1 => 'proxy.tp6.linux',
  ),
  'datadirectory' => '/var/www/tp5_nextcloud/data',
  'dbtype' => 'mysql',
  'version' => '25.0.0.15',
  'overwrite.cli.url' => 'http://web.tp5.linux',
  'installed' => true,
  'maintenance' => false,
  'dbname' => 'nextcloud',
  'dbhost' => '10.105.1.12',
  'dbuser' => 'nextcloud',
  'dbpassword' => 'pewpewpew',
);
```
  
```bash
[nathan@web config]$ sudo systemctl restart httpd
```

```bash
nathan@nathan-SSD-Linux:~$ curl 10.105.1.13 -s | head -n 10 # web.tp6.linux because of /etc/hosts but the curl command don't work with the name
<!DOCTYPE html>
<html class="ng-csp" data-placeholder-focus="false" lang="en" data-locale="en" >
        <head
 data-requesttoken="06u5q1N/IEuAGYhxrMvXDyhCNXi+jnFAkDF0uJ5y4ms=:lfvXyDQcVxjpVd8g5fzjYWEQdx7T2SE65Us319ImjVk=">
                <meta charset="utf-8">
                <title>
                        Nextcloud               </title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
                                <meta name="apple-itunes-app" content="app-id=1125420102">
                                <meta name="theme-color" content="#0082c9">
```

🌞 **Faites en sorte de**

```bash
[nathan@web ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources: 
  services: 
  ports: 
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
        rule family="ipv4" source address="10.105.1.1" port port="22" protocol="tcp" accept
        rule family="ipv4" source address="10.105.1.13" port port="80" protocol="tcp" accept
```

🌞 **Une fois que c'est en place**

- faire un `ping` manuel vers l'IP de `proxy.tp6.linux` fonctionne

```bash
nathan@nathan-SSD-Linux:~$ ping proxy.tp6.linux
PING proxy.tp6.linux (10.105.1.13) 56(84) bytes of data.
64 bytes from proxy.tp6.linux (10.105.1.13): icmp_seq=1 ttl=64 time=0.609 ms
64 bytes from proxy.tp6.linux (10.105.1.13): icmp_seq=2 ttl=64 time=0.643 ms
64 bytes from proxy.tp6.linux (10.105.1.13): icmp_seq=3 ttl=64 time=0.612 ms
^C
--- proxy.tp6.linux ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2039ms
rtt min/avg/max/mdev = 0.609/0.621/0.643/0.015 ms
```

- faire un `ping` manuel vers l'IP de `web.tp6.linux` ne fonctionne pas

```bash
nathan@nathan-SSD-Linux:~$ ping 10.105.1.11
PING 10.105.1.11 (10.105.1.11) 56(84) bytes of data.
^C
--- 10.105.1.11 ping statistics ---
7 packets transmitted, 0 received, 100% packet loss, time 6139ms

nathan@nathan-SSD-Linux:~$ 
```

# II. HTTPS

🌞 **Faire en sorte que NGINX force la connexion en HTTPS plutôt qu'HTTP**

```bash
[nathan@proxy ~]$ openssl genrsa -out private.key 2048
[nathan@proxy ~]$ openssl req -new -x509 -key private.key -out certificate.crt
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:
State or Province Name (full name) []:
Locality Name (eg, city) [Default City]:
Organization Name (eg, company) [Default Company Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) []:
Email Address []:
```

```bash
[nathan@proxy ~]$ sudo firewall-cmd --add-port=443/tcp --permanent
success
[nathan@proxy ~]$ sudo firewall-cmd --reload
success
```

```bash
[nathan@proxy ~]$ sudo cat /etc/nginx/conf.d/proxy.conf 
[sudo] password for nathan: 
server {
    # On indique le nom que client va saisir pour accéder au service
    # Pas d'erreur ici, c'est bien le nom de web, et pas de proxy qu'on veut ici !
    server_name web.tp5.linux;

    location / {
        # On définit des headers HTTP pour que le proxying se passe bien
        proxy_set_header  Host $host;
        proxy_set_header  X-Real-IP $remote_addr;
        proxy_set_header  X-Forwarded-Proto https;
        proxy_set_header  X-Forwarded-Host $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

        # On définit la cible du proxying 
        proxy_pass http://10.105.1.11:80;
    }

    # Deux sections location recommandés par la doc NextCloud
    location /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }

    location /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }
    listen 443 ssl;
    ssl_certificate /home/nathan/certificate.crt;
    ssl_certificate_key /home/nathan/private.key;
}
```

```bash
[nathan@proxy ~]$ sudo systemctl restart nginx
```

The site is reachable via HTTPS but the certificate is not trusted by the browser.