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

# Génération du tableau (tsv)
id=1

printf "id \t url \t gestion de robots.txt \t code http \t encodage initial de la page \t lien vers la page brute \t statut de la conversion en UTF-8 \t lien vers le dump textuel \t numbre total de mots dans le dump \t nombre d'occurrences du mot cible dans le dump \t lien vers le concordancier \t lien vers l'analyse des bigrammes\n"

while read -r line; do

  Url=$line

  Robots=$(${CheminRacineProjet}/programmes/scripts/robots.sh $Url)
  if [[ $Robots = 'Disallow' ]]; then
    printf "${id}\t${Url}\t${Robots}\t\t\t\t\t\t\t\t\t\n"
    ((id++))
    continue
  else
    Robots='Allow'
  fi

  CheminFichierAspiration="${CheminRacineProjet}/aspirations/${Langue}/${Langue}-${id}.html"
  data=$(curl -s -i -L -w "%{http_code}\n%{content_type}" -o ${CheminFichierAspiration} ${Url})

  CodeHTTP=$(echo "$data" | head -1)
  if [[ ! $CodeHTTP =~ (2|3).. ]]; then
    printf "${id}\t${Url}\t${Robots}\t${CodeHTTP}\t\t\t\t\t\t\t\t\n"
    ((id++))
    continue
  fi

  Encodage=$(echo "$data" | tail -1 | grep charset | cut -d "=" -f2)
  if [[ $Encodage = "" ]]; then
    Encodage="Non Renseigné"
  fi

  ErreurConversion=$(${CheminRacineProjet}/programmes/scripts/convert_utf-8.sh ${CheminFichierAspiration} ${Encodage} 2>&1)
  if [[ -n $ErreurConversion ]]; then
    printf "${id}\t${Url}\t${Robots}\t${CodeHTTP}\t${Encodage}\tÉchec\t\t\t\t\t\t\n"
    ((id++))
    continue
  fi

  CheminFichierTexte="${CheminRacineProjet}/dumps-text/${Langue}/${Langue}-${id}.txt"
  ${CheminRacineProjet}/programmes/scripts/text_dump.sh $CheminFichierAspiration $CheminFichierTexte

  NbMots=$(cat ${CheminFichierTexte} | wc -w)
  NbOccurrences=$(egrep -o ${MotCible} ${CheminFichierTexte} | wc -w)

  CheminFichierTokens="${CheminRacineProjet}/dumps-tokenises/${Langue}/${Langue}-${id}.conll"
  ${CheminRacineProjet}/programmes/scripts/tokenizer.sh $CheminFichierTexte $CheminFichierTokens

  CheminFichierConcordances="${CheminRacineProjet}/concordances/${Langue}/${Langue}-${id}-concordance.html"
  echo XXX >$CheminFichierConcordances
  #${CheminRacineProjet}/programmes/scripts/concordances.sh $CheminFichierTexte $Langue 5 $Monmot >$CheminFichierConcordance

  CheminFichierBigrammes="${CheminRacineProjet}/bigrammes/${Langue}/${Langue}-${id}.XXX"
  echo XXX >$CheminFichierBigrammes
  #${CheminRacineProjet}/programmes/scripts/bigrammes.sh XXX

  printf "${id}\t${Url}\t${Robots}\t${CodeHTTP}\t${Encodage}\tConverti\t[Lien vers le dump](${CheminFichierTexte})\t${NbMots}\t${NbOccurrences}\t[Lien vers le fichier tokenisé](${CheminFichierTokens})\t[Lien vers le concordancier](${CheminFichierConcordances})\t[Lien vers les bigrammes](${CheminFichierBigrammes})\n"

  ((id++))
done <$FichierUrls

# Génération du tableau des coocurents
CheminFichierCoocurrents="../coocurents/${Langue}.tsv"
./scripts/coocurrents.sh ../dumps-tokenises/${Langue} $Monmot $CheminFichierCoocurrents

# Génération du nuage de mots
#XXX
