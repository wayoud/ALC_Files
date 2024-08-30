rem @echo off

cd /d D:\Cassiopae\Archive
for %%i in (*.zip) do move "%%i" "\\alc-sb003\Backups BDD\Cassiopae"

rem echo Done!
rem exit