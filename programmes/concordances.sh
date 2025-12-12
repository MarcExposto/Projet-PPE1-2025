#!/usr/bin/env bash

if ! [[ -e $1 ]]; then
  echo "Le premier argument doit être le chemin vers un fichier texte."
  echo "Usage : $0 chemin_vers_le_fichier_texte code_langue taille_fenetre mot_cible"
  exit
elif ! [[ "$2" =~ ^(en)|(fa)|(fr)$ ]]; then
  echo "Le deuxième argument doit être le code ISO-639-1 de la langue."
  echo "Usage : $0 chemin_vers_le_fichier_texte code_langue taille_fenetre mot_cible"
  exit
elif ! [[ "$3" =~ ^[0-9]+$ ]]; then
  echo "Le troisième argument doit être la taille de la fenêtre contextuelle."
  echo "Usage : $0 chemin_vers_le_fichier_texte code_langue taille_fenetre mot_cible"
  exit
elif ! [[ -n $4 ]]; then
  echo "Le quatrième argument doit être le mot cible."
  echo "Usage : $0 chemin_vers_le_fichier_texte code_langue taille_fenetre mot_cible"
  exit
fi

Monfichier=$1
Malangue=$2
Nbmot=$3
Monmot=$4

echo '''
<html>
<head>
  <meta charset="UTF-8" /> <meta name="viewport" content="width=device-width, initial-scale=1"> <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css"> <title>Tableau miniprojet</title> </head>
<body>
  <section class="hero is-info mb-5"> <div class="hero-body"> <p class="title is-3">Resultats du mini projet sous forme tableau</p> </div> </section>'''

##DEBUT TABLEAU DES CONCORDANCES

echo """  <section class='container mb-5'>
    <table class='table is-bordered is-striped is-centered'>
      <thead>
        <tr>
          <th> Contexte ${Nbmot} mots avant </th><th> Mot chercher </th><th>Contexte ${Nbmot} mots après</th>
        </tr>
      </thead>
      <tbody>"""

python3 python/concordancier.py "$Malangue" "$Monfichier" "$Nbmot" "$Monmot" |
  while IFS=$'\t' read -r -a cols; do
    echo "<tr>"
    for col in "${cols[@]}"; do
      echo "    <td>$col</td>" # est-ce qu'on pourrait faire un truc du style "<td>${cols[0]}</td> <td><b>${cols[1]}</b></td> <td>${cols[2]}</td>" pour mettre le mot cible en valeur ?
    done
    echo " </tr>"
  done

#FERMETURE BALISES

echo '''      </tbody>
    </table>
  </section>
</body>
</html>
'''
