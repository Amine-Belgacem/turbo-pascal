
{*******************************************************}
{                                                       }
{       Turbo Pascal                                    }
{       Borland Custom Control Interface Unit           }
{                                                       }
{       Copyright (c) 1991 Borland International        }
{                                                       }
{*******************************************************}

unit BWCC;

interface

uses WinTypes, WObjects;

const
  BwccVersion = $0100;

  { BWCC Custom Dialog class }
  BorDlgClass = 'BorDlg';

  { Borland dialog window property for instance data }
  BorDlgProp = 'FB';

  idHelp = 998;                      { Id of help button }

  { Button style definitions:
    the Borland buttons use Windows button styles for button type: i.e.
    bs_PushButton/bs_DefPushButton }

  button_Class = 'BorBtn';           { Our Bitmap Buttons }
  radio_Class  = 'BorRadio';         { Our radio buttons }
  check_Class  = 'BorCheck';         { Our Checkboxes }

  { Styles }
  bbs_Bitmap: Longint = $8000;       { this is a bitmap static }
  bbs_DlgPaint: Longint = $4000;     { used at runtime by dialog class }
  bbs_ParentNotify: Longint =$2000;  { Notify parent of TAB keys and focus }
  bbs_OwnerDraw: Longint = $1000;    { let parent paint via wm_DrawItem }

  { Messages }
  bbm_SetBits = bm_SetStyle + 10;

  { Notifications }
  bbn_SetFocus = bn_DoubleClicked + 10;
  bbn_SetFocusmouse = bn_DoubleClicked + 11;
  bbn_GotaTab = bn_DoubleClicked + 12;
  bbn_GotaBTab = bn_DoubleClicked + 13;

  shade_Class = 'BorShade';

  bss_Group = 1;  	  {  group box              }
  bss_Hdip = 2;   	  {  horizontal border      }
  bss_Vdip = 3;   	  {  hertical border        }
  bss_Hbump = 4;  	  {  horizontal speed bump  }
  bss_Vbump = 5;  	  {  vertical speed bump    }

  bss_DlgErase = $8000;   {  Dialog Window erases for us }
  bss_DlgPaint = $4000;   {  Dialog Window paints for us }

  static_Class = 'BorStatic';

function DialogBox(Instance: THandle; Templatename: PChar;
  WndParent: HWnd; DialogFunc: TFarProc): Integer;
function DialogBoxParam(Instance: THandle; TemplateName: PChar;
  WndParent: HWnd; DialogFunc: TFarProc; InitParam: LongInt): Integer;
function CreateDialog(Instance: THandle; TemplateName: PChar;
  WndParent: HWnd; DialogFunc: TFarProc): HWnd;
function CreateDialogParam(Instance: THandle; TemplateName: PChar;
  WndParent: HWnd; DialogFunc: TFarProc; InitParam: LongInt): HWnd;
function BWCCMessageBox(WndParent: HWnd; Txt, Caption: PChar;
  TextType: Word): Integer;
function BWCCDefDlgProc(Dlg: HWnd; Msg, wParam: Word; lParam:
  LongInt): LongInt;
function BWCCGetPattern: HBrush;
function BWCCGetVersion: Word;
function SpecialLoadDialog(hResMod: THandle; Templatename: PChar;
  DialogFunc: TFarProc): THandle;
function MangleDialog(hDlg: THandle; hResMod: THandle;
  DialogFunc: TFarProc): THandle;
function BWCCDefWindowProc(hWindow: HWnd; Message, wParam: Word;
  lParam: LongInt): LongInt;
function BWCCDefMDIChildProc(hWindow: HWnd; Message, wParam: Word;
  lParam: LongInt): LongInt;

implementation

function SpecialLoadDialog;             external 'BWCC' index 1;
function DialogBox;                     external 'BWCC' index 2;
function DialogBoxParam;                external 'BWCC' index 3;
function CreateDialog;                  external 'BWCC' index 4;
function CreateDialogParam;             external 'BWCC' index 5;
function BWCCDefDlgProc;                external 'BWCC' index 6;
function BWCCMessageBox;                external 'BWCC' index 9;
function BWCCGetPattern;                external 'BWCC' index 10;
function BWCCGetVersion;                external 'BWCC' index 11;
function MangleDialog;                  external 'BWCC' index 12;
function BWCCDefWindowProc;             external 'BWCC' index 14;
function BWCCDefMDIChildProc;           external 'BWCC' index 15;

begin
  WObjects.CreateDialogParam := CreateDialogParam;
  WObjects.DialogBoxParam := DialogBoxParam;
  WObjects.DefDlgProc := BWCCDefDlgProc;
  WObjects.MessageBox := BWCCMessageBox;
  WObjects.BWCCClassNames := True;
end.
