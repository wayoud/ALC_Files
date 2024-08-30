@echo off
SET MyTime=%time%
set wdate=%DATE% 
set dtexp=%wdate:~6,4%%wdate:~3,2%%wdate:~0,2%
SETLOCAL


set AUTOJOB=%1
IF "%AUTOJOB%"=="" ( GOTO EXPLAIN
)ELSE (GOTO AUTOJOB
)

:EXPLAIN
echo USAGE : DATAPUMP_KSIOP_V1
echo To Export Database Make 1 
echo To Import Database Make 2
set /p CHOICE=[1-EXPORT ^| 2-IMPORT ^| 3-QUIT]  :
IF %CHOICE%==1 GOTO EXPORT
IF %CHOICE%==2 GOTO IMPORT
IF %CHOICE%==3 GOTO FIN
echo " Mauvais Choix !! ""
TIMEOUT 5
REM CLS
GOTO EXPLAIN


:EXPORT
echo USAGE : You are invited to enter the information :
SET /P SID=[The Database From Which you will Export Schemas -Must Not Be Empty-]:
IF "%SID%"=="" (
	echo ERROR !! : Required Parameter -Database Must not be Empty- 
	TIMEOUT 5
	CLS
	GOTO EXPORT 
) Else (GOTO SCHEMAS
	)
EXIT /B

:SCHEMAS
SET /P BOSCHEMA=[Back Schema -Will not be Exported if left Empty-]:
SET /P FOSCHEMA=[Front Schema -Will not be Exported if left Empty-]:
IF "%BOSCHEMA%"=="" (
	IF "%FOSCHEMA%"=="" (
		echo ERROR !! : At Least one schema is required 
		TIMEOUT 5
		CLS
		GOTO SCHEMAS)
) ELSE ( 
	SET /P PROJECT=[Project Name -Will be set "PROJECT" if left Empty-]:
	IF "%PROJECT%"=="" SET PROJECT=PROJECT
	GOTO START_EXPORT
)
EXIT /B

:START_EXPORT
echo You will Export %BOSCHEMA% %FOSCHEMA% From the Database %SID% ?
SET /P CONFIRM=[Y- Confirm ^| N- Cancel ^| C- Correct Information] :
IF "%CONFIRM%"=="N" GOTO FIN
IF "%CONFIRM%"=="C" CLS & GOTO EXPORT
IF "%CONFIRM%"=="Y" (
	echo expdp userid=system/manager@%SID% dumpfile=%dtexp%_%SID%_%PROJECT%.DMP LOGFILE=%dtexp%_%SID%_%PROJECT%.log DIRECTORY=DATAPUMP_DIR COMPRESSION=ALL SCHEMAS=%BOSCHEMA%,%FOSCHEMA%
) ELSE (
	echo " Mauvais Choix !! "
	TIMEOUT 5
	CLS
	GOTO START_EXPORT
	)
echo Export Has been Done
EXIT /B
GOTO FIN

:IMPORT
@echo off
del /f /s /q D:\Cassiopae\Tools\DATAPUMP\*.log
echo USAGE : You are invited to enter the information :
SET /P SID=[The Target Database On Which you will Import Schemas -Must Not Be Empty-]:
IF "%SID%"=="" (
	echo ERROR !! : Required Parameter -Database Must not be Empty- 
	TIMEOUT 5
	CLS
	GOTO IMPORT 
) 
SET /P EXECUTE=[B- Back Schema ^| F- Front Schema ^| A- Both Schemas -Default is Both] :
IF "%EXECUTE%"=="B" ( 
	call :BACK_VAR 
	call :BACK
	call :CORRECTION
)  
IF "%EXECUTE%"=="F" ( 
	call :FRONT_VAR 
	call :FRONT
	call :CORRECTION
) 
IF "%EXECUTE%"=="A" (
	call :BACK_VAR
	call :FRONT_VAR
	call :BACK
	call :FRONT
	call :CORRECTION
) ELSE  ( 
	echo " Mauvais Choix !! "
	TIMEOUT 5
	CLS
	GOTO IMPORT
)

