
--set colsep ,
Set feedback on
Set Linesize 200
Set Heading on
set headsep on
Set Pagesize 0
Set Trimspool on
Set Verify on
define repertoire ='\\10.16.106.51\e$' --  répertoire de destination des fichiers sauvegardés 
define fichier_control=\\10.16.106.51\e$\IMPAYE.txt  -- définition du fichier de sortie
spool &fichier_control

SELECT "Code contrat" ||'§§',
  "Code client" ||'§§',
  "Nom client" ||'§§',
  "Numéro facture" ||'§§',
  "Age impaye du client" ||'§§',
  "Montant initial TTC facture" ||'§§',
  "Montant initial HT facture" ||'§§',
  "Taux TVA de la facture" ||'§§',
  "Numéro loyer" ||'§§',
  "Montant initial TVA facture" ||'§§',
  "Montant du principal facture" ||'§§',
  "Montant de interet facture" ||'§§',
  "Montant service HT facture" ||'§§',
  "SOLDE_RESTANT" ||'§§',
  "CRD du contrat" ||'§§',
  "DATE_EXIGIBILITE" ||'§§',
  "Date de saisie facture" ||'§§',
  "Date comptable de la facture" ||'§§',
  "Secteur activite du client" ||'§§',
  "Produit du contrat" ||'§§',
  "Agence du client" ||'§§',
  "Phase du contrat" ||'§§',
  "Portefeuille" ||'§§',
  "Type de facture" ||'§§',
  "Wilaya" ||'§§',
  "Region" || 'FINMEF'
FROM "DachBoard_IMPAYES_CLIENT";

spool off 
exit