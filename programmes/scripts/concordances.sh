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

printf "Contexte Gauche \t Mot Cible \t Contexte Droit\n"

LignesOccurrences=$(egrep ${MotCible})

while read -r line; do
  ContexteGauche=$(sed "s/\(\([^\s]+\){0,${TailleFenetre}}\)\(${MotCible}\)\(\([^\s]+\){0,${TailleFenetre}}\)/\1/")
  OccurrenceMotCible=$(sed "s/\(\([^\s]+\){0,${TailleFenetre}}\)\(${MotCible}\)\(\([^\s]+\){0,${TailleFenetre}}\)/\3/")
  ContexteDroit=$(sed "s/\(\([^\s]+\){0,${TailleFenetre}}\)\(${MotCible}\)\(\([^\s]+\){0,${TailleFenetre}}\)/\4/")
  printf "${ContexteGauche}\t${OccurrenceMotCible}\t${ContexteDroit}\n"
done <<<"${LignesOccurrences}" # trois chevrons pour lire le contenu de la variable et pas le contenu du fichier dont le chemin est stoqué dans la variable, ce langage est HORRIBLE
