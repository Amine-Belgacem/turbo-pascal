@echo off
call "%~1\Common7\Tools\VsDevCmd.bat" -arch=x86 -host_arch=x64 >nul
if errorlevel 1 exit /b 1
cd /d "%~dp0"
rc /nologo /fo Launcher.res Launcher.rc
if errorlevel 1 exit /b 1
cl /nologo /std:c++17 /O2 /MT /EHsc /W4 /D_WIN32_WINNT=0x0601 Launcher.cpp /Fe:payload\TurboPascal.exe /Fo:Launcher.obj /link Launcher.res user32.lib shell32.lib /SUBSYSTEM:WINDOWS /DYNAMICBASE /NXCOMPAT
exit /b %errorlevel%
