
{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit LZExpand;

interface

uses WinTypes;

{ Constants }

const
{ Error Return Codes }

  lzerror_BadInHandle = -1;            { invalid input handle }
  lzerror_BadOutHandle = -2;           { invalid output handle }
  lzerror_Read = -3;                   { corrupt compressed file format }
  lzerror_Write = -4;                  { out of space for output file }
  lzerror_GlobAlloc = -5;              { insufficient memory for LZFile struct }
  lzerror_GlobLock = -6;               { bad global handle }
  lzerror_BadValue = -7;               { input parameter out of acceptable range }
  lzerror_UnknownAlg = -8;             { compression algorithm not recognized }

{ Prototypes }

function LZStart: Integer;
procedure LZDone;
function CopyLZFile(Source, Dest: Integer): Longint;

function LZCopy(Source, Dest: Integer): Longint;
function LZInit(Source: Integer): Integer;
function GetExpandedName(Source, Buffer: PChar): Integer;
function LZOpenFile(FileName: PChar; var ReOpenBuf: TOFStruct;
  Style: Word): Integer;
function LZSeek(LZFile: Integer; SeekTo: Longint; Mode: Integer): Longint;
function LZRead(LZFile: Integer; Buf: PChar; Count: Integer): Integer;
procedure LZClose(LZFile: Integer);

implementation

function LZStart;                          external 'LZEXPAND' index 7;
procedure LZDone;                          external 'LZEXPAND' index 9;
function CopyLZFile;                       external 'LZEXPAND' index 8;
function LZCopy;                           external 'LZEXPAND' index 1;
function LZInit;                           external 'LZEXPAND' index 3;
function LZSeek;                           external 'LZEXPAND' index 4;
function LZRead;                           external 'LZEXPAND' index 5;
procedure LZClose;                         external 'LZEXPAND' index 6;
function GetExpandedName;                  external 'LZEXPAND' index 10;
function LZOpenFile;                       external 'LZEXPAND' index 2;

end.

