{***********************************************************************
 *  File: TDDEMO.PAS
 *
 *  Turbo Pascal Demonstration program for use with Turbo Debugger
 *  Copyright (c) 1988, 1991 - Borland International.
 *
 *  Reads words from standard input, analyzes letter and word frequency.
 *  Uses linked list to store command-line parameters on heap.
 *
 *  Uses the following data types:
 *
 *    Boolean,
 *    Char, Byte,
 *    Integer, Word,
 *    LongInt,
 *    Real (can't use 8087 type yet, change to extended)
 *    String,
 *    Array,
 *    Record,
 *    Set,
 *    Pointer
 ***********************************************************************}
program TDDemo;

uses
  WinCrt;              { text mode I/O library for Windows }

const
  BufSize    = 128;    { length of line buffer }
  MaxWordLen =  10;    { maximum word length allowed }

type
  BufferStr = String[BufSize];

  LInfoRec = record
    Count: Word;               { number of occurrences of this letter }
    FirstLetter: Word;         { number of times as first letter of a }
  end;

var
  NumLines, NumWords: Word;                     { counters }
  NumLetters: LongInt;
  WordLenTable: array[1..MaxWordLen] of Word;   { info for each word }
  LetterTable: array['A'..'Z'] of LInfoRec;     { info for each letter }
  Buffer: BufferStr;

{***************************************************
 * procedure ShowResults
 ***************************************************}
procedure ShowResults;

{+--------------------------------------------------
 | procedure ShowLetterInfo
 +--------------------------------------------------}
procedure ShowLetterInfo(FromLet, ToLet: Char);
{ Dump letter information }
var
  ch: Char;
begin
  Writeln;
  Write('Letter:     ');
  for ch := FromLet to ToLet do                 { column titles }
    Write(ch:5);
  Writeln;

  Write('Frequency:  ');
  for ch := FromLet to ToLet do                 { letter count }
    Write(LetterTable[ch].Count:5);
  Writeln;
  Write('Word starts:');
  for ch := FromLet to ToLet do                 { first letter count }
    Write(LetterTable[ch].FirstLetter:5);
  Writeln;
end; { ShowLetterInfo }

{*** ShowResults starts here ***}

var
  i: Integer;
  AvgWords: Real;

begin { ShowResults }
  if NumLines <> 0 then AvgWords := NumWords / NumLines
  else AvgWords := 0;
  Writeln;
  Writeln(NumLetters, ' char(s) in ',
    NumWords, ' word(s) in ',
    NumLines, ' line(s)');
  Writeln('Average of ', AvgWords:0:2, ' words per line');
  Writeln;

  { Dump word count }
  Write('Word length:');
  for i := 1 to MaxWordLen do Write(i:4);
  Writeln;

  Write('Frequency:  ');
  for i := 1 to MaxWordLen do Write(WordLenTable[i]:4);
  Writeln;

  { Dump letter counts }
  ShowLetterInfo('A', 'M');
  ShowLetterInfo('N', 'Z');
end; { ShowResults }


{***************************************************
 * procedure Init
 ***************************************************}
procedure Init;
begin
  NumLines := 0;
  NumWords := 0;
  NumLetters := 0;
  FillChar(LetterTable, SizeOf(LetterTable), 0);
  FillChar(WordLenTable, SizeOf(WordLenTable), 0);
  Writeln('Enter a string to process, an empty string quits.');
end; { Init }

{***************************************************
 * procedure ProcessLine
 ***************************************************}
procedure ProcessLine(var S: BufferStr);

{+--------------------------------------------------
 | function IsLetter
 +--------------------------------------------------}
function IsLetter(ch: Char): Boolean;
begin
  IsLetter := UpCase(ch) in ['A'..'Z'];
end; { IsLetter }


{*** Process Line starts here ***}

var
  i: Integer;
  WordLen: Word;

begin { ProcessLine }
  Inc(NumLines);
  i := 1;
  while i <= Length(S) do
  begin
    { Skip non-letters }
    while (i <= Length(S)) and not IsLetter(S[i]) do
      Inc(i);

    { Find end of word, bump letter & word counters }
    WordLen := 0;
    while (i <= Length(S)) and IsLetter(S[i]) do
    begin
      Inc(NumLetters);
      Inc(LetterTable[UpCase(S[i])].Count);
      if WordLen = 0 then                    { bump counter }
	Inc(LetterTable[UpCase(S[i])].FirstLetter);
      Inc(i);
      Inc(WordLen);
    end;

    { Bump word count info }
    if WordLen > 0 then
    begin
      Inc(NumWords);
      if WordLen <= MaxWordLen then
	Inc(WordLenTable[WordLen]);
    end;
  end; { while }
end; { ProcessLine }

{***************************************************
 * function GetLine
 ***************************************************}
function GetLine: BufferStr;
var
  S: BufferStr;
begin
  Write('String: ');
  Readln(S);
  GetLine := S;
end;


{*** Program starts here ***}

begin { program }
  Init;
  Buffer := GetLine;
  while Buffer <> '' do
  begin
    ProcessLine(Buffer);
    Buffer := GetLine;
  end;
  ShowResults;
end.
