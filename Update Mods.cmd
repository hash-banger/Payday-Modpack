@echo off
color 0a
title Payday mod updater V4.3.2
echo So this file was made for me and my friends so they can update the modpack I made for them more quickly.
echo THIS WILL REMOVE CUSTOM MOD CONFIGS, BACK THOSE UP BEFORE RUNNING THIS
echo This script will remove your mods before you run the updater, backup the saves folder before running the rest of the script
pause >nul
C:

:ask
cls
echo What do you want to do.
echo 1. Update mods from outside of the Payday 2 Dir.
echo 2. Update mods from outside of the Payday 2 Dir (Not default install).
echo 3. Update mods from inside of the Payday 2 Dir.
echo 4. Update mods to BETA BRANCH (C: drive only)
echo 5. Update this script
echo 6. Update this script (Beta version)
echo 9. Discord

set /p a=
IF %a%==1 goto 1Update
IF %a%==2 goto 2start
IF %a%==3 goto 3UPDATE
IF %a%==4 goto 4BETA
IF %a%==5 goto 5UPDATE
IF %a%==6 goto 6UPDATE
IF %a%==9 goto Discord

:1Update
cls
echo This will now connect to the github repo and download the most recent version of the modpack
cd "C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2"
rmdir /s /q mods
rmdir /s /q assets\mod_overrides
del IPHLPAPI.dll
rmdir /s /q Maps
git clone --branch master https://github.com/46620/Payday-Modpack
cd Payday-Modpack
robocopy . .. /e >nul
cd ..
rmdir /s /q Payday-Modpack
del "Update Mods.cmd"
del README.md
rmdir /s /q .git
exit

:2start
cls
echo What drive is this game on
set /p dri=
%dri%:
cd "%dri%:\Steam\steamapps\common\PAYDAY 2"
goto 2remove

:2remove
cls
rmdir /s /q mods
rmdir /s /q assets\mod_overrides
del IPHLPAPI.dll
rmdir /s /q Maps
goto 2UPDATE

:2UPDATE
cls
rmdir /s /q mods
rmdir /s /q assets\mod_overrides
del IPHLPAPI.dll
rmdir /s /q Maps
git clone --branch master https://github.com/46620/Payday-Modpack
cd Payday-Modpack
robocopy . .. /e >nul
cd ..
rmdir /s /q Payday-Modpack
del "Update Mods.cmd"
del README.md
rmdir /s /q .git
exit

:3UPDATE
cls
rmdir /s /q mods
rmdir /s /q assets\mod_overrides
del IPHLPAPI.dll
rmdir /s /q Maps
git clone --branch beta https://github.com/46620/Payday-Modpack
cd Payday-Modpack
robocopy . .. /e >nul
cd ..
rmdir /s /q Payday-Modpack
del "Update Mods.cmd"
del README.md
rmdir /s /q .git
exit

:4BETA
cls
cd "C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2"
rmdir /s /q mods
rmdir /s /q assets\mod_overrides
del IPHLPAPI.dll
rmdir /s /q Maps
git clone --branch beta https://github.com/46620/Payday-Modpack
rmdir /s /q Maps
git clone --branch master https://github.com/46620/Payday-Modpack
cd Payday-Modpack
robocopy . .. /e >nul
cd ..
rmdir /s /q Payday-Modpack
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
del "Update Mods.cmd"
del README.md
rmdir /s /q .git
exit

:5UPDATE
cls
cd C:\Users\%USERNAME%\Desktop
git clone --branch master https://github.com/46620/Payday-Modpack
cd Payday-Modpack
move "Update Mods.cmd" ..
cd ..
rmdir /s /q Payday-Modpack
exit

:6UPDATE
cls
cd C:\Users\%USERNAME%\Desktop
git clone --branch beta https://github.com/46620/Payday-Modpack
cd Payday-Modpack
move "Update Mods.cmd" ..
cd ..
rmdir /s /q Payday-Modpack
exit

:Discord
start https://discord.gg/YtwfQrD