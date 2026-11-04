{************************************************}
{                                                }
{   Turbo Pascal for Windows                     }
{   Demo Dynamic Link Library                    }
{   Copyright (c) 1991 by Borland International  }
{                                                }
{************************************************}

library MathDll;

uses WinTypes, WinProcs;

function Power(X, Y: Real): Real; export;
begin
  Power:=Exp(Y * ln(X));
end;

function Payments(Period, Interest, Term, Principal: Real): Real; export;
begin
  Payments := (Principal * Interest / Period) /
    (1 - Power(1 + Interest / Period, -Term * Period));
end;

function Principals(Payment, Period, Interest, Term: Real): Real; export;
begin
  Principals := Payment * ((1 - Power(1 + Interest / Period,
    -Term * Period)) / (Interest / Period));
end;

procedure WriteError(Window: hWnd; ErrorMessage: PChar); export;
begin
  MessageBox(Window, ErrorMessage, 'Error', MB_OK);
end;

exports
  Power        index 1,
  Payments     index 2,
  Principals   index 3,
  WriteError   index 4;

begin
end.
