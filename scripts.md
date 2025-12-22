Pour prétraiter le texte en entrée compatible avec les scripts PALS, plusieurs options :
  * `tr` : implique de passer de nombreuses commandes à travers des pipelines, peu pratique + ne gère pas correctement l'UTF-8, ce qui a causé des problèmes d'encodage.
  * `sed` : l'entrée contenant plusieurs lignes et un retour à la ligne pouvant être placé en milieu de phrase, `sed` (qui applique des modifications ligne par ligne), n'est pas très adapté.
  * `awk` : permet de faire des traitements plus complexes, choisi pour une première version du tokenizer.
