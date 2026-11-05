# Turbo Pascal for Windows

Run the English Turbo Pascal for Windows 1.5 editor on Windows 10/11 x64 through a native launcher and OTVDM 0.9.0.

## Features

- Native launcher with optional desktop shortcuts and `.pas` file association.
- Reuses the running editor for file-open requests.
- Handles deep source paths through short NTFS folder aliases.
- Keeps user programs when the package is uninstalled.

## Build the installer

Requires Windows, PowerShell, Visual Studio 2022 C++ x86 build tools, a Windows SDK, and Inno Setup 6.2.2.

The build script expects the Inno compiler at `tools/inno/app/ISCC.exe`. Supply it locally after cloning; the `tools` directory is excluded from Git.

```powershell
.\installer\build.ps1
```

The build creates `dist/TurboPascal15-Windows-Setup.exe` and `dist/SHA256.txt`. Run the installer, then open Turbo Pascal from its installed shortcut or an associated `.pas` file. Generated installers are not included in the repository.

## Development

The launcher is in [installer/Launcher.cpp](installer/Launcher.cpp); installer settings are in [installer/setup.iss](installer/setup.iss).

```powershell
.\tests\smoke-open.ps1
.\tests\source-paths.ps1
```

[Package guide](installer/payload/README.txt) · [Detailed reference](docs/reference.md)

## Third-party software

Borland Turbo Pascal remains proprietary and subject to its original terms. OTVDM is GPL v2; its license and source archive are included under [installer/payload/licenses](installer/payload/licenses). Microsoft and Inno Setup components retain their respective licenses. This wrapper does not grant redistribution rights to those components.
