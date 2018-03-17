@echo off
color 0a
title Payday mod updater V3.0
echo So this file was made for me and my friends so they can update the modpack I made for them more quickly.
timeout 1 >nul
echo THIS WILL REMOVE CUSTOM MOD CONFIGS, BACK THOSE UP BEFORE RUNNING THIS
C:

:ask
echo What do you want to do.
echo 1. Update mods from outside of the Payday 2 Dir.
echo 2. Update mods from outside of the Payday 2 Dir (Not default install).
echo 3. Update mods from inside of the Payday 2 Dir.

set /p a=
IF %a%==1 goto 1remove
IF %a%==2 goto 2start
IF %a%==3 goto 3UPDATE

:1remove
cls
cd "C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2"
rmdir /s /q mods
rmdir /s /q assets\mod_overrides
rm IPHLPAPI.dll
rmdir /s /q Maps
goto 1Update

:1Update
cls
echo This will now connect to the github repo and download the most recent version of the modpack
git gc
git init . >nul
git remote add origin https://github.com/46620/Payday-Modpack.git >nul 2>&1
git fetch --all
git reset --hard origin/master
git fetch origin master >nul 2>&1
rmdir /s /q .git
rm README.md
rm "Update Mods.cmd"
exit

:2start
cls
echo What drive is this game on
set /p dri=
%dri%:
cd "%dri%:\Steam\steamapps\common\PAYDAY 2"
goto 2UPDATE

:2remove
cls
rmdir /s /q mods
rmdir /s /q assets\mod_overrides
rm IPHLPAPI.dll
rmdir /s /q Maps
goto 2UPDATE

:2UPDATE
cls
git gc
git init . >nul
git remote add origin https://github.com/46620/Payday-Modpack.git >nul 2>&1
git fetch --all
git reset --hard origin/master
git fetch origin master >nul 2>&1
rmdir /s /q .git
rm README.md
rm "Update Mods.cmd"
exit

:3UPDATE
cls
rmdir /s /q mods
rmdir /s /q assets\mod_overrides
rm IPHLPAPI.dll
rmdir /s /q Maps
git gc
git init . >nul
git remote add origin https://github.com/46620/Payday-Modpack.git >nul 2>&1
git fetch --all
git reset --hard origin/master
git fetch origin master >nul 2>&1
rmdir /s /q .git
rm README.md
rm "Update Mods.cmd"
exit