{*******************************************************}
{                                                       }
{     Turbo Pascal for Windows Run-time Library         }
{     Windows 3.1 API Interface Unit                    }
{     Printing helper functions, types, and definitions }
{                                                       }
{     Copyright (c) 1992 Borland International          }
{                                                       }
{*******************************************************}

unit Print;

interface

uses WinTypes;

type
  PTType = TPoint;

const
  pqError  = -1;

type
  HPQ = Word;

function CreatePQ(i: Integer): HPQ;
function MinPQ(h: HPQ): Integer;
function ExtractPQ(h: HPQ): Integer;
function InsertPQ(h: HPQ; i1: Integer; i2: Integer): Integer;
function SizePQ(h: HPQ; i: Integer): Integer;
procedure DeletePQ(h: HPQ);

{ Spool routines for use by printer drivers }

type
  HPJob = Word;

function OpenJob(P1: PChar; P2: PChar; Job: HPJob): HPJob;
function StartSpoolPage(Job: HPJob): Integer;
function EndSpoolPage(Job: HPJob): Integer;
function WriteSpool(Lob: HPJob; P: PChar; i: Integer): Integer;
function CloseJob(Job: HPJob): Integer;
function DeleteJob(Job: HPJob; i: Integer): Integer;
function WriteDialog(Job: HPJob; P: PChar; i: Integer): Integer;
function DeleteSpoolPage(Job: HPJob): Integer;

type

  { LPBI used as far pointer to this record in SDK }
  PBandInfoStruct = ^TBandInfoStruct;
  TBandInfoStruct = record
    fGraphics: Bool;
    fText: Bool;
    rcGraphics: TRect;
  end;

const
  USA_CountryCode  = 1;

{
 *  Printer driver initialization using ExtDeviceMode()
 *  and DeviceCapabilities().
 *  This replaces Drivinit.h
 }

{ size of a device name string }
const
  CCHDeviceName = 32;
  CCHPaperName  = 64;

{ current version of specification }
const
  dm_SpecVersion = $30A;

{ field selection bits }
const
  dm_Orientation      = $0000001;
  dm_PaperSize        = $0000002;
  dm_PaperLength      = $0000004;
  dm_PaperWidth       = $0000008;
  dm_Scale            = $0000010;
  dm_Copies           = $0000100;
  dm_DefaultSource    = $0000200;
  dm_PrintQuality     = $0000400;
  dm_Color            = $0000800;
  dm_Duplex           = $0001000;
  dm_YResolution      = $0002000;
  dm_TTOption         = $0004000;

{ orientation selections }
const
  dmOrient_Portrait   = 1;
  dmOrient_Landscape  = 2;

{ paper selections }
{  Warning: The PostScript driver mistakingly uses DMPAPER_ values between
 *  50 and 56.  Don't use this range when defining new paper sizes.
 }
