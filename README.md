# Turbo Pascal for Windows

This package makes the English Turbo Pascal for Windows 1.5 editor usable on Windows 10/11 x64 through OTVDM and a native launcher. It is intended for opening older Pascal projects, revisiting the original development environment, or working through material written for that editor.

The launcher prepares compatible settings and reuses the running editor when you open another source file. Short NTFS folder aliases help with source directories that exceed the legacy editor's path limits. The installer can create shortcuts and associate `.pas` files, while retaining user programs during uninstall.

This is a compatibility wrapper around the original software, not a new Pascal compiler. The original program and bundled components retain their own licensing terms.

## Features

- Native launcher with optional desktop shortcuts and `.pas` file association.
- Reuses the running editor for file-open requests.
- Handles deep source paths through short NTFS folder aliases.
- Keeps user programs when the package is uninstalled.

## Build

Requires Windows, PowerShell, Visual Studio 2022 C++ x86 build tools with a
Windows SDK, and Inno Setup 6.2.2. The local command-line Inno compiler is kept
in `tools/inno/app` for offline builds; that dependency is ignored by Git.

From the repository root:

```powershell
.\installer\build.ps1
```

Outputs `dist/TurboPascal15-Windows-Setup.exe` and `dist/SHA256.txt`. Run the installer, then open Turbo Pascal from its installed shortcut or an associated `.pas` file. Generated installers are not included in Git.
Build paths are relative to this repository, so moving it does not require
editing the scripts.

Run `.\tests\smoke-open.ps1` to check rapid launches, editor reuse, and unchanged
settings in an isolated temporary package. It leaves the test folder for review.
Run `.\tests\source-paths.ps1` to verify deep-path aliases, their identity,
reuse, and direct saving to the original disposable fixture.

## Contents

- `installer/Launcher.cpp`, `Launcher.rc`, `Pascal.ico`: native launcher and icon.
- `installer/compile-native.cmd`, `build.ps1`: build entry points.
- `installer/setup.iss`: installer, optional tasks, and association cleanup.
- `installer/payload/`: program files, runtime, sample program, and user guide.
- `installer/vc_redist.x86.exe`: Microsoft runtime prerequisite.
- `installer/payload/licenses/`: OTVDM license and corresponding source archive.
- `dist/`: current installer and checksum; generated and ignored by Git.

Installed user programs belong in the installed application's `Programs`
folder, separate from this repository. See the bundled README for legacy path
limits, file association behavior, and installation requirements.

## Third-party software

Borland Turbo Pascal remains proprietary and subject to its original terms;
this compatibility wrapper does not grant redistribution rights. OTVDM is
GPL v2; its license and source archive are included. Microsoft's redistributable
and Inno Setup retain their respective licenses.
