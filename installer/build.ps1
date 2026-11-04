$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
$visualStudio = & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if (!$visualStudio) { throw 'Visual Studio C++ x86 build tools are required.' }
$inno = Join-Path $root 'tools\inno\app\ISCC.exe'
if (!(Test-Path $inno)) { throw 'Inno Setup 6.2.2 compiler is expected at tools\inno\app\ISCC.exe.' }
& (Join-Path $PSScriptRoot 'compile-native.cmd') $visualStudio
if ($LASTEXITCODE -ne 0) { throw 'Launcher compilation failed.' }
& $inno (Join-Path $PSScriptRoot 'setup.iss')
if ($LASTEXITCODE -ne 0) { throw 'Installer compilation failed.' }
$setup = Join-Path $root 'dist\TurboPascal15-Windows-Setup.exe'
$hash = (Get-FileHash $setup -Algorithm SHA256).Hash
Set-Content (Join-Path $root 'dist\SHA256.txt') ($hash + '  TurboPascal15-Windows-Setup.exe')
