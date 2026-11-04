{************************************************}
{                                                }
{   Turbo Pascal for Windows                     }
{   Demo program                                 }
{   Copyright (c) 1992 by Borland International  }
{                                                }
{************************************************}

{
  This OWL example demonstrates how to make an application PenWindows
  sensitive.
 
  If this application is not running under PenWindows then the application
  works like a traditional Windows application with a TextEdit box.
 
  The mouse should only be used as the stylus for testing it is almost always
  inferior to a pen/tablet hardware configuration. It will also produce poor
  recognition results.
 
  This is the simplest way to make an application pen aware the steps are:
 
      1. Check for PenWindows
      2. Register the application as a pen application, if PenWindow exists
      3. Create two different dialog boxes depending on whether the
	 application is running under Windows or PenWindows.  Under Pen
	 Windows a BEDIT control is used for text recognition and entry.
 }

program OWLPenDemo;

uses WinProcs, WinTypes, WObjects, Strings, Win31, PenWin;

{$R OWLPEN.RES}

const
  id_Button          = 101;
  TextEntryDialog    = 102;
  PenTextEntryDialog = 103;

  id_Edit            = 1000;
  id_Show            = 1001;
  id_Text            = 1002;

type
  TRegPenApp = procedure(w: Word; b: Bool);

  TTestApp = object(TApplication)
    hPenWin: THandle;
    RegPen: Pointer;
    procedure InitMainWindow; virtual;
  end;

  PTestWIndow = ^TTestWindow;
  TTestWindow = object(TWindow)
   EditText: array[0..80] of Char;
   hPenWindow: THandle;
   constructor Init(AParent: PWindowsObject; ATitle: PChar; hPenWin: THandle);
   procedure HandleButtonMsg(var Msg: TMessage); virtual id_First + id_Button;
   procedure Paint(PaintDC: HDC; var PaintInfo: TPaintStruct); virtual;
   procedure SetEditText(Text: PChar); 
  end;

  PDialogTextEntry = ^TDialogTextEntry;
  TDialogTextEntry = object(TDialog)
    procedure HandleShowButton(var Msg: TMessage); virtual id_First + id_Show;
  end;

constructor TTestWindow.Init(AParent: PWindowsObject; ATitle: PChar; hPenWin: THandle);
var
  PCntrl: PWindowsObject;
begin
  TWindow.Init(AParent, ATitle);
  hPenWindow := hPenWin;
  { display a line of text, showing (Pen)Windows is installed }
  if hPenWindow <> 0 then
    StrCopy(EditText, 'PenWindows Installed')
  else
    StrCopy(EditText, 'PenWindows is not Installed');

  Attr.X := 100;
  Attr.Y := 100;
  Attr.W := 400;
  Attr.H := 300;

  PCntrl := New(PButton, Init(@Self, id_Button, 'Text Entry', 0, 0,
    100, 24, False));
end;

procedure TTestWindow.Paint(PaintDC: HDC; var PaintInfo: TPaintStruct);
begin
  TextOut(PaintDC, 150, 2, EditText, StrLen(EditText));
end;

procedure TTestWindow.SetEditText(Text: PChar);
begin
  StrCopy(EditText, Text);
end;

{ response function to SHOW button, get text and show it in
  the lower control }

procedure TDialogTextEntry.HandleShowButton(var Msg: TMessage);
var
  Buffer: array[0..80] of Char;
begin
  GetDlgItemText(HWindow, id_Edit, Buffer, 80);
  SetDlgItemText(HWindow, id_Text, Buffer);
end;

{ open a dialogbox, depending on (Pen)Windows running or not
 You may look at OWLPEN.RC file and see that BEDIT is used in
 PenTextEntryDialog }

procedure TTestWindow.HandleButtonMsg(var Msg: TMessage);
var
  ResID: Word;
begin
  if hPenWindow <> 0 then ResId := PenTextEntryDialog else
    ResId := TextEntryDialog;
  Application^.ExecDialog(New(PDialogTextEntry, Init(@Self, PChar(ResId))));
end;

procedure TTestApp.InitMainWindow;
begin
  hPenWin := GetSystemMetrics(sm_PenWindows);
  if hPenWin <> 0 then
  begin
    { PenWindows is now running, Get adress of RegisterPenApp using
      runtime dynamic linking }
    RegPen := GetProcAddress(hPenWin, 'RegisterPenApp');
    { Call RegisterPenApp to indicate that we are a PenWindows
      application }
    if RegPen <> nil then
      TRegPenApp(RegPen)(rpa_Default, True);
  end;
  MainWindow := New(PTestWindow, Init(nil, Name, hPenWin));
end;

var
  App: TTestApp;

begin
  App.Init('This Owl is pen aware');
  App.Run;
  App.DOne;
end.
