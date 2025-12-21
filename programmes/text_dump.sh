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

if [[ -z "$3" ]]; then
  echo "Veuillez entrer l'encodage de la page en troisième argument."
  exit
else
  Encodage=$3
  Encodage=$(echo "${Encodage}" | tr '[:lower:]' '[:upper:]') # Gère les cas comme 'charset=utf-8'
  if [[ $Encodage == "N/A" ]]; then
    Encodage="UTF-8" # Si l'encodage n'est pas renseigné, UTF-8 est choisi par défaut
  fi
fi

# Extrait le texte brut de la page
Dump=$(lynx -dump -nolist -display_charset=${Encodage} ${CheminFichierAspiration})
echo "$Dump" >.tmp

if [[ $Encodage != "UTF-8" ]]; then
  # Éventuellement ajouter une normalisation pour le persan
  iconv -f ${Encodage} -t UTF-8 .tmp >"$CheminFichierDump" # Converti le dump en UTF-8 si ce n'est pas son encodage
  rm .tmp
else
  mv .tmp ${CheminFichierDump}
fi
