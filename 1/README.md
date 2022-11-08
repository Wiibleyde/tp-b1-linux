# TP1 : Are you dead yet ?

🌞 **Trouver au moins 4 façons différentes de péter la machine**

1) Démarrage d'un script au démarrage de la machine qui la fait reboot.

Script bash :

```bash
#!/bin/bash
/usr/sbin/reboot
```

Crontab :

```bash
@reboot /chemin/vers/le/script.sh
```

Observation : Le script est exécuté au démarrage de la machine et donc, la machine reboot en boucle.