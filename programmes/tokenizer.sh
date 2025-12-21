#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  echo "Veuillez entrer le chemin vers le dossier des dumps en premier argument."
  exit
else
  CheminDossierDumps=$1
fi

#if [[ -z "$2" ]]; then
#  echo "Veuillez entrer la langue en second argument."
#  exit
#else
#  Langue=$2
#fi

cat "${CheminDossierDumps}"/* | egrep -o "(\w+ ?)+[.?\!]" | tr "[.?\!]" "\n" | tr " " "\n"
