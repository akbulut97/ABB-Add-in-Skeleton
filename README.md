# ABB RobotWare Add-in Skeleton

Opinionated starter kit for building ABB RobotWare Additional Options. The repository mirrors ABB's reference layout (Code/Config/Language/Rules), ships with working RAPID modules, and includes scripts that swap every `YOUR_ADDIN_NAME` placeholder so you can jump straight into feature work instead of bootstrapping files by hand.

## Why use this skeleton?

- Mirrors ABB's add-in conventions, so anything you build here can be dropped into RobotStudio without rework.
- `setup_skeleton.ps1` personalises metadata (alias, title, version, description) everywhere from `version.xml` to cfg/rule files.
- Ready-to-run RAPID samples (`Code/TASK1/...`) show how to hook into system start, map handshake signals, and execute a minimal cycle.
- Config, language, and rule registrations (`install.cmd`, `install_lang.cmd`) are already wired, letting you focus on your own PROC/EIO/MMC/SYS tweaks.
- Ships with MIT License so you can embed the template inside internal or commercial projects.

## Prerequisites

- RobotStudio + RobotWare installation packages (for testing/installing the option).
- Windows PowerShell 5.1+ or PowerShell 7+ to execute `setup_skeleton.ps1`.
- Basic familiarity with RAPID, cfgtext, and cfgrules authoring.

## Getting started

1. **Clone or copy the template**
   ```powershell
   git clone https://github.com/<your-org>/ABB-Add-in-Skeleton.git
   cd ABB-Add-in-Skeleton
   ```
   (Alternatively, use "Use this template" in GitHub or duplicate the folder manually.)

2. **Personalise the skeleton**
   ```powershell
   .\setup_skeleton.ps1 `
       -AddInName MY_OPTION `
       -Title "My Option" `
       -Description "RobotWare demo add-in" `
       -Version 1.0.0 `
       -Date 2025-01-01
   ```
   The script validates naming rules, writes `version.xml`, and replaces every remaining `YOUR_ADDIN_NAME`.

3. **Review metadata and install scripts**
   - `version.xml` - ensure `Type`, `Title`, and `Description` match your product.
   - `install.cmd` - extend cfg registrations or add extra files (RAPID modules, documentation, etc.).
   - `install_lang.cmd` / `Language/install.cmd` - duplicate `Language/en` for each locale you support.

4. **Develop your option**
   - Keep the helper routines referenced from `Config/SYS/sysSkeleton.cfg` while you add your own RAPID logic under `Code/TASK1`.
   - Extend the config snippets in `Config/EIO`, `Config/PROC`, `Config/SYS`, and `Config/MMC` to match the signals, tasks, and device data your option needs.
   - Update `Rules/addin_cfgrules.xml` and `Language/*/addin_cfgtext.xml` every time you introduce new parameters.

5. **Package and install**
   - Zip the add-in folder (RobotStudio expects the root to contain `version.xml` and `install.cmd`).
   - In RobotStudio: *Controller* -> *Installation Manager* -> *Add* -> select your zip -> follow the wizard.
   - On a controller service port: `install option "<path>\YourAddIn.zip"`.

## Repository layout

| Path | Purpose |
| ---- | ------- |
| `setup_skeleton.ps1` | Prompts for alias/title/version/description and replaces every placeholder plus `version.xml`. |
| `install.cmd` | Registers cfg text/rules, loads each domain config, and publishes a BOOTPATH alias so configs can refer to `ADDIN:/Code/...`. |
| `install_lang.cmd`, `Language/install.cmd` | Installs `Language/<locale>/addin_cfgtext.xml` during RobotWare language deployment. |
| `Code/TASK1/SYSMOD/AddinSystem.sys` | Example system module that wires in power-on hooks and helper routines referenced from SYS configs. |
| `Code/TASK1/PROGMOD/AddinMain.mod` | Minimal RAPID cycle showcasing digital signal handshake and ADDIN parameter usage. |
| `Config/EIO|PROC|SYS|MMC/*.cfg` | Domain-specific starter cfg files that reference the sample modules through the alias exported in `install.cmd`. |
| `Rules/addin_cfgrules.xml` | Defines the `ADDIN_SETTINGS` PROC type and binds parameters to SYS/EIO lookups. |
| `Language/en/addin_cfgtext.xml` | Text resources for the rule file; copy the folder to add more locales. |
| `Docs/README.md` | Longer-form guide that explains how to extend the skeleton beyond the quick start above. |

## Customisation checklist

- [ ] Update RAPID modules with your routines while keeping any entry points referenced from cfg files.
- [ ] Expand `Rules/addin_cfgrules.xml` with parameters, value constraints, and defaults that match your option.
- [ ] Duplicate `Language/en` and translate strings for each controller language you'll ship.
- [ ] Add/remove cfg files and update `install.cmd` registrations whenever you touch new domains.
- [ ] Document project-specific behaviour in `Docs/README.md` so downstream teams understand how to extend it.

## Scripts & automation

- `setup_skeleton.ps1` - handles metadata replacement, placeholder cleanup, and validates version format (Major.Minor.Build.Revision).
- `install.cmd` - primary entry point executed by RobotWare during add-in installation.
- `install_lang.cmd` - helper invoked once per installed language pack.
- `Docs/README.md` - deeper explanation of each folder plus tips for extending the baseline.

## License

Distributed under the MIT License. See `LICENSE` for details.

