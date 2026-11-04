{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{       Pen Windows APIs into Recognizer Layer          }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit PenWOEM;

interface

uses WinTypes, PenWin;

type
  TFuncResults = function(lprcresult: PRCResult; R: TRec): Integer;

{ Initialization Functions }

const
  wcr_RecogName          = 0;
  wcr_Query              = 1;
  wcr_ConfigDialog       = 2;
  wcr_Default            = 3;
  wcr_RCChange           = 4;
  wcr_Version            = 5;
  wcr_Train              = 6;
  wcr_TrainSave          = 7;
  wcr_TrainMax           = 8;
  wcr_TrainDirty         = 9;
  wcr_TrainCustom        = 10;
  wcr_QueryLanguage      = 11;
  wcr_UserChange         = 12;
  wcr_Private            = 1024;

{ sub-function of wcr_UserChange }
const
  cruc_Remove            = 1;

{ Return values for wcr_Train Function }
const
  Train_None             = $0000;
  Train_Default          = $0001;
  Train_Custom           = $0002;
  Train_Both             = Train_Default or Train_Custom;

{ Control values for TrainSave }
const
  Train_Save             = 0;  { Save changes that have been made }
  Train_Revert           = 1;  { Discard changes that have been made }

function ConfigRecognizer(wConfigRecog: Word; wParam: Word;
  lParam: Longint ): Word;
function InitRecognizer(lprc: PRC): Bool;
procedure CloseRecognizer;

{ Recognition Functions }
function RecognizeInternal(lprc: PRC; lpfuncresults: TFuncResults): TRec;
function RecognizeDataInternal(lprc: PRC; hPenData: THPenData;
  lpfuncresults: TFuncResults): TRec;

{ Training Functions }
function TrainInkInternal(lprc: PRC; hPenData: THPenData; lpsyv: PSYV): Bool;
function TrainContextInternal(lprcresult: PRCResult; lpsye: PSYE;
  cSye: Integer; lpsyc: PSYC; cSyc: Integer): Bool;

implementation

function ConfigRecognizer;                   external 'MARS' index 4;
function InitRecognizer;                     external 'MARS' index 5;
procedure CloseRecognizer;                   external 'MARS' index 6;
function RecognizeInternal;                  external 'MARS' index 2;
function RecognizeDataInternal;              external 'MARS' index 3;
function TrainInkInternal;                   external 'MARS' index 7;
function TrainContextInternal;               external 'MARS' index 8;

end.