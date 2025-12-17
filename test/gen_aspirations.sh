#!/usr/bin/env bash

curl -si -L -w "%{http_code},%{content_type}" $1 -o tmp.html | tr "=" "," >data.tmp # Envoie la sortie dans data.tmp
# tr converti la sortie pour faciliter le parsing : la sortie a la forme http_code, xxx, charset
