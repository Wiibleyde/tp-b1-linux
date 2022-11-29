# TP 3 : We do a little scripting

## Sommaire

- [TP 3 : We do a little scripting](#tp-3--we-do-a-little-scripting)
  - [Sommaire](#sommaire)
- [0. Un premier script](#0-un-premier-script)
- [I. Script carte d'identité](#i-script-carte-didentité)
  - [Rendu](#rendu)
- [II. Script youtube-dl](#ii-script-youtube-dl)
  - [Rendu](#rendu-1)
- [III. MAKE IT A SERVICE](#iii-make-it-a-service)
  - [Rendu](#rendu-2)
- [IV. Bonus](#iv-bonus)

# I. Script carte d'identité

## Rendu

Fichier : [idcard.sh](/3/srv/idcard/idcard.sh)

🌞 **Vous fournirez dans le compte-rendu**, en plus du fichier, **un exemple d'exécution avec une sortie**, dans des balises de code.

```bash
nathan@nathan-SSD-Linux:~/Documents/Github/tp-b1-linux/3/srv/idcard$ sudo ./idcard.sh 
Machine name : nathan-SSD-Linux
OS "Ubuntu 22.04.1 LTS" and kernel version is 5.15.0-53-generic
IP address is 10.33.18.254/22
RAM : 3,4Gi memory avialable on 15Gi total memory
Disk : 119G space left
Top 5 processes by RAM usage :
  - /usr/share/discord/Discord
  - /opt/brave.com/brave/brave
  - /usr/share/code/code
  - /usr/bin/plasmashell
  - /opt/brave.com/brave/brave
Listening ports :
  - udp 56539 : avahi-daemon
  - udp 53 : dnsmasq
  - udp 53 : systemd-resolve
  - udp 67 : dnsmasq
  - udp 631 : cups-browsed
  - tcp 53 : dnsmasq
  - tcp 53 : systemd-resolve
  - tcp 631 : cupsd
  - tcp 6463 : Discord
Here is your random cat : ./cat.jpg
```

# II. Script youtube-dl

## Rendu

Fichier : [yt.sh](/3/srv/yt/yt.sh)

Log : [download.log](/3/srv/yt/download.log)

🌞 Vous fournirez dans le compte-rendu, en plus du fichier, **un exemple d'exécution avec une sortie**, dans des balises de code.

```bash
nathan@nathan-SSD-Linux:~/Documents/Github/tp-b1-linux/3/srv/yt$ ./yt.sh https://youtu.be/tPEE9ZwTmy0
Video https://youtu.be/tPEE9ZwTmy0 was downloaded.
File path: download/Shortest Video on Youtube-tPEE9ZwTmy0/Shortest Video on Youtube-tPEE9ZwTmy0.mp4
```

# III. MAKE IT A SERVICE

YES. Yet again. **On va en faire un [service](../../cours/notions/serveur/README.md#ii-service).**

L'idée :

➜ plutôt que d'appeler la commande à la main quand on veut télécharger une vidéo, **on va créer un service qui les téléchargera pour nous**

➜ le service devra **lire en permanence dans un fichier**

- s'il trouve une nouvelle ligne dans le fichier, il vérifie que c'est bien une URL de vidéo youtube
  - si oui, il la télécharge, puis enlève la ligne
  - sinon, il enlève juste la ligne

➜ **qui écrit dans le fichier pour ajouter des URLs ? Bah vous !**

- vous pouvez écrire une liste d'URL, une par ligne, et le service devra les télécharger une par une

---

Pour ça, procédez par étape :

- **partez de votre script précédent** (gardez une copie propre du premier script, qui doit être livré dans le dépôt git)
  - le nouveau script s'appellera `yt-v2.sh`
- **adaptez-le pour qu'il lise les URL dans un fichier** plutôt qu'en argument sur la ligne de commande
- **faites en sorte qu'il tourne en permanence**, et vérifie le contenu du fichier toutes les X secondes
  - boucle infinie qui :
    - lit un fichier
    - effectue des actions si le fichier n'est pas vide
    - sleep pendant une durée déterminée
- **il doit marcher si on précise une vidéo par ligne**
  - il les télécharge une par une
  - et supprime les lignes une par une
- **une fois que tout ça fonctionne, enfin, créez un service** qui lance votre script :
  - créez un fichier `/etc/systemd/system/yt.service`. Il comporte :
    - une brève description
    - un `ExecStart` pour indiquer que ce service sert à lancer votre script
    - une clause `User=` pour indiquer quel utilisateur doit lancer le script

```bash
[Unit]
Description=<Votre description>

[Service]
ExecStart=<Votre script>
User=<User>

[Install]
WantedBy=multi-user.target
```

> Pour rappel, après la moindre modification dans le dossier `/etc/systemd/system/`, vous devez exécuter la commande `sudo systemctl daemon-reload` pour dire au système de lire les changements qu'on a effectué.

Vous pourrez alors interagir avec votre service à l'aide des commandes habituelles `systemctl` :

- `systemctl status yt`
- `sudo systemctl start yt`
- `sudo systemctl stop yt`

![Now witness](./pics/now_witness.png)

## Rendu

📁 **Le script `/srv/yt/yt-v2.sh`**

📁 **Fichier `/etc/systemd/system/yt.service`**

🌞 Vous fournirez dans le compte-rendu, en plus des fichiers :

- un `systemctl status yt` quand le service est en cours de fonctionnement
- un extrait de `journalctl -xe -u yt`

> Hé oui les commandes `journalctl` fonctionnent sur votre service pour voir les logs ! Et vous devriez constater que c'est vos `echo` qui pop. En résumé, **le STDOUT de votre script, c'est devenu les logs du service !**

🌟**BONUS** : get fancy. Livrez moi un gif ou un [asciinema](https://asciinema.org/) (PS : c'est le feu asciinema) de votre service en action, où on voit les URLs de vidéos disparaître, et les fichiers apparaître dans le fichier de destination

# IV. Bonus

Quelques bonus pour améliorer le fonctionnement de votre script :

➜ **en accord avec les règles de [ShellCheck](https://www.shellcheck.net/)**

- bonnes pratiques, sécurité, lisibilité

➜  **fonction `usage`**

- le script comporte une fonction `usage`
- c'est la fonction qui est appelée lorsque l'on appelle le script avec une erreur de syntaxe
- ou lorsqu'on appelle le `-h` du script

➜ **votre script a une gestion d'options :**

- `-q` pour préciser la qualité des vidéos téléchargées (on peut choisir avec `youtube-dl`)
- `-o` pour préciser un dossier autre que `/srv/yt/`
- `-h` affiche l'usage

➜ **si votre script utilise des commandes non-présentes à l'installation** (`youtube-dl`, `jq` éventuellement, etc.)

- vous devez TESTER leur présence et refuser l'exécution du script

➜  **si votre script a besoin de l'existence d'un dossier ou d'un utilisateur**

- vous devez tester leur présence, sinon refuser l'exécution du script

➜ **pour le téléchargement des vidéos**

- vérifiez à l'aide d'une expression régulière que les strings saisies dans le fichier sont bien des URLs de vidéos Youtube
