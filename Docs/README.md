# ABB RobotWare Add-in Skeleton

This folder contains a minimal, self-documenting baseline you can copy when building a new ABB RobotWare Additional Option. It mirrors ABB's typical add-in layout (Code/Config/Language/Rules) and keeps every placeholder isolated so you can replace `YOUR_ADDIN_NAME` with your actual option name.

## Structure

| Path | Purpose |
| ---- | ------- |
| `install.cmd` | Registers cfg text/rules and loads every domain config. |
| `install_lang.cmd` & `Language/install.cmd` | Simple helper that pushes `addin_cfgtext.xml` for whichever language RobotWare installs. |
| `Rules/addin_cfgrules.xml` | Defines the PROC type `ADDIN_SETTINGS` with a couple of parameters bound to SYS/EIO lookups. |
| `Language/en/addin_cfgtext.xml` | Text resources referenced from the rule file. Duplicate this for more locales. |
| `Config/*` | Starter `.cfg` files for EIO, PROC, SYS and MMC domains. They reference the demo RAPID modules via the alias set in `install.cmd`. |
| `Code/TASK1/...` | Example system (`AddinSystem.sys`) and program (`AddinMain.mod`) modules showing power-on hooks, handshake signals and a minimal RAPID cycle. |
| `Docs/README.md` | Explains how to extend the skeleton. |

## How to use

1. Copy the `ABB_Addin_Skeleton` folder, rename it to your project, then run `.\setup_skeleton.ps1` inside the copy to fill in the alias, title, version and description (or pass the values as parameters).
2. Review `version.xml`/`install.cmd` afterwards and extend the cfg registrations or file list to match your option.
3. Extend the RAPID modules or replace them with your own. Keep the system module routines referenced in `sysSkeleton.cfg`.
4. Add/remove `.cfg` files or rules as needed. When you introduce new parameters, add matching language resources.
5. Zip the folder and deploy it through RobotStudio or `install option` just like any other add-in.
