BEGIN {
  separateur_phrase="[.!?]";
  RS=separateur_phrase;
  ORS="\n\n"
  }
{
  print
  }
