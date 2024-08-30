
--set colsep ,
Set feedback on
Set Linesize 200
Set Heading on
set headsep on
Set Pagesize 0
Set Trimspool on
Set Verify on
define repertoire ='\\10.16.106.51\e$' --  répertoire de destination des fichiers sauvegardés 
define fichier_control=\\10.16.106.51\e$\ENG.txt  -- définition du fichier de sortie
spool &fichier_control
select "DOSID" ||'§§',
"Code demande" ||'§§',
"Date tirage" ||'§§',
"Code du materiel" ||'§§',
"Code du client" ||'§§',
"Nom client" ||'§§',
"Code contrat" ||'§§',
"Secteur d'activite" ||'§§',
"Montant materiel" ||'§§',
"Agence" ||'§§',
"Code Agence" ||'§§',
"Phase du contrat" ||'§§',
"Date debut du contrat" ||'§§',
"Date fin du contrat" ||'§§',
"Phase du materiel" ||'§§',
"Reference approbation" ||'§§',
"Date creation approbation" ||'§§',
"Date accord" ||'§§',
"Region" ||'§§',
"Produit" ||'§§',
"Date mise en service" ||'§§',
"Commercial" ||'§§',
"Origine du bien" ||'§§',
"Date_Transfert"	 || 'FINMEF'
from R21_ETAT_DES_TIRAGES ;

spool off 
exit