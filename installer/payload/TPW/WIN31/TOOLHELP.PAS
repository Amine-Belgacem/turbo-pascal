

{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit TOOLHELP;

interface

uses WinTypes;


{ General symbols }
const
  max_Data = 11;
  max_Path = 255;
  max_Module_Name =  8 + 1;
  Max_ClassName = 255;

{ Global heap walking }

type

  PGlobalInfo = ^TGlobalInfo;
  TGlobalInfo = record
    dwSize: Longint;
    wcItems: Word;
    wcItemsFree: Word;
    wcItemsLRU: Word;
  end;

  PGlobalEntry = ^TGlobalEntry;
  TGlobalEntry = record
    dwSize: Longint;
    dwAddress: Longint;
    dwBlockSize: Longint;
    hBlock: THandle;
    wcLock: Word;
    wcPageLock: Word;
    wFlags: Word;
    wHeapPresent: Bool;
    hOwner: THandle;
    wType: Word;
    wData: Word;
    dwNext: Longint;
    dwNextAlt: Longint;
  end;

const
{ GlobalFirst()/GlobalNext() flags }
  global_All = 0;
  global_LRU = 1;
  global_Free = 2;

{ TGlobalEntry.wType entries }
  gt_Unknown = 0;
  gt_DGroup = 1;
  gt_Data = 2;
  gt_Code = 3;
  gt_Task = 4;
  gt_Resource = 5;
  gt_Module = 6;
  gt_Free = 7;
  gt_Internal = 8;
  gt_Sentinel = 9;
  gt_BurgerMaster = 10;

{ If TGlobalEntry.wType = gt_Resource, the following is TGlobalEntry.wData: }
  gd_UserDefined = 0;
  gd_CursorComponent = 1;
  gd_Bitmap = 2;
  gd_IconComponent = 3;
  gd_Menu = 4;
  gd_Dialog = 5;
  gd_String = 6;
  gd_FontDir = 7;
  gd_Font = 8;
  gd_Accelerators = 9;
  gd_RCData = 10;
  gd_ErrTable = 11;
  gd_Cursor = 12;
  gd_Icon = 14;
  gd_NameTable = 15;
  gd_Max_Resource = 15;

{ TGlobalEntry.wFlags }
  gf_PDB_Owner = $100;    { Low byte us KERNAL flags }

function GlobalInfo(lpGlobalInfo: PGlobalInfo): Bool;
function GlobalFirst(lpGlobal: PGlobalEntry; wFlags: Word): Bool;
function GlobalNext(lpGlobal: PGlobalEntry; wFlags: Word): Bool;
function GlobalEntryHandle(lpGlobal: PGlobalEntry; hItem: THandle): Bool;
function GlobalEntryModule(lpGlobal: PGlobalEntry; hModule: THandle; wSeg: Word): Bool;
function GlobalHandleToSel(hMem: THandle): Word;

{ Local heap walking }
type
  PLocalInfo = ^TLocalInfo;
  TLocalInfo = record
    dwSize: Longint;
    wcItems: Word;
  end;

  PLocalEntry = ^TLocalEntry;
  TLocalEntry = record
    dwSize: Longint;
    hHandle: THandle;
    wAddress: Word;
    wSize: Word;
    wFlags: Word;
    wcLock: Word;
    wType: Word;
    hHeap: Word;
    wHeapType: Word;
    wNext: Word;
  end;

const

{ TLocalEntry.wHeapType flags }
  Normal_Heap = 0;
  User_Heap = 1;
  gdi_Heap = 2;

{ TLocalEntry.wFlags }
  lf_Fixed = 1;
  lf_Free = 2;
  lf_Moveable = 4;

{ TLocalEntry.wType }
  lt_Normal = 0;
  lt_Free = $FF;
  lt_GDI_Pen = 1;  { lt_GDI_* is for GDI's heap }
  lt_GDI_Brush = 2;
  lt_GDI_Font = 3;
  lt_GDI_Palette = 4;
  lt_GDI_Bitmap = 5;
  lt_GDI_RGN = 6;
  lt_GDI_DC = 7;
  lt_GDI_Disabled_DC = 8;
  lt_GDI_MetaDC = 9;
  lt_GDI_MetaFile = 10;
  lt_GDI_Max = lt_GDI_MetaFile;
  lt_User_Class = 1;  { lt_USER_* is for USER's heap }
  lt_User_Wnd = 2;
  lt_User_String = 3;
  lt_User_Menu = 4;
  lt_User_Clip = 5;
  lt_User_CBox = 6;
  lt_User_Palette = 7;
  lt_User_ED = 8;
  lt_User_BWL = 9;
  lt_User_OwnerDraw = 10;
  lt_User_SPB = 11;
  lt_User_CheckPoint = 12;
  lt_User_DCE = 13;
  lt_User_MWP = 14;
  lt_User_Prop = 15;
  lt_User_LBIV = 16;
  lt_User_Misc = 17;
  lt_User_Atoms = 18;
  lt_User_LockInputState = 19;
  lt_User_HookList = 20;
  lt_User_UserSeeUserDoAlloc = 21;
  lt_User_HotKeyList = 22;
  lt_User_PopUpMenu = 23;
  lt_User_HandleTable = 32;
  lt_User_Max = lt_User_HandleTable;

function LocalInfo(lpLocal: PLocalInfo; hHeap: THandle): Bool;
function LocalFirst(lpLocal: PLocalEntry; hHeap: THandle): Bool;
function LocalNext(lpLocal: PLocalEntry): Boolean;


{ Stack Tracing }
type

  PStackTraceEntry = ^TStackTraceEntry;
  TStackTraceEntry = record
    dwSize: Longint;
    hTask: THandle;
    wSS: Word;
    wBP: Word;
    wCS: Word;
    wIP: Word;
    hModule: THandle;
    wSegment: Word;
    wFlags: Word;
  end;

const
{ TStackTraceEntry.wFlags values }
  frame_Far = 0;
  frame_Near = 1;

function StackTraceFirst(lpStackTrace: PStackTraceEntry; hTask: THandle): Bool;
function StackTraceCSIPFirst(lpStackTrace: PStackTraceEntry;
                             wSS, wCS, wIP, wBP: Word): Bool;
function StackTraceNext(lpStackTrace: PStackTraceEntry): Bool;

{ Module list walking }
type
  PModuleEntry = ^TModuleEntry;
  TModuleEntry = record
    dwSize: Longint;
    szModule : array[0..max_Module_Name] of Char;
    hModule: THandle;
    wUsageFlags: Word;
    szExePath: array[0..max_Path] of Char;
    wNext: Word;
  end;

function ModuleFirst(lpModule: PModuleEntry): Bool;
function ModuleNext(lpModule: PModuleEntry): Bool;
function ModuleFindName(lpModule: PModuleEntry; lpstrName: PChar): THandle;
function ModuleFindHandle(lpModule: PModuleEntry; hModule: THandle): THandle;


{ Task list walking }
type

  PTaskEntry = ^TTaskEntry;
  TTaskEntry = record
    dwSize: Longint;
    hTask: THandle;
    hTaskParent: THandle;
    hInst: THandle;
    hModule: THandle;
    wSS: Word;
    wSP: Word;
    wStackTop: Word;
    wStackMinimum: Word;
    wStackBottom: Word;
    wcEvents: Word;
    hQueue: THandle;
    szModule: array[0..max_Module_Name] of Char;
    wPSPOffset: Word;
    hNext: THandle;
  end;

function TaskFirst(lpTask: PTaskEntry): Bool;
function TaskNext(lpTask: PTaskEntry): Bool;
function TaskFindHandle(lpTask: PTaskEntry; hTask: THandle): Bool;
function TaskSetCSIP(hTask: THandle; wCS, wIP: Word): Longint;
function TaskGetCSIP(hTask: THandle): Longint;
function TaskSwitch(hTask: THandle; dwNewCSIP: Longint): Bool;

{ Window Class enumeration }
type
  PClassEntry = ^TClassEntry;
  TClassEntry = record
    dwSize: Longint;
    hInst: THandle;
    szClassName: array[0..Max_ClassName] of Char;
    wNext: Word;
  end;

function ClassFirst(lpClass: PClassEntry): Bool;
function ClassNext(lpClass: PClassEntry): Bool;


type

{ Information functions }
  PMemManInfo = ^TMemManInfo;
  TMemManInfo = record
    dwSize: Longint;
    dwLargestFreeBlock: Longint;
    dwMaxPagesAvailable: Longint;
    dwMaxPagesLockable: Longint;
    dwTotalLinearSpace: Longint;
    dwTotalUnlockedPages: Longint;
    dwFreePages: Longint;
    dwTotalPages: Longint;
    dwFreeLinearSpace: Longint;
    dwSwapFilePages: Longint;
    wPageSize: Word;
  end;

function MemManInfo(lpEnhMode: PMemManInfo): Bool;


type
  PSysHeapInfo = ^TSysHeapInfo;
  TSysHeapInfo = record
    dwSize: Longint;
    wUserFreePercent: Word;
    wGDIFreePercent: Word;
    hUserSegment: THandle;
    hGDISegment: THandle;
  end;

function SystemHeapInfo(lpSysHeap: PSysHeapInfo): Bool;


{ Interrupt Handling }

const

{ Hooked interrupts }
  int_Div0            = 0;
  int_1               = 1;
  int_3               = 3;
  int_UDInstr         = 6;
  int_StkFault        = 12;
  int_GPFault         = 13;
  int_BadPageFault    = 14;
  int_CtlAltSysRq     = 256;

{ TOOLHELP Interrupt callbacks registered with InterruptRegister should
 *  always be written in assembly language.  The stack frame is not
 *  compatible with high level language conventions.
 *
 *  This stack frame looks as follows to the callback.  All registers
 *  should be preserved across this callback to allow restarting fault.
 *               ------------
 *               |   Flags  |  [SP + 0Eh]
 *               |    CS    |  [SP + 0Ch]
 *               |    IP    |  [SP + 0Ah]
 *               |  Handle  |  [SP + 08h]
 *               |Exception#|  [SP + 06h]
 *               |    AX    |  [SP + 04h]  AX Saved to allow MakeProcInstance
 *               |  Ret CS  |  [SP + 02h]
 *       SP--->  |  Ret IP  |  [SP + 00h]
 *               ------------
 }

type
  TIntCallBack = procedure;

function InterruptRegister(hTask: THandle; lpfnIntCallBack: TIntCallBack): Bool;
function InterruptUnRegister(hTask: THandle): Bool;

{  Notifications:
     When a notification callback is called, two parameters are passed
     in:  a WORD, wID, and another DWORD, dwData.  wID is one of
     the values nfy_* below.  Callback routines should ignore unrecog-
     nized values to preserve future compatibility.  Callback routines
     are also passed a dwData value.  This may contain data or may be
     a FAR pointer to a structure, or may not be used depending on
     which notification is being received.

     In all cases, if the return value of the callback is TRUE, the
     notification will NOT be passed on to other callbacks.  It has
     been handled.  This should be used sparingly and only with certain
     notifications.  Callbacks almost always return FALSE.
}

const

{ nfy_Unknown:  An unknown notification has been returned from KERNEL.  Apps
  should ignore these. }

  nfy_Unknown         = 0;

{ nfy_LoadSeg:  dwData points to a TNFYLoadSeg structure }

  nfy_LoadSeg         = 1;

type

  PNFYLoadSeg = ^TNFYLoadSeg;
  TNFYLoadSeg = record
    dwSize: Longint;
    wSelector: Word;
    wSegNum: Word;
    wType: Word;
    hInstance: THandle;
    lpstrModuleName: PChar;
  end;

const

{ nfy_FreeSeg:  LOWORD(dwData) is the selector of the segment being freed }

  nfy_FreeSeg       = 2;

{ nfy_StartDll:  dwData points to a NFYLOADSEG structure }
  nfy_StartDLL      = 3;

type
  PNFYStartDLL = ^TNFYStartDLL;
  TNFYStartDLL = record
    dwSize: Longint;
    hModule: THandle;
    wCS: Word;
    wIP: Word;
  end;

const
{ nfy_StartTask:  dwData is the CS:IP of the start address of the task }
  nfy_StartTask = 4;

{ nfy_ExitTask:  The low byte of dwData contains the program exit code }
  nfy_ExitTask = 5;

{ nfy_DelModule:  LOWORD(dwData) is the handle of the module to be freed }
  nfy_DelModule = 6;

{ nfy_Rip:  dwData points to a NFYRIP structure }
  nfy_Rip = 7;

type
  PNFYRip = ^TNFYRip;
  TNFYRip = record
    dwSize: Longint;
    wIP: Word;
    wCS: Word;
    wSS: Word;
    wBP: Word;
    wExitCode: Word;
  end;

const
{ nfy_TaskIn:  No data.  Callback should do GetCurrentTask() }
  nfy_TaskIn = 8;

{ nfy_TaskOut:  No data.  Callback should do GetCurrentTask() }
  nfy_TaskOout = 9;

{ nfy_InChar:  Return value from callback is used.  If NULL, mapped to 'i' }
  nfy_InChar = 10;

{ nfy_OutStr:  dwData points to the string to be displayed }
  nfy_OutStr = 11;

{ nfy_LogError:  dwData points to a TNFYLogError struct }
  nfy_LogError = 12;

type
  PNFYLogError = ^TNFYLogError;
  TNFYLogError = record
    dwSize: Longint;
    wErrCode: Word;
    lpInfo: PChar;      { Error code-dependent }
  end;

const
{ nfy_LogParamError:  dwData points to a TNFYLogParamError struct }
  nfy_LogParamError = 13;

type
  PNFYLogParamError = ^TNFYLogParamError;
  TNFYLogParamError = record
    dwSize: Longint;
    wErrCode: Word;
    lpfnErrorAddr : TFarProc;
    lpBadParam: ^Pointer;
  end;

const
{ NotifyRegister() flags }
  nf_Normal       = 0;
  nf_TaskSwitch   = 1;
  nf_RIP          = 2;

type
  TNotifyCallBack = function(wID: Word; dwData: Longint): Bool;

function NotifyRegister(hTask: THandle; lpfn: TNotifyCallBack; wFlags:Word): Bool;
function NotifyUnRegister(hTask: THandle): Bool;

{ Miscellaneous }

procedure TerminateApp(hTask: THandle; wFlags: Word);

const

{ TerminateApp() flag values }
  UAE_Box     = 0;
  No_UAE_Box  = 1;

function MemoryRead(wSel: Word; dwOffset: Longint; lpBuffer: PChar;
  dwcb: Longint): Longint;
function MemoryWrite(wSel: Word; dwOffset: Longint; lpBuffer: PChar;
  dwcb: Longint): Longint;

type

  PTimerInfo = ^TTimerInfo;
  TTimerInfo = record
    dwSize: Longint;
    dwmsSinceStart: Longint;
    dwmsThisVM: Longint;
  end;

function TimerCount(lpTimer: PTimerInfo): Bool;

implementation

function GlobalInfo;             external 'TOOLHELP' index  53;
function GlobalFirst;            external 'TOOLHELP' index  51;
function GlobalNext;             external 'TOOLHELP' index  52;
function GlobalEntryHandle;      external 'TOOLHELP' index  54;
function GlobalEntryModule;      external 'TOOLHELP' index  55;
function GlobalHandleToSel;      external 'TOOLHELP' index  50;


function LocalInfo;              external 'TOOLHELP' index  56;
function LocalFirst;             external 'TOOLHELP' index  57;
function LocalNext;              external 'TOOLHELP' index  58;

function StackTraceFirst;        external 'TOOLHELP' index  66;
function StackTraceCSIPFirst;    external 'TOOLHELP' index  67;
function StackTraceNext;         external 'TOOLHELP' index  68;

function ModuleFirst;            external 'TOOLHELP' index  59;
function ModuleNext;             external 'TOOLHELP' index  60;
function ModuleFindName;         external 'TOOLHELP' index  61;
function ModuleFindHandle;       external 'TOOLHELP' index  62;

function TaskFirst;              external 'TOOLHELP' index  63;
function TaskNext;               external 'TOOLHELP' index  64;
function TaskFindHandle;         external 'TOOLHELP' index  65;
function TaskSetCSIP;            external 'TOOLHELP' index  81;
function TaskGetCSIP;            external 'TOOLHELP' index  82;
function TaskSwitch;             external 'TOOLHELP' index  83;

function ClassFirst;             external 'TOOLHELP' index  69;
function ClassNext;              external 'TOOLHELP' index  70;

function MemManInfo;             external 'TOOLHELP' index  72;

function SystemHeapInfo;         external 'TOOLHELP' index  71;

function InterruptRegister;      external 'TOOLHELP' index  75;
function InterruptUnRegister;    external 'TOOLHELP' index  76;

function NotifyRegister;         external 'TOOLHELP' index  73;
function NotifyUnRegister;       external 'TOOLHELP' index  74;

procedure TerminateApp;          external 'TOOLHELP' index  77;

function MemoryRead;             external 'TOOLHELP' index  78;
function MemoryWrite;            external 'TOOLHELP' index  79;

function TimerCount;             external 'TOOLHELP' index  80;

end.
