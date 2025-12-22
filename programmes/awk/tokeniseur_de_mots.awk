BEGIN {
  separateur_mot="[ ,();:'\\-]+";
  RS=separateur_mot
  }
{
  print tolower($0)
  }
