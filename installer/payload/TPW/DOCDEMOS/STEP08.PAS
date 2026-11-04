{************************************************}
{                                                }
{   Turbo Pascal for Windows                     }
{   Demo program                                 }
{   Copyright (c) 1991 by Borland International  }
{                                                }
{************************************************}

program MyProgram;

uses Strings, WinTypes, WinProcs, WinDos, WObjects, StdDlgs;

{$R COOKBOOK.RES}

const
  cm_New    = 101;
  cm_Open   = 102;
  cm_Save   = 103;
  cm_SaveAs = 104;
  cm_Help   = 901;

type
  TMyApplication = object(TApplication)
    procedure InitMainWindow; virtual;
  end;

type
  PMyWindow = ^TMyWindow;
  TMyWindow = object(TWindow)
    DragDC: HDC;
    ButtonDown: Boolean;
    ThePen: HPen;
    PenSize: Integer;
    Points: PCollection;
    FileName: array[0..fsPathName] of Char;
    constructor Init(AParent: PWindowsObject; ATitle: PChar);
    destructor Done; virtual;
    function CanClose: Boolean; virtual;
    procedure WMLButtonDown(var Msg: TMessage);
      virtual wm_First + wm_LButtonDown;
    procedure WMLButtonUp(var Msg: TMessage);
      virtual wm_First + wm_LButtonUp;
    procedure WMMouseMove(var Msg: TMessage);
      virtual wm_First + wm_MouseMove;
    procedure WMRButtonDown(var Msg: TMessage);
      virtual wm_First + wm_RButtonDown;
    procedure SetPenSize(NewSize: Integer);
    procedure Paint(PaintDC: HDC; var PaintInfo: TPaintStruct); virtual;
    procedure FileNew(var Msg: TMessage);
      virtual cm_First + cm_New;
    procedure FileOpen(var Msg: TMessage);
      virtual cm_First + cm_Open;
    procedure FileSave(var Msg: TMessage);
      virtual cm_First + cm_Save;
    procedure FileSaveAs(var Msg: TMessage);
      virtual cm_First + cm_SaveAs;
    procedure Help(var Msg: TMessage);
      virtual cm_First + cm_Help;
  end;

type
  PDPoint = ^TDPoint;
  TDPoint = object(TObject)
    X, Y: Integer;
    constructor Init(AX, AY: Integer);
  end;

