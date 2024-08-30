
--set colsep ,
Set feedback on
Set Linesize 200
Set Heading on
set headsep on
Set Pagesize 0
Set Trimspool on
Set Verify on
define repertoire ='\\10.16.106.51\e$' --  répertoire de destination des fichiers sauvegardés 
define fichier_control=\\10.16.106.51\e$\APP.txt  -- définition du fichier de sortie
spool &fichier_control
SELECT "Numero PV" ||'§§',
"Produit" ||'§§',
"Phase du contrat" ||'§§',
"Date création de offre" ||'§§',
"Code agence" ||'§§',
"Comite" ||'§§',
"Code cllient" ||'§§',
"Commercial" ||'§§',
"Juriste" ||'§§',
"Analyste" ||'§§',
"decision finale" ||'§§',
"Taux 1er loyer majore" ||'§§',
"Taux interet" ||'§§',
"Duree" ||'§§',
"Conditions suspensives-obs" ||'§§',
"Observation" ||'§§',
"Materiel" ||'§§',
"Quantite" ||'§§',
"Montant unitaire" ||'§§',
"Fournisseur" ||'§§',
"Nom client" ||'§§',
"Date création du client" ||'§§',
"Commercial résident" ||'§§',
"Chargé affaires" ||'§§',
"Agence" ||'§§',
"Montant offre" ||'§§',
"Source affaire" ||'§§',
"Statut dossier" ||'§§',
"Sort offre" ||'§§',
"Date de decision" ||'§§',
"Motif rejet / archivage" ||'§§',
"Wilaya" ||'§§',
"Montant demandé" ||'§§',
"Montant accordé" ||'§§',
"Type Produit" ||'§§',
"Secteur Activite" ||'§§',
"Montant restant" ||'§§',
"Commentaire Dern Conlusion"	 || 'FINMEF' FROM R30_RAPPORT_PV_DECISION ;

spool off 
exit