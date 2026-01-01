#!/usr/bin/env bash

if ! [[ -e $1 ]]; then
  echo "Le premier argument doit être le chemin vers un fichier texte." >&2
  echo "Usage : $0 chemin_vers_le_fichier_texte code_langue taille_fenetre mot_cible" >&2
  exit
elif ! [[ "$2" =~ ^(en)|(fa)|(fr)$ ]]; then
  echo "Le deuxième argument doit être le code ISO-639-1 de la langue." >&2
  echo "Usage : $0 chemin_vers_le_fichier_texte code_langue taille_fenetre mot_cible" >&2
  exit
elif ! [[ "$3" =~ ^[0-9]+$ ]]; then
  echo "Le troisième argument doit être la taille de la fenêtre contextuelle." >&2
  echo "Usage : $0 chemin_vers_le_fichier_texte code_langue taille_fenetre mot_cible" >&2
  exit
elif ! [[ -n $4 ]]; then
  echo "Le quatrième argument doit être le mot cible." >&2
  echo "Usage : $0 chemin_vers_le_fichier_texte code_langue taille_fenetre mot_cible" >&2
  exit
fi

CheminFichierTokens=$1
Langue=$2
TailleFenetre=$3
MotCible=$4

printf "Contexte Gauche \t Mot Cible \t Contexte Droit\n"

Occurrences=$(egrep ${MotCible})

while read -r line; do
  ContexteGauche=$(sed "s/(([^\s]+){0,${TailleFenetre}})(${MotCible})(([^\s]+){0,${TailleFenetre}})/\1/")
  OccurrenceMotCible=$(sed "s/(([^\s]+){0,${TailleFenetre}})(${MotCible})(([^\s]+){0,${TailleFenetre}})/\3/")
  ContexteDroit=$(sed "s/(([^\s]+){0,${TailleFenetre}})(${MotCible})(([^\s]+){0,${TailleFenetre}})/\4/")
  printf "${ContexteGauche}\t${OccurrenceMotCible}\t${ContexteDroit}\n"
done <"${Occurrences}"
