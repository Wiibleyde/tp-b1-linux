# Module 4 : Monitoring

🌞 **Installer Netdata**

```bash
nathan@nathan-SSD-Linux:~/Documents/Github/tp-b1-linux$ curl 10.105.1.11:19999 -s | head -n 1
<!doctype html><html lang="en"><head><title>netdata dashboard</title><meta name="application-name" content="netdata"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="apple-mobile-web-app-capable" content="yes"><meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"><meta name="author" content="costa@tsaousis.gr"><link rel="icon" href="data:image/x-icon;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAP9JREFUeNpiYBgFo+A/w34gpiZ8DzWzAYgNiHGAA5UdgA73g+2gcyhgg/0DGQoweB6IBQYyFCCOGOBQwBMd/xnW09ERDtgcoEBHB+zHFQrz6egIBUasocDAcJ9OxWAhE4YQI8MDILmATg7wZ8QRDfQKhQf4Cie6pAVGPA4AhQKo0BCgZRAw4ZSBpIWJNI6CD4wEKikBaFqgVSgcYMIrzcjwgcahcIGRiPYCLUPBkNhWUwP9akVcoQBpatG4MsLviAIqWj6f3Absfdq2igg7IIEKDVQKEzN5ofAenJCp1I8gJRTug5tfkGIdR1FDniMI+QZUjF8Amn5htOdHCAAEGACE6B0cS6mrEwAAAABJRU5ErkJggg=="/><meta property="og:locale" content="en_US"/><meta property="og:url" content="https://my-netdata.io"/><meta property="og:type" content="website"/><meta property="og:site_name" content="netdata"/><meta property="og:title" content="Get control of your Linux Servers. Simple. Effective. Awesome."/><meta property="og:description" content="Unparalleled insights, in real-time, of everything happening on your Linux systems and applications, with stunning, interactive web dashboards and powerful performance and health alarms."/><meta property="og:image" content="https://cloud.githubusercontent.com/assets/2662304/22945737/e98cd0c6-f2fd-11e6-96f1-5501934b0955.png"/><meta property="og:image:type" content="image/png"/><meta property="fb:app_id" content="1200089276712916"/><meta name="twitter:card" content="summary"/><meta name="twitter:site" content="@linuxnetdata"/><meta name="twitter:title" content="Get control of your Linux Servers. Simple. Effective. Awesome."/><meta name="twitter:description" content="Unparalleled insights, in real-time, of everything happening on your Linux systems and applications, with stunning, interactive web dashboards and powerful performance and health alarms."/><meta name="twitter:image" content="https://cloud.githubusercontent.com/assets/2662304/14092712/93b039ea-f551-11e5-822c-beadbf2b2a2e.gif"/><style>.loadOverlay{position:fixed;top:0;left:0;width:100%;height:100%;z-index:2000;font-size:10vh;font-family:sans-serif;padding:40vh 0 40vh 0;font-weight:700;text-align:center}</style><link href="./static/css/2.c454aab8.chunk.css" rel="stylesheet"><link href="./static/css/main.53ba10f1.chunk.css" rel="stylesheet"></head><body data-spy="scroll" data-target="#sidebar" data-offset="100"><div id="loadOverlay" class="loadOverlay" style="background-color:#fff;color:#888"><div style="font-size:3vh">You must enable JavaScript in order to use Netdata!<br/>You can do this in <a href="https://enable-javascript.com/" target="_blank">your browser settings</a>.</div></div><script type="text/javascript">// Cleanup JS warning.
```

