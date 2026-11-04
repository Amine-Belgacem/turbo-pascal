
{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit OLE;

interface

uses WinTypes;

{ Object types }

const
  ot_Link = 1;
  ot_Embedded = 2;
  ot_Static = 3;


{ activate verbs }

  oleverb_Primary = 0;

type
  POleTargetDevice = ^TOleTargetDevice;
  TOleTargetDevice = record
    otdDeviceNameOffset: Word;
    otdDriverNameOffset: Word;
    otdPortNameOffset: Word;
    otdExtDevmodeOffset: Word;
    otdExtDevmodeSize: Word;
    otdEnvironmentOffset: Word;
    otdEnvironmentSize: Word;
    otdData: array[0..0] of Byte;
  end;

const
{ flags used in some methods }

  of_Set = $0001;
  of_Get = $0002;
  of_Handler = $0004;

{ return codes for OLE functions }

type
  TOleStatus = Word;

const
  ole_OK = 0;                     {  0   Function operated correctly }

  ole_Wait_For_Release = 1;       {  1   Command has been initiated, client  }
                                  {      must wait for release. keep dispatching }
                                  {      messages till ole_RELEASE in callback }

  ole_Busy = 2;                   {  2   Tried to execute a method while another }
                                  {      method is in progress. }

  ole_Error_Protect_Only = 3;     {  3   Ole APIs are called in real mode  }
  ole_Error_Memory = 4;           {  4   Could not alloc or lock memory }
  ole_Error_Stream = 5;           {  5   (TOleStream) stream error }
  ole_Error_Static = 6;           {  6   Non static object expected }
  ole_Error_Blank = 7;            {  7   Critical data missing }
  ole_Error_Draw = 8;             {  8   Error while drawing }
  ole_Error_Metafile = 9;         {  9   Invalid metafile }
  ole_Error_Abort = 10;           {  10  Client chose to abort metafile drawing }
  ole_Error_Clipboard = 11;       {  11  Failed to get/set clipboard data }
  ole_Error_Format = 12;          {  12  Requested format is not available }
  ole_Error_Object = 13;          {  13  Not a valid object }
  ole_Error_Option = 14;          {  14  Invalid option (link update / render) }
  ole_Error_Protocol = 15;        {  15  Invalid protocol }
  ole_Error_Address = 16;         {  16  One of the pointers is invalid }
  ole_Error_Not_Equal = 17;       {  17  Objects are not equal }
  ole_Error_Handle = 18;          {  18  Invalid handle encountered }
  ole_Error_Generic = 19;         {  19  Some general error }
  ole_Error_Class = 20;           {  20  Invalid class }
  ole_Error_Syntax = 21;          {  21  Command syntax is invalid }
  ole_Error_DataType = 22;        {  22  Data format is not supported }
  ole_Error_Palette = 23;         {  23  Invalid color palette }
  ole_Error_Not_Link = 24;        {  24  Not a linked object }
  ole_Error_Not_Empty = 25;       {  25  Client doc contains objects. }
  ole_Error_Size = 26;            {  26  Incorrect buffer size passed to the api }
                                  {      that places some string in caller's }
                                  {      buffer }
  ole_Error_Drive = 27;           {  27  Drive letter in doc name is invalid }
  ole_Error_Network = 28;         {  28  Failed to establish connection to a }
                                  {      network share on which the document }
                                  {      is located }
  ole_Error_Name = 29;            {  29  Invalid name (doc name, object name), }
                                  {      etc.. passed to the APIs }
  ole_Error_Template = 30;        {  30  Server failed to load template }
  ole_Error_New = 31;             {  31  Server failed to create new doc }
  ole_Error_Edit = 32;            {  32  Server failed to create embedded }
                                  {      instance }
  ole_Error_Open = 33;            {  33  Server failed to open document,  }
                                  {      possible invalid link }
  ole_Error_Not_Open = 34;        {  34  Object is not open for editing }
  ole_Error_Launch = 35;          {  35  Failed to launch server }
  ole_Error_Comm = 36;            {  36  Failed to communicate with server }
  ole_Error_Terminate = 37;       {  37  Error in termination }
  ole_Error_Command = 38;         {  38  Error in execute }
  ole_Error_Show = 39;            {  39  Error in show }
  ole_Error_DoVerb = 40;          {  40  Error in sending do verb, or invalid }
                                  {      verb }
  ole_Error_Advise_Native = 41;   {  41  Item could be missing }
  ole_Error_Advise_Pict = 42;     {  42  Item could be missing or server doesn't }
                                  {      this format. }
  ole_Error_Advise_Rename = 43;   {  43  Server doesn't support rename }
  ole_Error_Poke_Native = 44;     {  44  Failure of poking native data to server }
  ole_Error_Request_Native = 45;  {  45  Server failed to render native data }
  ole_Error_Request_Pict = 46;    {  46  Server failed to render presentation }
                                  {      data }
  ole_Error_Server_Blocked = 47;  {  47  Trying to block a blocked server or }
                                  {      trying to revoke a blocked server }
                                  {      or document }
  ole_Error_Registration = 48;    {  48  Server is not registered in regestration }
                                  {      data base }
  ole_Error_Already_Registered = 49;{ 49  Trying to register same doc multiple }
                                  {     times }
  ole_Error_Task = 50;            {  50  Server or client task is invalid }
  ole_Error_OutOfDate = 51;       {  51  Object is out of date }
  ole_Error_Cant_Update_Client = 52;{  52  embed doc's client doesn't accept  }
                                  {      updates }
  ole_Error_Update = 53;          {  53  error while trying to update  }

  ole_Error_Setdata_Format = 54;  { 54  Server app doesn't understand the       }
                                  {     format given to its SetData method      }
  ole_Error_Static_From_Other_OS = 55; { 55 trying to load a static object created }
                                  {    on another Operating System           }
  {  Following are warnings    }

  ole_Warn_Delete_Data = 1000;    {      Caller must delete the data when }
                                  {      done with it. }

{  Codes for CallBack events }
type
  TOle_Notification = Word;

const
  ole_Changed = 0;            {  0 }
  ole_Saved = 1;              {  1 }
  ole_Closed = 2;             {  2 }
  ole_Renamed = 3;            {  3 }
  ole_Query_Paint = 4;        {  4  Interruptible paint support }
  ole_Release = 5;            {  5  Object is released (asynchronous operation }
                              {     is completed) }
  ole_Query_Retry = 6;        {  6  Query for retry when server sends busy ACK }


type
  TOle_Release_Method = Word;

const
  ole_None = 0;                {  0  no method active }
  ole_Delete = 1;              {  1  object delete }
  ole_LnkPaste = 2;            {  2  PasteLink (auto reconnect) }
  ole_EmbPaste = 3;            {  3  paste (and update)  }
  ole_Show = 4;                {  4  Show }
  ole_Run = 5;                 {  5  Run }
  ole_Activate = 6;            {  6  Activate }
  ole_Update = 7;              {  7  Update }
  ole_Close = 8;               {  8  Close }
  ole_Reconnect = 9;           {  9  Reconnect }
  ole_SetUpdateOptions = 10;   {  10 setting update options }
  ole_ServerUnlaunch = 11;     {  11 server is being unlaunched }
  ole_LoadFromStream = 12;     {  12 LoadFromStream (auto reconnect) }
  ole_SetData = 13;            {  13 OleSetData }
  ole_RequestData = 14;        {  14 OleRequestData }
  ole_Other = 15;              {  15 other misc async operations }
  ole_Create = 16;             {  16 create }
  ole_CreateFromTemplate = 17; {  17 CreatefromTemplate }
  ole_CreateLinkFromFile = 18; {  18 CreateLinkFromFile }
  ole_CopyFromLnk = 19;        {  19 CopyFromLink (auto reconnect) }
  ole_CreateFromFile = 20;     {  20 CreateFromFile }
  ole_CreateInvisible = 21;    {  21 CreateInvisible }

  { rendering options }

type
  TOleOpt_Render = Word;

const
  olerender_none = 0;
  olerender_draw = 1;
  olerender_format = 2;

type
  TOleClipFormat = Word; {  standard clipboard format type }

  { Link update options }

  TOleOpt_Update = Word;

const
  oleupdate_always = 0;
  oleupdate_onsave = 1;
  oleupdate_oncall = 2;
  oleupdate_onclose = 3;

type
  HObject = THandle;
  LHServer = Longint;
  LHClientDoc = Longint;
  LHServerDoc = Longint;

  POleObject = ^TOleObject;
  POleStream = ^TOleStream;
  POleClient = ^TOleClient;
  POleObjectVTbl = ^TOleObjectVTbl;

  TOleObject = record
    lpvtbl: POleObjectVTbl;
  end;

  TOleObjectVTbl = record
    QueryProtocol: function (Self: POleObject; Protocol: PChar): Pointer;
    Release: function (Self: POleObject): TOleStatus;
    Show: function (Self: POleObject; TakeFocus: Bool): TOleStatus;
    DoVerb: function (Self: POleObject; Verb: Word; Show, Focus: Bool): TOleStatus;
    GetData: function (Self: POleObject; Format: TOleClipFormat;
      var Handle: THandle): TOleStatus;
    SetData: function (Self: POleObject; Format: TOleClipFormat;
      Data: THandle): TOleStatus;
    SetTargetDevice: function (Self: POleObject;
      TargetDevice: THandle): TOleStatus;
    SetBounds: function (Self: POleObject; var Bounds: TRect): TOleStatus;
    EnumFormats: function (Self: POleObject;
      Format: TOleClipFormat): TOleClipFormat;
    SetColorScheme: function (Self: POleObject; var Palette:
      TLogPalette): TOleStatus;

    { Server has to implement only the above methods. }

    { Extra methods required for client. }

    Delete: function (Self: POleObject): TOleStatus;
    SetHostNames: function (Self: POleObject; Client,
      ClientObj: PChar): TOleStatus;
    SaveToStream: function (Self: POleObject; Stream: POleStream): TOleStatus;
    Clone: function (Self: POleObject; Client: POleClient;
      ClientDoc: LHClientDoc; ObjectName: PChar;
      var OleObject: POleObject): TOleStatus;
    CopyFromLink: function (Self: POleObject; Client: POleClient;
      ClientDoc: LHClientDoc; ObjName: PChar;
      var OleObject: POleObject): TOleStatus;
    Equal: function (Self: POleObject; OleObject: POleObject): TOleStatus;
    CopyToClipboard: function (Self: POleObject): TOleStatus;
    Draw: function (Self: POleObject; DC: HDC; var Bounds, WBounds: TRect;
      FormatDC: HDC): TOleStatus;
    Activate: function (Self: POleObject; Verb: Word; Show, TakeFocus: Bool;
      hWnd: HWnd; Bounds: PRect): TOleStatus;
    Execute: function (Self: POleObject; Commands: THandle;
      Reserved: Word): TOleStatus;
    Close: function (Self: POleObject): TOleStatus;
    Update: function (Self: POleObject): TOleStatus;
    Reconnect: function (Self: POleObject): TOleStatus;

    ObjectConvert: function (Self: POleObject; Protocol: PChar;
      Client: POleClient; ClientDoc: LHClientDoc; ObjName: PChar;
      var OleObject: POleObject): TOleStatus;
    GetLinkUpdateOptions: function (Self: POleObject;
      var UpdateOpt: TOleOpt_Update): TOleStatus;
    SetLinkUpdateOptions: function (Self: POleObject;
      UpdateOpt: TOleOpt_Update): TOleStatus;

    Rename: function (Self: POleObject; NewName: PChar): TOleStatus;
    QueryName: function (Self: POleObject; Name: PChar;
      var NameSize: Word): TOleStatus;

    QueryType: function (Self: POleObject; var ObjType: Longint): TOleStatus;
    QueryBounds: function (Self: POleObject; var Bounds: TRect): TOleStatus;
    QuerySize: function (Self: POleObject; var Size: Longint): TOleStatus;
    QueryOpen: function (Self: POleObject): TOleStatus;
    QueryOutOfDate: function (Self: POleObject): TOleStatus;

    QueryReleaseStatus: function (Self: POleObject): TOleStatus;
    QueryReleaseError: function (Self: POleObject): TOleStatus;
    QueryReleaseMethod: function (Self: POleObject): TOle_Release_Method;

    RequestData: function (Self: POleObject;
      Format: TOleClipFormat): TOleStatus;
    ObjectLong: function (Self: POleObject; Flags: Word;
      Data: PLongint): TOleStatus;

    { This method is internal only }
    ChangeData: function (Self: POleObject; Data: THandle;
     Client: POleClient; Flag: Bool): TOleStatus;
  end;

  { ole client definitions }

  POleClientVTbl = ^TOleClientVTbl;

  TOleClient = record
    lpvtbl: POleClientVTBL;
  end;

  TOleClientVTbl = record
    CallBack: function (Client: POleClient; Nofication: TOle_Notification;
      OleObject: POleObject): Integer;
  end;

  { Stream definitions }

  POleStreamVTbl = ^TOleStreamVTbl;

  TOleStream = record
    lpstbl: POleStreamVTbl;
  end;

  TOleStreamVTbl = record
    Get: function (Stream: POleStream; Buffer: PChar;
      Size: Longint): Longint;
    Put: function (Stream: POleStream; Buffer: PChar;
      Size: Longint): Longint;
  end;

{ Public Function Prototypes }

function OleDelete(Self: POleObject): TOleStatus;
function OleRelease(Self: POleObject): TOleStatus;
function OleSaveToStream(Self: POleObject; Stream: POleStream): TOleStatus;
function OleEqual(Self: POleObject; OleObject: POleObject): TOleStatus;
function OleCopyToClipboard(Self: POleObject): TOleStatus;
function OleSetHostNames(Self: POleObject; ClientName,
  ObjectName: PChar): TOleStatus;
function OleSetTargetDevice(Self: POleObject;
  TargetDevice: THandle): TOleStatus;
function OleSetBounds(Self: POleObject; var Bounds: TRect): TOleStatus;
function OleSetColorScheme(Self: POleObject;
  var Palette: TLogPalette): TOleStatus;
function OleQueryBounds(Self: POleObject; var Bounds: TRect): TOleStatus;
function OleQuerySize(Self: POleObject; var Size: Longint): TOleStatus;
function OleDraw(Self: POleObject; DC: HDC; var Bounds, WBounds: TRect;
  FormatDC: HDC): TOleStatus;
function OleQueryOpen(Self: POleObject): TOleStatus;
function OleActivate(Self: POleObject; Verb: Word; Show, TakeFocus: Bool;
  hWnd: HWnd; Bounds: PRect): TOleStatus;
function OleExecute(Self: POleObject; Commands: THandle;
  Reserved: Word): TOleStatus;
function OleClose(Self: POleObject): TOleStatus;
function OleUpdate(Self: POleObject): TOleStatus;
function OleReconnect(Self: POleObject): TOleStatus;

function OleGetLinkUpdateOptions(Self: POleObject;
  var UpdateOpt: TOleOpt_Update): TOleStatus;
function OleSetLinkUpdateOptions(Self: POleObject;
  UpdateOpt: TOleOpt_Update): TOleStatus;

function OleQueryProtocol(Self: POleObject; Protocol: PChar): Pointer;

{ Routines related to asynchronous operations. }

function OleQueryReleaseStatus(Self: POleObject): TOleStatus;
function OleQueryReleaseError(Self: POleObject): TOleStatus;
function OleQueryReleaseMethod(Self: POleObject): TOle_Release_Method;

function OleQueryType(Self: POleObject; var LinkType: Longint): TOleStatus;

{ Low word is major version, High word is minor version }

function OleQueryClientVersion: Longint;
function OleQueryServerVersion: Longint;

{ Converting to format (as in clipboard): }

function OleEnumFormats(Self: POleObject;
  Format: TOleClipFormat): TOleClipFormat;

function OleGetData(Self: POleObject; Format: TOleClipFormat;
  var Data: THandle): TOleStatus;
function OleSetData(Self: POleObject; Format: TOleClipFormat;
  Data: THandle): TOleStatus;
function OleQueryOutOfDate(Self: POleObject): TOleStatus;
function OleRequestData(Self: POleObject;
  Format: TOleClipFormat): TOleStatus;

{ Query apis for creation from clipboard }

function OleQueryLinkFromClip(Protocol: PChar; render_opt: TOleOPT_Render; Format: TOleClipFormat): TOleStatus;
function OleQueryCreateFromClip(Protocol: PChar; render_opt: TOleOPT_Render; Format: TOleClipFormat): TOleStatus;

{ Object creation functions }

function OleCreateFromClip(Protocol: PChar; Client: POleClient;
  ClientDoc: LHClientDoc; ObjName: PChar; var OleObject: POleObject;
  RenderOpt: TOleOPT_Render; Format: TOleClipFormat): TOleStatus;
function OleCreateLinkFromClip(Protocol: PChar; Client: POleClient;
  ClientDoc: LHClientDoc; ObjectName: PChar; var OleObject: POleObject;
  RenderOpt: TOleOPT_Render; Format: TOleClipFormat): TOleStatus;
function OleCreateFromFile(Protocol: PChar; Client: POleClient;
  Class, OleFile: PChar; ClientDoc: LHClientDoc; ObjName: PChar;
  var OleObject: POleObject; RenderOpt: TOleOPT_Render;
  Format: TOleClipFormat): TOleStatus;
function OleCreateLinkFromFile(Protocol: PChar; Client: POleClient;
  Class, OleFile, Item: PChar; ClientDoc: LHClientDoc; ObjName: PChar;
  var OleObject: POleObject; RenderOpt: TOleOPT_Render;
  Format: TOleClipFormat): TOleStatus;
function OleLoadFromStream(Stream: POleStream; Protocol: PChar;
  Client: POleClient; ClientDoc: LHClientDoc; ObjectName: PChar;
  var OleObject: POleObject): TOleStatus;

function OleCreate(Protocol: PChar; Client: POleClient; Class: PChar;
  ClientDoc: LHClientDoc; ObjectName: PChar; var OleObject: POleObject;
  RenderOpt: TOleOPT_Render; Format: TOleClipFormat): TOleStatus;
function OleCreateInvisible(Protocol: PChar; Client: POleClient; Class: PChar;
  ClientDoc: LHClientDoc; ObjName: PChar; var OleObject: POleObject;
  RenderOpt: TOleOPT_Render; Format: TOleClipFormat;
  Activate: Bool): TOleStatus;
function OleCreateFromTemplate(Protocol: PChar; Client: POleClient;
  Template: PChar; ClientDoc: LHClientDoc; ObjName: PChar;
  var OleObject: POleObject; RenderOpt: TOleOPT_Render;
  Format: TOleClipFormat): TOleStatus;
function OleClone(OleObject: POleObject; Client: POleClient;
  ClientDoc: LHClientDoc; ObjName: PChar; var OleObject: POleObject): TOleStatus;
function OleCopyFromLink(OleObject: POleObject; Protocol: PChar;
  Client: POleClient; ClientDoc: LHClientDoc; ObjName: PChar;
  var OleObject: POleObject): TOleStatus;

function OleObjectConvert(OleObject: POleObject; Protocol: PChar;
  Client: POleClient; ClientDoc: LHClientDoc; ObjName: PChar;
  var OleObject: POleObject): TOleStatus;

function OleRename(Self: POleObject; NewName: PChar): TOleStatus;
function OleQueryName(Self: POleObject; Name: PChar;
  var NameSize: Word): TOleStatus;


function OleRevokeObject(Client: POleClient): TOleStatus;
function OleIsDcMeta(DC: HDC): Bool;

{ client document API  }

function OleRegisterClientDoc(Class, Doc: PChar; Reserved: Longint;
  var Doc: LHClientDoc): TOleStatus;
function OleRevokeClientDoc(ClientDoc: LHClientDoc): TOleStatus;
function OleRenameClientDoc(ClientDoc: LHClientDoc;
  NewDocName: PChar): TOleStatus;
function OleRevertClientDoc(ClientDoc: LHClientDoc): TOleStatus;
function OleSavedClientDoc(ClientDoc: LHClientDoc): TOleStatus;
function OleEnumObjects(ClientDoc: LHClientDoc;
  var OleObject: POleObject): TOleStatus;

{ server usage definitions }

type
  TOle_Server_Use =  Word;

const
  ole_Server_Multi = 0;            { multiple instances }
  ole_Server_Single = 1;           { single instance (multiple document) }

{ Server API }

type
  POleServer = ^TOleServer;
  POleServerDoc = ^TOleServerDoc;
  POleServerVTBl = ^TOleServerVTbl;

  TOleServerVTbl = record
    Open: function (Server: POleServer; Doc: LHServerDoc; DocName: PChar;
      var ServerDoc: POleServerDoc): TOleStatus;
                                    { long handle to doc (privtate to DLL) }
                                    { lp to OleServer }
                                    { document name }
                                    { place holder for returning oledoc. }


    Create: function (Server: POleServer; Doc: LHServerDoc; Class,
      DocName: PChar; var ServerDoc: POleServerDoc): TOleStatus;
                                    { long handle to doc (privtate to DLL) }
                                    { lp to OleServer }
                                    { lp class name }
                                    { lp doc name }
                                    { place holder for returning oledoc. }


    CreateFromTemplate: function (Server: POleServer; Doc: LHServerDoc; Class,
      DocName, TemplateName: PChar; var ServerDoc: POleServerDoc): TOleStatus;

                                    { long handle to doc (privtate to DLL) }
                                    { lp to OleServer }
                                    { lp class name }
                                    { lp doc name }
                                    { lp template name }
                                    { place holder for returning oledoc. }


    Edit: function (Server: POleServer; Doc: LHServerDoc; Class,
      DocName: PChar; var ServerDoc: POleServerDoc): TOleStatus;

                                    { long handle to doc (privtate to DLL) }
                                    { lp to OleServer }
                                    { lp class name }
                                    { lp doc name }
                                    { place holder for returning oledoc. }

    Exit: function (Server: POleServer): TOleStatus;

                                    { lp OleServer }


    Release: function (Server: POleServer): TOleStatus;
                                    { lp OleServer }

    Execute: function (Server: POleServer; Commands: THandle): TOleStatus;
                                    { lp OleServer }
                                    { handle to command strings }
  end;

  TOleServer = record
    lpvtbl: POleServerVTbl;
  end;

  POleServerDocVTbl = ^TOleServerDocVTbl;
  TOleServerDocVTbl = record
    Save: function (Doc: POleServerDoc): TOleStatus;
    Close: function (Doc: POleServerDoc): TOleStatus;
    SetHostNames: function (Doc: POleServerDoc; Client, Doc: PChar): TOleStatus;
    SetDocDimensions: function (Doc: POleServerDoc;
     var Bounds: TRect): TOleStatus;
    GetObject: function (Doc: POleServerDoc; Item: PChar;
      var OleObject: POleObject; Client: POleClient): TOleStatus;
    Release: function (Doc: POleServerDoc): TOleStatus;
    SetColorScheme: function (Doc: POleServerDoc;
     var Palette: TLogPalette): TOleStatus;
    Execute: function (Doc: POleServerDoc; Commands: THandle): TOleStatus;
  end;

  TOleServerDoc = record
    lpvtbl: POleServerDocVTbl;
  end;


function OleRegisterServer(Class: PChar; ServerDef: POleServer;
  var Server: LHServer; Inst: THandle; Use: TOle_Server_Use): TOleStatus;
function OleRevokeServer(Server: LHServer): TOleStatus;
function OleBlockServer(Server: LHServer): TOleStatus;
function OleUnblockServer(Server: LHServer; var Reqests: Bool): TOleStatus;

{ APIs to keep server open }

function OleLockServer(OleObject: POleObject; var Server: LHServer): TOleStatus;
function OleUnlockServer(Sever: LHServer): TOleStatus;

{ Server document API  }

function OleRegisterServerDoc(Server: LHServer; DocName: PChar;
  DocDef: POleServerDoc; var Doc: LHServerDoc): TOleStatus;
function OleRevokeServerDoc(Doc: LHServerDoc): TOleStatus;
function OleRenameServerDoc(Doc: LHServerDoc; NewName: PChar): TOleStatus;
function OleRevertServerDoc(Doc: LHServerDoc): TOleStatus;
function OleSavedServerDoc(Doc: LHServerDoc): TOleStatus;

implementation

function OleDelete;                        external 'OLECLI'   index 2;
function OleRelease;                       external 'OLECLI'   index 40;
function OleSaveToStream;                  external 'OLECLI'   index 3;
function OleEqual;                         external 'OLECLI'   index 8;
function OleCopyToClipboard;               external 'OLECLI'   index 13;
function OleSetHostNames;                  external 'OLECLI'   index 15;
function OleSetTargetDevice;               external 'OLECLI'   index 16;
function OleSetBounds;                     external 'OLECLI'   index 17;
function OleSetColorScheme;                external 'OLECLI'   index 49;
function OleQueryBounds;                   external 'OLECLI'   index 18;
function OleQuerySize;                     external 'OLECLI'   index 56;
function OleDraw;                          external 'OLECLI'   index 19;
function OleQueryOpen;                     external 'OLECLI'   index 20;
function OleActivate;                      external 'OLECLI'   index 21;
function OleExecute;                       external 'OLECLI'   index 57;
function OleClose;                         external 'OLECLI'   index 27;
function OleUpdate;                        external 'OLECLI'   index 22;
function OleReconnect;                     external 'OLECLI'   index 23;
function OleGetLinkUpdateOptions;          external 'OLECLI'   index 24;
function OleSetLinkUpdateOptions;          external 'OLECLI'   index 25;
function OleQueryProtocol;                 external 'OLECLI'   index 30;
function OleQueryReleaseStatus;            external 'OLECLI'   index 35;
function OleQueryReleaseError;             external 'OLECLI'   index 36;
function OleQueryReleaseMethod;            external 'OLECLI'   index 37;
function OleQueryType;                     external 'OLECLI'   index 14;
function OleQueryClientVersion;            external 'OLECLI'   index 59;
function OleQueryServerVersion;            external 'OLESVR'   index 12;
function OleEnumFormats;                   external 'OLECLI'   index 26;
function OleGetData;                       external 'OLECLI'   index 28;
function OleSetData;                       external 'OLECLI'   index 29;
function OleQueryOutOfDate;                external 'OLECLI'   index 31;
function OleRequestData;                   external 'OLECLI'   index 50;
function OleQueryLinkFromClip;             external 'OLECLI'   index 9;
function OleQueryCreateFromClip;           external 'OLECLI'   index 10;
function OleCreateFromClip;                external 'OLECLI'   index 12;
function OleCreateLinkFromClip;            external 'OLECLI'   index 11;
function OleCreateFromFile;                external 'OLECLI'   index 38;
function OleCreateLinkFromFile;            external 'OLECLI'   index 39;
function OleLoadFromStream;                external 'OLECLI'   index 4;
function OleCreate;                        external 'OLECLI'   index 34;
function OleCreateFromTemplate;            external 'OLECLI'   index 33;
function OleClone;                         external 'OLECLI'   index 6;
function OleCopyFromLink;                  external 'OLECLI'   index 7;
function OleObjectConvert;                 external 'OLECLI'   index 32;
function OleRename;                        external 'OLECLI'   index 46;
function OleQueryName;                     external 'OLECLI'   index 48;
function OleRevokeObject;                  external 'OLESVR'   index 11;
function OleIsDcMeta;                      external 'OLECLI'   index 60;
function OleRegisterClientDoc;             external 'OLECLI'   index 41;
function OleRevokeClientDoc;               external 'OLECLI'   index 42;
function OleRenameClientDoc;               external 'OLECLI'   index 43;
function OleRevertClientDoc;               external 'OLECLI'   index 44;
function OleSavedClientDoc;                external 'OLECLI'   index 45;
function OleEnumObjects;                   external 'OLECLI'   index 47;
function OleRegisterServer;                external 'OLESVR'   index 2;
function OleRevokeServer;                  external 'OLESVR'   index 3;
function OleBlockServer;                   external 'OLESVR'   index 4;
function OleUnblockServer;                 external 'OLESVR'   index 5;
function OleLockServer;                    external 'OLECLI'   index 54;
function OleUnlockServer;                  external 'OLECLI'   index 55;
function OleRegisterServerDoc;             external 'OLESVR'   index 6;
function OleRevokeServerDoc;               external 'OLESVR'   index 7;
function OleRenameServerDoc;               external 'OLESVR'   index 8;
function OleRevertServerDoc;               external 'OLESVR'   index 9;
function OleSavedServerDoc;                external 'OLESVR'   index 10;
function OleCreateInvisible;               external 'OLECLI'   index 58;

end.

