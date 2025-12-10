#!/usr/bin/env bash
Monfichier=$1
Malangue=$2
Nbmot=$3
Monmot=$4

if [ -n "$Monfichier" ] && [ -n "$Monmot" ] && [ -n "$Malangue" ] && [ -n "$Nbmot" ];
then
    	echo '<html>'
	echo '<head>
    <meta charset="UTF-8" /> <meta name="viewport" content="width=device-width, initial-scale=1"> <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css"> <title>Tableau miniprojet</title> </head>'
	echo "<body>"
	echo '<section class="hero is-info mb-5"> <div class="hero-body"> <p class="title is-3">Resultats du mini projet sous forme tableau</p> </div> </section>'

	##DEBUT TABLEAU

	echo '<section class="container mb-5">'
	echo "<table class='table is-bordered is-striped is-centered'>
        <thead>
            <tr>
                <th> Contexte ${Nbmot} mots avant </th><th> Mot chercher </th><th>Contexte ${Nbmot} mots après</th>
            </tr>
        </thead>"
	echo '<tbody>'


    python ../script-py/concordancier.py "$Malangue" "$Monfichier" "$Nbmot" "$Monmot" |
    while IFS=$'\t' read -r -a cols;
        do
        echo "<tr>"
        for col in "${cols[@]}";
            do
                echo "    <td>$col</td>"
            done
        echo " </tr>"
        done

    #FERMETURE BALISES
	echo "</tbody>"
	echo "</table>"
	echo "</section>"
	echo "</body>"
	echo "</html>"
else
    echo "Veuillez relancer et bien specifier les 4 arguments"
    exit
fi
