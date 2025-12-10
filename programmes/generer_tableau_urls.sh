MonUrl=$1

if [ -n "$MonUrl" ] #verifie si il y a qqch dans l'argument avec -n #-ne pour dire si vide faire x
then
	compte=1

	echo '<html>'
	echo '<head>
    <meta charset="UTF-8" /> <meta name="viewport" content="width=device-width, initial-scale=1"> <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css"> <title>Tableau miniprojet</title> </head>'
	echo "<body>"
	echo '<section class="hero is-info mb-5"> <div class="hero-body"> <p class="title is-3">Resultats du mini projet sous forme tableau</p> </div> </section>'

	##DEBUT TABLEAU

	echo '<section class="container mb-5">'
	echo '<table class="table is-bordered is-striped is-centered">
        <thead>
            <tr>
                <th> # </th><th> lien </th><th> Code http </th><th> Encodage </th><th> Nombre de mots </th>
            </tr>
        </thead>'
	echo '<tbody>'

	while read -r line
do
	data=$(curl -s -i -L -w "%{http_code}\n%{content_type}" -o ./.data.tmp $line)
	codeHTTP=$(echo "$data" | head -1)
	ligneEncodage=$(echo "$data" | tail -1 | grep -Po "charset=\S+" | cut -d"=" -f2)

	if [ -z "${ligneEncodage}" ]
	then
		ligneEncodage="N/A" # petit raccourci qu'on peut utiliser à la place du if : encoding=${encoding:-"N/A"}
	fi

	nbMots=$(cat ./.data.tmp | lynx -dump -nolist -stdin | wc -w)
	echo -e "			<tr>
				<td>$compte</td>
				<td>$line</td>
				<td>$codeHTTP</td>
				<td>$ligneEncodage</td>
				<td>$nbMots</td>
			</tr>"


	((compte++))
done < $MonUrl

	#FERMETURE BALISES
	echo "</tbody>"
	echo "</table>"
	echo "</section>"

	#Bouton retour
	echo '<div class="container mb-5">
        <a href="../../index.html">
        <button class="button is-small is-info is-outlined is-focused"> Retour </button>
        </a>
        </div>'
	echo "</body>"
	echo "</html>"
else
	echo "Veuillez relancer et specifier l'argument"
            exit
fi

