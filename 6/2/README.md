# Module 2 : Sauvegarde du système de fichiers

## Sommaire

- [Module 2 : Sauvegarde du système de fichiers](#module-2--sauvegarde-du-système-de-fichiers)
  - [Sommaire](#sommaire)
  - [I. Script de backup](#i-script-de-backup)
    - [1. Ecriture du script](#1-ecriture-du-script)
    - [2. Clean it](#2-clean-it)
    - [3. Service et timer](#3-service-et-timer)
  - [II. NFS](#ii-nfs)
    - [1. Serveur NFS](#1-serveur-nfs)
    - [2. Client NFS](#2-client-nfs)

## I. Script de backup

### 1. Ecriture du script

🌞 **Ecrire le script `bash`**

The script can be found : [here](tp6_backup.sh)

Example of output :

```bash
[nathan@web srv]$ sudo ./tp6_backup.sh 
Filename : nextcloud_20230110113107.tar.gz saved in /srv/backup
```

### 3. Service et timer

🌞 **Créez un *service*** système qui lance le script

```bash
[nathan@web system]$ sudo systemctl status backup
○ backup.service - Backup script for nextcloud
     Loaded: loaded (/etc/systemd/system/backup.service; static)
     Active: inactive (dead)
[nathan@web srv]$ sudo systemctl start backup
[nathan@web srv]$ sudo systemctl status backup
○ backup.service - Backup script for nextcloud
     Loaded: loaded (/etc/systemd/system/backup.service; static)
     Active: inactive (dead)

Jan 10 11:54:03 web systemd[1]: Starting Backup script for nextcloud...
Jan 10 11:54:03 web bash[14913]: tar: Removing leading `/` from member names
Jan 10 11:54:52 web bash[14911]: Filename : nextcloud_20230110115403.tar.gz saved in /srv/backup
Jan 10 11:54:52 web systemd[1]: backup.service: Deactivated successfully.
Jan 10 11:54:52 web systemd[1]: Finished Backup script for nextcloud.
Jan 10 11:54:52 web systemd[1]: backup.service: Consumed 34.619s CPU time.
[nathan@web srv]$ cd backup/
[nathan@web backup]$ ls
nextcloud_20230110115403.tar.gz

```

🌞 **Créez un *timer*** système qui lance le *service* à intervalles réguliers

- le fichier doit être créé dans le même dossier
- le fichier doit porter le même nom
- l'extension doit être `.timer` au lieu de `.service`
- ainsi votre fichier s'appellera `backup.timer`
- la syntaxe est la suivante :

```systemd
[Unit]
Description=Run service X

[Timer]
OnCalendar=*-*-* 4:00:00

[Install]
WantedBy=timers.target
```

> [La doc Arch est cool à ce sujet.](https://wiki.archlinux.org/title/systemd/Timers)

🌞 Activez l'utilisation du *timer*

- vous vous servirez des commandes suivantes :

```bash
# demander au système de lire le contenu des dossiers de config
# il découvrira notre nouveau timer
$ sudo systemctl daemon-reload

# on peut désormais interagir avec le timer
$ sudo systemctl start backup.timer
$ sudo systemctl enable backup.timer
$ sudo systemctl status backup.timer

# il apparaîtra quand on demande au système de lister tous les timers
$ sudo systemctl list-timers
```

## II. NFS

### 1. Serveur NFS

> On a déjà fait ça au TP4 ensemble :)

🖥️ **VM `storage.tp6.linux`**

**N'oubliez pas de dérouler la [📝**checklist**📝](../../2/README.md#checklist).**

🌞 **Préparer un dossier à partager sur le réseau** (sur la machine `storage.tp6.linux`)

- créer un dossier `/srv/nfs_shares`
- créer un sous-dossier `/srv/nfs_shares/web.tp6.linux/`

> Et ouais pour pas que ce soit le bordel, on va appeler le dossier comme la machine qui l'utilisera :)

🌞 **Installer le serveur NFS** (sur la machine `storage.tp6.linux`)

- installer le paquet `nfs-utils`
- créer le fichier `/etc/exports`
  - remplissez avec un contenu adapté
  - j'vous laisse faire les recherches adaptées pour ce faire
- ouvrir les ports firewall nécessaires
- démarrer le service
- je vous laisse check l'internet pour trouver [ce genre de lien](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-rocky-linux-9) pour + de détails

### 2. Client NFS

🌞 **Installer un client NFS sur `web.tp6.linux`**

- il devra monter le dossier `/srv/nfs_shares/web.tp6.linux/` qui se trouve sur `storage.tp6.linux`
- le dossier devra être monté sur `/srv/backup/`
- je vous laisse là encore faire vos recherches pour réaliser ça !
- faites en sorte que le dossier soit automatiquement monté quand la machine s'allume

🌞 **Tester la restauration des données** sinon ça sert à rien :)

- livrez-moi la suite de commande que vous utiliseriez pour restaurer les données dans une version antérieure

![Backup everything](../pics/backup_everything.jpg)
