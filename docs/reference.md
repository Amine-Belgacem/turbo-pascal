# Detailed reference

Paths in commands and inline code are relative to the repository root.

Personal compatibility package for the English Turbo Pascal for Windows 1.5
repack and OTVDM 0.9.0. Targets Windows 10/11 on Intel/AMD x64 PCs.

The native C++ launcher embeds the Pascal icon, prepares compatible settings,
and starts the original editor without a virtual machine or .NET dependency.
Setup provides optional desktop shortcuts and `.pas` file association, bundles
the Microsoft x86 runtime prerequisite, and retains user programs on uninstall.
File-open requests reuse the running editor and serialize simultaneous launches.
The first launch still initializes OTVDM; later opens avoid that initialization.
Deep source directories are accessed through short NTFS folder junctions, so
files can remain in their existing locations. Aliases point at original folders.

## Build

Requires Windows, PowerShell, Visual Studio 2022 C++ x86 build tools with a
Windows SDK, and Inno Setup 6.2.2. The local command-line Inno compiler is kept
in `tools/inno/app` for offline builds; that dependency is ignored by Git.

From the repository root:

```powershell
.\installer\build.ps1
```

Outputs `dist/TurboPascal15-Windows-Setup.exe` and `dist/SHA256.txt`.
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
