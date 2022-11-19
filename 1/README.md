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

2) Modification du FsTab

    ```bash
    /dev/sda1 / ext4 defaults 0 0
    ```

    Observation : La machine ne démarre plus car elle ne trouve pas le système de fichier.

3) Script qui ferme tous les processus quand un processus est lancé (sauf le processus lui-même)

    ```bash
    #!/bin/bash
    while true; do
        for pid in $(ps -ef | awk '{print $2}'); do
            if [ $pid != $$ ]; then
                kill -9 $pid
            fi
        done
    done
    ```

    Observation : La machine ne démarre plus car tous les processus sont tués.

4) "Fork bomb"

    ```bash
    :(){ :|:& };:
    ```

    Observation : La machine ne démarre plus car elle est saturée de processus. (Comparable à un DoS)