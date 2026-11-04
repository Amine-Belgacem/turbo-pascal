{************************************************}
{                                                }
{   Turbo Pascal for Windows                     }
{   Demo unit                                    }
{   Copyright (c) 1991 by Borland International  }
{                                                }
{************************************************}

unit HelpWind;

interface

uses Strings, WObjects, WinTypes, WinProcs;

const
  id_LB1 = 201;
  id_BN1 = 202;
  id_BN2 = 203;
  id_EC1 = 204;
  id_ST1 = 205;

type
  
  PHelpWindow = ^THelpWindow;
  THelpWindow = object(TWindow)
    LB1: PListBox;
    EC1: PEdit;
    constructor Init(AParent: PWindowsObject; ATitle: PChar);
    procedure SetupWindow; virtual;
    procedure IDLB1(var Msg: TMessage); virtual id_First + id_LB1;
    procedure IDBN1(var Msg: TMessage); virtual id_First + id_BN1;
    procedure IDBN2(var Msg: TMessage); virtual id_First + id_BN2;
    procedure FillEdit(SelStringPtr: PChar); virtual;
  end;

implementation

constructor THelpWindow.Init(AParent: PWindowsObject; ATitle: PChar);
var
  TempStat : PStatic;
  TempBtn: PButton;
begin
  TWindow.Init(AParent, ATitle);
  DisableAutoCreate;
  Attr.Style := ws_PopupWindow or ws_Caption or ws_Visible;
  Attr.X := 100;
  Attr.Y := 100;
  Attr.W := 300;
  Attr.H := 300;
  LB1 := New(PListBox, Init(@Self, id_LB1, 20, 20, 180, 80));
  TempBtn := New(PButton, Init(@Self, id_BN1, 'Help', 220, 20, 60, 30, True));
  TempBtn := New(PButton, Init(@Self, id_BN2, 'Cancel', 220, 70, 60, 30, False));
  EC1 := New(PEdit, Init(@Self, id_EC1, '', 20, 180, 260, 90, 40, True));
  EC1^.Attr.Style := EC1^.Attr.Style or ws_Border or ws_VScroll;
  TempStat := New(PStatic, Init(@Self, id_ST1,'Help Information:', 20, 160, 160, 20, 0));
end;

procedure THelpWindow.SetupWindow;
begin
  TWindow.SetupWindow;
  { Fill the list box }
  LB1^.AddString('List Boxes');
  LB1^.AddString('Buttons');
  LB1^.AddString('Scroll Bars');
  LB1^.AddString('Edit Controls');
  LB1^.AddString('Static Controls');
  LB1^.AddString('Combo Boxes');
  LB1^.SetSelIndex(0);
end;

procedure THelpWindow.IDLB1(var Msg: TMessage);
var
  SelString: array[0..25] of Char;
begin
  if Msg.LParamHi = lbn_DblClk then
  begin
    LB1^.GetSelString(SelString, 25);
    FillEdit(SelString);
  end;
end;

procedure THelpWindow.IDBN1(var Msg: TMessage);
var
  SelString: array[0..25] of Char;
begin
  LB1^.GetSelString(SelString, 25);
  FillEdit(SelString);
end;

procedure THelpWindow.IDBN2(var Msg: TMessage);
begin
  CloseWindow;
end;

procedure THelpWindow.FillEdit(SelStringPtr: PChar);
var
  TheString: PChar;
begin
  if StrComp(SelStringPtr, 'List Boxes') = 0 then
    TheString :=
      'List Boxes are used as a device to' + #13#10 +
      'provide your users with a choice of ' + #13#10 +
      'text selections.  The user can ' + #13#10 +
      'choose only from the available ' + #13#10 +
      'selections.  You can process their ' + #13#10 +
      'choice made by single- or double-' + #13#10 +
      'clicking on the text item.'
  else if StrComp(SelStringPtr, 'Buttons') = 0 then
    TheString :=
      'Buttons prompt the user for simple ' + #13#10 +
      'input in a variety of ways.  For ' + #13#10 +
      'example, push buttons provide a ' + #13#10 +
      'single declarative command, as in ' + #13#10 +
      'Cancel, above.  Check boxes act as ' + #13#10 +
      'a toggle switch, and radio buttons ' + #13#10 +
      'provide a multiple choice.'
  else if StrComp(SelStringPtr, 'Scroll Bars') = 0 then
    TheString :=
      'Scroll Bars are most often used as' + #13#10 +
      'part of other windows and controls.' + #13#10 +
      'These scroll bars need no objects.' + #13#10 +
      'However, standalone scroll bars' + #13#10 +
      'can be used for specific control ' + #13#10 +
      'purposes such as controlling the' + #13#10 +
      'temperature in a thermostat' + #13#10 +
      'program.'
  else if StrComp(SelStringPtr, 'Edit Controls') = 0 then
    TheString :=
      'You are looking at an edit control' + #13#10 +
      'right now.  Edit controls provide a' + #13#10 +
      'mechanism for displaying text and ' + #13#10 +
      'getting user input.  They are ideal' + #13#10 +
      'for use as entry fields in a data' + #13#10 +
      'entry system.'
  else if StrComp(SelStringPtr, 'Static Controls') = 0 then
    TheString :=
      'Static controls are simple text items' + #13#10 +
      'that can be displayed in a window.' + #13#10 +
      'They cannot be modified by the ' + #13#10 +
      'user but their text can be altered' + #13#10 +
      'by your programs.  They provide a ' + #13#10 +
      'useful alternative for Windows text ' + #13#10 +
      'drawing functions.'
  else if StrComp(SelStringPtr, 'Combo Boxes') = 0 then
    TheString :=
      'Combo box controls combine the ' + #13#10 +
      'item selection properties of list' + #13#10 +
      'boxes with the editing properties ' + #13#10 +
      'of an edit control.  They let you ' + #13#10 +
      'choose items from a list, which ' + #13#10 +
      'can be hidden.  They also let you' + #13#10 +
      'type in items that are not in the list.';
  EC1^.SetText(TheString);
end;

end.

