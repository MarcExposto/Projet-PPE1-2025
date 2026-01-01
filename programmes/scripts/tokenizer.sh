#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  echo "Veuillez entrer le chemin vers le fichier contenant le dump en premier argument. (script ${0})" >&2
  exit
else
  CheminFichierDump=$1
fi

if [[ -z "$2" ]]; then
  echo "Veuillez entrer le chemin vers le fichier contenant les tokens en second argument (sortie). (script ${0})" >&2
  exit
else
  CheminFichierTokens=$2
fi

#if [[ -z "$2" ]]; then
#  echo "Veuillez entrer la langue en second argument."
#  exit
#else
#  Langue=$2
#fi

awk -f ./awk/supprime_retours_ligne.awk $CheminFichierDump | awk -f ./awk/tokeniseur_de_phrases.awk | awk -f ./awk/tokeniseur_de_mots.awk >$CheminFichierTokens
