[Setup]
AppId={{677EE224-3D30-4CA4-8C38-4DB5494B81B8}
AppName=Turbo Pascal for Windows 1.5
AppVersion=1.5.4
AppPublisher=Personal compatibility package
DefaultDirName={localappdata}\TurboPascal15
DefaultGroupName=Turbo Pascal 1.5
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64
MinVersion=10.0
OutputDir=..\dist
OutputBaseFilename=TurboPascal15-Windows-Setup
SetupIconFile=Pascal.ico
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\TurboPascal.exe
InfoBeforeFile=payload\README.txt
CloseApplications=no
SetupLogging=yes
ChangesAssociations=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "associatepas"; Description: "{cm:AssociatePas}"; GroupDescription: "{cm:FileAssociation}"; Flags: unchecked

[CustomMessages]
english.AssociatePas=Open .pas source files with Turbo Pascal
english.FileAssociation=File associations:
french.AssociatePas=Ouvrir les fichiers source .pas avec Turbo Pascal
french.FileAssociation=Associations de fichiers :

[Files]
Source: "payload\*"; DestDir: "{app}"; Excludes: "Programs\*"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "payload\Programs\HELLO.PAS"; DestDir: "{app}\Programs"; Flags: onlyifdoesntexist uninsneveruninstall
Source: "vc_redist.x86.exe"; Flags: dontcopy

[Icons]
Name: "{group}\Turbo Pascal 1.5"; Filename: "{app}\TurboPascal.exe"; WorkingDir: "{app}\Programs"; IconFilename: "{app}\Pascal.ico"
Name: "{group}\My Pascal programs"; Filename: "{app}\Programs"
Name: "{group}\Read me"; Filename: "{app}\README.txt"
Name: "{autodesktop}\Turbo Pascal 1.5"; Filename: "{app}\TurboPascal.exe"; WorkingDir: "{app}\Programs"; IconFilename: "{app}\Pascal.ico"; Tasks: desktopicon

[Run]
Filename: "{app}\TurboPascal.exe"; Parameters: "/configure"; Flags: runhidden waituntilterminated
Filename: "{app}\TurboPascal.exe"; Description: "{cm:LaunchProgram,Turbo Pascal 1.5}"; Flags: nowait postinstall skipifsilent

[Registry]
Root: HKCU; Subkey: "Software\Classes\TurboPascal15.Source"; ValueType: string; ValueData: "Pascal source file"; Flags: uninsdeletekey; Tasks: associatepas
Root: HKCU; Subkey: "Software\Classes\TurboPascal15.Source\DefaultIcon"; ValueType: string; ValueData: """{app}\Pascal.ico"""; Tasks: associatepas
Root: HKCU; Subkey: "Software\Classes\TurboPascal15.Source\shell\open\command"; ValueType: string; ValueData: """{app}\TurboPascal.exe"" ""%1"""; Tasks: associatepas
Root: HKCU; Subkey: "Software\Classes\.pas\OpenWithProgids"; ValueName: "TurboPascal15.Source"; ValueType: string; ValueData: ""; Flags: uninsdeletevalue; Tasks: associatepas

[Code]
const
  AssociationBackup = 'Software\TurboPascal15\AssociationBackup';

procedure CurStepChanged(CurStep: TSetupStep);
var Previous: String; HadValue: Boolean;
begin
  if (CurStep = ssPostInstall) and WizardIsTaskSelected('associatepas') then begin
    if not RegValueExists(HKCU, AssociationBackup, 'HadValue') then begin
      HadValue := RegQueryStringValue(HKCU, 'Software\Classes\.pas', '', Previous);
      if HadValue then begin
        RegWriteDWordValue(HKCU, AssociationBackup, 'HadValue', 1);
        RegWriteStringValue(HKCU, AssociationBackup, 'Previous', Previous);
      end else RegWriteDWordValue(HKCU, AssociationBackup, 'HadValue', 0);
    end;
    RegWriteStringValue(HKCU, 'Software\Classes\.pas', '', 'TurboPascal15.Source');
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var Current, Previous: String; HadValue: Cardinal;
begin
  if CurUninstallStep = usUninstall then begin
    if RegQueryDWordValue(HKCU, AssociationBackup, 'HadValue', HadValue) then begin
      if RegQueryStringValue(HKCU, 'Software\Classes\.pas', '', Current) and (Current = 'TurboPascal15.Source') then begin
        if (HadValue = 1) and RegQueryStringValue(HKCU, AssociationBackup, 'Previous', Previous) then
          RegWriteStringValue(HKCU, 'Software\Classes\.pas', '', Previous)
        else RegDeleteValue(HKCU, 'Software\Classes\.pas', '');
      end;
      RegDeleteKeyIncludingSubkeys(HKCU, AssociationBackup);
    end;
  end;
end;

function NeedsVCRuntime: Boolean;
var Installed: Cardinal;
begin
  Result := not (RegQueryDWordValue(HKLM32, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x86', 'Installed', Installed) and (Installed = 1));
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var Code: Integer;
begin
  Result := '';
  if NeedsVCRuntime then begin
    ExtractTemporaryFile('vc_redist.x86.exe');
    if not ShellExec('runas', ExpandConstant('{tmp}\vc_redist.x86.exe'), '/install /passive /norestart', '', SW_SHOWNORMAL, ewWaitUntilTerminated, Code) then
      Result := 'Microsoft Visual C++ x86 runtime installation could not start. Allow its administrator prompt, then run Setup again.'
    else if (Code <> 0) and (Code <> 1638) and (Code <> 3010) then
      Result := 'Microsoft Visual C++ runtime installation failed (code ' + IntToStr(Code) + ').'
    else if Code = 3010 then NeedsRestart := True;
  end;
end;
