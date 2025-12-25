#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  echo "Veuillez entrer le chemin vers le fichier aspiré en premier argument."
  exit
else
  CheminFichierAspiration=$1
fi

if [[ -z "$2" ]]; then
  echo "Veuillez entrer le titre de la page en second argument."
  exit
else
  CheminFichierDump=$2
fi

# Extrait le texte brut de la page
Dump=$(lynx -dump -nolist -display_charset=UTF-8 ${CheminFichierAspiration})
echo "$Dump" >$CheminFichierDump
