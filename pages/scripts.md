# Scripts

## Guidelines pour l'écriture des scripts bash (pour rendre le debbugage plus facile)

* Shebang : `#!/bin/bash`
* Vérification des arguments : dans un bloc if, si l'argument n'est pas valide, on renvoie un message d'erreur contenant le nom du script (avec `${0}`) et on quite avec `exit`
* Racine du projet dans une variable : pour toujours exprimer les chemins vers les fichiers et scripts par rapport à la racine du projet (on peut executer le script depuis n'importe où sans avoir d'erreurs qui donnent envie de s'arracher les cheveux).
* Nommage des variables : `NomDeLaVariable`
* Un script par tâche
* Un script `pipeline.sh` pour traiter les données
* Un script `generer_pages.sh` pour générer les pages html à partir des données de `pipeline.sh`
