
{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit ShellAPI;

interface

uses WinTypes;

const
  Error_Success = 0;
  Error_BadDB = 1;
  Error_BadKey = 2;
  Error_CantOpen = 3;
  Error_CantRead = 4;
  Error_CantWrite = 5;
  Error_OutOfMemory = 6;
  Error_Invalid_Parameter = 7;
  Error_Access_Denied = 8;

  reg_SZ = 1;	                       { string type }

  hKey_Classes_Root = 1;

{ necessary types.  Everything in this API is 32-bit. }

type
  HKey = Longint;
  PHKey = ^HKey;

{ API exports from the library }

function RegOpenKey(Key: HKey; SubKey: PChar; var Result: HKey): Longint;
function RegCreateKey(Key: HKey; SubKey: PChar;var Result: HKey): Longint;
function RegCloseKey(Key: HKey): Longint;
function RegDeleteKey(Key: HKey; SubKey: PChar): Longint;
function RegSetValue(Key: HKey; SubKey: PChar; ValType: Longint;
  Value: PChar; cb: Longint): Longint;
function RegQueryValue(Key: HKey; SubKey: PChar; Value: PChar;
  var cb: Longint): Longint;
function RegEnumKey(Key: HKey; index: Longint; Buffer: PChar;
  cb: Longint): Longint;

function DragQueryFile(Drop: THandle; FileIndex: Word; FileName: PChar;
  cb: Word): Word;
function DragQueryPoint(Drop: THandle; var Pt: TPoint): Bool;
procedure DragFinish(Drop: THandle);
procedure DragAcceptFiles(Wnd: HWnd; Accept: Bool);

function ExtractIcon(Inst: THandle; ExeFileName: PChar; IconIndex: Word): HIcon;

{ error values for ShellExecute() beyond the regular WinExec() codes }
const
  se_err_Share = 26;
  se_err_AssocIncomplete = 27;
  se_err_DDETimeout = 28;
  se_err_DDEFail = 29;
  se_err_DDEBusy = 30;
  se_err_NoAssoc = 31;

function ShellExecute(hWnd: HWnd; Operation, FileName, Parameters,
  Directory: PChar; ShowCmd: Integer): THandle;
function FindExecutable(FileName, Directory, Result: PChar): THandle;

implementation

function RegOpenKey;                       external 'SHELL'    index 1;
function RegCreateKey;                     external 'SHELL'    index 2;
function RegCloseKey;                      external 'SHELL'    index 3;
function RegDeleteKey;                     external 'SHELL'    index 4;
function RegSetValue;                      external 'SHELL'    index 5;
function RegQueryValue;                    external 'SHELL'    index 6;
function RegEnumKey;                       external 'SHELL'    index 7;
function DragQueryFile;                    external 'SHELL'    index 11;
function DragQueryPoint;                   external 'SHELL'    index 13;
procedure DragFinish;                      external 'SHELL'    index 12;
procedure DragAcceptFiles;                 external 'SHELL'    index 9;
function ExtractIcon;                      external 'SHELL'    index 34;
function ShellExecute;                     external 'SHELL'    index 20;
function FindExecutable;                   external 'SHELL'    index 21;

end.


