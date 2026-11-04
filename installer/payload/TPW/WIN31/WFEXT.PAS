{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{       Windows File Manager Extensions definitions     }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}


unit WFExt;

interface

uses WinTypes;

const
  Menu_Text_Len   = 40;

  fmMenu_First    = 1;
  fmMenu_Last   = 99;

  fmEvent_Load    = 100;
  fmEvent_Unload    = 101;
  fmEvent_InitMenu  = 102;
  fmEvent_User_Refresh  = 103;
  fmEvent_SelChange = 104;

  fmFocus_Dir   = 1;
  fmFocus_Tree    = 2;
  fmFocus_Drives    = 3;
  fmFocus_Search    = 4;

  fm_GetFocus   = wm_User + $0200;
  fm_GetDriveInfo   = wm_User + $0201;
  fm_GetSelCount    = wm_User + $0202;
  fm_GetSelCountLFN = wm_User + $0203;  { LFN versions are odd }
  fm_GetFileSel   = wm_User + $0204;
  fm_GetFileSellFN  = wm_User + $0205;  { LFN versions are odd }
  fm_Refresh_Windows  = wm_User + $0206;
  fm_Reload_Extensions  = wm_User + $0207;

type
  PFMS_GetFileSel = ^TFMS_GetFileSel;
  TFMS_GetFileSel = record
    wTime: Word;
    wDate: Word;
    dwSize: Longint;
    bAttr: Byte;
    szName: array[0..259] of Char;   { always fully qualified }
  end;

type
  PFMS_GetDriveInfo = ^TFMS_GetDriveInfo;    { for drive }
  TFMS_GetDriveInfo = record
    dwTotalSpace: Longint;
    dwFreeSpace: Longint;
    szPath: array[0..259] of Char;   { current directory }
    szVolume: array[0..13] of Char;    { volume label }
    szShare: array[0..127] of Char;    { if this is a net drive }
  end;

type
  PFMS_Load = ^TFMS_Load;
  TFMS_Load = record
    dwSize: Longint;       { for version checks }
    szMenuName: array[0..Menu_Text_Len - 1] of Char;  { output }
    Menu: HMenu;           { output }
    wMenuDelta: Word;      { input }
  end;

type
  TFM_Ext_Proc = function(Handle: HWnd; w: Word; l: Longint): Longint;
  TFM_UnDelete_Proc = function(Handle: HWnd; P: PChar): Longint;


implementation

end.
