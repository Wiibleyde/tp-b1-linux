# Module 3 : Fail2Ban

🌞 Faites en sorte que :

```bash
[nathan@proxy ~]$ sudo cat /etc/fail2ban/jail.local
...
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/secure
maxretry = 3
bantime = 600
...
```

```bash
[nathan@proxy ~]$ sudo fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     0
|  `- File list:        /var/log/secure
`- Actions
   |- Currently banned: 1
   |- Total banned:     1
   `- Banned IP list:
        `- 10.105.1.1/24
```
    
```bash
[nathan@proxy ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3
  sources:
  services: dhcpv6-client ssh
  ports:
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
        rule family="ipv4" source address="10.105.1.1/24" reject
```

```bash
[nathan@proxy ~]$ sudo fail2ban-client set sshd unbanip
```