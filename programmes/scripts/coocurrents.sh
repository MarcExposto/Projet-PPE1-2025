#!/usr/bin/env bash
if [ -z "$1" ]; then
  echo "Veuillez entrer le chemin vers le dossier des fichiers tokensisés en premier argument." >&2
  exit
else
  DossierTokens=$1
fi

if [ -z "$2" ]; then
  echo "Veuillez entrer le mot cible en second argument." >&2
  exit
else
  MotCible=$2
fi

if [ -z "$3" ]; then
  echo "Veuillez entrer le chemin vers le fichier de sortie en troisième argument." >&2
  exit
else
  FichierSortie=$3
fi

python3 ./python/coocurrents.py ${DossierTokens}/* --target $MotCible --match-mode regex 1>$FichierSortie 2>/dev/null
