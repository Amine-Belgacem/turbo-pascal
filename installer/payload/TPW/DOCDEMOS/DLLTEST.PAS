{*****************************************************}
{                                                     }
{  Turbo Pascal for Windows                           }
{  Demo program                                       }
{  Copyright (c) 1991, 1992 by Borland International  }
{                                                     }
{*****************************************************}


{  This program demonstrates how to use functions located in a DLL.  The unit
   MATH.PAS provides the function names and parameters of the math functions
   this program uses.

   *NOTE*  You need to compile MATHDLL.PAS to produce the DLL module this
   program uses BEFORE you try to run this program.

}




program DLLTest;

{$R MATH}

uses WinTypes, WinProcs, WObjects, Math;

type
  TMyApplication = object(TApplication)
    procedure InitMainWindow; virtual;
  end;

  PFinancialDialog = ^TFinancialDialog;
  TFinancialDialog = object(TDialog)
    Error: Word;
    Period, Interest, Term, Principal, Payment : Real;
    function LoadFields: Boolean;  virtual;
    procedure OK(var Msg: TMessage); virtual id_First + IdOk;
    function Calculate: Real; virtual;
  end;

  PPaymentDialog = ^TPaymentDialog;
  TPaymentDialog = object(TFinancialDialog)
    function LoadFields: Boolean; virtual;
    function Calculate: Real; virtual;
  end;

  PPrincipalDialog = ^TPrincipalDialog;
  TPrincipalDialog = object(TFinancialDialog)
    function LoadFields: Boolean; virtual;
    function Calculate: Real; virtual;
  end;


  PMyWindow = ^TMyWindow;
  TMyWindow = Object(TWindow)
    constructor Init(AParent: PWindowsObject; ATitle: PChar);
    procedure Payment(var Msg: TMessage); virtual cm_First + cm_Payment;
    procedure Principal(var Msg: TMessage); virtual cm_First + cm_Principal;
  end;

function TFinancialDialog.LoadFields: Boolean;
var
  E: Integer;
  S: array[0..50] of char;
begin
  LoadFields := False;
  Error := 0;

  GetDlgItemText(HWindow, id_Interest, S, SizeOf(S));
  Val(S, Interest, E);
  if E<>0 then
    Error := er_MustHaveValue
  else
    if (Interest > 1) then  
      Error := er_InterestLimit;
   
  if (Error = 0) then
  begin
    GetDlgItemText(HWindow, id_Term, S, SizeOf(S));
    Val(S, Term, E);
    If E<>0 then
      Error := er_MustHaveValue
    else
      if Term > 50 then
        Error := er_TermLimit;
  end;

  if (Error = 0) then
  begin
    GetDlgItemText(HWindow, id_Periods, S, SizeOf(S));
    Val(S, Period, E);
    If E<>0 then
      Error := er_MustHaveValue;
  end;

  LoadFields:= Error = 0;
end;

procedure TFinancialDialog.Ok(var Msg: TMessage);
var
  S: array [0..100] of char;
begin
  if LoadFields then
  begin
    FillChar(S, SizeOf(S), #0);
    Str(Calculate:10:2, S);
    SetDlgItemText(HWindow, id_Output, S);
  end
  else
  begin  { Load error string from the resource file }
    LoadString(HInstance, Error, S, SizeOf(S));
    WriteError(HWindow, S);
  end;
end;

function TFinancialDialog.Calculate: Real;
begin
  Abstract;
end;



function TPaymentDialog.LoadFields: Boolean;
var
  E: Integer;
  S: array [0..100] of char;
begin
  if TFinancialDialog.LoadFields then
  begin
    GetDlgItemText(HWindow, id_Principal, S, SizeOf(S));
    Val(S, Principal, E);
    If E<>0 then
      Error := er_MustHaveValue
    else
      if Principal > 1000000 then
        Error := er_PrincipalLimit;
    LoadFields := Error = 0;
  end
  else
    LoadFields := False;
end;


function TPaymentDialog.Calculate: Real;
begin
  Payment := Payments(Period, Interest, Term, Principal);
  Calculate := Payment;
end;


function TPrincipalDialog.LoadFields: Boolean;
var
  E: Integer;
  S: array [0..100] of char;
begin
  if TFinancialDialog.LoadFields then
  begin
    GetDlgItemText(HWindow, id_Payment, S, SizeOf(S));
    Val(S, Payment, E);
    If E<>0 then
      Error := er_MustHaveValue
    else
      if Payment < 1 then
        Error := er_PaymentLimit;
    LoadFields := Error = 0;
  end
  else
    LoadFields := False;
end;


function TPrincipalDialog.Calculate: Real;
begin
  Principal := Principals(Payment, Period, Interest, Term);
  Calculate := Principal;
end;


constructor TMyWindow.Init(AParent: PWindowsObject; ATitle: PChar);
begin
  TWindow.Init(AParent, ATitle);
  Attr.Menu := LoadMenu(HInstance, 'Menu');
end;

procedure TMyWindow.Payment(var Msg: TMessage);
begin
  Application^.ExecDialog(new(PPaymentDialog, Init(@Self, 'PaymentDlg')));
end;

procedure TMyWindow.Principal(var Msg: TMessage);
begin
  Application^.ExecDialog(new(PPrincipalDialog, Init(@Self, 'PrincipalDlg')));
end;

procedure TMyApplication.InitMainWindow;
begin
  MainWindow:=New(PMyWindow, Init(nil, 'DLL Test'));
end;

var
  MyApplication: TMyApplication;
begin
  MyApplication.Init('DLLTest');
  MyApplication.Run;
  MyApplication.Done;
end.
