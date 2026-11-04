
{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit Win31;

interface

uses WinTypes;

const
  rt_Group_Cursor     = rt_Cursor + Difference;
  rt_Group_Icon       = rt_Icon + Difference;

const
  err_Warning   = $8000;
  err_Param     = $4000;

  err_Size_Mask   = $3000;
  err_Byte        = $1000;
  err_Word        = $2000;
  err_DWord       = $3000;

{***** LogParamError() values }

{ Generic parameter values }
  err_Bad_Value      = $6001;
  err_Bad_Flags      = $6002;
  err_Bad_Index      = $6003;
  err_Bad_DValue     = $7004;
  err_Bad_DFlags     = $7005;
  err_Bad_DIndex     = $7006;
  err_Bad_Ptr        = $7007;
  err_Bad_Func_Ptr   = $7008;
  err_Bad_Selector   = $6009;
  err_Bad_String_ptr = $700a;
  err_Bad_Handle     = $600b;

{ KERNEL parameter errors }
  err_Bad_HInstance       = $6020;
  err_Bad_HModule         = $6021;
  err_Bad_Global_Handle   = $6022;
  err_Bad_Local_Handle    = $6023;
  err_Bad_Atom            = $6024;
  err_Bad_Hfile           = $6025;

{ USER parameter errors }
  err_Bad_HWnd            = $6040;
  err_Bad_HMenu           = $6041;
  err_Bad_HCursor         = $6042;
  err_Bad_HIcon           = $6043;
  err_Bad_HDWP            = $6044;
  err_Bad_CID             = $6045;
  err_Bad_HDrvr           = $6046;

{ GDI parameter errors }
  err_Bad_COORDS    = $7060;
  err_Bad_GDI_OBJECT      = $6061;
  err_Bad_HDC             = $6062;
  err_Bad_HPEN            = $6063;
  err_Bad_HFONT           = $6064;
  err_Bad_HBRUSH          = $6065;
  err_Bad_HBITMAP         = $6066;
  err_Bad_HRGN            = $6067;
  err_Bad_HPALETTE        = $6068;
  err_Bad_HMETAFILE       = $6069;

{**** LogError() values }

{ KERNEL errors }
  err_GAlloc              = $0001;
  err_GRealloc            = $0002;
  err_GLock               = $0003;
  err_LAlloc              = $0004;
  err_LRealloc            = $0005;
  err_LLock               = $0006;
  err_ALlocres            = $0007;
  err_LockRes             = $0008;
  err_LoadModule          = $0009;

{ USER errors }
  err_CreateDlg           = $0040;
  err_CreateDlg2          = $0041;
  err_RegisterClass       = $0042;
  err_DCBusy              = $0043;
  err_CreateWnd           = $0044;
  err_StrucExtra          = $0045;
  err_LoadStr             = $0046;
  err_LoadMenu            = $0047;
  err_NestedBeginPaint    = $0048;
  err_BadIndex            = $0049;
  err_CreateMenu          = $004a;

{ GDI errors }
  err_CreateDC            = $0080;
  err_CreateMeta          = $0081;
  err_DelObjSelected      = $0082;
  err_SelBitmap           = $0083;

const
{ WINDEBUGINFO flags values }
  wdi_Options         = $0001;
  wdi_Filter          = $0002;
  wdi_AllocBreak      = $0004;

{ dwOptions values }
  dbo_CheckHeap       = $0001;
  dbo_BufferFill      = $0004;
  dbo_DisableGPTrapping = $0010;
  dbo_CheckFree       = $0020;

  dbo_Silent          = $8000;

  dbo_TraceBreak      = $2000;
  dbo_WarningBreak    = $1000;
  dbo_NoErrorBreak    = $0800;
  dbo_NofatalBreak    = $0400;
  dbo_INT3Break       = $0100;

{ DebugOutput flags values }
  dbf_Trace           = $0000;
  dbf_Warning         = $4000;
  dbf_Error           = $8000;
  dbf_Fatal           = $c000;

{ dwFilter values }
  dbf_Kernel          = $1000;
  dbf_Krn_MemMan      = $0001;
  dbf_Krn_LoadModule  = $0002;
  dbf_Krn_SegmentLoad = $0004;
  dbf_User            = $0800;
  dbf_GDI             = $0400;
  dbf_MMSystem        = $0040;
  dbf_Penwin          = $0020;
  dbf_Application     = $0008;
  dbf_Driver          = $0010;

const
  ew_RebootSystem   = $43;

{ SetErrorMode() constants }
  sem_FailCriticalErrors  = $0001;
  sem_NoGPFaultErrorBox   = $0002;
  sem_NoOpenFileErrorBox  = $8000;

const
  hInstance_Error = THandle(32);

const
  of_Verify     = $0400;      { Used with OF_REOPEN }

{ _llseek origin values }
const
  seek_set = 0;
  seek_cur = 1;
  seek_end = 2;

const
{ Errors }
  wn_Success       = $0000;
  wn_Not_Supported = $0001;
  wn_Net_Error     = $0002;
  wn_More_Data     = $0003;
  wn_Bad_Pointer   = $0004;
  wn_Bad_Value     = $0005;
  wn_Bad_Password  = $0006;
  wn_Access_Denied = $0007;
  wn_Function_Busy = $0008;
  wn_Windows_Error = $0009;
  wn_Bad_User      = $000A;
  wn_Out_Of_Memory = $000B;
  wn_Cancel        = $000C;
  wn_Continue      = $000D;

{ Connection errors }
  wn_Not_Connected     = $0030;
  wn_Open_Files        = $0031;
  wn_Bad_Netname       = $0032;
  wn_Bad_Localname     = $0033;
  wn_Already_Connected = $0034;
  wn_Device_Error      = $0035;
  wn_Connection_Closed = $0036;

const
  cc_RoundRect        = $0100;
  cp_Region           = $0002;

const
  rc_GDI20_State      = $0020;
  rc_SaveBitmap       = $0040;
  rc_OP_DX_Output     = $4000;
  rc_DevBits          = $8000;

const
  Default_Charset     = 1;
  Hangeul_Charset     = 129;
  ChineseBig5_Charset = 136;

{ OutPrecision values }
const
  out_TT_Precis   = 4;
  out_Device_Precis = 5;
  out_Raster_Precis = 6;
  out_TT_Only_Precis  = 7;

{ ClipPrecision values }
const
  clip_Mask   = $0F;
  clip_LH_Angles    = $10;
  clip_TT_Always    = $20;
  clip_Embedded   = $80;

{ tmPitchAndFamily values }
const
  tmpf_Fixed_Pitch    = $01;
  tmpf_Vector     = $02;
  tmpf_Device     = $08;
  tmpf_Truetype     = $04;

{ new StretchBlt() Modes (simpler names) }
const
  stretch_ANDScans        = 1;
  stretch_ORScans         = 2;
  stretch_DeleteScans     = 3;

{ Metafile Functions }
const
  meta_StretchDIB        = $0f43;
  meta_ExtFloodFill        = $0548;

  meta_ResetDC         = $014C;
  meta_StartDoc        = $014D;
  meta_StartPage         = $004F;
  meta_EndPage         = $0050;
  meta_AbortDoc        = $0052;
  meta_EndDoc        = $005E;

  GetFaceName        = 513;

{ wm_Size message wParam values }

const
  size_Restored = 0;
  size_Minimized = 1;
  size_Maximized = 2;
  size_MaxShow = 3;
  size_MaxHide = 4;

{ wm_KeyUp/Down/Char HiWord(lParam) flags }

  kf_Extended = $0100;
  kf_DLGMode = $0800;
  kf_MenuMode = $1000;
  kf_AltDown = $2000;
  kf_Repeat = $4000;
  kf_Up = $8000;

{ wm_Activate state values }

  wa_Inactive = 0;
  wa_Active = 1;
  wa_ClickActive = 2;

{ Dialog window class }

  wc_Dialog = MakeIntAtom($8002);

{ Get/SetWindowWord/Long offsets for use with wc_Dialog windows }

  dwl_MsgResult = 0;
  dwl_DLGProc = 4;
  dwl_User = 8;

{ Redefined wm_NCHitTest return values }

  htMinButton = 8;
  htMaxButton = 9;
  htBorder = 18;

{ Special HWND value for use with PostMessage() and SendMessage() }
const
  hWnd_Broadcast  = $FFFF;

  wh_MsgFilter = -1;


{ CallMsgFilter() and WH_SYS/MSGFILTER context codes }
const
  msgf_MainLoop            = 8;
  msgf_User                = 4096;

{***** Power management ***************************************************}
const
  wm_Power      = $0048;

{ wParam for WM_POWER window message and DRV_POWER driver notification }
  pwr_Ok              = 1;
  pwr_Fail            = -1;
  pwr_SuspendRequest  = 1;
  pwr_SuspendResume   = 2;
  pwr_CriticalResume  = 3;

const
  wm_SystemError = $0017;

const
  gcw_Atom = -32;

{ WM_SHOWWINDOW wParam codes }
const
  sw_OtherMaximized   = 2;
  sw_OtherRestored    = 4;


{ Special value for CreateWindow, et al. }
const
  hWnd_Desktop = 0;

const
  wf_Paging = $0800;
  wf_WLO = $8000;

  obm_UpArrowI = 32737;
  obm_DnArrowI = 32736;
  obm_RgArrowI = 32735;
  obm_LfArrowI = 32734;

  MouseTrails = 39;

  GetSetScreenParams = 800;


{ Network support }

function WNetAddConnection(lpszNetPath, lpszPassword,
  lpszLocalName: PChar): Word;
function WNetGetConnection(lpszLocalName, lpszRemoteName: PChar;
  cbBufferSize: PWord): Word;
function WNetCancelConnection(lpszName: PChar; tForce: Bool): Word;


type
  PNewTextMetric = ^TNewTextMetric;
  TNewTextMetric = record
    tmHeight: Integer;
    tmAscent: Integer;
    tmDescent: Integer;
    tmInternalLeading: Integer;
    tmExternalLeading: Integer;
    tmAveCharWidth: Integer;
    tmMaxCharWidth: Integer;
    tmWeight: Integer;
    tmItalic: Byte;
    tmUnderlined: Byte;
    tmStruckOut: Byte;
    tmFirstChar: Byte;
    tmLastChar: Byte;
    tmDefaultChar: Byte;
    tmBreakChar: Byte;
    tmPitchAndFamily: Byte;
    tmCharSet: Byte;
    tmOverhang: Integer;
    tmDigitizedAspectX: Integer;
    tmDigitizedAspectY: Integer;
    ntmFlags: Longint;			{ various flags (fsSelection) }
    ntmSizeEM: Word;			{ size of EM }
    ntmCellHeight: Word; 		{ height of font in notional units }
    ntmAvgWidth: Word;      { average width in notional units }
  end;

const
  ntm_Regular = $00000040;	{ possible ntmFlags bits }
  ntm_Bold = $00000020;
  ntm_Italic = $00000001;

  lf_FullFaceSize = 64;

type
  PEnumLogFont = ^TEnumLogFont;
  TEnumLogFont = record
    elfLogFont: TLogFont;
    elfFullName: array[0..LF_FULLFACESIZE-1] of Char;
    elfStyle: array[0..LF_FACESIZE-1] of Char;
  end;

const
  dcx_Window = $00000001;
  dcx_Cache = $00000002;
  dcx_ClipChildren = $00000008;
  dcx_ClipSiblings = $00000010;
  dcx_ParentClip = $00000020;

  dcx_ExcludeRgn = $00000040;
  dcx_IntersectRgn = $00000080;

  dcx_LockWindowUpdate = $00000400;

  dcx_UseStyle = $00010000;

  dcb_Reset = $0001;
  dcb_Accumulate = $0002;
  dcb_Dirty = dcb_Accumulate;
  dcb_Set = dcb_Reset or dcb_Accumulate;
  dcb_Enable = $0004;
  dcb_Disable = $0008;


const
{ GetGlyphOutline constants }
  ggo_Metrics        = 0;
  ggo_Bitmap         = 1;
  ggo_Native         = 2;

  tt_Polygon_Type   = 24;

  tt_Prim_Line       = 1;
  tt_Prim_QSPLine    = 2;


type
  PPanose = ^TPanose;
  TPanose = record
    bFamilyType: Byte;
    bSerifStyle: Byte;
    bWeight: Byte;
    bProportion: Byte;
    bContrast: Byte;
    bStrokeVariation: Byte;
    bArmStyle: Byte;
    bLetterform: Byte;
    bMidline: Byte;
    bXHeight: Byte;
  end;

  POutlineTextMetric = ^TOutlineTextMetric;
  TOutlineTextMetric = record
    otmSize: Word;		  { I size of this structure		     }
    otmTextMetrics: TTextMetric;	  { regular text metrics		     }
    otmFiller: Byte;		  { want to be word aligned		     }
    otmPanoseNumber: TPanose;	  { Panose number of font		     }
    otmfsSelection: Word;	  { B Font selection flags (see #defines)   }
    otmfsType: Word;		  { B Type indicators	(see #defines)	     }
    otmsCharSlopeRise: Word;	  { Slope angle Rise / Run   1 vertical     }
    otmsCharSlopeRun: Word;	  {			      0 vertical     }
    otmEMSquare: Word;		  { N size of EM			     }
    otmAscent: Word;		  { D ascent above baseline		     }
    otmDescent: Word;		  { D descent below baseline		     }
    otmLineGap: Word;		  { D					     }
    otmCapEmHeight: Word;	  { D height of upper case M		     }
    otmXHeight: Word;		  { D height of lower case chars in font    }
    otmrcFontBox: TRect;		  { D Font bounding box		     }
    otmMacAscent: Word;		  { D ascent above baseline for Mac	     }
    otmMacDescent: Word; 	  { D descent below baseline for Mac	     }
    otmMacLineGap: Word; 	  { D					     }
    otmusMinimumPPEM: Word;	  { D Minimum point ppem		     }
    otmptSubscriptSize: TPoint;	  { D Size of subscript		     }
    otmptSubscriptOffset: TPoint;   { D Offset of subscript		     }
    otmptSuperscriptSize: TPoint;   { D Size of superscript		     }
    otmptSuperscriptOffset: TPoint; { D Offset of superscript		     }
    otmsStrikeoutSize: Word;	  { D Strikeout size			     }
    otmsStrikeoutPosition: Word;   { D Strikeout position		     }
    otmsUnderscoreSize: Word;	  { D Underscore size			     }
    otmsUnderscorePosition: Word;  { D Underscore position		     }
    otmpFamilyName: PChar;	  { offset to family name		     }
    otmpFaceName: PChar;		  { offset to face name		     }
    otmpStyleName: PChar; 	  { offset to Style string		     }
    otmpFullName: PChar;		  { offset to full name		     }
  end;

  PFixed = ^TFixed;
  TFixed = record
    fract: Word;
    value: Integer;
  end;

  PMat2 = ^TMat2;
  TMat2 = record
     eM11: TFixed;
     eM12: TFixed;
     eM21: TFixed;
     eM22: TFixed;
  end;

  PGlyphMetrics = ^TGlyphMetrics;
  TGlyphMetrics = record
    gmBlackBoxX: Word;
    gmBlackBoxY: Word;
    gmptGlyphOrigin: TPoint;
    gmCellIncX: Integer;
    gmCellIncY: Integer;
  end;

  PPointFX = ^TPointFX;
  TPointFX = record
    x: TFixed;
    y: TFixed;
  end;

  PTTPolyCurve = ^TTTPolyCurve;
  TTTPolyCurve = record
    wType: Word;
    cpfx: Word;
    apfx: array[0..0] of TPointFX;
  end;

  PPolygonHeader = ^TPolygonHeader;
  TPolygonHeader = record
    cb: Longint;
    dwType: Longint;
    pfxStart: TPointFX;
  end;

  PABC = ^TABC;
  TABC = record
    abcA: Integer;
    abcB: Word;
    abcC: Integer;
  end;

  PRasterizer_Status = ^TRasterizer_Status;
  TRasterizer_Status = record
    nSize: Integer;
    wFlags: Integer;
    nLanguageID: Integer;
  end;

{ bits defined in wFlags of TRasterizer_Status }
const
  tt_Available = $0001;
  tt_Enabled = $0002;

const
  sb_LineLeft = 0;
  sb_LineRight = 1;
  sb_PageLeft = 2;
  sb_PageRight = 3;
  sb_Left = 6;
  sb_Right = 7;

  esb_Enable_Both = $0000;
  esb_Disable_Both = $0003;

  esb_Disable_Left = $0001;
  esb_Disable_Right = $0002;

  esb_Disable_Up = $0001;
  esb_Disable_Down = $0002;

  esb_Disable_LtUp = esb_Disable_Left;
  esb_Disable_RtDn = esb_Disable_Right;

  vk_F17 = $80;
  vk_F18 = $81;
  vk_F19 = $82;
  vk_F20 = $83;
  vk_F21 = $84;
  vk_F22 = $85;
  vk_F23 = $86;
  vk_F24 = $87;
  vk_Scroll = $91;

  wm_CommNotify = $0044;

  wm_WindowPosChanging = $0046;
  wm_WindowPosChanged = $0047;
  wm_DropFiles = $0233;

  wm_PenWinFirst = $0380;
  wm_PenWinLast = $038F;

  wm_Coalesce_First = $0390;
  wm_Coalesce_Last = $039F;

type
  { wm_WindowPosChanging/Changed record pointed to by lParam }
  PWindowPos = ^TWindowPos;
  TWindowPos = record
    hWnd: HWnd;
    hWndInsertAfter: HWnd;
    x: Integer;
    y: Integer;
    cx: Integer;
    cy: Integer;
    flags: Word;
  end;

  PNCCalcSize_Params = ^TNCCalcSize_Params;
  TNCCalcSize_Params = record
    rgrc: array[0..2] of TRect;
    lppos: PWindowPos;
  end;

const
  { wm_NCCalcSize "window valid rect" return values }
  wvr_AlignTop = $0010;
  wvr_AlignLeft = $0020;
  wvr_AlignBottom = $0040;
  wvr_AlignRight = $0080;
  wvr_HRedraw = $0100;
  wvr_VRedraw = $0200;
  wvr_Redraw = wvr_HRedraw or wvr_VRedraw;
  wvr_ValidTRectS = $0400;


  ma_NOActivateAndEat = 4;

  ws_ex_TopMost = $00000008;
  ws_ex_AcceptFiles = $00000010;
  ws_ex_Transparent = $00000020;

  cf_PenData = 10;
  cf_RIFF = 11;
  cf_Wave = 12;

  { Special HWnd values for SetWindowPos() hwndInsertAfter }
  hwnd_Top = HWnd(0);
  hwnd_Bottom = HWnd(1);
  hwnd_TopMost = HWnd(-1);
  hwnd_NoTopMost = HWnd(-2);

  { GetQueueStatus flags }
  qs_Key = $0001;
  qs_MouseMove = $0002;
  qs_MouseButton = $0004;
  qs_Mouse = qs_MouseMove or qs_MouseButton;
  qs_PostMessage = $0008;
  qs_Timer = $0010;
  qs_Paint = $0020;
  qs_SendMessage = $0040;
  qs_AllInput = $007F;

  sm_CXDoubleClk = 36;
  sm_CYDoubleClk = 37;
  sm_CXIconSpacing = 38;
  sm_CYIconSpacing = 39;
  sm_MenuDropAlignment = 40;
  sm_PenWindows = 41;
  sm_DBCSEnabled = 42;

  sm_CMetrics = 43; { this overrides WINTYPES.PAS }


  { Flags for TrackPopupMenu }
  tpm_LeftButton = $0000;

  tpm_RightButton = $0002;
  tpm_LeftAlign = $0000;
  tpm_CenterAlign = $0004;
  tpm_RightAlign = $0008;

  { RedrawWindow() flags }
  rdw_Invalidate = $0001;
  rdw_InternalPaint = $0002;
  rdw_Erase = $0004;

  rdw_Validate = $0008;
  rdw_NoInternalPaint = $0010;
  rdw_NoErase = $0020;

  rdw_NoChildren = $0040;
  rdw_AllChildren = $0080;

  rdw_UpdateNow = $0100;
  rdw_EraseNow = $0200;
  rdw_Frame = $0400;
  rdw_NoFrame = $0800;

  sw_ScrollChildren = $0001;  { Scroll children within *lprcScroll. }
  sw_Invalidate = $0002;  { Invalidate after scrolling }
  sw_Erase = $0004;  { If sw_Invalidate, don't send wm_EraseBackground }

  color_InactiveCaptionText = 19;
  color_BtnHighlight = 20;


type
  HHook = Longint;
  THookProc = function (Code: Integer; wParam: Word; lParam: Longint): Longint;

const
  wh_CBT = 5;
  wh_SysMsgFilter = 6;
  wh_Mouse = 7;
  wh_Hardware = 8;
  wh_Debug = 9;
  wh_Shell = 10;

  hshell_WindowCreated = 1;
  hshell_WindowDestroyed = 2;
  hshell_ActivateShellWindow = 3;

  { CBT Hook Codes }
  hcbt_MoveSize = 0;
  hcbt_MinMax = 1;
  hcbt_QS = 2;
  hcbt_CreateWnd = 3;
  hcbt_DestroyWnd = 4;
  hcbt_Activate = 5;
  hcbt_ClickSkipped = 6;
  hcbt_KeySkipped = 7;
  hcbt_SysCommAnd = 8;
  hcbt_SetFocus = 9;

type
  { hcbt_CreateWnd parameters pointed to by lParam }
  PCBT_CreateWnd = ^TCBT_CreateWnd;
  TCBT_CreateWnd = record
    lpcs: PCreateStruct;
    hWndInsertAfter: HWnd;
  end;

  PMouseHookStruct = ^TMouseHookStruct;
  TMouseHookStruct = record
    pt: TPoint;
    hWnd: HWnd;
    wHitTestCode: Word;
    dwExtraInfo: Longint;
  end;

  PCBTActivateStruct = ^TCBTActivateStruct;
  TCBTActivateStruct = record
    fMouse: Bool;
    hWndActive: HWnd;
  end;

  PHardwareHookStruct = ^THardwareHookStruct;
  THardwareHookStruct = record
    hWnd: HWnd;
    wMessage: Word;
    wParam: Word;
    lParam: Longint;
  end;

  { Message Structure used in Journaling }
  PEventMsg = TEventMsg;
  TEventMsg = record
    message: Word;
    param: Word;
    paramH: Word;
    time: Longint;
  end;

const
  sc_ScreenSave = $F140;
  sc_Hotkey = $F150;

  es_ReadOnly = $0800;
  es_WantReturn = $1000;

  em_GetFirstVisibleLine = wm_User+30;
  em_SetReadOnly = wm_User+31;
  em_SetWordBreakProc = wm_User+32;
  em_GetWordBreakProc = wm_User+33;
  em_GetPasswordChar = wm_User+34;

type
 TEditWordBreakProc = function(lpch: PChar; ichCurrent: Integer; cch: Integer;
   Code: Integer): Integer;

{ TEditWordBreakProc code values }
const
  wb_Left = 0;
  wb_Right = 1;
  wb_IsDelimiter = 2;

const
  stm_SetIcon = wm_User+0;
  stm_GetIcon = wm_User+1;

  { DlgDirList, DlgDirListComboBox flags values }
  ddl_ReadWrite = $0001;
  ddl_ReadOnly = $0002;
  ddl_Hidden = $0004;
  ddl_System = $0008;
  ddl_Directory = $0010;
  ddl_Archive = $0020;

  ddl_PostMsgs = $2000;
  ddl_Drives = $4000;
  ddl_Exclusive = $8000;


  lb_SetCaretIndex = wm_User+31;
  lb_GetCaretIndex = wm_User+32;

  lb_SetItemHeight = wm_User+33;
  lb_GetItemHeight = wm_User+34;
  lb_FindStringExact = wm_User+35;

  lbs_DisableNoScroll = $1000;

  cbn_Closeup = 8;
  cbn_SelEndOk = 9;
  cbn_SelEndCancel = 10;

  cbs_DisableNoScroll = $0800;

  cb_GetDroppedControlRect = wm_User+18;
  cb_SetItemHeight = wm_User+19;
  cb_GetItemHeight = wm_User+20;
  cb_SetExtendedUI = wm_User+21;
  cb_GetExtendedUI = wm_User+22;
  cb_GetDroppedState = wm_User+23;
  cb_FindStringExact = wm_User+24;

  ev_CTSS = $0400;	{ CTS state                    }
  ev_DSRS = $0800;	{ DSR state                    }
  ev_RLSDS = $1000;	{ RLSD state                   }
  ev_RingTe = $2000;	{ Ring trailing edge indicator }

  GetMaxLPT = 8;	{ Max supported LPT id	    }
  GetMaxCOM = 9;	{ Max supported COM id	    }
  GetBaseIRQ = 10;	{ Get port base & irq for a port }

  { Comm Baud Rate indices }
  cbr_110 = $FF10;
  cbr_300 = $FF11;
  cbr_600 = $FF12;
  cbr_1200 = $FF13;
  cbr_2400 = $FF14;
  cbr_4800 = $FF15;
  cbr_9600 = $FF16;
  cbr_14400 = $FF17;
  cbr_19200 = $FF18;
  cbr_38400 = $FF1B;
  cbr_56000 = $FF1F;
  cbr_128000 = $FF23;
  cbr_256000 = $FF27;

  { notifications passed in low word of lParam on wm_CommNotify messages }
  cn_Receive = $01;	{ bytes are available in the input queue }
  cn_Transmit = $02;    { fewer than wOutTrigger bytes still	 }
			{ remain in the output queue waiting	 }
			{ to be transmitted.			 }
  cn_Event = $0004;

  drv_Load = $0001;
  drv_Enable = $0002;
  drv_Open = $0003;
  drv_Close = $0004;
  drv_Disable = $0005;
  drv_Free = $0006;
  drv_Configure = $0007;
  drv_QueryConfigure = $0008;
  drv_Install = $0009;
  drv_Remove = $000A;
  drv_ExitSession = $000B;
  drv_ExitApplication = $000C;
  drv_Power = $000F;

  drv_Reserved = $0800;
  drv_User = $4000;

  { Supported return values for drv_Configure message }
  drvcnf_Cancel = $0000;
  drvcnf_OK = $0001;
  drvcnf_Restart = $0002;

  drvea_NormalExit = $0001;
  drvea_AbnormalExit = $0002;

  { GetNextDriver flags }
  gnd_Forward = $00000000;
  gnd_FirstInstanceOnly = $00000001;
  gnd_Reverse = $00000002;

type
  PDriverInfoStruct = ^TDriverInfoStruct;
  TDriverInfoStruct = record
    length: Word;
    hDriver: THandle;
    hModule: THandle;
    szAliasName: array[0..128] of Char;
  end;

type
  PDrvConfigInfo = ^TDrvConfigInfo;
  TDrvConfigInfo = record
    dwDCISize: Longint;
    lpszDCISectionName: PChar;
    lpszDCIAliasName: PChar;
  end;


const
  { MDI client style bits }
  mdis_AllChildStyles = $0001;

  { wParam Flags for wm_MDITILE and wm_MDICASCADE messages. }
  mditile_Vertical = $0000;
  mditile_Horizontal = $0001;
  mditile_SkipDisabled = $0002;

  { Parameter for SystemParametersInfo() }
  spi_GetBeep = 1;
  spi_SetBeep = 2;
  spi_GetMouse = 3;
  spi_SetMouse = 4;
  spi_GetBorder = 5;
  spi_SetBorder = 6;
  spi_GetKeyBoardSpeed = 10;
  spi_SetKeyBoardSpeed = 11;
  spi_LangDriver = 12;
  spi_IconHorizontalSpacing = 13;
  spi_GetScreenSaveTimeout = 14;
  spi_SetScreenSaveTimeout = 15;
  spi_GetScreenSaveActive = 16;
  spi_SetScreenSaveActive = 17;
  spi_GetGridGranularity = 18;
  spi_SetGridGranularity = 19;
  spi_SetDeskWallpaper = 20;
  spi_SetDeskPattern = 21;
  spi_GetKeyBoardDelay = 22;
  spi_SetKeyBoardDelay = 23;
  spi_IconVerticalSpacing = 24;
  spi_GetIconTitleWrap = 25;
  spi_SetIconTitleWrap = 26;
  spi_GetMenuDropAlignment = 27;
  spi_SetMenuDropAlignment = 28;
  spi_SetDoubleClkWidth = 29;
  spi_SetDoubleClkHeight = 30;
  spi_GetIconTitleLogfont = 31;
  spi_SetDoubleClickTime = 32;
  spi_SetMouseButtonSwap = 33;
  spi_SetIconTitleLogfont = 34;
  spi_GetFastTaskSwitch = 35;
  spi_SetFastTaskSwitch = 36;


  { Flags }
  spif_UpdateIniFile = $0001;
  spif_SendWinIniChange = $0002;

type
  PDocInfo = ^TDocInfo;
  TDocInfo = record
    cbSize: Integer;
    lpszDocName: PChar;
    lpszOutput: PChar;
  end;

type
  TAbortProc = function (DC: HDC; Error: Integer): Boolean;

type
  TTask = Word;

type
  PWinDebugInfo = ^TWinDebugInfo;
  TWinDebugInfo = record
    Flags: Word;
    dwOptions: Longint;
    dwFilter: Longint;
    achAllocModule: array[0..7] of Char;
    dwAllocBreak: Longint;
    dwAllocCount: Longint;
  end;

const
  wpf_SetMinPosition      = $0001;
  wpf_RestoreToMaximized  = $0002;

  swp_FrameChanged    = $0020;
  swp_NoOwnerZOrder   = $0200;
  swp_NoSendChanging  = $0400;
  swp_DeferErase      = $2000;


type
  PWindowPlacement = ^TWindowPlacement;
  TWindowPlacement = record
    length: Word;
    flags: Word;
    showCmd: Word;
    ptMinPosition: TPoint;
    ptMaxPosition: TPoint;
    rcNormalPosition: TRect;
  end;

type
  PSize = ^TSize;
  TSize = record
    cX: Integer;
    cY: Integer;
  end;

type
  TOldFontEnumProc = TFarProc;
  TFontEnumProc = TFarProc;

const
  TrueType_FontType  = $0004;


type
  PKerningPair = ^TKerningPair;
  TKerningPair = record
    wFirst: Word;
    wSecond: Word;
    iKernAmount: Integer;
  end;

type
  PComStat = ^TComStat;
  TComStat = record
    status: Byte;
    cbInQue: Word;
    cbOutQue: Word;
  end;

const
  cstf_ctsHold    = $01;
  cstf_dsrHold    = $02;
  cstf_rlsdHold   = $04;
  cstf_xoffHold   = $08;
  cstf_xoffSent   = $10;
  cstf_Eof        = $20;
  cstf_txim       = $40;


type
  PDebugHookInfo = ^TDebugHookInfo;
  TDebugHookInfo = record
    hModuleHook: THandle;
    reserved: Longint;
    lParam: Longint;
    wParam: Word;
    code: Integer;
  end;

{ Flags returned by GetSystemDebugState. }
const
  sds_Menu        = $0001;
  sds_SysModal    = $0002;
  sds_NoTaskQueue = $0004;
  sds_Dialog      = $0008;
  sds_TaskLocked  = $0010;

{ Constants passed to WinHelp }
const
  help_Contents = $0003;
  help_SetContents = $0005;
  help_ContextPopup = $0008;
  help_ForceFile = $0009;
  help_Command = $0102;
  help_PartialKey = $0105;
  help_SetWinPos = $0203;

type
  PHelpWinInfo = ^THelpWinInfo;
  THelpWinInfo = record
    wStructSize: Integer;
    x: Integer;
    y: Integer;
    dx: Integer;
    dy: Integer;
    wMax: Integer;
    rgchMember: array[0..1] of Char;
  end;

{ Struct pointed to by WM_GETMINMAXINFO lParam }
type
  PMinMaxInfo = ^TMinMaxInfo;
  TMinMaxInfo = record
    ptReserved: TPoint;
    ptMaxSize: TPoint;
    ptMaxPosition: TPoint;
    ptMinTrackSize: TPoint;
    ptMaxTrackSize: TPoint;
  end;

type
  PSegInfo = ^TSegInfo;
  TSegInfo = record
    offSegment: Word;
    cbSegment: Word;
    flags: Word;
    cbAlloc: Word;
    h: THandle;
    alignShift: Word;
    reserved: array[0..1] of Word;
  end;


const
  gfsr_SystemResources  = $0000;
  gfsr_GDIResources     = $0001;
  gfsr_UserResources    = $0002;


{ function changed from Windows 3.0 to Windows 3.1 }
procedure AnsiToOem(AnsiStr, OemStr: PChar);
procedure AnsiToOemBuff(AnsiStr, OemStr: PChar; Length: Word);
function BringWindowToTop(Wnd: HWnd): Bool;
function EndDeferWindowPos(WinPosInfo: THandle): Bool;
function Escape(DC: HDC; Escape, Count: Integer; InData: PChar;
  OutData: Pointer): Integer;
function FrameRect(DC: HDC; var Rect: TRect; Brush: HBrush): Integer;
function GetMenuItemCount(Menu: HMenu): Integer;
function GetInstanceData(Instance: THandle; Data: PByte;
  Count: Integer): Integer;
procedure GlobalUnfix(Mem: THandle);
procedure OemToAnsi(OemStr, AnsiStr: PChar);
procedure OemToAnsiBuff(OemStr, AnsiStr: PChar; Length: Word);
function SetResourceHandler(Instance: THandle; ResType: PChar;
  LoadFunc: TFarProc): TFarProc;
procedure UnlockSegment(Segment: Word);
function CreateBitmap(Width, Height: Integer; Planes, BitCount: Word;
  Bits: Pointer): HBitmap;


{ functions new to Windows 3.1 }
function GetTextExtentPoint(DC: HDC; Str: PChar; Count: Integer;
  var Size: Integer): Bool;
function GetSystemDebugState: Longint;
function LockInput(h1: THandle; hwndInput: HWnd; fLock: Bool): Bool;
function QuerySendMessage(h1, h2, h3: THandle; lpmsg: PMsg): Bool;
function EnumFonts(DC: HDC; lpszFace: PChar; fntenmprc: TOldFontEnumProc;
  lpszData: PChar): Integer;
function GetWinDebugInfo(DebugInfo: PWinDebugInfo; Flags: Word): Bool;
function SetWinDebugInfo(DebugInfo: PWinDebugInfo): Bool;
function IsBadReadPtr(lp: Pointer; cb: Word): Bool;
function IsBadWritePtr(lp: Pointer; cb: Word): Bool;
function IsBadHugeReadPtr(lp: Pointer; cb: Longint): Bool;
function IsBadHugeWritePtr(lp: Pointer; cb: Longint): Bool;
function IsBadCodePtr(lpfn: TFarProc): Bool;
function IsBadStringPtr(lpsz: PChar; cchMax: Word): Bool;
procedure DirectedYield(Task: TTask);
function PrestoChangoSelector(SourceSel, DestSel: Word): Word;
function GetSelectorBase(Selector: Word): Longint;
function SetSelectorBase(Selector: Word; Base: Longint): Word;
function GetSelectorLimit(Selector: Word): Longint;
function SetSelectorLimit(Selector: Word; Base: Longint): Word;

function GetDriverInfo(hDriver: THandle; lpdis: PDriverInfoStruct): Bool;
function GetWindowPlacement(Wnd: HWnd; Placement: PWindowPlacement): Bool;
function SetWindowPlacement(Wnd: HWnd; Placement: PWindowPlacement): Bool;
function DlgDirSelectEx(Dlg: HWnd; Path: PChar; cbPath: Integer;
  ListBox: Integer): Bool;
function DlgDirSelectComboBoxEx(Dlg: HWnd; Path: PChar; cbPath: Integer;
  ComboBox: Integer): Bool;
function GetTimerResolution: Longint;
function ExitWindowsExec(Exe: PChar; Params: PChar): Bool;

function SpoolFile(Printer, Port, Job, F: PChar): THandle;
function QueryAbort(DC: HDC; Reserved: Integer): Bool;
function SetWindowOrgEx(DC: HDC; nX, nY: Integer; Point: PPoint): Bool;
function GetWindowOrgEx(DC: HDC; Point: PPoint): Bool;
function SetWindowExtEx(DC: HDC; nX, nY: Integer; Size: PSize): Bool;
function GetWindowExtEx(DC: HDC; Size: PSize): Bool;
function OffsetWindowOrgEx(DC: HDC; nX, nY: Integer; Point: PPoint): Bool;
function ScaleWindowExtEx(DC: HDC; Xnum, Xdenom, Ynum, Ydenom: Integer;
  Size: PSize): Bool;
function SetViewportExtEx(DC: HDC; nX, nY: Integer; Size: PSize): Bool;
function GetViewportExtEx(DC: HDC; Size: PSize): Bool;
function SetViewportOrgEx(DC: HDC; nX, nY: Integer; Point: PPoint): Bool;
function GetViewportOrgEx(DC: HDC; Point: PPoint): Bool;
function OffsetViewportOrgEx(DC: HDC; nX, nY: Integer; Point: PPoint): Bool;
function ScaleViewportExtEx(DC: HDC; Xnum, Xdenom, Ynum, Ydenom: Integer;
  Size: PSize): Bool;
function GetBrushOrgEx(DC: HDC; Point: PPoint): Bool;
function MoveToEx(DC: HDC; nX, nY: Integer; Point: PPoint): Bool;
function GetCurrentPositionEx(DC: HDC; Point: PPoint): Bool;
function GetAspectRatioFilterEx(DC: HDC; Size: PSize): Bool;
function EnumFontFamilies(DC: HDC; Family: PChar;
  EnumProc: TFontEnumProc; Data: PChar): Integer;
function GetKerningPairs(DC: HDC; i: Integer; Pair: PKerningPair): Integer;
function SetBitmapDimensionEx(BM: HBitmap; nX, nY: Integer; Size: PSize): Bool;
function GetBitmapDimensionEx(BM: HBitmap; Size: PSize): Bool;
function SetMetaFileBitsBetter(mf: THandle): THandle;
function StartDoc(DC: HDC; var di: TDocInfo): Integer;
function StartPage(DC: HDC): Integer;
function EndPage(DC: HDC): Integer;
function EndDoc(DC: HDC): Integer;
function AbortDoc(DC: HDC): Integer;
function SetAbortProc(DC: HDC; AbortProc: TAbortProc): Integer;

function IsTask(Task: THandle): Bool;
function GetFreeSystemResources(SysResource: Word): Word;
function GlobalAllocPtr(Flags: Word; Bytes: Longint): Pointer;
function GlobalReAllocPtr(Mem: Pointer; NewBytes: Longint; Flags: Word): Pointer;
function GlobalFreePtr(Mem: Pointer): Bool;
function GlobalLockPtr(Mem: Pointer): Bool;
procedure GlobalUnlockPtr(Mem: Pointer);
procedure LogError(Err: Word; Info: Pointer);
procedure LogParamError(Err: Word; fn: TFarProc; Param: Pointer);
function IsDBCSLeadByte(Ch: Byte): Bool;
function GetDCEx(Wnd: HWnd; Clip: HRgn; Flags: Longint): HDC;
function IsGDIObject(Obj: THandle): Bool;
function SetBoundsRect(DC: HDC; var Bounds: TRect; Flags: Word): Word;
function GetBoundsRect(DC: HDC; var Bounds: TRect; Flags: Word): Word;
function ConvertOutlineFontFile(A, B, C: PChar): Longint;
function GetFontData(hdc: HDC; dwTable, dwOffset: Longint; lpvBuffer: PChar;
  cbData: Longint): Longint;
function GetGlyphOutline(hdc: HDC; uChar, fuFormat: Word;
  var lpgm: TGlyphMetrics; cbBuffer: Longint; lpBuffer: PChar;
  var lpMat2: TMat2): Longint;
function CreateScalableFontResource(fHidden: Word; lpszResourceFile,
  lpszFontFile, lpszCurrentPath: PChar): Bool;
function GetCharABCWidths(hdc: HDC; uFirstChar, uLastChar: Word;
  var lpabc: TABC): Bool;
function GetRasterizerCaps(var lpRastStat: TRasterizer_Status;
  cbNumBytes: Integer): Bool;
function GetOutlineTextMetrics(hdc: HDC; cbData: Word;
  lpotm: POutlineTextMetric): Word;
function GetMessageExtraInfo: Longint;
function GetOpenClipboardWindow: HWnd;
function GetQueueStatus(Flags: Word): Longint;
function IsMenu(Menu: HMenu): Bool;
function RedrawWindow(Wnd: HWnd; UpdateRect: PRect; UpdateRgn: HRgn;
  Flags: Word): Bool;
function LockWindowUpdate(Wnd: HWnd): Bool;
function ScrollWindowEx(Wnd: HWnd; dx, dy: Integer; Scroll, Clip: PRect; UpdateRgn: HRgn;
  UpdateRect: PRect; Flags: Word): Integer;
function EnableScrollBar(hwnd: HWnd; fnSBFlags: Integer;
  fuArrowFlags: Word): Bool;
function CopyCursor(hInst: THandle; hCur: HCursor): HCursor;
function GetCursor: HCursor;
procedure GetClipCursor(var Rect: TRect);
function CopyIcon(hInst: THandle; Icon: HIcon): HIcon;
procedure MapWindowPoints(FromWnd, ToWnd: HWnd; var Point; Count: Word);
procedure MapWindowRect(FromWnd, ToWnd: HWnd; var Rect: TRect);
function SubtractRect(var Dest, Source1, Source2: TRect): Bool;
function SetWindowsHookEx(HookId: Integer; Hook: THookProc; Module, Task: THandle): HHook;
function UnhookWindowsHookEx(Hook: HHook): Bool;
function CallNextHookEx(Hook: HHook; Code: Integer; wParam: Word; lParam: Longint): Longint;
function EnableCommNotification(idComDev: Integer; hwnd: HWnd;
  cbWriteNotify, cbOutQueue: Integer): Bool;
function OpenDriver(DriverName, SectionName: PChar; lParam2: Longint): THandle;
function CloseDriver(Driver: THandle; lParam1, lParam2: Longint): Longint;
function GetDriverModuleHandle(Driver: THandle): THandle;
function SendDriverMessage(Driver: THandle; message: Word; lParam1,
  lParam2: Longint): Longint;
function GetNextDriver(Driver: THandle; lParam: Longint): THandle;

function lstrcpyn(String1, String2: PChar; i: Integer): PChar;
procedure hmemcpy(p1, p2: Pointer; L: Longint);


{  Not exported by any DLL but included in WINDOWS.H
  function SetDriverMessage(Driver: THandle; Message: Word; lParam1, lParam2: LongInt): LongInt; }

function DefDriverProc(DriverIdentifier: Longint; DriverId: THandle; Message: Word; lParam1, lParam2: Longint): Longint;
function SystemParametersInfo(Action, wParam: Word; lParam: Pointer;
  UpdateWinIni: Word): Bool;

{ Provided for compatiblity only.  Should use the Pascal RTL functions
  Ptr, Off, and Seg instead. }

function MakeLP(Sel, Off: Word): Pointer;
inline(
  $5A/    { POP DX }
  $58);   { POP AX }

function SelectorOf(lp: Pointer): THandle;
inline(
  $5A/    { POP DX }
  $58);   { POP AX }

function OffsetOf(lp: Pointer): Word;
inline(
  $58/    { POP AX }
  $5A);   { POP DX }

implementation

uses WinProcs;

function GlobalAllocPtr(Flags: Word; Bytes: Longint): Pointer;
begin
  GlobalAllocPtr := Ptr(GlobalAlloc(Flags, Bytes), 0);
end;

function GlobalReAllocPtr(Mem: Pointer; NewBytes: Longint; Flags: Word): Pointer;
begin
  GlobalReAllocPtr := Ptr(GlobalReAlloc(Seg(Mem), NewBytes, Flags), 0);
end;

function GlobalFreePtr(Mem: Pointer): Bool;
begin
  GlobalFreePtr := Bool(GlobalFree(Seg(Mem)));
end;

function GlobalLockPtr(Mem: Pointer): Bool;
begin
  GlobalLockPtr := Bool(GlobalLock(Seg(Mem)));
end;

procedure GlobalUnlockPtr(Mem: Pointer);
begin
  GlobalUnlock(Seg(Mem));
end;

procedure MapWindowRect(FromWnd, ToWnd: HWnd; var Rect: TRect);
begin
  MapWindowPoints(FromWnd, ToWnd, Rect, 2);
end;



procedure AnsiToOem;                       external 'KEYBOARD' index 5;
procedure AnsiToOemBuff;                   external 'KEYBOARD' index 134;
function BringWindowToTop;                 external 'USER'     index 45;
function CreateBitmap;                     external 'GDI'      index 48;
function EndDeferWindowPos;                external 'USER'     index 261;
function Escape;                           external 'GDI'      index 38;
function FrameRect;                        external 'USER'     index 83;
function GetMenuItemCount;                 external 'USER'     index 263;
function GetInstanceData;                  external 'KERNEL'   index 54;
procedure GlobalUnfix;                     external 'KERNEL'   index 198;
procedure OemToAnsi;                       external 'KEYBOARD' index 6;
procedure OemToAnsiBuff;                   external 'KEYBOARD' index 135;
function SetResourceHandler;               external 'KERNEL'   index 67;
procedure UnlockSegment;                   external 'KERNEL'   index 24;

function IsTask;                           external 'KERNEL'   index 320;
function GetFreeSystemResources;           external 'USER'     index 284;
procedure LogError;                        external 'KERNEL'   index 324;
procedure LogParamError;                   external 'KERNEL'   index 325;
function IsDBCSLeadByte;                   external 'KERNEL'   index 207;
function GetDCEx;                          external 'USER'     index 359;
function IsGDIObject;                      external 'GDI'      index 462;
function SetBoundsRect;                    external 'GDI'      index 193;
function GetBoundsRect;                    external 'GDI'      index 194;
function ConvertOutlineFontFile;           external 'GDI'      index 312;
function GetFontData;                      external 'GDI'      index 311;
function GetGlyphOutline;                  external 'GDI'      index 309;
function CreateScalableFontResource;       external 'GDI'      index 310;
function GetCharABCWidths;                 external 'GDI'      index 307;
function GetRasterizerCaps;                external 'GDI'      index 313;
function GetOutlineTextMetrics;            external 'GDI'      index 308;
function GetMessageExtraInfo;              external 'USER'     index 288;
function GetOpenClipboardWindow;           external 'USER'     index 248;
function GetQueueStatus;                   external 'USER'     index 334;
function IsMenu;                           external 'USER'     index 358;
function RedrawWindow;                     external 'USER'     index 290;
function LockWindowUpdate;                 external 'USER'     index 294;
function ScrollWindowEx;                   external 'USER'     index 319;
function EnableScrollBar;                  external 'USER'     index 482;
function CopyCursor;                       external 'USER'     index 369;
function GetCursor;                        external 'USER'     index 247;
procedure GetClipCursor;                   external 'USER'     index 309;
function CopyIcon;                         external 'USER'     index 368;
procedure MapWindowPoints;                 external 'USER'     index 258;
function SetWindowsHookEx;                 external 'USER'     index 291;
function UnhookWindowsHookEx;              external 'USER'     index 292;
function CallNextHookEx;                   external 'USER'     index 293;
function EnableCommNotification;           external 'USER'     index 245;
function OpenDriver;                       external 'USER'     index 252;
function CloseDriver;                      external 'USER'     index 253;
function GetDriverModuleHandle;            external 'USER'     index 254;
function DefDriverProc;                    external 'USER'     index 255;
function GetNextDriver;                    external 'USER'     index 257;
function SubtractRect;                     external 'USER'     index 373;
function SystemParametersInfo;             external 'USER'     index 483;

function WNetAddConnection;                external 'USER'     index 517;
function WNetGetConnection;                external 'USER'     index 512;
function WNetCancelConnection;             external 'USER'     index 518;

function GetWinDebugInfo;                  external 'KERNEL'   index 355;
function SetWinDebugInfo;                  external 'KERNEL'   index 356;
function IsBadReadPtr;                     external 'KERNEL'   index 334;
function IsBadWritePtr;                    external 'KERNEL'   index 335;
function IsBadHugeReadPtr;                 external 'KERNEL'   index 346;
function IsBadHugeWritePtr;                external 'KERNEL'   index 347;
function IsBadCodePtr;                     external 'KERNEL'   index 336;
function IsBadStringPtr;                   external 'KERNEL'   index 337;
procedure DirectedYield;                   external 'KERNEL'   index 150;
function PrestoChangoSelector;             external 'KERNEL'   index 177;
function GetSelectorBase;                  external 'KERNEL'   index 186;
function SetSelectorBase;                  external 'KERNEL'   index 187;
function GetSelectorLimit;                 external 'KERNEL'   index 188;
function SetSelectorLimit;                 external 'KERNEL'   index 189;

function SendDriverMessage;                external 'USER'     index 251;
function GetDriverInfo;                    external 'USER'     index 256;
function GetWindowPlacement;               external 'USER'     index 370;
function SetWindowPlacement;               external 'USER'     index 371;
function DlgDirSelectEx;                   external 'USER'     index 422;
function DlgDirSelectComboBoxEx;           external 'USER'     index 423;
function GetTimerResolution;               external 'USER'     index 14;
function ExitWindowsExec;                  external 'USER'     index 246;
function GetSystemDebugState;              external 'USER'     index 231;
function QuerySendMessage;                 external 'USER'     index 184;
function LockInput;                        external 'USER'     index 226;

function GetTextExtentPoint;               external 'GDI'      index 471;
function SpoolFile;                        external 'GDI'      index 254;
function QueryAbort;                       external 'GDI'      index 155;
function SetWindowOrgEx;                   external 'GDI'      index 482;
function GetWindowOrgEx;                   external 'GDI'      index 475;
function SetWindowExtEx;                   external 'GDI'      index 481;
function GetWindowExtEx;                   external 'GDI'      index 474;
function OffsetWindowOrgEx;                external 'GDI'      index 477;
function ScaleWindowExtEx;                 external 'GDI'      index 485;
function SetViewportExtEx;                 external 'GDI'      index 479;
function GetViewportExtEx;                 external 'GDI'      index 472;
function SetViewportOrgEx;                 external 'GDI'      index 480;
function GetViewportOrgEx;                 external 'GDI'      index 473;
function OffsetViewportOrgEx;              external 'GDI'      index 476;
function ScaleViewportExtEx;               external 'GDI'      index 484;
function GetBrushOrgEx;                    external 'GDI'      index 469;
function MoveToEx;                         external 'GDI'      index 483;
function GetCurrentPositionEx;             external 'GDI'      index 470;
function GetAspectRatioFilterEx;           external 'GDI'      index 486;
function EnumFontFamilies;                 external 'GDI'      index 330;
function EnumFonts;                        external 'GDI'      index 70;
function GetKerningPairs;                  external 'GDI'      index 332;
function SetBitmapDimensionEx;             external 'GDI'      index 478;
function GetBitmapDimensionEx;             external 'GDI'      index 468;
function SetMetaFileBitsBetter;            external 'GDI'      index 196;
function StartDoc;                         external 'GDI'      index 377;
function StartPage;                        external 'GDI'      index 379;
function EndPage;                          external 'GDI'      index 380;
function EndDoc;                           external 'GDI'      index 378;
function AbortDoc;                         external 'GDI'      index 382;
function SetAbortProc;                     external 'GDI'      index 381;

function lstrcpyn;                         external 'KERNEL'   index 353;
procedure hmemcpy;                         external 'KERNEL'   index 348;


end.
