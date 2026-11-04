{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{       Stress function declarations                    }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit Stress;

interface

uses WinTypes;

{***** Simple types & common helper macros ********************************}

{ stuff for AllocDiskSpace() }
const
  eds_Win     = 1;
  eds_Cur     = 2;
  eds_Temp    = 3;


{ function prototypes }
function AllocMem(dwLeft: Longint): Bool;
procedure FreeAllMem;
function AllocFileHandles(left: Integer): Integer;
procedure UnAllocFileHandles;
function GetFreeFileHandles: Integer;
function AllocDiskSpace(lLeft: Longint; wDrive: Word): Integer;
procedure UnAllocDiskSpace(wDrive: Word);
function AllocUserMem(wContig: Word): Bool;
procedure FreeAllUserMem;
function AllocGDIMem(wLeft: Word): Bool;
procedure FreeAllGDIMem;

implementation

function AllocMem;                           external 'STRESS' index 2;
procedure FreeAllMem;                        external 'STRESS' index 3;
function AllocFileHandles;                   external 'STRESS' index 6;
procedure UnAllocFileHandles;                external 'STRESS' index 7;
function GetFreeFileHandles;                 external 'STRESS' index 8;
function AllocDiskSpace;                     external 'STRESS' index 10;
procedure UnAllocDiskSpace;                  external 'STRESS' index 11;
function AllocUserMem;                       external 'STRESS' index 12;
procedure FreeAllUserMem;                    external 'STRESS' index 13;
function AllocGDIMem;                        external 'STRESS' index 14;
procedure FreeAllGDIMem;                     external 'STRESS' index 15;

end.
