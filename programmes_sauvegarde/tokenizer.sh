#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  echo "Veuillez entrer le chemin vers le fichier contenant le dump en premier argument."
  exit
else
  CheminFichierDump=$1
fi

#if [[ -z "$2" ]]; then
#  echo "Veuillez entrer la langue en second argument."
#  exit
#else
#  Langue=$2
#fi

LC_ALL=fr_FR.UTF-8 gawk -f ./awk/supprime_retours_ligne.awk $CheminFichierDump | gawk -f ./awk/tokeniseur_de_phrases.awk | gawk -f ./awk/tokeniseur_de_mots.awk
