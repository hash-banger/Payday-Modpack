@echo off
color 0a
title Payday mod updater V2.1 BETA
echo So this file was made for me and my friends so they can update the modpack I made for them more quickly.
timeout 1 >nul
echo THIS WILL REMOVE CUSTOM MOD CONFIGS, BACK THOSE UP BEFORE RUNNING THIS
C:

:ask
echo What do you want to do.
echo 1. Update mods from outside of the Payday 2 Dir.
echo 2. Update mods from inside of the Payday 2 Dir.
echo 3. Update this CMD script.

set /p a=
IF %a%==1 goto 1remove
IF %a%==2 goto 2start
IF %a%==3 goto 3UPDATE

:1remove
cd "C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2"
rm -rf mods
rm -rf assets\mod_overrides
rm IPHLPAPI.dll
rm -rf Maps
goto 1Update

:1Update
echo This will now connect to the github repo and download the most recent version of the modpack
git init . >nul || goto :git
git remote add origin https://github.com/46620/Payday-Modpack.git >nul 2>&1
git fetch --all
git reset --hard origin/master
git fetch origin master >nul 2>&1

:2start
cls
echo Please Specify what the Payday Directory is and it will install to there
set /p dir=
echo What drive is this game on
set /p dri=
%dri%:
cd %dir%
goto 2UPDATE

:2UPDATE
git init . >nul || goto :git
git remote add origin https://github.com/46620/Payday-Modpack.git >nul 2>&1
git fetch --all
git reset --hard origin/master
git fetch origin master >nul 2>&1

:3UPDATE
echo WARNING! DO THIS OUTSIDE OF THE PAYDAY DIRECTORY OR IT WILL DELETE THE ASSETS FOLDER!
pause
git init . >nul || goto :git
git remote add origin https://github.com/46620/Payday-Modpack.git >nul 2>&1
git fetch --all
git reset --hard origin/master
git fetch origin master >nul 2>&1
rm -rf mods
rm -rf assets
rm IPHLPAPI.dll
rm Maps