#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  echo "Veuillez entrer le chemin vers le fichier aspiré en premier argument. (script ${0})" >&2
  exit
else
  CheminFichierAspiration=$1
fi

if [[ -z "$2" ]]; then
  echo "Veuillez entrer le chemin vers le fichier du dump (sortie) en second argument. (script ${0})" >&2
  exit
else
  CheminFichierDump=$2
fi

# Extrait le texte brut de la page
#Dump=$(LC_ALL=C.UTF-8 LANG=C.UTF-8 lynx -dump -nolist -assume_charset=UTF-8 -display_charset=UTF-8 "${CheminFichierAspiration}")
Dump=$(lynx -dump -nolist "${CheminFichierAspiration}")
echo "$Dump" >"$CheminFichierDump"
