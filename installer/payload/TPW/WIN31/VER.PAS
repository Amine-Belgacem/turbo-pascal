
{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit Ver;

interface

uses WinTypes;

const
  { Symbols }
  vs_File_Info = PChar(16);		{ Version stamp res type }
  vs_Version_Info = PChar(1);  		{ Version stamp res ID }
  vs_User_Defined = PChar(100);		{ User-defined res IDs }

  { vs_Version.dwFileFlags }
  vs_FFI_Signature = $FEEF04BD;
  vs_FFI_StrucVersion = $00010000;
  vs_FFI_FileFlagsMask = $0000003F;

  { vs_Version.dwFileFlags }
  vs_FF_Debug = $00000001;
  vs_FF_Prerelease = $00000002;
  vs_FF_Patched = $00000004;
  vs_FF_PrivateBuild = $00000008;
  vs_FF_InfoInferred = $00000010;
  vs_FF_SpecialBuild = $00000020;

  { vs_Version.dwFileOS }
  vos_Unknown = $00000000;
  vos_DOS = $00010000;
  vos_OS216 = $00020000;
  vos_OS232 = $00030000;
  vos_NT = $00040000;

  vos__Base = $00000000;
  vos__Windows16 = $00000001;
  vos__PM16 = $00000002;
  vos__PM32 = $00000003;
  vos__Windows32 = $00000004;

  vos_DOS_Windows16 = $00010001;
  vos_DOS_Windows32 = $00010004;
  vos_OS216_PM16 = $00020002;
  vos_OS232_PM32 = $00030003;
  vos_NT_Windows32 = $00040004;

  { vs_Version.dwFileType }
  vft_Unknown = $00000000;
  vft_APP = $00000001;
  vft_DLL = $00000002;
  vft_DRV = $00000003;
  vft_Font = $00000004;
  vft_VXD = $00000005;
  vft_Static_Lib = $00000007;

  { vs_Version.dwFileSubtype for vft_Windows_DRV }
  vft2_Unknown = $00000000;
  vft2_DRV_Printer = $00000001;
  vft2_DRV_Keyboard = $00000002;
  vft2_DRV_Language = $00000003;
  vft2_DRV_Display = $00000004;
  vft2_DRV_Mouse = $00000005;
  vft2_DRV_Network = $00000006;
  vft2_DRV_System = $00000007;
  vft2_DRV_Installable = $00000008;
  vft2_DRV_Sound = $00000009;
  vft2_DRV_Comm = $00000000A;

  { vs_Version.dwFileSubtype for vft_Windows_Font }
  vft2_Font_Raster = $00000001;
  vft2_Font_Vector = $00000002;
  vft2_Font_TrueType = $00000003;

  { VerFindFile() flags }
  vfff_IsSharedFile = $0001;

  vff_CurNEDest = $0001;
  vff_FileInUse = $0002;
  vff_BuffTooSmall = $0004;

  { VerInstallFile() flags }
  viff_ForceInstall = $0001;
  viff_DontDeleteOld = $0002;

  vif_TempFile = $00000001;
  vif_Mismatch = $00000002;
  vif_SrcOld = $00000004;

  vif_DiffLang = $00000008;
  vif_DiffCodePg = $00000010;
  vif_DiffType = $00000020;

  vif_WriteProt = $00000040;
  vif_FileInUse = $00000080;
  vif_OutOfSpace = $00000100;
  vif_AccessViolation = $00000200;
  vif_SharingViolation = $00000400;
  vif_CannotCreate = $00000800;
  vif_CannotDelete = $00001000;
  vif_CannotRename = $00002000;
  vif_CannotDeleteCur = $00004000;
  vif_OutOfMemory = $00008000;

  vif_CannotReadSrc = $00010000;
  vif_CannotReadDst = $00020000;

  vif_BuffTooSmall = $00040000;

type
  Pvs_FixedFileInfo = ^Tvs_FixedFileInfo;
  Tvs_FixedFileInfo = record
    dwSignature: Longint;		{ e.g. $feef04bd }
    dwStrucVersion: Longint;		{ e.g. $00000042 = "0.42" }
    dwFileVersionMS: Longint;		{ e.g. $00030075 = "3.75" }
    dwFileVersionLS: Longint;		{ e.g. $00000031 = "0.31" }
    dwProductVersionMS: Longint;	{ e.g. $00030010 = "3.10" }
    dwProductVersionLS: Longint;	{ e.g. $00000031 = "0.31" }
    dwFileFlagsMask: Longint;		{ = $3F for version "0.42" }
    dwFileFlags: Longint;		{ e.g. vff_Debug | vff_Prerelease }
    dwFileOS: Longint;			{ e.g. vos_DOS_Windows16 }
    dwFileType: Longint;		{ e.g. vft_DRIVER }
    dwFileSubtype: Longint;		{ e.g. vft2_DRV_Keyboard }
    dwFileDateMS: Longint;		{ e.g. 0 }
    dwFileDateLS: Longint;		{ e.g. 0 }
  end;


function VerFindFile(Flags: Word; FileName, WinDir, AppDir,
  CurDir: PChar; var CurDirLen: Word; DestDir: PChar;
  var DestDirLen: Word): Word;

function VerInstallFile(Flags: Word; SrcFileName, DestFileName,
  SrcDir, DestDir, CurDir, TmpFile: PChar; var TmpFileLen: Word): Longint;

{ Returns size of version info in bytes }

function GetFileVersionInfoSize(
  FileName: PChar;			{ Filename of version stamped file }
  var Handle: Longint): Longint;	{ Information for use by GetFileVersionInfo }

{ Read version info into buffer }

function GetFileVersionInfo(
  FileName: PChar;			{ Filename of version stamped file }
  Handle: Longint;			{ Information from GetFileVersionSize }
  Len: Longint;				{ Length of buffer for info }
  Data: PChar): Bool;			{ Buffer to place the data structure }

{ Returns size of resource in bytes }

function GetFileResourceSize(
  FileName: PChar;			{ Filename of version stamped file }
  ResType: PChar;			{ Type:  normally vs_File_Info }
  ResID: PChar;				{ ID:  normally vs_Version_Info }
  var FileOffset: Longint): Longint;	{ Returns file offset of resource }

{ Reads file resource into buffer }

function GetFileResource(
  FileName: PChar;			{ Filename of version stamped file }
  ResType: PChar;			{ Type:  normally vs_File_Info }
  ResID: PChar;				{ ID:  normally vs_Version_Info }
  FileOffset: Longint;			{ File offset or NULL }
  ResLen: Longint;			{ Length of resource to read or NULL }
  Data: PChar): Bool;			{ Pointer to data buffer }

function VerLanguageName(Lang: Word; Lang: PChar; Size: Word): Word;

{  In VER.H but not exported by any DLL or EXE
function GetWindowsDir(AppDir: PChar; Buffer: PChar; Size: Integer): Word;
function GetSystemDir(AppDir: PChar; Buffer: PChar; Size: Integer): Word;
}

function VerQueryValue(Block: Pointer; SubBlock: PChar;	var Buffer: Pointer;
  var Len: Word): Bool;

implementation

function VerFindFile;                      external 'VER'      index 8;
function VerInstallFile;                   external 'VER'      index 9;
function GetFileVersionInfoSize;           external 'VER'      index 6;
function GetFileVersionInfo;               external 'VER'      index 7;
function GetFileResourceSize;              external 'VER'      index 2;
function GetFileResource;                  external 'VER'      index 3;
function VerLanguageName;                  external 'VER'      index 10;
function VerQueryValue;                    external 'VER'      index 11;

end.
