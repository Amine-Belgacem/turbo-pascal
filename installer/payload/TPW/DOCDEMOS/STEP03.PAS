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
    function CanClose: Boolean; virtual;
    procedure WMLButtonDown(var Msg: TMessage);
      virtual wm_First + wm_LButtonDown;
    procedure WMRButtonDown(var Msg: TMessage);
      virtual wm_First + wm_RButtonDown;
  end;

{--------------------------------------------------}
{ TMyWindow's method implementations:              }
{--------------------------------------------------}

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
var
  DC: HDC;
  S: array[0..9] of Char;
begin
  WVSPrintF(S, '(%d,%d)', Msg.LParam);
  DC := GetDC(HWindow);
  TextOut(DC, Msg.LParamLo, Msg.LParamHi, S, StrLen(S));
  ReleaseDC(HWindow, DC);
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
