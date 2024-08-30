set wdate=%DATE% 
set dtexp=%wdate:~6,4%%wdate:~3,2%%wdate:~0,2%

copy \\alc-sd003\archive\%dtexp%_ALCPRD_AUTOEXPORT.zip  \\Srv-cassio-test\DATAPUMP\ALCPRD_AUTOEXPORT.zip
unzip \\Srv-cassio-test\DATAPUMP\ALCPRD_AUTOEXPORT.zip -d \\Srv-cassio-test\DATAPUMP\ALCPRD_AUTOEXPORT
cd \\Srv-cassio-test\DATAPUMP\ALCPRD_AUTOEXPORT
Datapump_ImportKSIOPANDRO_V4 KSIOPUAT %dtexp%_ALCPRD_AUTOEXPORT.DMP TRALCREC TRES5PRG AVALCREC prospect TRALCPRD AVALCPRD %dtexp%_ALCPRD_AUTOEXPORT.DMP
exit
