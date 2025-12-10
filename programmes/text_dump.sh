#!/usr/bin/env bash
MonUrl=$1

if [ -n "$MonUrl" ] #verifie si il y a qqch dans l'argument avec -n #-ne pour dire si vide faire x
then
	compte=1
    while read -r line
    do
        # Extraire le titre de la page à partir des métadonnées HTML
        Titre=$(curl -s "$line" | grep -oP '(?<=<title>)(.*?)(?=</title>)' | head -1) # Extrait le titre de la page
        TitrePropre=$(echo "$Titre" | sed 's/[^a-zA-Z0-9]/_/g')  # Remplace les caractères spéciaux pour le nom du fichier

        # Extrait le texte de la page et l'écrit dans un fichier texte
        fichierTexte="${TitrePropre}.txt"
        pageTexte=$(curl -s "$line" | lynx -dump -nolist -stdin)  # Extrait le texte brut de la page
        echo -e "$pageTexte" > "$fichierTexte"  # Sauvegarde le contenu dans un fichier avec le nom de la page
        ((compte++))
    done < $MonUrl
else
	echo "Veuillez relancer et specifier l'argument URL"
            exit
fi
