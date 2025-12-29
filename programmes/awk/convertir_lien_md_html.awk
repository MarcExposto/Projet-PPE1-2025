BEGIN {
    FS = OFS = "\t"
}

{
    for (i = 1; i <= NF; i++) {
        while (match($i, /\[([^]]+)\]\(([^)]+)\)/, m)) {
            texte = m[1]
            lien  = m[2]
            replacement = "<a href=\"" lien "\">" texte "</a>"

            $i = substr($i, 1, RSTART - 1) \
                 replacement \
                 substr($i, RSTART + RLENGTH)
        }
    }
    print
}
