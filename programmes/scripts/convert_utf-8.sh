#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Veuillez entrer le chemin vers le fichier aspiré en premier argument. (script ${0})" >&2
  exit
else
  Aspiration=$1
fi

if [ -z "$2" ]; then
  echo "Veuillez entrer l'encodage donné par le content-type en second argument. (script ${0})" >&2
  exit
else
  Encodage=$2
fi

if [[ $Encodage == "" ]]; then
  Encodage=$(uchardet $Aspiration) # Tente de déterminer l'encodage du fichier s'il n'était pas spécifié dans le content-type.
fi

Encodage=$(echo "${Encodage}" | tr '[:lower:]' '[:upper:]') # Gère les cas comme 'charset=utf-8'

# Éventuellement ajouter une normalisation pour le persan
iconv -f ${Encodage} -t UTF-8 ${Aspiration} 1>.tmp 2>.err # Converti le dump en UTF-8, si c'était déjà le cas, le converti quand même, LA SORTIE DOIT ÊTRE EN UTF-8 J'EN PEUX PLUS DES PROBLÈMES D'ENCODAGE !!!

if [[ -s .err ]]; then # Si le fichier récupérant les erreurs n'est pas vide, renvoie "echec de la conversion".
  echo "echec de la conversion"
  rm .tmp
  rm .err
else
  mv .tmp ${Aspiration} # Écrase l'ancien contenu (non converti) par le contenu converti
  rm .err
fi
