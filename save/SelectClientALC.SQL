
--set colsep ,
Set feedback on
Set Linesize 200
Set Heading on
set headsep on
Set Pagesize 0
Set Trimspool on
Set Verify on
define repertoire ='\\10.16.106.51\e$' --  répertoire de destination des fichiers sauvegardés 
define fichier_control=\\10.16.106.51\e$\ClientALC.txt  -- définition du fichier de sortie
spool &fichier_control
SELECT acteur.actcode ||'§§',
acteur.actnom ||'§§',
acteur.actlibcourt ||'§§',
acteur.acttype ||'§§',
adresse.adrsubregion ||'§§',
adresse.adrvoie ||'§§',
adresse.adrville ||'§§',
actrole.rolcode || 'FINMEF'
from acteur ,actrole, adresse,actadresse
where actrole.ACTID=acteur.actid and adresse.adrid = actadresse.adrid 
and actadresse.actid = acteur.actid;


spool off 
exit