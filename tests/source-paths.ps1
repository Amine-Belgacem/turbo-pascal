$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$testRoot = Join-Path $env:LOCALAPPDATA ('TP' + [guid]::NewGuid().ToString('N').Substring(0, 6))
New-Item -ItemType Directory -Path $testRoot | Out-Null
$sourceDir = Join-Path $testRoot 'Deep lesson folder with spaces\Programming materials\Arithmetic exercises\Nested revision folder\Final source examples'
New-Item -ItemType Directory -Path $sourceDir -Force | Out-Null
$source = Join-Path $sourceDir 'greatest-common-divisor.pas'
Set-Content $source 'program DisposableFixture; begin end.' -Encoding ascii
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
$vs = & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if (!$vs) { throw 'Visual Studio C++ tools are required.' }
$vc = Join-Path $vs 'Common7\Tools\VsDevCmd.bat'
$compilerScript = Join-Path $testRoot 'compile.cmd'
$probe = Join-Path $testRoot 'source-paths.exe'
$obj = Join-Path $testRoot 'source-paths.obj'
$testSource = Join-Path $repo 'tests\source-paths.cpp'
Set-Content $compilerScript @"
@echo off
call "$vc" -arch=x86 -host_arch=x64 >nul
if errorlevel 1 exit /b 1
cl /nologo /std:c++17 /O2 /MT /EHsc /W4 /D_WIN32_WINNT=0x0601 "$testSource" /Fe:"$probe" /Fo:"$obj" /link user32.lib shell32.lib
exit /b %errorlevel%
"@ -Encoding ascii
& $compilerScript
if ($LASTEXITCODE -ne 0) { throw 'Source-path test compilation failed.' }
& $probe $testRoot $source
if ($LASTEXITCODE -ne 0) { throw 'Source-path tests failed.' }
Write-Output "Test files retained at $testRoot"
