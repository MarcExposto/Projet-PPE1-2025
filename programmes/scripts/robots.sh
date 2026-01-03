#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  echo "Veuillez entrer l'url en premier argument. (script ${0})" >&2
  exit
else
  url=$1
fi

FichierRobots=$(echo $url | sed -E 's/(https?:\/\/[^/]+\/)(.*)/\1robots.txt/g')
IsCurlAllow=$(curl -s $FichierRobots | grep "User-agent: curl")

if [[ -z "${IsCurlAllow}" ]]; then
  echo "Allow"
else
  echo "Disallow"
fi