```bash
nathan@nathan-SSD-Linux:~/Documents/Github/tp-b1-linux$ curl 10.105.1.12:19999 -s | head -n 1
<!doctype html><html lang="en"><head><title>netdata dashboard</title><meta name="application-name" content="netdata"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="apple-mobile-web-app-capable" content="yes"><meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"><meta name="author" content="costa@tsaousis.gr"><link rel="icon" href="data:image/x-icon;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAP9JREFUeNpiYBgFo+A/w34gpiZ8DzWzAYgNiHGAA5UdgA73g+2gcyhgg/0DGQoweB6IBQYyFCCOGOBQwBMd/xnW09ERDtgcoEBHB+zHFQrz6egIBUasocDAcJ9OxWAhE4YQI8MDILmATg7wZ8QRDfQKhQf4Cie6pAVGPA4AhQKo0BCgZRAw4ZSBpIWJNI6CD4wEKikBaFqgVSgcYMIrzcjwgcahcIGRiPYCLUPBkNhWUwP9akVcoQBpatG4MsLviAIqWj6f3Absfdq2igg7IIEKDVQKEzN5ofAenJCp1I8gJRTug5tfkGIdR1FDniMI+QZUjF8Amn5htOdHCAAEGACE6B0cS6mrEwAAAABJRU5ErkJggg=="/><meta property="og:locale" content="en_US"/><meta property="og:url" content="https://my-netdata.io"/><meta property="og:type" content="website"/><meta property="og:site_name" content="netdata"/><meta property="og:title" content="Get control of your Linux Servers. Simple. Effective. Awesome."/><meta property="og:description" content="Unparalleled insights, in real-time, of everything happening on your Linux systems and applications, with stunning, interactive web dashboards and powerful performance and health alarms."/><meta property="og:image" content="https://cloud.githubusercontent.com/assets/2662304/22945737/e98cd0c6-f2fd-11e6-96f1-5501934b0955.png"/><meta property="og:image:type" content="image/png"/><meta property="fb:app_id" content="1200089276712916"/><meta name="twitter:card" content="summary"/><meta name="twitter:site" content="@linuxnetdata"/><meta name="twitter:title" content="Get control of your Linux Servers. Simple. Effective. Awesome."/><meta name="twitter:description" content="Unparalleled insights, in real-time, of everything happening on your Linux systems and applications, with stunning, interactive web dashboards and powerful performance and health alarms."/><meta name="twitter:image" content="https://cloud.githubusercontent.com/assets/2662304/14092712/93b039ea-f551-11e5-822c-beadbf2b2a2e.gif"/><style>.loadOverlay{position:fixed;top:0;left:0;width:100%;height:100%;z-index:2000;font-size:10vh;font-family:sans-serif;padding:40vh 0 40vh 0;font-weight:700;text-align:center}</style><link href="./static/css/2.c454aab8.chunk.css" rel="stylesheet"><link href="./static/css/main.53ba10f1.chunk.css" rel="stylesheet"></head><body data-spy="scroll" data-target="#sidebar" data-offset="100"><div id="loadOverlay" class="loadOverlay" style="background-color:#fff;color:#888"><div style="font-size:3vh">You must enable JavaScript in order to use Netdata!<br/>You can do this in <a href="https://enable-javascript.com/" target="_blank">your browser settings</a>.</div></div><script type="text/javascript">// Cleanup JS warning.
```

🌞 **Une fois Netdata installé et fonctionnel, déterminer :**

- l'utilisateur sous lequel tourne le(s) processus Netdata
- si Netdata écoute sur des ports
- comment sont consultables les logs de Netdata

```bash
[nathan@web ~]$ ps -aux | grep netdata
root        1898  0.0  0.2 228680  1984 ?        Ssl  13:42   0:00 gpg-agent --homedir /var/cache/dnf/netdata-edge-a383c484584e0b14/pubring --use-standard-socket --daemon
root        1900  0.0  0.1  81532  1368 ?        SLl  13:42   0:00 scdaemon --multi-server --homedir /var/cache/dnf/netdata-edge-a383c484584e0b14/pubring
root        1941  0.0  0.2 228680  1984 ?        Ssl  13:42   0:00 gpg-agent --homedir /var/cache/dnf/netdata-repoconfig-3ca68ffb39611f32/pubring --use-standard-socket --daemon
root        1943  0.0  0.1  81532  1496 ?        SLl  13:42   0:00 scdaemon --multi-server --homedir /var/cache/dnf/netdata-repoconfig-3ca68ffb39611f32/pubring
netdata     2217  0.6  5.8 464928 45572 ?        SNsl 13:43   0:02 /usr/sbin/netdata -P /run/netdata/netdata.pid -D
netdata     2221  0.0  0.8  28736  6668 ?        SNl  13:43   0:00 /usr/sbin/netdata --special-spawn-server
netdata     2468  0.0  0.4   4504  3388 ?        SN   13:43   0:00 bash /usr/libexec/netdata/plugins.d/tc-qos-helper.sh 1
netdata     2483  0.5  0.7 134708  6224 ?        SNl  13:43   0:01 /usr/libexec/netdata/plugins.d/apps.plugin 1
root        2485  0.1  4.9 740992 38436 ?        SNl  13:43   0:00 /usr/libexec/netdata/plugins.d/ebpf.plugin 1
netdata     2486  0.1  6.3 773668 49940 ?        SNl  13:43   0:00 /usr/libexec/netdata/plugins.d/go.d.plugin 1
nathan      2881  0.0  0.2   6408  2232 pts/0    S+   13:49   0:00 grep --color=auto netdata
```

The user is `netdata` and the port is `19999`.