const
  dmPaper_Letter      = 1;           { Letter 8 1/2 x 11 in               }
  dmPaper_LetterSmall = 2;           { Letter Small 8 1/2 x 11 in         }
  dmPaper_Tabloid     = 3;           { Tabloid 11 x 17 in                 }
  dmPaper_Ledger      = 4;           { Ledger 17 x 11 in                  }
  dmPaper_Legal       = 5;           { Legal 8 1/2 x 14 in                }
  dmPaper_Statement   = 6;           { Statement 5 1/2 x 8 1/2 in         }
  dmPaper_Executive   = 7;   { Executive 7 1/4 x 10 1/2 in        }
  dmPaper_A3          = 8;           { A3 297 x 420 mm                    }
  dmPaper_A4          = 9;           { A4 210 x 297 mm                    }
  dmPaper_A4Small     = 10;          { A4 Small 210 x 297 mm              }
  dmPaper_A5          = 11;          { A5 148 x 210 mm                    }
  dmPaper_B4          = 12;          { B4 250 x 354                       }
  dmPaper_B5          = 13;          { B5 182 x 257 mm                    }
  dmPaper_Folio       = 14;          { Folio 8 1/2 x 13 in                }
  dmPaper_Quarto      = 15;          { Quarto 215 x 275 mm                }
  dmPaper_10X14       = 16;          { 10x14 in                           }
  dmPaper_11X17       = 17;          { 11x17 in                           }
  dmPaper_Note        = 18;          { Note 8 1/2 x 11 in                 }
  dmPaper_Env_9       = 19;          { Envelope #9 3 7/8 x 8 7/8          }
  dmPaper_Env_10      = 20;          { Envelope #10 4 1/8 x 9 1/2         }
  dmPaper_Env_11      = 21;          { Envelope #11 4 1/2 x 10 3/8        }
  dmPaper_Env_12      = 22;          { Envelope #12 4 \276 x 11           }
  dmPaper_Env_14      = 23;          { Envelope #14 5 x 11 1/2            }
  dmPaper_CSheet      = 24;          { C size sheet                       }
  dmPaper_DSheet      = 25;          { D size sheet                       }
  dmPaper_ESheet      = 26;          { E size sheet                       }
  dmPaper_Env_DL      = 27;          { Envelope DL 110 x 220mm            }
  dmPaper_Env_C5      = 28;          { Envelope C5 162 x 229 mm           }
  dmPaper_Env_C3      = 29;          { Envelope C3  324 x 458 mm          }
  dmPaper_Env_C4      = 30;          { Envelope C4  229 x 324 mm          }
  dmPaper_Env_C6      = 31;          { Envelope C6  114 x 162 mm          }
  dmPaper_Env_C65     = 32;          { Envelope C65 114 x 229 mm          }
  dmPaper_Env_B4      = 33;          { Envelope B4  250 x 353 mm          }
  dmPaper_Env_B5      = 34;          { Envelope B5  176 x 250 mm          }
  dmPaper_Env_B6      = 35;          { Envelope B6  176 x 125 mm          }
  dmPaper_Env_Italy   = 36;          { Envelope 110 x 230 mm              }
  dmPaper_Env_Monarch = 37;          { Envelope Monarch 3.875 x 7.5 in    }
  dmPaper_Env_Personal = 38;         { 6 3/4 Envelope 3 5/8 x 6 1/2 in    }
  dmPaper_Fanfold_US  = 39;          { US Std Fanfold 14 7/8 x 11 in      }
  dmPaper_Fanfold_Std_German  = 40;  { German Std Fanfold 8 1/2 x 12 in   }
  dmPaper_Fanfold_Lgl_German  = 41;  { German Legal Fanfold 8 1/2 x 13 in }

  dmPaper_First     = dmPaper_Letter;
  dmPaper_Last      = dmPaper_Fanfold_Lgl_German;

  dmPaper_User      = 256;

{ bin selections }
const
  dmBin_Upper         = 1;
  dmBin_OnlyOne       = 1;
  dmBin_Lower         = 2;
  dmBin_Middle        = 3;
  dmBin_Manual        = 4;
  dmBin_Envelope      = 5;
  dmBin_EnvManual     = 6;
  dmBin_Auto          = 7;
  dmBin_Tractor       = 8;
  dmBin_SmallFmt      = 9;
  dmBin_LargeFmt      = 10;
  dmBin_LargeCapacity = 11;
  dmBin_Cassette      = 14;

  dmBin_First     = dmBin_Upper;
  dmBin_Last      = dmBin_Cassette;

  dmBin_User      = 256;    { device specific bins start here }

{ print qualities }
const
  dmRes_Draft   = -1;
  dmRes_Low     = -2;
  dmRes_Medium  = -3;
  dmRes_High    = -4;

{ color enable/disable for color printers }
const
  dmColor_Monochrome  = 1;
  dmColor_Color       = 2;

{ duplex enable }
const
  dmDup_Simplex    = 1;
  dmDup_Vertical   = 2;
  dmDup_Horizontal = 3;

{ TrueType options }
const
  dmtt_Bitmap     = 1;       { print TT fonts as graphics }
  dmtt_Download   = 2;       { download TT fonts as soft fonts }
  dmtt_SubDev     = 3;       { substitute device fonts for TT fonts }

type
  PDevMode = ^TDevMode;
  TDevMode = record
    dmDeviceName: array[0..CCHDeviceName-1] of Char;
    dmSpecVersion: Word;
    dmDriverVersion: Word;
    dmSize: Word;
    dmDriverExtra: Word;
    dmFields: Longint;
    dmOrientation: Integer;
    dmPaperSize: Integer;
    dmPaperLength: Integer;
    dmPaperWidth: Integer;
    dmScale: Integer;
    dmCopies: Integer;
    dmDefaultSource: Integer;
    dmPrintQuality: Integer;
    dmColor: Integer;
    dmDuplex: Integer;
    dmYResolution: Integer;
    dmTTOption: Integer;
  end;

{ mode selections for the device mode function }
const
  dm_Update     = 1;
  dm_Copy       = 2;
  dm_Prompt     = 4;
  dm_Modify     = 8;

  dm_In_Buffer      = dm_Modify;
  dm_In_Prompt      = dm_Prompt;
  dm_Out_Buffer     = dm_Copy;
  dm_Out_Default    = dm_Update;

{ device capabilities indices }
const
  dc_Fields           = 1;
  dc_Papers           = 2;
  dc_PaperSize        = 3;
  dc_MinExtent        = 4;
  dc_MaxExtent        = 5;
  dc_Bins             = 6;
  dc_Duplex           = 7;
  dc_Size             = 8;
  dc_Extra            = 9;
  dc_Version          = 10;
  dc_Driver           = 11;
  dc_BinNames         = 12;
  dc_EnumResolutions  = 13;
  dc_FileDependencies = 14;
  dc_TrueType         = 15;
  dc_PaperNames       = 16;
  dc_Orientation      = 17;
  dc_Copies           = 18;

{ bit fields of the return value (DWORD) for DC_TRUETYPE }
const
  dctt_Bitmap     = $0000001;
  dctt_Download   = $0000002;
  dctt_SubDev     = $0000004;

{ export ordinal definitions }
const
  proc_ExtDeviceMode      = MakeIntResource(90);
  proc_DeviceCapabilities = MakeIntResource(91);
  proc_OldDeviceMode      = MakeIntResource(13);

{ define types of pointers to ExtDeviceMode() and DeviceCapabilities()
 * functions
 }
type
  TExtDevMode = function(Wnd: HWnd; Driver: THandle;
    DevModeOutput: PDevMode; DeviceName, Port: PChar;
    DevModeInput: PDevMode; Profile: PChar; Mode: Word): Word;

type
  TDevCaps = function(DeviceName, Port: PChar; index: Word;
    OutPut: PChar; DevMode: PDevMode): Longint;


function ResetDC(aHdc: HDC; DevMode: PDevMode): HDC;

{ this structure is used by the GETSETSCREENPARAMS escape }
type
  PScreenParams = ^TScreenParams;
  TScreenParams = record
    Angle: Integer;
    Frequency: Integer;
  end;

implementation

function CreatePQ;                           external 'GDI' index 230;
function MinPQ;                              external 'GDI' index 231;
function ExtractPQ;                          external 'GDI' index 232;
function InsertPQ;                           external 'GDI' index 233;
function SizePQ;                             external 'GDI' index 234;
procedure DeletePQ;                          external 'GDI' index 235;
function OpenJob;                            external 'GDI' index 240;
function StartSpoolPage;                     external 'GDI' index 246;
function EndSpoolPage;                       external 'GDI' index 247;
function WriteSpool;                         external 'GDI' index 241;
function CloseJob;                           external 'GDI' index 243;
function DeleteJob;                          external 'GDI' index 244;
function WriteDialog;                        external 'GDI' index 242;
function DeleteSpoolPage;                    external 'GDI' index 253;
function ResetDC;                            external 'GDI' index 376;

end.
