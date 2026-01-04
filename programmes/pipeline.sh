#!/bin/bash

# Vérification des arguments
if [ -z "$1" ]; then
  echo "Veuillez entrer le chemin vers le fichier d'URLs en premier argument. (script ${0})" >&2
  exit
else
  FichierUrls=$1
fi

if ! [[ "$2" =~ ^(en|fa|fr)$ ]]; then
  echo "Le deuxième argument doit être le code ISO-639-1 de la langue. (script ${0})" >&2
  exit
else
  Langue=$2
fi

if [ -z "$3" ]; then
  echo "Veuillez entrer le mot cible en troisième argument. (script $0)" >&2
  exit
else
  MotCible=$3
fi

# Calcul du chemin du script et de la racine
CheminScript="$(cd "$(dirname "$0")" && pwd)"
CheminRacineProjet="$(cd "${CheminScript}/.." && pwd)"

# Création de l'arborescence si elle n'existe pas
mkdir -p \
  "${CheminRacineProjet}/aspirations/${Langue}" \
  "${CheminRacineProjet}/dumps-text/${Langue}" \
  "${CheminRacineProjet}/dumps-tokenises/${Langue}" \
  "${CheminRacineProjet}/bigrammes/${Langue}" \
  "${CheminRacineProjet}/contextes/${Langue}" \
  "${CheminRacineProjet}/concordances/${Langue}" \
  "${CheminRacineProjet}/coocurrents" \
  "${CheminRacineProjet}/images"

# Définition de fonctions à partir des scripts pour plus de lisibilité du code
bigrammes() {
  "${CheminRacineProjet}/programmes/scripts/bigrammes.sh" "$@"
}
concordances() {
  "${CheminRacineProjet}/programmes/scripts/concordances.sh" "$@"
}
convert_utf-8() {
  "${CheminRacineProjet}/programmes/scripts/convert_utf-8.sh" "$@"
}
coocurrents() {
  "${CheminRacineProjet}/programmes/scripts/coocurrents.sh" "$@"
}
robots() {
  "${CheminRacineProjet}/programmes/scripts/robots.sh" "$@"
}
text_dump() {
  "${CheminRacineProjet}/programmes/scripts/text_dump.sh" "$@"
}
tokenizer() {
  "${CheminRacineProjet}/programmes/scripts/tokenizer.sh" "$@"
}

# Taille de la fenêtre contextuelle pour le concordancier
TailleFenetre=5

# Génération du tableau (tsv)
id=1

# Entête du tableau
printf " id \t url \t gestion de robots.txt \t code http \t encodage initial de la page \t lien vers la page brute \t lien vers le dump textuel \t nombre total de mots dans le dump \t nombre d'occurrences du mot cible dans le dump \t lien vers le concordancier\n"

while read -r line; do

  Url=$line

  Robots=$(robots $Url)
  if [[ $Robots = 'Disallow' ]]; then
    printf "${id}\t${Url}\t${Robots}\t\t\t\t\t\t\t\n"
    ((id++))
    continue
  fi

  CheminFichierAspiration="${CheminRacineProjet}/aspirations/${Langue}/${Langue}-${id}.html"
  data=$(curl -s -L -w "%{http_code}\n%{content_type}" -o ${CheminFichierAspiration} ${Url})

  CodeHTTP=$(echo "${data}" | head -1)
  if [[ ! "${CodeHTTP}" =~ (2|3).. ]]; then
    printf "${id}\t${Url}\t${Robots}\t${CodeHTTP}\t\t\t\t\t\t\n"
    ((id++))
    continue
  fi

  Encodage=$(echo "$data" | grep charset | cut -d "=" -f2)

  ErreurConversion=$(convert_utf-8 "${CheminFichierAspiration}" "${Encodage}" 2>&1)
  if [[ -n "$ErreurConversion" ]]; then
    printf "${id}\t${Url}\t${Robots}\t${CodeHTTP}\t${Encodage}\t\t\t\t\t\n"
    ((id++))
    continue
  fi

  CheminFichierTexte="${CheminRacineProjet}/dumps-text/${Langue}/${Langue}-${id}.txt"
  text_dump "${CheminFichierAspiration}" "${CheminFichierTexte}"

  convert_utf-8 "${CheminFichierTexte}" ISO-8859-1

  NbMots=$(cat "${CheminFichierTexte}" | wc -w)
  if [[ -z "${NbMots}" ]]; then
    echo "probleme comptage nombre de mots" >&2
    NbMots=0
  fi
  NbOccurrences=$(egrep -o "${MotCible}" "${CheminFichierTexte}" | wc -w)
  if [[ -z "${NbOccurrences}" ]]; then
    echo "probleme comptage nombre d'occurrences" >&2
    NbOccurrences=0
  fi

  CheminFichierTokens="${CheminRacineProjet}/dumps-tokenises/${Langue}/${Langue}-${id}.conll"
  tokenizer "${CheminFichierTexte}" "${CheminFichierTokens}"

  CheminFichierBigrammes="${CheminRacineProjet}/bigrammes/${Langue}/${Langue}-${id}.conll"
  bigrammes "${CheminFichierTexte}" "${CheminFichierBigrammes}" "${MotCible}"

  CheminFichierContextes="${CheminRacineProjet}/contextes/${Langue}/${Langue}-${id}-contextes.txt"
  egrep -C 4 -i "${MotCible}" "${CheminFichierTexte}" >"${CheminFichierContextes}"

  CheminFichierConcordances="${CheminRacineProjet}/concordances/${Langue}/${Langue}-${id}-concordances.tsv"
  concordances "${CheminFichierTexte}" "${TailleFenetre}" "${MotCible}" >"${CheminFichierConcordances}"

  printf "${id}\t<a href=${Url}>${Url}</a>\t${Robots}\t${CodeHTTP}\t${Encodage}\t<a href=${CheminFichierAspiration}>Lien page brute</a>\t<a href=${CheminFichierTexte}>Lien dump</a>\t${NbMots}\t${NbOccurrences}\t<a href=${CheminFichierConcordances}>Lien Concordancier</a>\n"

  echo "${Langue}: ${id} terminé" >&2
  ((id++))
done <"${FichierUrls}"

# Génération du tableau des coocurrents
CheminFichierCoocurrents="${CheminRacineProjet}/coocurrents/${Langue}.tsv"
coocurrents "${CheminRacineProjet}/dumps-tokenises/${Langue}" "${MotCible}" "${CheminFichierCoocurrents}"

# Génération du tableau des bigrammes coocurrents
CheminFichierBigrammesCoocurrents="${CheminRacineProjet}/coocurrents/${Langue}_bigrammes.tsv"
coocurrents "${CheminRacineProjet}/bigrammes/${Langue}" "${MotCible}" "${CheminFichierBigrammesCoocurrents}"

# Génération du nuage de mots
CheminNuageMots="${CheminRacineProjet}/images/${Langue}.png"
