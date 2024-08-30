
--set colsep ,
Set feedback on
Set Linesize 200
Set Heading on
set headsep on
Set Pagesize 0
Set Trimspool on
Set Verify on
define repertoire ='\\10.16.106.51\e$' --  répertoire de destination des fichiers sauvegardés 
define fichier_control=\\10.16.106.51\e$\MEF.txt  -- définition du fichier de sortie
spool &fichier_control
select "Code du contrat" ||'§§',
"Code du client" ||'§§',
"Nom du client" ||'§§',
"Secteur activite du client" ||'§§',
"Nom Fournisseur"||'§§',
"Agence" ||'§§',
"Montant du materiel" ||'§§',
"Chargé daffaires" ||'§§',
"Phase Jalon du contrat" ||'§§',
"Date de debut du contrat" ||'§§',
"Date de fin du contrat" ||'§§',
"Date de Mise en force" ||'§§',
"Produit" ||'§§',
"Region" ||'§§',
"date approbation" ||'§§',
"Source affaire" || 'FINMEF' 
from DASGBOARDMEF_PAR_MATERIEL ;

spool off 
exit