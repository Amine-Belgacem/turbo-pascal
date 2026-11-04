{************************************************}
{                                                }
{   Turbo Pascal for Windows                     }
{   Demo program                                 }
{   Copyright (c) 1991 by Borland International  }
{                                                }
{************************************************}

program MyProgram;

uses Strings, WinTypes, WinProcs, WObjects;

type
  TMyApplication = object(TApplication)
    procedure InitMainWindow; virtual;
  end;

type
  PMyWindow = ^TMyWindow;
  TMyWindow = object(TWindow)
    DragDC: HDC;
    ButtonDown: Boolean;
    constructor Init(AParent: PWindowsObject; ATitle: PChar);
    function CanClose: Boolean; virtual;
    procedure WMLButtonDown(var Msg: TMessage);
      virtual wm_First + wm_LButtonDown;
    procedure WMLButtonUp(var Msg: TMessage);
      virtual wm_First + wm_LButtonUp;
    procedure WMMouseMove(var Msg: TMessage);
      virtual wm_First + wm_MouseMove;
    procedure WMRButtonDown(var Msg: TMessage);
      virtual wm_First + wm_RButtonDown;
  end;

{--------------------------------------------------}
{ TMyWindow's method implementations:              }
{--------------------------------------------------}

constructor TMyWindow.Init(AParent: PWindowsObject; ATitle: PChar);
begin
  TWindow.Init(AParent, ATitle);
  ButtonDown := False;
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
  InvalidateRect(HWindow, nil, True);
  if not ButtonDown then
  begin
    ButtonDown := True;
    SetCapture(HWindow);
    DragDC := GetDC(HWindow);
    MoveTo(DragDC, Msg.LParamLo, Msg.LParamHi);
  end;
end;

procedure TMyWindow.WMMouseMove(var Msg: TMessage);
begin
  if ButtonDown then
    LineTo(DragDC, Integer(Msg.LParamLo), Integer(Msg.LParamHi));
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
begin
  InvalidateRect(HWindow, nil, True);
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
  MyApp: TMyApplication;

begin
  MyApp.Init('MyProgram');
  MyApp.Run;
  MyApp.Done;
end.
