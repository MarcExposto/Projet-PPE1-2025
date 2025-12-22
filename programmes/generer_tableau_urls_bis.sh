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

compte=1

echo '<html>'
cat ./templates/header_tableau_urls
echo '<body>'
cat ./templates/titre_tableau_urls
##DEBUT TABLEAU
cat ./templates/debut_tableau_urls
## Entête du tableau : | # | lien | Code http | Encodage | Aspiration | Dump texte | Nombre de mots | Concordance |

while read -r line; do

  CheminFichierAspiration="../aspirations/${Langue}/${Langue}-${compte}.html"
  data=$(curl -s -i -L -w "%{http_code}\n%{content_type}" -o ${CheminFichierAspiration} ${line})
  codeHTTP=$(echo "$data" | head -1)
  Encodage=$(echo "$data" | tail -1 | cut -d "=" -f2)

  if [ -z "${Encodage}" ]; then
    Encodage="N/A" # petit raccourci qu'on peut utiliser à la place du if : encoding=${encoding:-"N/A"}
  fi

  CheminFichierTexte="../dumps-text/${Langue}/${Langue}-${compte}.txt"
  ./text_dump.sh $CheminFichierAspiration $CheminFichierTexte $Encodage

  nbMots=$(cat ${CheminFichierTexte} | wc -w)

  CheminFichierTokens="../dumps-tokenises/${Langue}/${Langue}-${compte}.conll"
  ./tokenizer.sh $CheminFichierTexte >$CheminFichierTokens

  #CheminFichierConcordance="../concordances/${Langue}/${Langue}-${compte}-concordance.html"
  #./concordances.sh $CheminFichierTexte $Langue 5 $Monmot >$CheminFichierConcordance

  echo "        <tr>
          <td>$compte</td>
          <td><a href="$line"> Lien page </a></td>
          <td>$codeHTTP</td>
          <td>$Encodage</td>
          <td><a href="${CheminFichierAspiration}"> Lien aspiration </a></td>
          <td><a href="${CheminFichierTexte}"> Lien dump </a></td>
          <td>$nbMots</td>
        </tr>"
  #<td><a href="${CheminFichierConcordance}"> Lien concordance </a></td>

  ((compte++))
done <$FichierUrls

# Génération du tableau des coocurents
CheminFichierCoocurents="../coocurents/${Langue}.tsv"
./coocurences.sh ../dumps-tokenisés/${Langue} $Monmot >$CheminFichierCoocurents

#FERMETURE BALISES
cat ./templates/fin_tableau_urls
#Bouton retour
cat ./templates/bouton_retour_tableau_urls
echo '</body>'
echo '</html>'
