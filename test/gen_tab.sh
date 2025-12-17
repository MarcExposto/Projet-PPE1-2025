#!/usr/bin/env bash

./gen_aspirations.sh "https://en.wikipedia.org/wiki/Lockdown"
http_code=$(./get_http_code.sh)
charset=$(./get_charset.sh)
