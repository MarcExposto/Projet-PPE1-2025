#!/bin/bash

# Calcul du chemin du script et de la racine
CheminScript="$(cd "$(dirname "$0")" && pwd)"
CheminRacineProjet="$(cd "${CheminScript}/.." && pwd)"

# Générer le tableau anglais
FichierUrls="../URLs/en.txt"
Langue="en"
MotCible="lockdowns\?"
${CheminRacineProjet}/programmes/pipeline.sh "${FichierUrls}" "${Langue}" "${MotCible}" >"${CheminRacineProjet}/tableaux/tableau_urls_${Langue}.tsv"

Titre="Tableau récapitulatif pour les URLs séléctionnées pour l'anglais"
CheminTableau="${CheminRacineProjet}/tableaux/tableau_urls_${Langue}.tsv"
Tableau="$(awk -f ${CheminRacineProjet}/programmes/awk/tsv_vers_html.awk -v indentation=4 ${CheminTableau})"
printf "${Tableau}" | awk -f ${CheminRacineProjet}/programmes/awk/formater_page.awk -v racine="${CheminRacineProjet}" -v titre="${Titre}" "${CheminRacineProjet}/programmes/templates/tableau.html" >"${CheminRacineProjet}/tableaux/${Langue}.html"

# Générer le tableau français
FichierUrls="../URLs/fr.txt"
Langue="fr"
MotCible="confinements\?"
${CheminRacineProjet}/programmes/pipeline.sh "${FichierUrls}" "${Langue}" "${MotCible}" >"${CheminRacineProjet}/tableaux/tableau_urls_${Langue}.tsv"

Titre="Tableau récapitulatif pour les URLs séléctionnées pour le français"
CheminTableau="${CheminRacineProjet}/tableaux/tableau_urls_${Langue}.tsv"
Tableau="$(awk -f ${CheminRacineProjet}/programmes/awk/tsv_vers_html.awk -v indentation=4 ${CheminTableau})"
printf "${Tableau}" | awk -f ${CheminRacineProjet}/programmes/awk/formater_page.awk -v racine="${CheminRacineProjet}" -v titre="${Titre}" "${CheminRacineProjet}/programmes/templates/tableau.html" >"${CheminRacineProjet}/tableaux/${Langue}.html"
