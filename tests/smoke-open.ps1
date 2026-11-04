# Opens only a temporary copy of the package, then closes its test editors.
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$testName = 'TP' + [guid]::NewGuid().ToString('N').Substring(0, 6)
$testRoot = Join-Path $env:LOCALAPPDATA $testName
New-Item -ItemType Directory -Path $testRoot | Out-Null
Copy-Item (Join-Path $repo 'installer\payload\*') $testRoot -Recurse
$launcher = Join-Path $testRoot 'TurboPascal.exe'
$first = Join-Path $testRoot 'Programs\FIRST.PAS'
$second = Join-Path $testRoot 'Programs\SECOND.PAS'
Set-Content $first 'program First; begin end.' -Encoding ascii
Set-Content $second 'program Second; begin end.' -Encoding ascii
function TestEngines {
    @(Get-Process -Name otvdmw -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "*\$testName\runtime\otvdmw.exe" })
}
try {
    $clock = [Diagnostics.Stopwatch]::StartNew()
    $a = Start-Process $launcher -ArgumentList ('"' + $first + '"') -PassThru
    $b = Start-Process $launcher -ArgumentList ('"' + $second + '"') -PassThru
    if (!$a.WaitForExit(20000) -or !$b.WaitForExit(20000)) { throw 'Rapid file-open requests timed out.' }
    if ($a.ExitCode -ne 0 -or $b.ExitCode -ne 0) { throw 'Rapid file-open request failed.' }
    $rapidMs = $clock.ElapsedMilliseconds
    if (@(TestEngines).Count -ne 1) { throw 'Rapid opens created multiple runtimes.' }
    $config = Join-Path $testRoot 'Programs\TPW.CFG'
    $configBefore = (Get-FileHash $config).Hash
    $clock.Restart()
    $c = Start-Process $launcher -ArgumentList ('"' + $first + '"') -PassThru
    if (!$c.WaitForExit(6000) -or $c.ExitCode -ne 0) { throw 'Existing-editor file open failed.' }
    $warmMs = $clock.ElapsedMilliseconds
    if (@(TestEngines).Count -ne 1) { throw 'Existing-editor open restarted the runtime.' }
    if ((Get-FileHash $config).Hash -ne $configBefore) { throw 'Existing-editor open rewrote settings.' }
    [pscustomobject]@{ RapidOpensMs = $rapidMs; ExistingEditorOpenMs = $warmMs; Runtimes = 1; SettingsUnchanged = $true; TestFolder = $testRoot }
} finally {
    foreach ($engine in TestEngines) { $engine.CloseMainWindow() | Out-Null }
}
