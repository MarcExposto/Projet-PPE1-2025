#!/bin/bash

# Vérification des arguments
if [ -z "$1" ]; then
  echo "Veuillez entrer le chemin vers le fichier d'URLs en premier argument. (script ${0})"
  exit
else
  FichierUrls=$1
fi

if ! [[ "$2" =~ ^(en)|(fa)|(fr)$ ]]; then
  echo "Le deuxième argument doit être le code ISO-639-1 de la langue. (script ${0})"
  exit
else
  Langue=$2
fi

if [ -z "$3" ]; then
  echo "Veuillez entrer le mot cible en troisième argument. (script $0)"
  exit
else
  MotCible=$3
fi

# Calcul du chemin du script et de la racine
CheminScript="$(cd "$(dirname "$0")" && pwd)"
CheminRacineProjet="$(cd "${CheminScript}/.." && pwd)"

# Générer le tableau principal
${CheminRacineProjet}/programmes/pipeline.sh $FichierUrls $Langue $MotCible >${CheminRacineProjet}/tableaux/tableau_urls.tsv
Titre="Tableau ${Langue}"
CheminTableau="${CheminRacineProjet}/tableaux/tableau_urls.tsv"
Tableau="$(awk -f ${CheminRacineProjet}/programmes/awk/tsv_vers_html.awk -v indentation=4 ${CheminTableau})"
printf "${Tableau}" | awk -f ${CheminRacineProjet}/programmes/awk/formater_page.awk -v titre="${Titre}" ${CheminRacineProjet}/programmes/templates/tableau.html