echo DATAPUMP IMPORT Has Been Done
GOTO FIN
EXIT /B

:BACK_VAR
echo TEMP BACK_VAR
echo USAGE : You are invited to enter Back informations :
SET /P BOTARGET=[TARGET Back Schema -Must not be left Empty-]:
IF "%BOTARGET%"=="" (
	echo ERROR !! : Required Parameter -Back Target Must not be Empty- 
	TIMEOUT 5
	CLS
	GOTO BACK_VAR 
	)
SET /P BOSOURCE=[SOURCE Back Schema -Must not be left Empty-]:
IF "%BOSOURCE%"=="" (
	echo ERROR !! : Required Parameter -Back Source Must not be Empty- 
	TIMEOUT 5
	CLS
	GOTO BACK_VAR 
	)
SET /P BODUMP=[DUMP File For Back Schema ]:
IF "%BODUMP%"=="" (
	echo ERROR !! : Required Parameter -Back DUMP Must not be Empty- 
	TIMEOUT 5
	CLS
	GOTO BACK_VAR 
	)
EXIT /B
	
	
:FRONT_VAR
echo TEMP FRONT_VAR
echo USAGE : You are invited to enter Back informations :
SET /P FOTARGET=[TARGET Front Schema -Must not be left Empty-]:
IF "%FOTARGET%"=="" (
	echo ERROR !! : Required Parameter -Front Target Must not be Empty- 
	TIMEOUT 5
	CLS
	GOTO BACK_VAR 
	)
SET /P FOSOURCE=[SOURCE Front Schema -Must not be left Empty-]:
IF "%FOSOURCE%"=="" (
	echo ERROR !! : Required Parameter -Front Source Must not be Empty- 
	TIMEOUT 5
	CLS
	GOTO BACK_VAR 
	)
SET /P FODUMP=[DUMP File For Front Schema ]:
IF "%FODUMP%"=="" (
	echo ERROR !! : Required Parameter -Front DUMP Must not be Empty- 
	TIMEOUT 5
	CLS
	GOTO BACK_VAR 
	)
EXIT /B



:FRONT
@echo on
IF "%BOTARGET%"=="" SET BOTARGET=TR%FOTARGET:~2,10%
echo  Import %FOSOURCE% ^-^> %FOTARGET% From %FODUMP% File On the %SID% Database
TIMEOUT 5
SQLPLUS "sys/system@%SID% as sysdba" @KILL_SESS.SQL %FOTARGET% > %SID%_%FOTARGET%_KILL_SESSION.log
SQLPLUS %FOTARGET%/prospect@%SID% @drop.sql > %SID%_%FOTARGET%_drop.log
SQLPLUS "sys/system@%SID% as sysdba" @DROITS_ANDRO.SQL %FOTARGET% %BOTARGET% > %SID%_%FOTARGET%_DROITS.log
impdp USERid=system/manager@%SID% dumpfile=%FODUMP% directory=DATAPUMP_DIR LOGFILE=%SID%_%FOTARGET%_import.log SCHEMAS=%FOSOURCE% REMAP_SCHEMA=%FOSOURCE%:%FOTARGET%,%FOSOURCE%_SEL:%FOTARGET%_SEL,%FOSOURCE%_MOD:%FOTARGET%_MOD  EXCLUDE=STATISTICS table_exists_action=replace REMAP_TABLESPACE=TBS_%FOSOURCE%:TBS_%FOTARGET%,TBS_ANDDEFAULT:TBS_%FOTARGET%,TBS_ANDTRV_DATA:TBS_%FOTARGET%,TBS_ANDVID_DATA:TBS_%FOTARGET%,TBS_ANDPAR_DATA:TBS_%FOTARGET%,TBS_ANDIMP_DATA:TBS_%FOTARGET%,TBS_ANDTRV_INDEX:TBS_%FOTARGET%,TBS_ANDVID_INDEX:TBS_%FOTARGET%,TBS_ANDPAR_INDEX:TBS_%FOTARGET%,TBS_ANDIMP_INDEX:TBS_%FOTARGET%
SQLPLUS %FOTARGET%/prospect@%SID% @FO-TYPES.SQL >%SID%_%FOTARGET%_Types.log
SQLPLUS %FOTARGET%/prospect@%SID% @CHANGESYNONYMES.SQL %BOSOURCE% %BOTARGET% >%SID%_%FOTARGET%_ChangeSynonymes.log
SQLPLUS %FOTARGET%/prospect@%SID% @PARSYSTEME.SQL %FOTARGET% %FOTARGET%_SEL %FOTARGET%_MOD %BOTARGET% >%SID%_%FOTARGET%_PARSYSTEME.log
SQLPLUS %FOTARGET%/prospect@%SID% @VIEWS.SQL >%SID%_%FOTARGET%_VIEWS.log
sqlplus %FOTARGET%/prospect@%SID% @COMPILE.SQL > %SID%_%FOTARGET%_compile.log
sqlplus %FOTARGET%/prospect@%SID% @STATISTIQUE.SQL > %SID%_%FOTARGET%_statistique.log
sqlplus %FOTARGET%/prospect@%SID% @GRANTSANDRO.SQL > %SID%_%FOTARGET%_grant.log
EXIT /B

