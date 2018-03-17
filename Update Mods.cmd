@echo off
color 0a
title Payday mod updater V3.7.2
echo So this file was made for me and my friends so they can update the modpack I made for them more quickly.
timeout 1 >nul
echo THIS WILL REMOVE CUSTOM MOD CONFIGS, BACK THOSE UP BEFORE RUNNING THIS
echo This script will remove your mods before you run the updater, backup the saves folder before running the rest of the script
pause >nul
C:

:cleanup
cls
cd "C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2"
rmdir /s /q mods
rmdir /s /q assets\mod_overrides
rm IPHLPAPI.dll
rmdir /s /q Maps
rm "Update Mods.cmd"

:ask
cls
echo What do you want to do.
echo 1. Update mods from outside of the Payday 2 Dir.
echo 2. Update mods from outside of the Payday 2 Dir (Not default install).
echo 3. Update mods from inside of the Payday 2 Dir.
echo 4. Update mods to BETA BRANCH (C: drive only)
echo 5. Update this script

set /p a=
IF %a%==1 goto 1Update
IF %a%==2 goto 2start
IF %a%==3 goto 3UPDATE
IF %a%==4 goto 4BETA
IF %a%==5 goto 5UPDATE

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
del README.md
del "Update Mods.cmd"
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
del IPHLPAPI.dll
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
del README.md
del "Update Mods.cmd"
exit

:3UPDATE
cls
rmdir /s /q mods
rmdir /s /q assets\mod_overrides
del IPHLPAPI.dll
rmdir /s /q Maps
git gc
git init . >nul
git remote add origin https://github.com/46620/Payday-Modpack.git >nul 2>&1
git fetch --all
git reset --hard origin/master
git fetch origin master >nul 2>&1
rmdir /s /q .git
del README.md
del "Update Mods.cmd"
exit

:4BETA
cls
cd "C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2"
rmdir /s /q mods
rmdir /s /q assets\mod_overrides
del IPHLPAPI.dll
rmdir /s /q Maps
git clone --branch beta https://github.com/46620/Payday-Modpack
cd Payday-Modpack
robocopy . .. /e >nul
cd ..
rmdir /s /q Payday-Modpack
exit

:5UPDATE
cls
echo Making folder for the script to download the new shit to
tinmeout 1 >nul
echo ALL OF THIS WILL HAPPEN ON DESKTOP
timeout 1 >nul
cd C:\Users\%USERNAME%\Desktop
rmdir /s /q "Script Update"
timeout 1 >nul
mkdir "Script Update"
echo Downloading the modpack to get the CMD script
cd "Script Update"
git clone https://github.com/46620/Payday-Modpack.git
cd Payday-Modpack
move "Update Mods.cmd" ..
cd ..
move "Update Mods.cmd" ..
exit