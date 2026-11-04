{************************************************}
{                                                }
{   Turbo Pascal for Windows                     }
{   Demo program                                 }
{   Copyright (c) 1991 by Borland International  }
{                                                }
{************************************************}

program MyProgram;

uses WObjects;

type
  TMyApplication = object(TApplication)
    procedure InitMainWindow; virtual;
  end;

{--------------------------------------------------}
{ TMyApplication's method implementations:         }
{--------------------------------------------------}

procedure TMyApplication.InitMainWindow;
begin
  MainWindow := New(PWindow, Init(nil, 'Sample ObjectWindows Program'));
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
