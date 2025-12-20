#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Veuillez entrer le chemin vers le fichier d'URLs en premier argument."
  exit
else
  FichierUrls=$1
fi

if [ -z "$2" ]; then
  echo "Veuillez entrer la langue en second argument."
  exit
else
  Malangue=$2
fi

if [ -z "$2" ]; then
  echo "Veuillez entrer le mot cible en troisième argument."
  exit
else
  Monmot=$3
fi

compte=1

echo '<html>'
cat ./templates/header_tableau_urls
cat ./templates/titre_tableau_urls
##DEBUT TABLEAU
cat ./templates/debut_tableau_urls
## | # | lien | Code http | Encodage | Dump Txt | Nombre de mots | Concordance |

while read -r line; do
  data=$(curl -s -i -L -w "%{http_code}\n%{content_type}" -o ./.data.tmp $line)
  codeHTTP=$(echo "$data" | head -1)
  Encodage=$(echo "$data" | tail -1 | cut -d "=" -f2)

  if [ -z "${Encodage}" ]; then
    Encodage="N/A" # petit raccourci qu'on peut utiliser à la place du if : encoding=${encoding:-"N/A"}
  fi

  CheminFichierTexte="../dumps-text/${Malangue}-${compte}.txt"
  ./text_dump.sh $line $CheminFichierTexte $Encodage

  nbMots=$(cat ${CheminFichierTexte} | wc -w)

  CheminFichierConcordance="../concordances/${Malangue}-${compte}-concordance.html"
  ./concordances.sh $CheminFichierTexte $Malangue 5 $Monmot >$CheminFichierConcordance

  echo "        <tr>
          <td>$compte</td>
          <td><a href="$line"> Lien page </a></td>
          <td>$codeHTTP</td>
          <td>$Encodage</td>
          <td><a href="${CheminFichierTexte}"> Lien dump </a></td>
          <td>$nbMots</td>
          <td><a href="${CheminFichierConcordance}"> Lien concordance </a></td>
        </tr>"

  ((compte++))
done <$FichierUrls

#FERMETURE BALISES
cat ./templates/fin_tableau_urls
#Bouton retour
cat ./templates/bouton_retour_tableau_urls
echo '</html>'
