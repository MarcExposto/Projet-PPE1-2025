BEGIN {
  if (mot_cible == "") {
    print "Le mot cible doit être renseigné : -v mot_cible=<regex>" > "/dev/stderr"
    exit 1
    }
}

$0 == "" {
  print ""
  prev_token = ""
  next
}

$0 ~ mot_cible {
  print $0
  prev_token = ""
  next
}


{
  if (prev_token != "") {
  printf "%s %s\n", prev_token, $0
  prev_token = $0
  }
  else {
    prev_token = $0
  }
}

