# ONI Together — Brandon's fork

This is my personal fork of [ONI Together](https://github.com/Lyraedan/Oxygen_Not_Included_Together) by Lyraedan,
just for playing with a friend. I won't be publishing it to the Steam Workshop or sharing compiled builds
(the [license](LICENSE.md) doesn't allow that anyway), so everything here is source only and builds on your own PC.
If you want the mod itself, use the official [Workshop page](https://steamcommunity.com/sharedfiles/filedetails/?id=3630759126).

## Install / update (Windows)

1. Close Oxygen Not Included.
2. Download [`update-mod.bat`](https://github.com/BrandonWherry/Oxygen_Not_Included_Together/raw/brandon-fork/update-mod.bat) (right-click → Save link as), put it anywhere, and double-click it.
   - If Windows SmartScreen warns you, click **More info → Run anyway**.
   - First run downloads ~250 MB of build tools into `%LOCALAPPDATA%\ONITogetherFork` (no admin needed). Later runs take about a minute.
3. Start the game → **Mods** → enable **ONI Together (Brandon fork)** → restart.
   Don't also enable the Steam Workshop version of ONI Together.

Run `update-mod.bat` again whenever I push an update. Both players must be on the same build;
the window prints the build ID at the end so you can compare.

To uninstall, delete `Documents\Klei\OxygenNotIncluded\mods\Local\ONI_Together_dev` and `%LOCALAPPDATA%\ONITogetherFork`.
