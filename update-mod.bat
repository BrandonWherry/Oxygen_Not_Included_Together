@echo off
rem Double-click to install or update ONI Together (Brandon fork). Close the game first.
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/BrandonWherry/Oxygen_Not_Included_Together/brandon-fork/tools/update-mod.ps1' | iex"
echo.
pause
