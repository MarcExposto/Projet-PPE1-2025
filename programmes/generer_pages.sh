#!/bin/bash

# Définition du chemin relatif vers la racine depuis ce script
CheminRacineProjet=".."

# Définition des chemins relatifs vers la racine à passer aux scripts awk pour générer les liens
CheminRacineDepuisTableaux=".."
CheminRacineDepuisConcordances=".."
CheminRacineDepuisCoocurrents=".."

# Crée le dossier tableaux s'il n'existe pas encore
mkdir -p "${CheminRacineProjet}/tableaux"

### ANGLAIS
# Générer le tableau anglais
FichierUrls="../URLs/en.txt"
Langue="en"
MotCible="lockdowns?"
${CheminRacineProjet}/programmes/pipeline.sh "${FichierUrls}" "${Langue}" "${MotCible}" >"${CheminRacineProjet}/tableaux/tableau_urls_${Langue}.tsv"

Titre="Tableau récapitulatif pour les URLs séléctionnées pour l'anglais"
CheminTableau="${CheminRacineProjet}/tableaux/tableau_urls_${Langue}.tsv"
Tableau="$(awk -f ${CheminRacineProjet}/programmes/awk/tsv_vers_html.awk -v indentation=6 ${CheminTableau})"
printf "${Tableau}" | awk -f ${CheminRacineProjet}/programmes/awk/formater_page.awk -v racine="${CheminRacineDepuisTableaux}" -v titre="${Titre}" "${CheminRacineProjet}/programmes/templates/tableau.html" >"${CheminRacineProjet}/tableaux/${Langue}.html"

# Convertir les concordanciers tsv en html
Titre="Concordancier lockdown"
CheminConcordancier="${CheminRacineProjet}/concordances/concordancier_${Langue}.tsv"
Concordancier="$(awk -f ${CheminRacineProjet}/programmes/awk/tsv_vers_html.awk -v indentation=6 ${CheminConcordancier})"
printf "${Concordancier}" | awk -f ${CheminRacineProjet}/programmes/awk/formater_page.awk -v racine="${CheminRacineDepuisConcordances}" -v titre="${Titre}" "${CheminRacineProjet}/programmes/templates/tableau.html" >"${CheminRacineProjet}/concordances/concordancier_${Langue}.html"

# Convertir tableaux coocurrences tsv en html
Titre="Tokens coocurrents de lockdown"
CheminCoocurrentsMonogrammes="${CheminRacineProjet}/coocurrents/${Langue}.tsv"
CoocurrentsMonogrammes="$(awk -f ${CheminRacineProjet}/programmes/awk/tsv_vers_html.awk -v indentation=6 ${CheminCoocurrentsMonogrammes})"
printf "${CoocurrentsMonogrammes}" | awk -f ${CheminRacineProjet}/programmes/awk/formater_page.awk -v racine="${CheminRacineDepuisCoocurrents}" -v titre="${Titre}" "${CheminRacineProjet}/programmes/templates/tableau.html" >"${CheminRacineProjet}/coocurrents/${Langue}.html"

Titre="Bigrammes coocurrents de lockdown"
CheminCoocurrentsBigrammes="${CheminRacineProjet}/coocurrents/${Langue}_bigrammes.tsv"
CoocurrentsBigrammes="$(awk -f ${CheminRacineProjet}/programmes/awk/tsv_vers_html.awk -v indentation=6 ${CheminCoocurrentsBigrammes})"
printf "${CoocurrentsBigrammes}" | awk -f ${CheminRacineProjet}/programmes/awk/formater_page.awk -v racine="${CheminRacineDepuisCoocurrents}" -v titre="${Titre}" "${CheminRacineProjet}/programmes/templates/tableau.html" >"${CheminRacineProjet}/coocurrents/${Langue}_bigrammes.html"

### FRANÇAIS
# Générer le tableau français
FichierUrls="../URLs/fr.txt"
Langue="fr"
MotCible="confinements?"
${CheminRacineProjet}/programmes/pipeline.sh "${FichierUrls}" "${Langue}" "${MotCible}" >"${CheminRacineProjet}/tableaux/tableau_urls_${Langue}.tsv"

Titre="Tableau récapitulatif pour les URLs séléctionnées pour le français"
CheminTableau="${CheminRacineProjet}/tableaux/tableau_urls_${Langue}.tsv"
Tableau="$(awk -f ${CheminRacineProjet}/programmes/awk/tsv_vers_html.awk -v indentation=6 ${CheminTableau})"
printf "${Tableau}" | awk -f ${CheminRacineProjet}/programmes/awk/formater_page.awk -v racine="${CheminRacineDepuisTableaux}" -v titre="${Titre}" "${CheminRacineProjet}/programmes/templates/tableau.html" >"${CheminRacineProjet}/tableaux/${Langue}.html"

# Convertir les concordanciers tsv en html
Titre="Concordancier confinement"
CheminConcordancier="${CheminRacineProjet}/concordances/concordancier_${Langue}.tsv"
Concordancier="$(awk -f ${CheminRacineProjet}/programmes/awk/tsv_vers_html.awk -v indentation=6 ${CheminConcordancier})"
printf "${Concordancier}" | awk -f ${CheminRacineProjet}/programmes/awk/formater_page.awk -v racine="${CheminRacineDepuisConcordances}" -v titre="${Titre}" "${CheminRacineProjet}/programmes/templates/tableau.html" >"${CheminRacineProjet}/concordances/concordancier_${Langue}.html"

# Convertir tableaux coocurrences tsv en html
Titre="Tokens coocurrents de confinement"
CheminCoocurrentsMonogrammes="${CheminRacineProjet}/coocurrents/${Langue}.tsv"
CoocurrentsMonogrammes="$(awk -f ${CheminRacineProjet}/programmes/awk/tsv_vers_html.awk -v indentation=6 ${CheminCoocurrentsMonogrammes})"
printf "${CoocurrentsMonogrammes}" | awk -f ${CheminRacineProjet}/programmes/awk/formater_page.awk -v racine="${CheminRacineDepuisCoocurrents}" -v titre="${Titre}" "${CheminRacineProjet}/programmes/templates/tableau.html" >"${CheminRacineProjet}/coocurrents/${Langue}.html"

Titre="Bigrammes coocurrents de confinement"
CheminCoocurrentsBigrammes="${CheminRacineProjet}/coocurrents/${Langue}_bigrammes.tsv"
CoocurrentsBigrammes="$(awk -f ${CheminRacineProjet}/programmes/awk/tsv_vers_html.awk -v indentation=6 ${CheminCoocurrentsBigrammes})"
printf "${CoocurrentsBigrammes}" | awk -f ${CheminRacineProjet}/programmes/awk/formater_page.awk -v racine="${CheminRacineDepuisCoocurrents}" -v titre="${Titre}" "${CheminRacineProjet}/programmes/templates/tableau.html" >"${CheminRacineProjet}/coocurrents/${Langue}_bigrammes.html"
