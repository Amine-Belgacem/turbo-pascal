{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{                                                       }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

Unit WinMem32;

interface

Uses WinTypes;

function GetWinMem32Version: Word;
function Global32Alloc(dwSize: Longint; lpSelector: PWord;
  dwMaxSize: Longint; wFlags: Word): Word;
function Global32Realloc(wSelector: Word; swNewSize: Longint;
  wFlags: Word): Word;
function Global32Free(wSelector, wFlags: Word): Word;
function Global16PointerAlloc(Selector: Word; dwOffset: Longint;
  lpBuffer: PLongint; dwSize: Longint; wFlags: Word): Word;
function Global16PointerFree(wSelector: Word; dwAlias: Longint;
  wFlags: Word): Word;
function Global32CodeAlias(wSelector: Word; lpAlias: PWord;
wFlags: Word): Word;
function Global32CodeAliasFree(wSelector, wAlias, wFlags: Word): Word;


{ Error Codes }

const
  wm32_Invalid_Func   = $01;
  wm32_Invalid_Flags  = $02;
  wm32_Invalid_Arg    = $03;
  wm32_Insufficient_Sels  = $04;
  wm32_Insufficient_Mem   = $05;

implementation

function GetWinMem32Version;                 external 'WINMEM32' index 1;
function Global32Alloc;                      external 'WINMEM32' index 2;
function Global32Realloc;                    external 'WINMEM32' index 3;
function Global32Free;                       external 'WINMEM32' index 4;
function Global16PointerAlloc;               external 'WINMEM32' index 5;
function Global16PointerFree;                external 'WINMEM32' index 6;
function Global32CodeAlias;                  external 'WINMEM32' index 7;
function Global32CodeAliasFree;              external 'WINMEM32' index 8;

end.
