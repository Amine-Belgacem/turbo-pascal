
{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit ddeml;

interface

uses WinTypes;

type
  HConvList = Longint;
  HConv = Longint;
  HSz = Longint;
  HDDEData = Longint;

type
  { the following structure is for use with xtyp_WildConnect processing. }
  PHSZPair = ^THSZPair;
  THSZPair = record
    hszSvc: HSZ;
    hszTopic: HSZ;
  end;

  { The following structure is used by DdeConnect() and DdeConnectList()
    and by xtyp_Connect and xtyp_WildConnect callbacks. }

  PConvContext = ^TConvContext;
  TConvContext = record
    cb: Word;             { set to sizeof(ConvCOnTEXT) }
    wFlags: Word;         { none currently defined. }
    wCountryID: Word;     { country code for topic/item strings used. }
    iCodePage: Integer;   { codepage used for topic/item strings. }
    dwLangID: Longint;    { language ID for topic/item strings. }
    dwSecurity: Longint;  { Private security code. }
  end;

{ The following structure is used by DdeQueryConvInfo(): }

  PConvInfo = ^TConvInfo;
  TConvInfo = record
    cb: Longint;            { sizeof(CONVINFO)  }
    hUser: Longint;         { user specified field  }
    hConvPartner: HConv;    { hConv on other end or 0 if non-ddemgr partner  }
    hszSvcPartner: HSz;     { app name of partner if obtainable  }
    hszServiceReq: HSz;     { AppName requested for connection  }
    hszTopic: HSz;          { Topic name for conversation  }
    hszItem: HSz;           { transaction item name or NULL if quiescent  }
    wFmt: Word;             { transaction format or NULL if quiescent  }
    wType: Word;            { XTYP_ for current transaction  }
    wStatus: Word;          { ST_ constant for current conversation  }
    wConvst: Word;          { XST_ constant for current transaction  }
    wLastError: Word;       { last transaction error.  }
    hConvList: HConvList;   { parent hConvList if this conversation is in a list }
    ConvCtxt: TConvContext; { conversation context }
  end;

const
  { conversation states (usState) }

  xst_NULL = 0;                 { quiescent states }
  xst_Incomplete = 1;
  xst_Connected = 2;
  xst_Init1 = 3;                { mid-initiation states }
  xst_Init2 = 4;
  xst_ReqSent = 5;              { active conversation states }
  xst_DataRcvd = 6;
  xst_PokeSent = 7;
  xst_PokeAckRcvd = 8;
  xst_ExecSent = 9;
  xst_ExecAckRcvd = 10;
  xst_AdvSent = 11;
  xst_UnadvSent = 12;
  xst_AdvAckRcvd = 13;
  xst_UnadvAckRcvd = 14;
  xst_AdvDataSent = 15;
  xst_AdvDataAckRcvd = 16;

  { used in LOWORD(dwData1) of XTYP_AdvReq callbacks... }

  cadv_LateAck = $FFFF;

  { conversation status bits (fsStatus) }

  st_Connected = $0001;
  st_Advise = $0002;
  st_IsLocal = $0004;
  st_Blocked = $0008;
  st_Client = $0010;
  st_Terminated = $0020;
  st_InList = $0040;
  st_BlockNext = $0080;
  st_IsSelf = $0100;

  { DDE constants for wStatus field }

  dde_FAck = $8000;
  dde_FBusy = $4000;
  dde_FDeferUpd = $4000;
  dde_FAckReq = $8000;
  dde_FRelease = $2000;
  dde_FRequested = $1000;
  dde_FAckReserved = $3ff0;
  dde_FAdvReserved = $3fff;
  dde_FDatReserved = $4fff;
  dde_FPokReserved = $dfff;
  dde_FAppStatus = $00ff;
  dde_FNotProcessed = $0000;

  { message filter hook types }

  msgf_DDEMgr = $8001;

  { default codepage for windows & old DDE convs. }

  cp_WinAnsi = 1004;

  { transaction types }

  xtypf_NoBlock = $0002; { cbr_Block will not work }
  xtypf_NoData = $0004;  { dde_FDeferUpd }
  xtypf_AckReq = $0008;  { dde_FAckReq }

  xclass_Mask = $FC00;
  xclass_Bool = $1000;
  xclass_Data = $2000;
  xclass_Flags = $4000;
  xclass_Notification = $8000;

  xtyp_Error = $0000 or xclass_Notification or xtypf_NoBlock;
  xtyp_AdvData = $0010 or xclass_Flags;
  xtyp_AdvReq = $0020 or xclass_Data or xtypf_NoBlock;
  xtyp_AdvStart = $0030 or xclass_Bool;
  xtyp_AdvStop = $0040 or xclass_Notification;
  xtyp_Execute = $0050 or xclass_Flags;
  xtyp_Connect = $0060 or xclass_Bool or xtypf_NoBlock;
  xtyp_Connect_Confirm = $0070 or xclass_Notification or xtypf_NoBlock;
  xtyp_XACT_Complete = $0080 or xclass_Notification;
  xtyp_Poke = $0090 or xclass_Flags;
  xtyp_Register = $00A0 or xclass_Notification or xtypf_NoBlock;
  xtyp_Request = $00B0 or xclass_Data;
  xtyp_Disconnect = $00C0 or xclass_Notification or xtypf_NoBlock;
  xtyp_Unregister = $00D0 or xclass_Notification or xtypf_NoBlock;
  xtyp_WildConnect = $00E0 or xclass_Data or xtypf_NoBlock;

  xtyp_Mask = $00F0;
  xtyp_Shift = 4;  { shift to turn xtyp_ into an index }

  { Timeout constants }

  Timeout_Async =           -1;

  { Transaction ID constatnts }
  QID_Sync =                -1;

  { public strings used in DDE }

  szddesys_Topic = 'System';
  szddesys_Item_Topics = 'Topics';
  szddesys_Item_SysItems = 'SysItems';
  szddesys_Item_RtnMsg = 'ReturnMessage';
  szddesys_Item_Status = 'Status';
  szddesys_Item_Formats = 'Formats';
  szddesys_Item_Help = 'Help';
  szdde_Item_ItemList = 'TopicItemList';

type
  { API entry points }
  TCallback = function (CallType, Fmt: Word; Conv: HConv; hsz1, hsz2: HSZ;
    Data: HDDEData; Data1, Data2: Longint): HDDEData;

const
  cbr_Block = $ffffffff;

{ DLL registration functions }

function DdeInitialize(var Inst: Longint; Callback: TCallback; Cmd, Res: Longint): Word;

const
  { Callback filter flags for use with standard apps. }

  cbf_Fail_SelfConnections = $00001000;
  cbf_Fail_Connections = $00002000;
  cbf_Fail_Advises = $00004000;
  cbf_Fail_Executes = $00008000;
  cbf_Fail_Pokes = $00010000;
  cbf_Fail_Requests = $00020000;
  cbf_Fail_AllSrvXActions = $0003f000;

  cbf_Skip_Connect_Confirms = $00040000;
  cbf_Skip_Registrations = $00080000;
  cbf_Skip_Unregistrations = $00100000;
  cbf_Skip_Disconnects = $00200000;
  cbf_Skip_AllNotifications = $003c0000;

  { Application command flags }

  AppCmd_ClientOnly = $00000010;
  AppCmd_FilterInits = $00000020;
  AppCmd_Mask = $00000FF0;

  { Application classification flags }

  AppClass_Standard = $00000000;
  AppClass_Mask = $0000000F;

function DdeUninitialize(Inst: Longint): Bool;

{ conversation enumeration functions }

function DdeConnectList(Inst: Longint; Service, Topic: HSZ;
  ConvList: HConvList; CC: PConvContext): HConvList;
function DdeQueryNextServer(ConvList: HConvList; ConvPrev: HConv): HConv;
function DdeDisconnectList(ConvList: HConvList): Bool;

{ conversation control functions }

function DdeConnect(Inst: Longint; Service, Topic: HSZ;
  CC: PConvContext): HConv;
function DdeDisconnect(Conv: HConv): Bool;
function DdeReconnect(Conv: HConv): HConv;

function DdeQueryConvInfo(Conv: HConv; Transaction: Longint;
 ConvInfo: PConvInfo): Word;
function DdeSetUserHandle(Conv: HConv; ID, User: Longint): Bool;

function DdeAbandonTransaction(Inst: Longint; Conv: HConv;
  Transaction: Longint): Bool;

{ app server interface functions }

function DdePostAdvise(Inst: Longint; Topic, Item: HSZ): Bool;
function DdeEnableCallback(Inst: Longint; Conv: HConv; Cmd: Word): Bool;

const
  ec_EnableAll = 0;
  ec_EnableOne = st_BlockNext;
  ec_Disable = st_Blocked;
  ec_QueryWaiting = 2;

function DdeNameService(Inst: Longint; hsz1, hsz2: HSZ;
  Cmd: Word): HDDEData;

const
  dns_Register = $0001;
  dns_Unregister = $0002;
  dns_FilterOn = $0004;
  dns_FilterOff = $0008;

{ app client interface functions }

function DdeClientTransaction(Data: Pointer; DataLen: Longint;
  Conv: HConv; Item: HSZ; Fmt, DataType: Word; Timeout: Longint;
  Result: PLongint): HDDEData;

{ data transfer functions }

function DdeCreateDataHandle(Inst: Longint; Src: Pointer;
  cb, Off: Longint; Item: HSZ; Fmt, Cmd: Word): HDDEData;

function DdeAddData(Data: HDDEData; Src: Pointer;
  cb, Off: Longint): HDDEData;
function DdeGetData(Data: HDDEData; Dst: Pointer;
  Max, Off: Longint): Longint;
function DdeAccessData(Data: HDDEData; DataSize: PLongint): Pointer;
function DdeUnaccessData(Data: HDDEData): Bool;
function DdeFreeDataHandle(Data: HDDEData): Bool;

const
  hdata_AppOwned = $0001;

function DdeGetLastError(Inst: Longint): Word;


const
  { error codes }

  dmlErr_No_Error = 0;       { must be 0 }

  dmlErr_First = $4000;

  dmlErr_AdvAckTimeout = $4000;
  dmlErr_Busy = $4001;
  dmlErr_DataAckTimeout = $4002;
  dmlErr_DLL_Not_Initialized = $4003;
  dmlErr_DLL_Usage = $4004;
  dmlErr_ExecAckTimeout = $4005;
  dmlErr_InvalidParameter = $4006;
  dmlErr_Low_Memory = $4007;
  dmlErr_Memory_Error = $4008;
  dmlErr_NotProcessed = $4009;
  dmlErr_No_Conv_Established = $400a;
  dmlErr_PokeAckTimeout = $400b;
  dmlErr_PostMsg_Failed = $400c;
  dmlErr_Reentrancy = $400d;
  dmlErr_Server_Died = $400e;
  dmlErr_Sys_Error = $400f;
  dmlErr_UnadvAckTimeout = $4010;
  dmlErr_Unfound_Queue_ID = $4011;

  dmlErr_Last = $4011;

function DdeCreateStringHandle(Inst: Longint; psz: PChar;
  CodePage: Integer): HSZ;
function DdeQueryString(Inst: Longint; HSZ: HSZ; psz: PChar;
  Max: Longint; CodePage: Integer): Longint;
function DdeFreeStringHandle(Inst: Longint; HSZ: HSZ): Bool;
function DdeKeepStringHandle(Inst: Longint; HSZ: HSZ): Bool;
function DdeCmpStringHandles(hsz1, hsz2: HSZ): Integer;

type
  { DDEML public debugging header file info }

  TMonMsgStruct = record
    cb: Word;
    hWndTo: HWnd;
    dwTime: Longint;
    hTask: THandle;
    wMsg: Word;
    wParam: Word;
    lParam: Longint;
  end;

  TMonCBStruct = record
    cb: Word;
    wReserved: Word;
    dwTime: Longint;
    hTask: THandle;
    dwRet: Longint;
    wType: Word;
    wFmt: Word;
    hConv: HConv;
    hsz1: HSZ;
    hsz2: HSZ;
    hData: HDDEData;
    dwData1: Longint;
    dwData2: Longint;
  end;

  TMonHSZStruct = record
    cb: Word;
    fsAction: Bool;    { mh_ value }
    dwTime: Longint;
    HSZ: HSZ;
    hTask: THandle;
    wReserved: Word;
    Str: array[0..0] of Char;
  end;

const
  mh_Create = 1;
  mh_Keep = 2;
  mh_Delete = 3;
  mh_Cleanup = 4;

type
  PMonErrStruct = ^TMonErrStruct;
  TMonErrStruct = record
    cb: Word;
    wLastError: Word;
    dwTime: Longint;
    hTask: THandle;
  end;

  PMonLinkStruct = ^TMonLinkStruct;
  TMonLinkStruct = record
    cb: Word;
    dwTime: Longint;
    hTask: THandle;
    fEstablished: Bool;
    fNoData: Bool;
    hszSvc: HSz;
    hszTopic: HSz;
    hszItem: HSz;
    wFmt: Word;
    fServer: Bool;
    hConvServer: HConv;
    hConvClient: HConv;
  end;

  PMonConvStruct = ^TMonConvStruct;
  TMonConvStruct = record
    cb: Word;
    fConnect: Bool;
    dwTime: Longint;
    hTask: THandle;
    hszSvc: HSz;
    hszTopic: HSz;
    hConvClient: HConv;
    hConvServer: HConv;
  end;

const
  max_Monitors = 4;
  appClass_Monitor = 1;
  xtyp_Monitor = $00F0 or xclass_Notification or xtypf_NoBlock;

const
{
 * Callback filter flags for use with MONITOR apps - 0 implies no monitor
 * callbacks.
}
  mf_Hsz_Info = $01000000;
  mf_SendMsgs = $02000000;
  mf_PostMsgs = $04000000;
  mf_CallBacks = $08000000;
  mf_Errors = $10000000;
  mf_Links = $20000000;
  mf_Conv = $40000000;


implementation

function DdeInitialize;                    external 'DDEML'    index 2;
function DdeUninitialize;                  external 'DDEML'    index 3;
function DdeConnectList;                   external 'DDEML'    index 4;
function DdeQueryNextServer;               external 'DDEML'    index 5;
function DdeDisconnectList;                external 'DDEML'    index 6;
function DdeConnect;                       external 'DDEML'    index 7;
function DdeDisconnect;                    external 'DDEML'    index 8;
function DdeReconnect;                     external 'DDEML'    index 37;
function DdeQueryConvInfo;                 external 'DDEML'    index 9;
function DdeSetUserHandle;                 external 'DDEML'    index 10;
function DdeAbandonTransaction;            external 'DDEML'    index 12;
function DdePostAdvise;                    external 'DDEML'    index 13;
function DdeEnableCallback;                external 'DDEML'    index 26;
function DdeNameService;                   external 'DDEML'    index 27;
function DdeClientTransaction;             external 'DDEML'    index 11;
function DdeCreateDataHandle;              external 'DDEML'    index 14;
function DdeAddData;                       external 'DDEML'    index 15;
function DdeGetData;                       external 'DDEML'    index 16;
function DdeAccessData;                    external 'DDEML'    index 17;
function DdeUnaccessData;                  external 'DDEML'    index 18;
function DdeFreeDataHandle;                external 'DDEML'    index 19;
function DdeGetLastError;                  external 'DDEML'    index 20;
function DdeCreateStringHandle;            external 'DDEML'    index 21;
function DdeQueryString;                   external 'DDEML'    index 23;
function DdeFreeStringHandle;              external 'DDEML'    index 22;
function DdeKeepStringHandle;              external 'DDEML'    index 24;
function DdeCmpStringHandles;              external 'DDEML'    index 36;

end.
