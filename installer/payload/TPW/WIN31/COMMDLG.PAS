
{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit CommDlg;

interface

uses WinTypes;

type
  POpenFilename = ^TOpenFilename;
  TOpenFilename = record
    lStructSize: Longint;
    hWndOwner: HWnd;
    hInstance: THandle;
    lpstrFilter: PChar;
    lpstrCustomFilter: PChar;
    nMaxCustFilter: Longint;
    nFilterIndex: Longint;
    lpstrFile: PChar;
    nMaxFile: Longint;
    lpstrFileTitle: PChar;
    nMaxFileTitle: Longint;
    lpstrInitialDir: PChar;
    lpstrTitle: PChar;
    Flags: Longint;
    nFileOffset: Word;
    nFileExtension: Word;
    lpstrDefExt: PChar;
    lCustData: Longint;
    lpfnHook: function (Wnd: HWnd; Msg, wParam: Word; lParam: Longint): Word;
    lpTemplateName: PChar;
  end;

function GetOpenFileName(var OpenFile: TOpenFilename): Bool;
function GetSaveFileName(var OpenFile: TOpenFilename): Bool;
function GetFileTitle(FileName, Title: PChar; TitleSize: Word): Integer;

const
  ofn_ReadOnly = $00000001;
  ofn_OverWritePrompt = $00000002;
  ofn_HideReadOnly = $00000004;
  ofn_NoChangeDir = $00000008;
  ofn_ShowHelp = $00000010;
  ofn_EnableHook = $00000020;
  ofn_EnableTemplate = $00000040;
  ofn_EnableTemplateHandle = $00000080;
  ofn_NoValidate = $00000100;
  ofn_AllowMultiSelect = $00000200;
  ofn_ExtentionDifferent = $00000400;
  ofn_PathMustExist = $00000800;
  ofn_FileMustExist = $00001000;
  ofn_CreatePrompt = $00002000;
  ofn_ShareAware = $00004000;
  ofn_NoReadOnlyReturn = $00008000;
  ofn_NoTextFileCreate = $00010000;

{ Return values for the registered message sent to the hook function
  when a sharing violation occurs.  ofn_ShareFallThrough allows the
  filename to be accepted, ofn_ShareNoWarn rejects the name but puts
  up no warning (returned when the app has already put up a warning
  message), and ofn_ShareWarn puts up the default warning message
  for sharing violations.

  Note:  Undefined return values map to ofn_ShareWarn. }

  ofn_ShareFallThrough = 2;
  ofn_ShareNoWarn = 1;
  ofn_ShareWarn = 0;

type
  PChooseColor = ^TChooseColor;
  TChooseColor = record
    lStructSize: Longint;
    hWndOwner: HWnd;
    hInstance: HWnd;
    rgbResult: Longint;
    lpCustColors: PLongint;
    Flags: Longint;
    lCustData: Longint;
    lpfnHook: function (Wnd: HWnd; Message, wParam: Word;
     lParam: Longint): Word;
    lpTemplateName: PChar;
  end;

function ChooseColor(var CC: TChooseColor): Bool;

const
  cc_RGBInit = $00000001;
  cc_FullOpen = $00000002;
  cc_PreventFullOpen = $00000004;
  cc_ShowHelp = $00000008;
  cc_EnableHook = $00000010;
  cc_EnableTemplate = $00000020;
  cc_EnableTemplateHandle = $00000040;

type
  PFindReplace = ^TFindReplace;
  TFindReplace = record
    lStructSize: Longint;        { size of this struct $20 }
    hWndOwner: HWnd;              { handle to owner's window }
    hInstance: THandle;           { instance handle of.EXE that
                                   contains cust. dlg. template }
    Flags: Longint;              { one or more of the fr_?? }
    lpstrFindWhat: PChar;        { ptr. to search string    }
    lpstrReplaceWith: PChar;     { ptr. to replace string   }
    wFindWhatLen: Word;          { size of find buffer      }
    wReplaceWithLen: Word;       { size of replace buffer   }
    lCustData: Longint;          { data passed to hook fn.  }
    lpfnHook: function (Wnd: HWnd; Msg, wParam: Word; lParam: Longint): Word;
                                 { ptr. to hook fn. or nil }
    lpTemplateName: PChar;       { custom template name     }
  end;

const
  fr_Down = $00000001;
  fr_WholeWord = $00000002;
  fr_MatchCase = $00000004;
  fr_FindNext = $00000008;
  fr_Replace = $00000010;
  fr_ReplaceAll = $00000020;
  fr_DialogTerm = $00000040;
  fr_ShowHelp = $00000080;
  fr_EnableHook = $00000100;
  fr_EnableTemplate = $00000200;
  fr_NoUpDown = $00000400;
  fr_NoMatchCase = $00000800;
  fr_NoWholeWord = $00001000;
  fr_EnableTemplateHandle = $00002000;
  fr_HideUpDown = $00004000;
  fr_HideMatchCase = $00008000;
  fr_HideWholeWord = $00010000;

function FindText(var FindReplace: TFindReplace): HWnd;
function ReplaceText(var FindReplace: TFindReplace): HWnd;

type
  PChooseFont = ^TChooseFont;
  TChooseFont = record
    lStructSize: Longint;       { }
    hWndOwner: HWnd;             { caller's window handle   }
    hDC: HDC;                    { printer DC/IC or nil    }
    lpLogFont: PLogFont;        { ptr. to a LOGFONT struct }
    iPointSize: Integer;                { 10 * size in points of selected font }
    Flags: Longint;             { enum. type flags          }
    rgbColors: Longint;         { returned text color       }
    lCustData: Longint;         { data passed to hook fn.  }
    lpfnHook: function (Wnd: HWnd; Msg, wParam: Word; lParam: Longint): Word;
                                { ptr. to hook function    }
    lpTemplateName: PChar;      { custom template name     }
    hInstance: THandle;          { instance handle of.EXE that
                                  contains cust. dlg. template }
    lpszStyle: PChar;           { return the style field here
                                  must be lf_FaceSize or bigger }
    nFontType: Word;            { same value reported to the EnumFonts
                                  call back with the extra fonttype_
                                  bits added }
    nSizeMin: Integer;          { minimum pt size allowed & }
    nSizeMax: Integer;          { max pt size allowed if
                                  cf_LimitSize is used      }
  end;

function ChooseFont(var ChooseFond: TChooseFont): Bool;

const
  cf_ScreenFonts = $00000001;
  cf_PrinterFonts = $00000002;
  cf_Both = cf_ScreenFonts or cf_PrinterFonts;
  cf_ShowHelp = $00000004;
  cf_EnableHook = $00000008;
  cf_EnableTemplate = $00000010;
  cf_EnableTemplateHandle = $00000020;
  cf_InitToLogfontStruct = $00000040;
  cf_UseStyle = $00000080;
  cf_Effects = $00000100;
  cf_Apply = $00000200;
  cf_AnsiOnly = $00000400;
  cf_NoVectorFonts = $00000800;
  cf_NoOEMFonts = cf_NoVectorFonts;
  cf_NoSimulations = $00001000;
  cf_LimitSize = $00002000;
  cf_FixedPitchOnly = $00004000;
  cf_WYSIWYG = $00008000; { must also have cf_ScreenFonts & cf_PrinterFonts }
  cf_ForceFontExist = $00010000;
  cf_ScalableOnly = $00020000;
  cf_TTOnly = $00040000;
  cf_NoFaceSel = $00080000;
  cf_NoStyleSel = $00100000;
  cf_NoSizeSel = $00200000;

{ these are extra nFontType bits that are added to what is returned to the
  EnumFonts callback routine }

  Simulated_FontType = $8000;
  Printer_FontType = $4000;
  Screen_FontType = $2000;
  Bold_FontType = $0100;
  Italic_FontType = $0200;
  Regular_FontType = $0400;

  wm_ChooseFont_GetLogfont = wm_User + 1;


{ strings used to obtain unique window message for communication
  between dialog and caller }

  LBSelChString = 'commdlg_LBSelChangedNotify';
  ShareViString = 'commdlg_ShareViolation';
  FileOKString = 'commdlg_FileNameOK';
  ColorOKString = 'commdlg_ColorOK';
  SetRGBString = 'commdlg_SetRGBColor';
  FindMsgString = 'commdlg_FindReplace';
  HelpMsgString = 'commdlg_help';

{ HIWORD values for lParam of commdlg_LBSelChangeNotify message }

const
  cd_LBSelNoItems = -1;
  cd_LBSelChange  = 0;
  cd_LBSELSUB     = 1;
  cd_LBSelAdd     = 2;

type
  PPrintDlg = ^TPrintDlg;
  TPrintDlg = record
    lStructSize: Longint;
    hWndOwner: HWnd;
    hDevMode: THandle;
    hDevNames: THandle;
    hDC: HDC;
    Flags: Longint;
    nFromPage: Word;
    nToPage: Word;
    nMinPage: Word;
    nMaxPage: Word;
    nCopies: Word;
    hInstance: THandle;
    lCustData: Longint;
    lpfnPrintHook: function (Wnd: HWnd; Msg, wParam: Word;
      lParam: Longint): Integer;
    lpfnSetupHook: function (Wnd: HWnd; Msg, wParam: Word;
      lParam: Longint): Integer;
    lpPrintTemplateName: PChar;
    lpSetupTemplateName: PChar;
    hPrintTemplate: THandle;
    hSetupTemplate: THandle;
  end;

function PrintDlg(var PrintDlg: TPrintDlg): Bool;

const
  pd_AllPages = $00000000;
  pd_Selection = $00000001;
  pd_PageNums = $00000002;
  pd_NoSelection = $00000004;
  pd_NoPageNums = $00000008;
  pd_Collate = $00000010;
  pd_PrintToFile = $00000020;
  pd_PrintSetup = $00000040;
  pd_NoWarning = $00000080;
  pd_ReturnDC = $00000100;
  pd_ReturnIC = $00000200;
  pd_ReturnDefault = $00000400;
  pd_ShowHelp = $00000800;
  pd_EnablePrintHook = $00001000;
  pd_EnableSetupHook = $00002000;
  pd_EnablePrintTemplate = $00004000;
  pd_EnableSetupTemplate = $00008000;
  pd_EnablePrintTemplateTHandle = $00010000;
  pd_EnableSetupTemplateTHandle = $00020000;
  pd_UseDevModeCopies = $00040000;
  pd_DisablePrintToFile = $00080000;
  pd_HidePrintToFile = $00100000;

type
  PDevNames = ^TDevNames;
  TDevNames = record
    wDriverOffset: Word;
    wDeviceOffset: Word;
    wOutputOffset: Word;
    wDefault: Word;
  end;

const
  dn_DefaultPrn = $0001;

function CommDlgExtendedError: Longint;

const
  cderr_DialogFailure    = $FFFF;

  cderr_GeneralCodes     = $0000;
  cderr_StructSize       = $0001;
  cderr_Initialization   = $0002;
  cderr_NoTemplate       = $0003;
  cderr_NoHInstance      = $0004;
  cderr_LoadStrFailure   = $0005;
  cderr_FindResFailure   = $0006;
  cderr_LoadResFailure   = $0007;
  cderr_LockResFailure   = $0008;
  cderr_MemAllocFailure  = $0009;
  cderr_MemLockFailure   = $000A;
  cderr_NoHook           = $000B;
  cderr_RegisterMsgFail  = $000C;

  pderr_PrinterCodes     = $1000;
  pderr_SetupFailure     = $1001;
  pderr_ParseFailure     = $1002;
  pderr_RetDefFailure    = $1003;
  pderr_LoadDrvFailure   = $1004;
  pderr_GetDevModeFail   = $1005;
  pderr_InitFailure      = $1006;
  pderr_NoDevices        = $1007;
  pderr_NoDefaultPrn     = $1008;
  pderr_DNDMMismatch     = $1009;
  pderr_CreateICFailure  = $100A;
  pderr_PrinterNotFound  = $100B;
  pderr_DefaultDifferent = $100C;

  cferr_ChooseFontCodes  = $2000;
  cferr_NoFonts          = $2001;
  cferr_MaxLessThanMin   = $2002;

  fnErr_FilenameCodes    = $3000;
  fnErr_SubclassFailure  = $3001;
  fnErr_InvalidFilename  = $3002;
  fnErr_BufferTooSmall   = $3003;

  frErr_FindReplaceCodes = $4000;
  frErr_BufferLengthZero = $4001;

  ccErr_ChooseColorCodes = $5000;

implementation

function GetOpenFileName;                  external 'COMMDLG'  index 1;
function GetSaveFileName;                  external 'COMMDLG'  index 2;
function GetFileTitle;                     external 'COMMDLG'  index 27;
function ChooseColor;                      external 'COMMDLG'  index 5;
function FindText;                         external 'COMMDLG'  index 11;
function ReplaceText;                      external 'COMMDLG'  index 12;
function ChooseFont;                       external 'COMMDLG'  index 15;
function PrintDlg;                         external 'COMMDLG'  index 20;
function CommDlgExtendedError;             external 'COMMDLG'  index 26;

end.

