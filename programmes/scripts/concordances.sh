#!/usr/bin/env bash

if ! [[ -e $1 ]]; then
  echo "Le premier argument doit être le chemin vers un fichier texte." >&2
  echo "Usage : $0 chemin_vers_le_fichier_texte taille_fenetre mot_cible" >&2
  exit
elif ! [[ "$2" =~ ^[0-9]+$ ]]; then
  echo "Le troisième argument doit être la taille de la fenêtre contextuelle." >&2
  echo "Usage : $0 chemin_vers_le_fichier_texte taille_fenetre mot_cible" >&2
  exit
elif ! [[ -n $3 ]]; then
  echo "Le quatrième argument doit être le mot cible." >&2
  echo "Usage : $0 chemin_vers_le_fichier_texte taille_fenetre mot_cible" >&2
  exit
fi

CheminFichierTexte=$1
TailleFenetre=$2
MotCible=$3

LignesOccurrences="$(egrep "${MotCible}" "${CheminFichierTexte}")"

while read -r line; do
  ContexteGauche="$(echo "${line}" | LC_CTYPE=C sed -E "s/(.*)(${MotCible})(.*)(${MotCible})?/\1/")"
  OccurrenceMotCible="$(echo "${line}" | LC_CTYPE=C sed -E "s/(.*)(${MotCible})(.*)(${MotCible})?/\2/")"
  ContexteDroit="$(echo "${line}" | LC_CTYPE=C sed -E "s/(.*)(${MotCible})(.*)(${MotCible})?/\3/")"
  printf "%s\t%s\t%s\n" "${ContexteGauche}" "${OccurrenceMotCible}" "${ContexteDroit}"
done <<<"${LignesOccurrences}" # trois chevrons pour lire le contenu de la variable et pas le contenu du fichier dont le chemin est stoqué dans la variable, ce langage est HORRIBLE
