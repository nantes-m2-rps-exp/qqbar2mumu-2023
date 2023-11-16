# Comment se connecter à la plateforme Jupyter du CC-IN2P3

Utilisez votre navigateur préféré pour aller sur https://notebook.cc.in2p3.fr, qui devrait ressembler à : 

![](./cc-jupyter-platform-landing-page.png)

Cliquez sur le bouton orange "Launch My Notebooks Server". Cela devrait vous emmener vers la page d'authentification du CC-IN2P3 :

![](./cc-authentication-page.png)

Entrez votre identifiant et votre mot de passe (donnés par vos encadrants à la première séance)

Sur l'écran suivant sélectionnez "CPU only" et cliquez sur le bouton  orange "Launch My Notebooks Server".

![](./cc-notebook-server-options.png)

# A faire après la première connexion

Aller dans `File -> New -> Terminal` (ou cliquez sur l'icone "Terminal" dans l'onglet "Launcher" qui devrait être ouvert) et tapez les commandes suivantes pour récupérer le dépot git qui contient le point de départ de ce projet : 

```shell
git clone https://github.com/nantes-m2-rps-exp/qqbar2mumu-2023.git
```

Notez qu'un répertoire `qqbar2mumu-2023` devrait apparaître dans la partie gauche de l'écran qui est la partie "explorateur de fichiers". A l'aide de cet explorateur de fichiers naviguez jusqu'au répertoire `qqbar2mumu-2023/notebooks` et double-cliquez sur `muon-eta-distribution.ipynl`. Ceci ouvre votre premier notebook qui vous sera présenté lors de la première séance.


