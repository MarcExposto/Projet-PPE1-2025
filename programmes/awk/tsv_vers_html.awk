BEGIN {
    FS = "\t"
    OFS = ""
    if (indentation == "") {
      indentation = 0
      }
}

function cell(tag, s) {
    printf "<%s>%s</%s>", tag, s, tag
}

BEGIN {
  printf "%*s", indentation, ""
	printf "<table class='table is-bordered is-striped is-centered'>\n"
  printf "%*s", (indentation + 2), ""
  printf "<tbody>\n"
  }

{
  if (NR == 1) {
    tag = "th"
    }
  else {
    tag = "td"
    }

  printf "%*s", (indentation + 4), ""
  printf "<tr>\n"
  for (i = 1; i <= NF; i++) {
    printf "%*s", (indentation + 6), ""
    cell(tag, $i)
    printf ""
    printf "\n"
    }
  printf "%*s", (indentation + 4), ""
  printf "</tr>\n"
  }

END {
  printf "%*s", (indentation + 2), ""
  printf "</tbody>\n"
  printf "%*s", indentation, ""
	printf "</table>\n"
  }

