# Utilisation de Multipass et Spack

Avec [Multipass](https://multipass.run) il est très facile d'installer une [machine virtuelle](https://azure.microsoft.com/en-us/overview/what-is-a-virtual-machine/#overview) Ubuntu sur macOS, Windows ou Linux.

[Spack](https://spack.io) est quant à lui est un gestionnaire de paquets, qui rend l'installation des logiciels scientifiques (en particulier) relativement aisée. Nous l'utilisons pour pré-installer l'ensemble des paquets nécessaires à ce projet, dans la machine virtuelle créée par Multipass.

L'avantage de ce type d'installation pour ce projet est qu'il n'y a plus qu'une seule plateforme (Ubuntu) sur laquelle l'ensemble de la pile logicielle doit être validée.

On accèdera à la machine virtuelle Ubuntu, depuis le système hôte (macOS, Linux ou Windows), comme on accèderait à n'importe quel serveur distant, via ssh, ou encore plus simplement en utilisant la commande `multipass shell`.


## Installation de Multipass

Suivez les instructions d'installation sur le site [multipass](https://multipass.run), en fonction de votre type de système d'exploitation. Vérifiez que vous avez récupéré la version `1.10.1` en utilisant la commande `multipass version`. Ce qui donne par exemple (sur un Mac) : 

```shell
$ multipass --version
multipass   1.10.1+mac
multipassd  1.10.1+mac
```

## Installation de la machine virtuelle

Executez la commande suivante depuis un terminal :

```shell
$ ./create-vm.sh
Launched: qqbar2mumu
==> Fetching file:///home/ubuntu/mirror/build_cache/_pgp/0BB2598DB7BB50156663C3C8625B32CA90BA8870.pub
gpg: key 625B32CA90BA8870: public key "Laurent Aphecetche (GPG created for Spack) <laurent.aphecetche@gmail.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1
gpg: inserting ownertrust of 6
```

Dans votre cas la clé gpg sera différente, c'est normal.

<details>
<summary>Occupation disque</summary>

Le script `create-vm.sh` va créer par défaut une machine virtuelle qui utilise 64 Go de disque, la moitié de la mémoire disponible sur la machine, et la moitié des CPUs.
Si vous voulez allouer moins de ressources à la machine virtuelle, vous pouvez fournir des paramètres au script. Par exemple pour créer une machine virtuelle avec 4 coeurs, 8 Go de RAM et 24 Go de disque :
```
./create-vm.sh cpus mem disk
./create-vm.sh 4 8G 24
```
</details>

<details>
<summary>Cela devrait prendre une dizaine de minutes</summary>

Le temps exact d'installation dépend de la vitesse de votre connection internet : le script télécharge en effet une image Ubuntu (c'est la partie Multipass), puis une archive contenant tous les paquets binaires à installer dans la machine virtuelle (c'est la partie Spack).
</details>

Vérifier que la machine virtuelle a bien été créée (l'address réseau IPv4 peut être différente dans votre cas, par exemple du style `192.168.xxx.yyy`, ce n'est pas un problème) :

```shell
$ multipass list
Name                    State             IPv4             Image
qqbar2mumu              Running           172.16.81.14     Ubuntu 22.04 LTS
```


## Utilisation de la machine virtuelle pour démarrer un serveur Jupyter Lab

C'est le mode de fonctionnement que vous utiliserez le plus souvent. Utilisez pour cela la commande `start` qui a été définie dans la machine virtuelle :
<details>
<summary>`multipass exec qqbar2mumu start`</summary>

```shell
$ multipass exec qqbar2mumu start
[I 2021-12-24 00:08:27.829 ServerApp] jupyterlab | extension was successfully linked.
[I 2021-12-24 00:08:27.859 LabApp] JupyterLab extension loaded from /home/ubuntu/spack/opt/spack/linux-ubuntu20.04-haswell/gcc-9.3.0/py-jupyterlab-3.2.1-veeoqqjxqx5un4b2oq3c2iispchd25cr/lib/python3.8/site
-packages/jupyterlab
[I 2021-12-24 00:08:27.859 LabApp] JupyterLab application directory is /home/ubuntu/spack/opt/spack/linux-ubuntu20.04-haswell/gcc-9.3.0/py-jupyterlab-3.2.1-veeoqqjxqx5un4b2oq3c2iispchd25cr/share/jupyter/l
ab
[I 2021-12-24 00:08:27.864 ServerApp] jupyterlab | extension was successfully loaded.
[I 2021-12-24 00:08:27.865 ServerApp] Serving notebooks from local directory: /home/ubuntu/nantes-m2-rps-exp/qqbar2mumu-2021
[I 2021-12-24 00:08:27.865 ServerApp] Jupyter Server 1.11.2 is running at:
[I 2021-12-24 00:08:27.865 ServerApp] http://172.16.81.14:8888/lab?token=282695122119c7cd9c16e096303a3290e387a9792bbafa8a
[I 2021-12-24 00:08:27.865 ServerApp]  or http://127.0.0.1:8888/lab?token=282695122119c7cd9c16e096303a3290e387a9792bbafa8a
[I 2021-12-24 00:08:27.865 ServerApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 2021-12-24 00:08:27.870 ServerApp]

    To access the server, open this file in a browser:
        file:///home/ubuntu/.local/share/jupyter/runtime/jpserver-21489-open.html
    Or copy and paste one of these URLs:
        http://172.16.81.14:8888/lab?token=282695122119c7cd9c16e096303a3290e387a9792bbafa8a
     or http://127.0.0.1:8888/lab?token=282695122119c7cd9c16e096303a3290e387a9792bbafa8a

```

</details>

Cliquez sur (ou copiez-collez, en fonction des capacités de votre terminal) sur l'addresse `http://172.../lab?token=....` pour ouvrir dans votre navigateur (sur votre système hôte) une fenêtre connectée au serveur Jupyter Lab (qui tourne dans la machine virtualle). Ce serveur Jupyter contient tous les modules Python nécessaires à ce projet (paquets génériques ainsi que paquets spécifiques `mch*`)

## Autres utilisations de la machine virtuelle

Vous pourrez avoir besoin d'utiliser la machine virtuelle dans un autre mode, en vous y connectant directement, par exemple pour télécharger les données.

Auquel cas vous "entrez" dans la machine virtuelle :

<details>
<summary>`multipass shell qqbar2mumu`</summary>

```shell
$ multipass shell qqbar2mumu
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-52-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed Nov  9 17:16:18 CET 2022

  System load:             0.0
  Usage of /:              8.8% of 61.84GB
  Memory usage:            4%
  Swap usage:              0%
  Processes:               156
  Users logged in:         0
  IPv4 address for enp0s2: 192.168.64.3
  IPv6 address for enp0s2: fdc4:3947:59f1:829f:3cc6:d1ff:feec:d24d


5 updates can be applied immediately.
4 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


Last login: Wed Nov  9 16:58:52 2022 from 192.168.64.1
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

📦qqbar2mumu-2022ubuntu@qqbar2mumu:~$
```

</details>

### Mise en place de l'environnement

Pour pouvoir utiliser l'ensemble des paquets Python utiles à ce projet, vous devrez, une fois connecté à la machine virtuelle, mettre en place l'environmment de la façon suivante :

```shell
cd ~/nantes-m2-rps-exp/qqbar2mumu-2022
spacktivate . 
spack load qqbar2mumu-2022
```

### Téléchargement des données

Si vous désirez seulement télécharger les données, il n'est pas nécessaire de mettre en place l'environnement comme ci-dessus, mais seulement d'exécuter le script de téléchargement :

```shell
cd ~/nantes-m2-rps-exp/qqbar2mumu-2022/data
./copy-data-locally.sh
```