:BACK
@echo on
IF "%FOTARGET%"=="" SET FOTARGET=AV%BOTARGET:~2,10%
echo  Import %BOSOURCE% ^-^> %BOTARGET% From %BODUMP% File On the %SID% Database
TIMEOUT 5
SQLPLUS "sys/system@%SID% as sysdba" @KILL_SESS.SQL %BOTARGET% > %SID%_%BOTARGET%_KILL_SESSION.log
SQLPLUS %BOTARGET%/TRES5PRG@%SID% @DROP.SQL > %SID%_%BOTARGET%_DROP.log
SQLPLUS "sys/system@%SID% as sysdba" @DROITS_KSIOP.SQL %BOTARGET% > %SID%_%BOTARGET%_DROITS.log
impdp USERid=system/manager@%SID% dumpfile=%BODUMP% directory=DATAPUMP_DIR LOGFILE=%SID%_%BOTARGET%_import.log SCHEMAS=%BOSOURCE% REMAP_SCHEMA=%BOSOURCE%:%BOTARGET%,%BOSOURCE%_USER:%BOTARGET%_USER,%BOSOURCE%_VIEWER:%BOTARGET%_VIEWER EXCLUDE=GRANT EXCLUDE=STATISTICS table_exists_action=replace REMAP_TABLESPACE=TBS_%BOSOURCE%:TBS_%BOTARGET%,TBS_CASTEMPORARY:TBS_%BOTARGET%,PRD_CASDEFAULT_INDEX:TBS_%BOTARGET%,LPTESTDB_INDEX:TBS_%BOTARGET%,PRD_CASDEFAULT:TBS_%BOTARGET%,LPPRODDB_DATA:TBS_%BOTARGET%,LPPRODDB_INDEX:TBS_%BOTARGET%,CASIOPE:TBS_%BOTARGET%, TBS_ANDIMP_DATA:TBS_%BOTARGET%,TBS_ANDIMP_INDEX:TBS_%BOTARGET%,TBS_ANDPAR_DATA:TBS_%BOTARGET%,TBS_ANDTRV_INDEX:TBS_%BOTARGET%,TBS_ANDTRV_DATA:TBS_%BOTARGET%,TBS_ANDPAR_INDEX:TBS_%BOTARGET%,TBS_ANDVID_DATA:TBS_%BOTARGET%,TBS_ANDDEFAULT:TBS_%BOTARGET%,TBS_CASTMP_INDEX:TBS_%BOTARGET%,TBS_CASTRV_DATA:TBS_%BOTARGET%,TBS_CASTRV_INDEX:TBS_%BOTARGET%,TBS_CASDEFAULT:TBS_%BOTARGET%
SQLPLUS %BOTARGET%/TRES5PRG@%SID% @BO-TYPES.SQL >%SID%_%BOTARGET%_Types.log
SQLPLUS %BOTARGET%/TRES5PRG@%SID% @CHANGESYNONYMES.SQL %FOSOURCE% %FOTARGET% >%SID%_%BOTARGET%_ChangeSynonymes.log
SQLPLUS %BOTARGET%/TRES5PRG@%SID% @PARSYSTEME.SQL %BOTARGET% %BOTARGET%_VIEWER %BOTARGET%_USER %FOTARGET% >%SID%_%BOTARGET%_PARSYSTEME.log
sqlplus %BOTARGET%/TRES5PRG@%SID% @COMPILE.SQL > %SID%_%BOTARGET%_compile.log
sqlplus %BOTARGET%/TRES5PRG@%SID% @STATISTIQUE.SQL > %SID%_%BOTARGET%_statistique.log
sqlplus %BOTARGET%/TRES5PRG@%SID% @GRANTSKSIOP.SQL > %SID%_%BOTARGET%_grant.log
EXIT /B

