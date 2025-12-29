#!/usr/bin/env bash
if [ -z "$1" ]; then
  echo "Veuillez entrer le chemin vers les fichiers tokensisés en premier argument."
  exit
else
  DossierTokens=$1
fi

if [ -z "$2" ]; then
  echo "Veuillez entrer le mot cible en second argument."
  exit
else
  MotCible=$1
fi

python3 ./python/cooccurrents.py ${DossierTokens}/* --target $MotCible --match-mode regex 2>/dev/null
