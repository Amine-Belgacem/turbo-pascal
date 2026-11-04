{************************************************}
{                                                }
{   Turbo Pascal for Windows                     }
{   Demo DLL interface unit                      }
{   Copyright (c) 1991 by Borland International  }
{                                                }
{************************************************}

unit Math;

interface

const

	cm_Payment	=	201;
	cm_Principal	=	202;
	id_Interest	=	104;
	id_Term	=	105;
	id_Periods	=	112;
	id_Principal	=	106;
	id_Payment	=	106;
	id_Output	=	113;
	er_MustHaveValue	=	1;
	er_InterestLimit	=	2;
	er_TermLimit	=	3;
	er_PrincipalLimit	=	4;
  er_PaymentLimit = 5;

function Power(X, Y: Real): Real;
function Payments(Period, Interest, Term, Principal: Real): Real;
function Principals(Payment, Period, Interest, Term: Real): Real;
procedure WriteError(Window: Word; ErrorMessage: PChar);

implementation

function Power;         external 'MathDll' index 1;
function Payments;      external 'MathDll' index 2;
function Principals;    external 'MathDll' index 3;
procedure WriteError;   external 'MathDll' index 4;

end.
