@echo off
color 0a
title Payday mod updater v2.0
C:
cd C:\Users\%USERNAME%\Desktop
rmdir /s /q Payday-Modpack

:Ask
cls
echo 1. Update mods from outside of the Payday 2 Dir.
echo 2. Update mods from outside of the Payday 2 Dir (D: ONLY! WORKING ON OTHER DRIVES SOON!).
echo 3. Update this script
echo 99. Discord

set /p a=
IF %a%==1 goto 1Update
IF %a%==2 goto 2start
IF %a%==3 goto 3UPDATE
IF %a%==99 goto 99Discord

:1Update
cls
cd "C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2"
rmdir /s /q mods assets\mod_overrides Maps
del IPHLPAPI.dll
git clone --branch master https://github.com/46620/Payday-Modpack
cd Payday-Modpack
robocopy . .. /e >nul
cd ..
rmdir /s /q Payday-Modpack .git
del "Update Mods.cmd" README.md
exit

:2start
D:
cd /
touch %tmp%\test1.txt
dir /ad /b "Payday 2" /S >> %tmp%\test1.txt
set /p Build=<%tmp%\test1.txt
cd "%Build%"
goto 2remove

:2remove
cls
rmdir /s /q mods assets\mod_overrides Maps
del IPHLPAPI.dll
goto 2UPDATE

:2UPDATE
cls
rmdir /s /q mods assets\mod_overrides Maps
del IPHLPAPI.dll
git clone --branch master https://github.com/46620/Payday-Modpack
cd Payday-Modpack
robocopy . .. /e >nul
cd ..
rmdir /s /q Payday-Modpack .git
del "Update Mods.cmd" README.md
exit

:3UPDATE
cls
git clone --branch master https://github.com/46620/Payday-Modpack
cd Payday-Modpack
move "Update Mods.cmd" ..
cd ..
exit

:99Discord
start https://discord.gg/4XHetnA