```bash
[nathan@web ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3
  sources:
  services: dhcpv6-client ssh
  ports: 19999/tcp
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

```bash
[nathan@web ~]$ sudo journalctl -u netdata | tail -n 10
[sudo] password for nathan: 
Jan 14 13:43:19 web systemd[1]: Starting Real time performance monitoring...
Jan 14 13:43:19 web systemd[1]: Started Real time performance monitoring.
Jan 14 13:43:19 web netdata[2217]: CONFIG: cannot load cloud config '/var/lib/netdata/cloud.d/cloud.conf'. Running with internal defaults.
Jan 14 13:43:19 web netdata[2217]: Found 0 legacy dbengines, setting multidb diskspace to 256MB
Jan 14 13:43:19 web netdata[2217]: 2023-01-14 13:43:19: netdata INFO  : MAIN : CONFIG: cannot load cloud config '/var/lib/netdata/cloud.d/cloud.conf'. Running with internal defaults.
Jan 14 13:43:19 web netdata[2217]: 2023-01-14 13:43:19: netdata INFO  : MAIN : Found 0 legacy dbengines, setting multidb diskspace to 256MB
Jan 14 13:43:19 web netdata[2217]: 2023-01-14 13:43:19: netdata INFO  : MAIN : Created file '/var/lib/netdata/dbengine_multihost_size' to store the computed value
Jan 14 13:43:19 web netdata[2217]: Created file '/var/lib/netdata/dbengine_multihost_size' to store the computed value
Jan 14 13:43:21 web ebpf.plugin[2485]: Does not have a configuration file inside `/etc/netdata/ebpf.d.conf. It will try to load stock file.
Jan 14 13:43:22 web ebpf.plugin[2485]: Cannot read process groups configuration file '/etc/netdata/apps_groups.conf'. Will try '/usr/lib/netdata/conf.d/apps_groups.conf'
```
🌞 **Configurer Netdata pour qu'il vous envoie des alertes** 

```bash
[nathan@web netdata]$ cat /etc/netdata/health_alarm_notify.conf | grep discord
# - messages to your discord guild (discordapp.com),
# flock, discord, telegram) via a proxy, set these to your proxy address:
#  - discord channels
#  discord    : "alarms disasters|critical"
# discord (discordapp.com) global notification options
# enable/disable sending discord notifications
# https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1063803595549585459/s9rgde5306lV_8LwS3Fh2vj856I9npEX8eTh2y9slThRs8SxtDTw61iWTXPAnpjAoQGq"
```

🌞 **Vérifier que les alertes fonctionnent**

```bash
[nathan@web netdata]$ sudo systemctl restart netdata
```

```bash
[nathan@web netdata]$ sudo systemctl status netdata
● netdata.service - Real time performance monitoring
   Loaded: loaded (/usr/lib/systemd/system/netdata.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2021-01-13 13:42:19 CET; 1min 0s ago
  Process: 2217 ExecStart=/usr/sbin/netdata -P /run/netdata/netdata.pid -D (code=exited, status=0/SUCCESS)
 Main PID: 2217 (netdata)
    Tasks: 11 (limit: 4915)
   CGroup: /system.slice/netdata.service
           ├─2217 /usr/sbin/netdata -P /run/netdata/netdata.pid -D
           ├─2221 /usr/sbin/netdata --special-spawn-server
           ├─2468 bash /usr/libexec/netdata/plugins.d/tc-qos-helper.sh 1
           ├─2483 /usr/libexec/netdata/plugins.d/apps.plugin 1
           ├─2485 /usr/libexec/netdata/plugins.d/ebpf.plugin 1
           ├─2486 /usr/libexec/netdata/plugins.d/go.d.plugin 1
           ├─2487 /usr/libexec/netdata/plugins.d/go.d.plugin 1
           ├─2488 /usr/libexec/netdata/plugins.d/go.d.plugin 1
           ├─2489 /usr/libexec/netdata/plugins.d/go.d.plugin 1
           ├─2490 /usr/libexec/netdata/plugins.d/go.d.plugin 1
           └─2491 /usr/libexec/netdata/plugins.d/go.d.plugin 1

Jan 13 13:42:19 web systemd[1]: Starting Real time performance monitoring...
Jan 13 13:42:19 web systemd[1]: Started Real time performance monitoring.
Jan 13 13:42:19 web netdata[2217]: CONFIG: cannot load cloud config '/var/lib/netdata/cloud.d/cloud.conf'. Running with internal defaults.
Jan 13 13:42:19 web netdata[2217]: Found 0 legacy dbengines, setting multidb diskspace to 256MB
Jan 13 13:42:19 web netdata[2217]: 2023-01-13 13:42:19: netdata INFO  : MAIN : CONFIG: cannot load cloud config '/var/lib/netdata/cloud.d/cloud.conf'. Running with internal defaults.
Jan 13 13:42:19 web netdata[2217]: 2023-01-13 13:42:19: netdata INFO  : MAIN : Found 0 legacy dbengines, setting multidb diskspace to 256MB
Jan 13 13:42:19 web netdata[2217]: 2023-01-13 13:42:19: netdata INFO  : MAIN : Created file '/var/lib/netdata/dbengine_multihost_size' to store the computed value
Jan 13 13:42:19 web netdata[2217]: Created file '/var/lib/netdata/dbengine_multihost_size' to store the computed value
Jan 13 13:42:21 web ebpf.plugin[2485]: Does not have a configuration file inside `/etc/netdata/ebpf.d.conf. It will try to load stock file.
Jan 13 13:42:22 web ebpf.plugin[2485]: Cannot read process groups configuration file '/etc/netdata/apps_groups.conf'. Will try '/usr/lib/netdata/conf.d/apps_groups.conf'
```