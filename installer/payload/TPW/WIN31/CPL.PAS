{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{       Control panel extension DLL definitions         }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}
{******************************************************************************
*  General rules for being installed in the Control Panel:
*
*      1) The DLL must export a function named CPlApplet which will handle
*         the messages discussed below.
*      2) If the applet needs to save information in CONTROL.INI minimize
*         clutter by using the application name [MMCPL.appletname].
*      2) If the applet is referenced in CONTROL.INI under [MMCPL] use
*         the following form:
*              ...
*              [MMCPL]
*              uniqueName=c:\mydir\myapplet.dll
*              ...
*
*
*  The order applet DLL's are loaded by CONTROL.EXE is:
*
*      1) MAIN.CPL is loaded from the windows system directory.
*
*      2) Installable drivers that are loaded and export the
*         CplApplet() routine.
*
*      3) DLL's specified in the [MMCPL] section of CONTROL.INI.
*
*      4) DLL's named *.CPL from windows system directory.
*
}

{
 * CONTROL.EXE will answer this message and launch an applet
 *
 * WM_CPL_LAUNCH
 *
 *      wParam      - window handle of calling app
 *      lParam      - LPSTR of name of applet to launch
 *
 * WM_CPL_LAUNCHED
 *
 *      wParam      - TRUE/FALSE if applet was launched
 *      lParam      - NULL
 *
 * CONTROL.EXE will post this message to the caller when the applet returns
 * (ie., when wParam is a valid window handle)
 *
 }

unit Cpl;

interface

uses WinTypes;

const
  wm_CPL_Launch   = wm_User+1000;
  wm_CPL_Launched = wm_User+1001;

{ A function prototype for CPlApplet() }

type
  TApplet_Proc = function(hWndCpl: HWnd; msg: Word;
    lParam1, lParam2: Longint): Longint;

{ The data structure CPlApplet() must fill in. }

type
  PCPLInfo = ^TCPLInfo;
  TCPLInfo = record
    idIcon: Integer;     { icon resource id, provided by CPlApplet() }
    idName: Integer;     { name string res. id, provided by CPlApplet() }
    idInfo: Integer;     { info string res. id, provided by CPlApplet() }
    lData: Longint;      { user defined data }
  end;

type
  PNewCPLInfo = ^TNewCPLInfo;
  TNewCPLInfo = record
    dwSize: Longint;                   { similar to the commdlg }
    dwFlags: Longint;
    dwHelpContext: Longint;            { help context to use }
    lData: Longint;                    { user defined data }
    Icon: HIcon;          { icon to use, this is owned by CONTROL.EXE (may be deleted) }
    szName: array[0..31] of Char;      { short name }
    szInfo: array[0..63] of Char;      { long name (status line) }
    szHelpFile: array[0..127] of Char; { path to help file to use }
  end;


{ The messages CPlApplet() must handle: }

const
  cpl_Init        = 1;
{  This message is sent to indicate CPlApplet() was found. }
{  lParam1 and lParam2 are not defined. }
{  Return TRUE or FALSE indicating whether the control panel should proceed. }


const
  cpl_GetCount    = 2;
{  This message is sent to determine the number of applets to be displayed. }
{  lParam1 and lParam2 are not defined. }
{  Return the number of applets you wish to display in the control }
{  panel window. }


const
  cpl_Inquire     = 3;
{  This message is sent for information about each applet. }
{  lParam1 is the applet number to register, a value from 0 to }
{  (CPL_GETCOUNT - 1).  lParam2 is a far ptr to a CPLINFO structure. }
{  Fill in CPL_INFO's idIcon, idName, idInfo and lData fields with }
{  the resource id for an icon to display, name and description string ids, }
{  and a long data item associated with applet #lParam1. }


const
  cpl_Select      = 4;
{  This message is sent when the applet's icon has been clicked upon. }
{  lParam1 is the applet number which was selected.  lParam2 is the }
{  applet's lData value. }


const
  cpl_DblClk      = 5;
{  This message is sent when the applet's icon has been double-clicked }
{  upon.  lParam1 is the applet number which was selected.  lParam2 is the }
{  applet's lData value. }
{  This message should initiate the applet's dialog box. }


const
  cpl_Stop        = 6;
{  This message is sent for each applet when the control panel is exiting. }
{  lParam1 is the applet number.  lParam2 is the applet's lData  value. }
{  Do applet specific cleaning up here. }


const
  cpl_Exit        = 7;
{  This message is sent just before the control panel calls FreeLibrary. }
{  lParam1 and lParam2 are not defined. }
{  Do non-applet specific cleaning up here. }


const
  cpl_NewInquire  = 8;
{ this is the same as CPL_INQUIRE execpt lParam2 is a pointer to a }
{ NEWCPLINFO structure.  this will be sent before the CPL_INQUIRE }
{ and if it is responed to (return <> 0) CPL_INQUIRE will not be sent }

implementation

end.