{--------------------------------------------------}
{ TMyWindow's method implementations:              }
{--------------------------------------------------}

constructor TMyWindow.Init(AParent: PWindowsObject; ATitle: PChar);
begin
  TWindow.Init(AParent, ATitle);
  Attr.Menu := LoadMenu(HInstance, PChar(100));
  ButtonDown := False;
  PenSize := 1;
  ThePen := CreatePen(ps_Solid, PenSize, 0);
  Points := New(PCollection, Init(50, 50));
end;

destructor TMyWindow.Done;
begin
  Dispose(Points, Done);
  DeleteObject(ThePen);
  TWindow.Done;
end;

function TMyWindow.CanClose: Boolean;
var
  Reply: Integer;
begin
  CanClose := True;
  Reply := MessageBox(HWindow, 'Do you want to save?',
    'Drawing has changed', mb_YesNo or mb_IconQuestion);
  if Reply = id_Yes then CanClose := False;
end;

procedure TMyWindow.WMLButtonDown(var Msg: TMessage);
begin
  Points^.FreeAll;
  InvalidateRect(HWindow, nil, True);
  if not ButtonDown then
  begin
    ButtonDown := True;
    SetCapture(HWindow);
    DragDC := GetDC(HWindow);
    SelectObject(DragDC, ThePen);
    MoveTo(DragDC, Msg.LParamLo, Msg.LParamHi);
    Points^.Insert(New(PDPoint, Init(Msg.LParamLo, Msg.LParamHi)));
  end;
end;

procedure TMyWindow.WMMouseMove(var Msg: TMessage);
begin
  if ButtonDown then
  begin
    LineTo(DragDC, Integer(Msg.LParamLo), Integer(Msg.LParamHi));
    Points^.Insert(New(PDPoint, Init(Integer(Msg.LParamLo), Integer(Msg.LParamHi))));
  end;
end;

procedure TMyWindow.WMLButtonUp(var Msg: TMessage);
begin
  if ButtonDown then
  begin
    ButtonDown := False;
    ReleaseCapture;
    ReleaseDC(HWindow, DragDC);
  end;
end;

procedure TMyWindow.WMRButtonDown(var Msg: TMessage);
var
  InputText: array[0..5] of Char;
  NewSize, ErrorPos: Integer;
begin
  if not ButtonDown then
  begin
    Str(PenSize, InputText);
    if Application^.ExecDialog(New(PInputDialog,
      Init(@Self, 'Line Thickness', 'Input a new thickness:',
        InputText, SizeOf(InputText)))) = id_Ok then
    begin
      Val(InputText, NewSize, ErrorPos);
      if ErrorPos = 0 then SetPenSize(NewSize);
    end;
  end;
end;

procedure TMyWindow.SetPenSize(NewSize: Integer);
begin
  DeleteObject(ThePen);
  ThePen := CreatePen(ps_Solid, NewSize, 0);
  PenSize := NewSize;
end;

procedure TMyWindow.Paint(PaintDC: HDC; var PaintInfo: TPaintStruct);
var
  First: Boolean;

procedure DrawLine(P: PDPoint); far;
begin
  if First then MoveTo(PaintDC, P^.X, P^.Y)
  else LineTo(PaintDC, P^.X, P^.Y);
  First := False;
end;

begin
  SelectObject(PaintDC, ThePen);
  First := True;
  Points^.ForEach(@DrawLine);
end;

procedure TMyWindow.FileNew(var Msg: TMessage);
begin
  Points^.FreeAll;
  InvalidateRect(HWindow, nil, True);
end;

procedure TMyWindow.FileOpen(var Msg: TMessage);
begin
  if Application^.ExecDialog(New(PFileDialog,
    Init(@Self, PChar(sd_FileOpen), StrCopy(FileName, '*.PTS')))) = id_Ok then
    MessageBox(HWindow, FileName, 'Open the file:', mb_Ok);
end;

procedure TMyWindow.FileSave(var Msg: TMessage);
begin
  MessageBox(HWindow, 'Feature not implemented', 'FileSave', mb_Ok);
end;

procedure TMyWindow.FileSaveAs(var Msg: TMessage);
begin
  if Application^.ExecDialog(New(PFileDialog,
      Init(@Self, PChar(sd_FileSave), FileName))) = id_Ok then
    MessageBox(HWindow, FileName, 'Save the file:', mb_Ok);
end;

procedure TMyWindow.Help(var Msg: TMessage);
var
  HelpWnd: PWindow;
begin
  HelpWnd := New(PWindow, Init(@Self, 'Help System'));
  with HelpWnd^.Attr do
  begin
    Style := Style or ws_Visible or ws_PopupWindow or ws_Caption;
    X := 100;
    Y := 100;
    W := 300;
    H := 300;
  end;
  Application^.MakeWindow(HelpWnd);
end;

{--------------------------------------------------}
{ TDPoints's method implementations:               }
{--------------------------------------------------}

constructor TDPoint.Init(AX, AY: Integer);
begin
  X := AX;
  Y := AY;
end;

{--------------------------------------------------}
{ TMyApplication's method implementations:         }
{--------------------------------------------------}

procedure TMyApplication.InitMainWindow;
begin
  MainWindow := New(PMyWindow, Init(nil, 'Sample ObjectWindows Program'));
end;

{--------------------------------------------------}
{ Main program:                                    }
{--------------------------------------------------}

var
  MyApp : TMyApplication;

begin
  MyApp.Init('MyProgram');
  MyApp.Run;
  MyApp.Done;
end.
