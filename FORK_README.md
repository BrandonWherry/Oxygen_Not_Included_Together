# ONI Together — Brandon's fork

A personal fork of [ONI Together](https://github.com/Lyraedan/Oxygen_Not_Included_Together) by Lyraedan.
Source only, per the [license](LICENSE.md): no compiled builds are distributed here, and this fork will
**not** be published to the Steam Workshop. For the official mod, use the
[ONI Together Workshop page](https://steamcommunity.com/sharedfiles/filedetails/?id=3630759126).

## Install / update (Windows)

1. Close Oxygen Not Included.
2. Download [`update-mod.bat`](https://github.com/BrandonWherry/Oxygen_Not_Included_Together/raw/brandon-fork/update-mod.bat) (right-click → Save link as), put it anywhere, and double-click it.
   - If Windows SmartScreen warns you, click **More info → Run anyway**.
   - First run downloads ~250 MB of build tools into `%LOCALAPPDATA%\ONITogetherFork` (no admin needed). Later runs take about a minute.
3. Start the game → **Mods** → enable **ONI Together (Brandon fork)** → restart.
   Don't also enable the Steam Workshop version of ONI Together.

Run `update-mod.bat` again whenever Brandon pushes an update. Both players must be on the same build;
the window prints the build ID at the end so you can compare.

To uninstall, delete `Documents\Klei\OxygenNotIncluded\mods\Local\ONI_Together_dev` and `%LOCALAPPDATA%\ONITogetherFork`.