:CORRECTION
@echo on
echo Correction
echo %FOTARGET%
echo %BOTARGET%
sqlplus %FOTARGET%/prospect@%SID% @COMPILE_ADVANCED.SQL > %SID%_%FOTARGET%_compile_ADVANCED.log
sqlplus %BOTARGET%/TRES5PRG@%SID% @COMPILE_ADVANCED.SQL > %SID%_%BOTARGET%_compile_ADVANCED.log
sqlplus %BOTARGET%/TRES5PRG@%SID% @CHECKSEQUENCE.SQL > %SID%_%BOTARGET%_CHECKSEQUENCE.log
sqlplus %FOTARGET%/prospect@%SID% @CHECKSEQUENCE.SQL > %SID%_%FOTARGET%_CHECKSEQUENCE.log
SQLPLUS "sys/system@%SID% as sysdba" @BUILD_INDEX.SQL %BOTARGET% > %SID%_%BOTARGET%_BUILD_INDEX.log
SQLPLUS "sys/system@%SID% as sysdba" @BUILD_INDEX.SQL %FOTARGET% > %SID%_%FOTARGET%_BUILD_INDEX.log
EXIT /B


:AUTOJOB
SET SID=ALCPRD
SET BOSCHEMA=TRALCPRD
SET FOSCHEMA=AVALCPRD
SET PROJECT=AUTOEXPORT
cd D:\Cassiopae\Tools\DATAPUMP
expdp userid=system/manager@%SID% dumpfile=%dtexp%_%SID%_%PROJECT%.DMP LOGFILE=%dtexp%_%SID%_%PROJECT%.log DIRECTORY=DATAPUMP_DIR COMPRESSION=ALL SCHEMAS=%BOSCHEMA%,%FOSCHEMA%
echo AUTOEXPORT DONE
echo OK
echo Zipping DUMP
PING 127.0.0.1 -n 3 > NUL
7z a D:\Cassiopae\Tools\DATAPUMP\%dtexp%_%SID%_%PROJECT%.zip D:\Cassiopae\Tools\DATAPUMP\%dtexp%_%SID%_%PROJECT%.* -mx9 -sdel
PING 127.0.0.1 -n 3 > NUL
echo 7zip File OK 
PING 127.0.0.1 -n 3 > NUL
move D:\Cassiopae\Tools\DATAPUMP\%dtexp%_%SID%_%PROJECT%.zip "D:\Cassiopae\Archive" 
PING 127.0.0.1 -n 3 > NUL
echo moving File Done 
PING 127.0.0.1 -n 3 > NUL
GOTO FIN


:FIN
echo Fin de la procedure

ENDLOCAL