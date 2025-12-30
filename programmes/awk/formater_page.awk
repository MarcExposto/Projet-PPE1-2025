BEGIN {
  FS = OFS = ""
  while ((getline line < "/dev/stdin") > 0)
    tableau = tableau line "\n"
}
  {
  gsub(/___TITRE___/, titre)
  gsub(/___TABLEAU___/, tableau)
  print
}
