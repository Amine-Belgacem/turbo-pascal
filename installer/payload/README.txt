Turbo Pascal for Windows 1.5 - personal compatibility package

Requirements: Windows 10 or 11, Intel/AMD x64 PC. ARM and 32-bit Windows are not
supported by this package. Tested on Windows 11 x64.

Run Setup, then open Turbo Pascal 1.5 from the Start menu or desktop.
Setup offers independent checkboxes for a desktop shortcut and .pas file
association. The .pas association is optional and unchecked by default.
If Windows already protects a default .pas app, select Turbo Pascal through
Open with > Choose another app > Always. Setup does not override Windows
UserChoice protections. Uninstall restores the previous extension default
if it still points to this package.
The original Windows editor runs through OTVDM 0.9.0 software emulation.
No virtual machine, guest operating system, or hypervisor is required.

Microsoft's x86 Visual C++ runtime is included for offline installation.
If it is missing, Windows will request administrator approval to install
that prerequisite. Pascal itself installs for the current user.

Press Ctrl+F9 to compile and run. HELLO.PAS is a working first example.
Save your source files in the Programs folder opened by the Start menu
shortcut. Executables are also written there. Use relative data filenames,
such as 'students.dat', instead of writing directly under C:\.
Short ASCII filenames such as STUDENT.PAS are best for this 16-bit editor.
When you open a file through the launcher or Explorer from a deeply nested
folder, the launcher creates a short NTFS folder junction under Links.
This refers to the original folder; it does not copy your source files.
The editor displays that short path, and ordinary saves edit the original.
Keep the original directory available while editing. Opening such folders
manually inside the legacy File Open dialog still has the editor's path limits.
Folder aliases require a local source folder and an NTFS installation drive.

The native Windows launcher embeds the Pascal icon and needs no .NET runtime.
Setup prepares paths in advance; unchanged settings are not rewritten.
Double-clicked .pas files open in the existing editor when it is available.
Rapid open requests are serialized so startup does not create duplicate runtimes.
The first editor launch still initializes the 16-bit compatibility runtime.
If Pascal is running a program or showing a modal dialog, finish that activity
before opening another file. The launcher leaves those dialogs untouched.
Settings and paths are adjusted on the destination PC when required.
If short filenames are disabled and the install path contains spaces or
non-ASCII characters, install to a writable ASCII path without spaces,
for example C:\TurboPascal15. Its short Programs directory path must be
63 characters or fewer. The launcher reports incompatible or deep paths.

Use Windows Installed Apps to uninstall. Your Programs folder and source,
data and generated executable files are retained. Back it up yourself
before moving or removing it.

This package contains the English TPW 1.5 repack already owned by the user,
including its modified editor shortcuts and WinCrt. Borland Turbo Pascal
remains proprietary: this wrapper does not grant a redistribution license.
Use and redistribution of those files remain subject to their original terms.

OTVDM: https://github.com/otya128/winevdm
The GPL v2 license and matching v0.9.0 source archive are in licenses.
Visual C++ runtime: Microsoft Corporation; its own license applies.
This personal installer and launcher are unsigned.
