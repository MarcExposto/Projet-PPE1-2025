#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Veuillez entrer le chemin vers le fichier d'URLs en premier argument."
  exit
else
  FichierUrls=$1
fi

if ! [[ "$2" =~ ^(en)|(fa)|(fr)$ ]]; then
  echo "Le deuxième argument doit être le code ISO-639-1 de la langue."
  exit
else
  Langue=$2
fi

if [ -z "$3" ]; then
  echo "Veuillez entrer le mot cible en troisième argument."
  exit
else
  Monmot=$3
fi

id=1

echo "id; url; http_code; encodage; status de la conversion; aspiration; dump textuel; nombre de mots; tableau des coocurrents"

while read -r line; do

  CheminFichierAspiration="../aspirations/${Langue}/${Langue}-${compte}.html"
  data=$(curl -s -i -L -w "%{http_code}\n%{content_type}" -o ${CheminFichierAspiration} ${line})

  codeHTTP=$(echo "$data" | head -1)
  if [[ $codeHTTP =~ "(2|3).." ]]; then
    echo "$id; $line; $codeHTTP; ; ; ; ; ; "
    ((id++))
    continue
  fi

  Encodage=$(echo "$data" | tail -1 | cut -d "=" -f2)
  Encodage=${Encodage:"_"}
  retour_convertion=(./scripts/convert_utf-8.sh ${CheminFichierAspiration} ${Encodage})
  if [[ $retour_convertion == "echec de la conversion" ]]; then
    echo "$id; $line; $codeHTTP; $Encodage; echec; ; ; ; "
    ((id++))
    continue
  fi

  CheminFichierTexte="../dumps-text/${Langue}/${Langue}-${compte}.txt"
  ./scripts/text_dump.sh $CheminFichierAspiration $CheminFichierTexte $Encodage

  NbrMots=$(cat ${CheminFichierTexte} | wc -w)

  CheminFichierTokens="../dumps-tokenises/${Langue}/${Langue}-${compte}.conll"
  ./scripts/tokenizer.sh $CheminFichierTexte >$CheminFichierTokens

  #CheminFichierConcordance="../concordances/${Langue}/${Langue}-${compte}-concordance.html"
  #./concordances.sh $CheminFichierTexte $Langue 5 $Monmot >$CheminFichierConcordance

  echo "$id; [$line]($line); $codeHTTP; $Encodage; réussie; [$CheminFichierAspiration](Lien aspiration); [$CheminFichierTexte](Lien dump textuel); $NbrMots; "

  ((id++))
done <$FichierUrls

# Génération du tableau des coocurents
CheminFichierCoocurrents="../coocurents/${Langue}.tsv"
./scripts/coocurrents.sh ../dumps-tokenises/${Langue} $Monmot $CheminFichierCoocurrents
