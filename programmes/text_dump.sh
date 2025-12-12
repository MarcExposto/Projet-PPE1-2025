#!/usr/bin/env bash

MonUrl=$1
TitrePropre=$2

# Vérifie que les deux arguments sont fournis
if [ -n "$MonUrl" ] && [ -n "$TitrePropre" ]; then
    # Extrait le texte brut de la page
    pageTexte=$(curl -s "$MonUrl" | lynx -dump -nolist -stdin -assume_charset=utf-8)
    echo "$pageTexte" > "$TitrePropre"
else
    echo "Veuillez spécifier l'URL et le titre"
    exit
fi
