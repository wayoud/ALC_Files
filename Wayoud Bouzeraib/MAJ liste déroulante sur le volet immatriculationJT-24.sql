**Description**

Mettre à jour une liste déroulante sur le volet immatriculation qui va permettre au back officeur de renseigner les informations reprises sur la recommandation a savoir statut des documents d’immatriculation (cartes grises) :

	-Dossier d’immatriculation non récupéré

	-Dossier d’immatriculation Déposé

	-Carte grise récupérée

	-Carte grise remise aux clients

	-Carte grise barrée

--------------------------------------------------- SQL -----------------------------------------------------------------------------------------------

Insert into tusparam (TUSNOM,TUPCODE,TUPFLAGORFI) values ('DOSSIERCG','DCG4','0');
Insert into lantusparam (TUSNOM,TUPCODE,LANCODE,TUPLIBELLE,TUPHELPTEXT) values ('DOSSIERCG','DCG4','FR','Dossier d’immatriculation Déposé',null);

Insert into tusparam (TUSNOM,TUPCODE,TUPFLAGORFI) values ('DOSSIERCG','DCG5','0');
Insert into lantusparam (TUSNOM,TUPCODE,LANCODE,TUPLIBELLE,TUPHELPTEXT) values ('DOSSIERCG','DCG5','FR','Carte grise récupérée',null);

Insert into tusparam (TUSNOM,TUPCODE,TUPFLAGORFI) values ('DOSSIERCG','DCG6','0');
Insert into lantusparam (TUSNOM,TUPCODE,LANCODE,TUPLIBELLE,TUPHELPTEXT) values ('DOSSIERCG','DCG6','FR','Carte grise remise aux clients',null);

Insert into tusparam (TUSNOM,TUPCODE,TUPFLAGORFI) values ('DOSSIERCG','DCG7','0');
Insert into lantusparam (TUSNOM,TUPCODE,LANCODE,TUPLIBELLE,TUPHELPTEXT) values ('DOSSIERCG','DCG7','FR','Carte grise barrée',null);

------------------------------------------------------------------------------------------------------------------------------------------------------------------

