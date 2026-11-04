{*******************************************************}
{                                                       }
{       Turbo Pascal for Windows Run-time Library       }
{       Windows 3.1 API Interface Unit                  }
{       Multimedia Interface unit                       }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit MMSystem;

interface

uses WinTypes, WinProcs, Win31;


{***************************************************************************

                    General constants and data types

***************************************************************************}

{ general constants }
const
  MaxPNameLen      =  32;    { max product name length (including NULL) }
  MaxErrorLength   = 128;    { max error text length (including NULL) }

{ general data types }
type
  Version = Word;             { major (high byte), minor (low byte) }

{ types for wType field in MMTIME struct }
const
  time_MS         = $0001;  { time in milliseconds }
  time_Samples    = $0002;  { number of wave samples }
  time_Bytes      = $0004;  { current byte offset }
  time_SMPTE      = $0008;  { SMPTE time }
  time_MIDI       = $0010;  { MIDI time }

{ MMTIME data structure }
type
  PMMTime = ^TMMTime;
  TMMTime = record
    case wType: Word of        { indicates the contents of the variant record }
     time_MS : (ms: Longint);
     time_Samples : (sample: Longint);
     time_Bytes : (cb: Longint);
     time_SMPTE : (
        hour: Byte;
        min: Byte;
        sec: Byte;
        frame: Byte;
        fps: Byte;
        dummy: Byte);
      time_MIDI : (songptrpos: Longint);
  end;


{***************************************************************************

                    Multimedia Extensions Window Messages

***************************************************************************}

{ joystick }
const
  mm_Joy1Move         = $3A0;
  mm_Joy2Move         = $3A1;
  mm_Joy1ZMove        = $3A2;
  mm_Joy2ZMove        = $3A3;
  mm_Joy1ButtonDown   = $3B5;
  mm_Joy2ButtonDown   = $3B6;
  mm_Joy1ButtonUp     = $3B7;
  mm_Joy2ButtonUp     = $3B8;

{ MCI }
  mm_MCINotify        = $3B9;

{ waveform output }
  mm_WOM_Open         = $3BB;
  mm_WOM_Close        = $3BC;
  mm_WOM_Done         = $3BD;

{ waveform input }
  mm_WIM_Open         = $3BE;
  mm_WIM_Close        = $3BF;
  mm_WIM_Data         = $3C0;

{ MIDI input }
  mm_MIM_Open         = $3C1;
  mm_MIM_Close        = $3C2;
  mm_MIM_Data         = $3C3;
  mm_MIM_LongData     = $3C4;
  mm_MIM_Error        = $3C5;
  mm_MIM_LongError    = $3C6;

{ MIDI output }
  mm_MOM_Open         = $3C7;
  mm_MOM_Close        = $3C8;
  mm_MOM_Done         = $3C9;


{***************************************************************************

                String resource number bases (internal use)

***************************************************************************}

const
  mmsyserr_Base          = 0;
  waverr_Base            = 32;
  midierr_Base           = 64;
  timerr_Base            = 96;
  joyerr_Base            = 160;
  mcierr_Base            = 256;

  mci_String_Offset      = 512;
  mci_VD_Offset          = 1024;
  mci_CD_Offset          = 1088;
  mci_Wave_Offset        = 1152;
  mci_Seq_Offset         = 1216;

{***************************************************************************

                        General error return values

***************************************************************************}

{ general error return values }
const
  mmsyserr_NoError      = 0;                  { no error }
  mmsyserr_Error        = mmsyserr_Base + 1;  { unspecified error }
  mmsyserr_BadDeviceID  = mmsyserr_Base + 2;  { device ID out of range }
  mmsyserr_NotEnabled   = mmsyserr_Base + 3;  { driver failed enable }
  mmsyserr_Allocated    = mmsyserr_Base + 4;  { device already allocated }
  mmsyserr_InvalHandle  = mmsyserr_Base + 5;  { device handle is invalid }
  mmsyserr_NoDriver     = mmsyserr_Base + 6;  { no device driver present }
  mmsyserr_NoMem        = mmsyserr_Base + 7;  { memory allocation error }
  mmsyserr_NotSupported = mmsyserr_Base + 8;  { function isn't supported }
  mmsyserr_BadErrNum    = mmsyserr_Base + 9;  { error value out of range }
  mmsyserr_InvalFlag    = mmsyserr_Base + 10; { invalid flag passed }
  mmsyserr_InvalParam   = mmsyserr_Base + 11; { invalid parameter passed }
  mmsyserr_LastError    = mmsyserr_Base + 11; { last error in range }

{***************************************************************************

                        Installable driver support

***************************************************************************}


{ return values from DriverProc() function }
const
  drv_Cancel             = drvcnf_Cancel;
  drv_OK                 = drvcnf_OK;
  drv_Restart            = drvcnf_Restart;

  drv_MCI_First          = drv_Reserved;
  drv_MCI_Last           = drv_Reserved + $FFF;


{***************************************************************************

                          Driver callback support

***************************************************************************}

{ flags used with waveOutOpen(), waveInOpen(), midiInOpen(), and }
{ midiOutOpen() to specify the type of the dwCallback parameter. }

const
  CallBack_TypeMask   = $00070000;    { callback type mask }
  CallBack_Null       = $00000000;    { no callback }
  CallBack_Window     = $00010000;    { dwCallback is a HWND }
  CallBack_Task       = $00020000;    { dwCallback is a HTASK }
  CallBack_Function   = $00030000;    { dwCallback is a FARPROC }

{ driver callback prototypes }


type
  TDrvCallBack = procedure(h: Word; uMessage: Word; dwUser: Longint;
    dw1: Longint; dw2: Longint);


{***************************************************************************

                         Manufacturer and product IDs

    Used with wMid and wPid fields in WAVEOUTCAPS, WAVEINCAPS,
    MIDIOUTCAPS, MIDIINCAPS, AUXCAPS, JOYCAPS structures.

***************************************************************************}

{ manufacturer IDs }
const
  mm_Microsoft            = 1;       { Microsoft Corp. }

{ product IDs }
  mm_MIDI_Mapper          = 1;       { MIDI Mapper }
  mm_Wave_Mapper          = 2;       { Wave Mapper }

  mm_SndBlst_MidiOut      = 3;       { Sound Blaster MIDI output port }
  mm_SndBlst_MidiIn       = 4;       { Sound Blaster MIDI input port  }
  mm_SndBlst_Synth        = 5;       { Sound Blaster internal synthesizer }
  mm_SndBlst_WaveOut      = 6;       { Sound Blaster waveform output }
  mm_SndBlst_WaveIn       = 7;       { Sound Blaster waveform input }

  mm_Adlib                = 9;       { Ad Lib-compatible synthesizer }

  mm_MPU401_MidiOut       = 10;      { MPU401-compatible MIDI output port }
  mm_MPU401_MidiIn        = 11;      { MPU401-compatible MIDI input port }

  mm_PC_Joystick          = 12;      { Joystick adapter }


{***************************************************************************

                    General MMSYSTEM support

***************************************************************************}

function mmsystemGetVersion: Word;
procedure OutputDebugStr(P: PChar);


{***************************************************************************

                            Sound support

***************************************************************************}

function sndPlaySound(lpszSoundName: PChar; uFlags: Word): Bool;

{ flag values for wFlags parameter }
const
  snd_Sync            = $0000;  { play synchronously (default) }
  snd_Async           = $0001;  { play asynchronously }
  snd_NoDefault       = $0002;  { don't use default sound }
  snd_Memory          = $0004;  { lpszSoundName points to a memory file }
  snd_Loop            = $0008;  { loop the sound until next sndPlaySound }
  snd_NoStop          = $0010;  { don't stop any currently playing sound }


{***************************************************************************

                        Waveform audio support

***************************************************************************}

{ waveform audio error return values }
const
  waverr_BadFormat      = waverr_Base + 0;    { unsupported wave format }
  waverr_StillPlaying   = waverr_Base + 1;    { still something playing }
  waverr_Unprepared     = waverr_Base + 2;    { header not prepared }
  waverr_Sync           = waverr_Base + 3;    { device is synchronous }
  waverr_LastError      = waverr_Base + 3;    { last error in range }

{ waveform audio data types }
type
  PHWave = ^HWave;
  HWave = Word;

  PHWaveIn = ^HWaveIn;
  HWaveIn = Word;

  PHWaveOut = ^HWaveOut;
  HWaveOut = Word;

type
  TWaveCallBack = TDrvCallBack;

{ wave callback messages }
const
  wom_Open        = mm_WOM_Open;
  wom_Close       = mm_WOM_Close;
  wom_Done        = mm_WOM_Done;
  wim_OPEN        = mm_WIM_Open;
  wim_CLOSE       = mm_WIM_Close;
  wim_DATA        = mm_WIM_Data;

{ device ID for wave device mapper }
  wave_Mapper     = -1;

{ flags for dwFlags parameter in waveOutOpen() and waveInOpen() }
  wave_Format_Query     = $0001;
  wave_AllowSync        = $0002;

{ wave data block header }
type
  PWaveHdr = ^TWaveHdr;
  TWaveHdr = record
    lpData: PChar;                 { pointer to locked data buffer }
    dwBufferLength: Longint;         { length of data buffer }
    dwBytesRecorded: Longint;     { used for input only }
    dwUser: Longint;              { for client's use }
    dwFlags: Longint;             { assorted flags (see defines) }
    dwLoops: Longint;             { loop control counter }
    lpNext: PWaveHdr;             { reserved for driver }
    reserved: Longint;            { reserved for driver }
  end;


{ flags for dwFlags field of WAVEHDR }
const
  whdr_Done       = $00000001;  { done bit }
  whdr_Prepared   = $00000002;  { set if this header has been prepared }
  whdr_BeginLoop  = $00000004;  { loop start block }
  whdr_EndLoop    = $00000008;  { loop end block }
  whdr_InQueue    = $00000010;  { reserved for driver }

{ waveform output device capabilities structure }
type

  PWaveOutCaps = ^TWaveOutCaps;
  TWaveOutCaps = record
    wMid: Word;                 { manufacturer ID }
    wPid: Word;                 { product ID }
    vDriverVersion: Version;       { version of the driver }
    szPname: array[0..MaxPNameLen-1] of Char;  { product name (NULL terminated string) }
    dwFormats: Longint;          { formats supported }
    wChannels: Word;            { number of sources supported }
    dwSupport: Longint;          { functionality supported by driver }
  end;


{ flags for dwSupport field of WAVEOUTCAPS }
const
  wavecaps_Pitch          = $0001;   { supports pitch control }
  wavecaps_PlaybackRate   = $0002;   { supports playback rate control }
  wavecaps_Volume         = $0004;   { supports volume control }
  wavecaps_LRVolume       = $0008;   { separate left-right volume control }
  wavecaps_Sync           = $0010;

{ waveform input device capabilities structure }
type
  PWaveInCaps = ^TWaveInCaps;
  TWaveInCaps = record
    wMid: Word;                   { manufacturer ID }
    wPid: Word;                   { product ID }
    vDriverVersion: Version;         { version of the driver }
    szPname: array[0..MaxPNameLen-1] of Char;    { product name (NULL terminated string) }
    dwFormats: Longint;            { formats supported }
    wChannels: Word;              { number of channels supported }
  end;


{ defines for dwFormat field of WAVEINCAPS and WAVEOUTCAPS }
const
  wave_InvalidFormat     = $00000000;       { invalid format }
  wave_Format_1M08       = $00000001;       { 11.025 kHz, Mono,   8-bit  }
  wave_Format_1S08       = $00000002;       { 11.025 kHz, Stereo, 8-bit  }
  wave_Format_1M16       = $00000004;       { 11.025 kHz, Mono,   16-bit }
  wave_Format_1S16       = $00000008;       { 11.025 kHz, Stereo, 16-bit }
  wave_Format_2M08       = $00000010;       { 22.05  kHz, Mono,   8-bit  }
  wave_Format_2S08       = $00000020;       { 22.05  kHz, Stereo, 8-bit  }
  wave_Format_2M16       = $00000040;       { 22.05  kHz, Mono,   16-bit }
  wave_Format_2S16       = $00000080;       { 22.05  kHz, Stereo, 16-bit }
  wave_Format_4M08       = $00000100;       { 44.1   kHz, Mono,   8-bit  }
  wave_Format_4S08       = $00000200;       { 44.1   kHz, Stereo, 8-bit  }
  wave_Format_4M16       = $00000400;       { 44.1   kHz, Mono,   16-bit }
  wave_Format_4S16       = $00000800;       { 44.1   kHz, Stereo, 16-bit }

{ general waveform format structure (information common to all formats) }
type
  PWaveFormat = ^TWaveFormat;
  TWaveFormat = record
    wFormatTag: Word;         { format type }
    nChannels: Word;          { number of channels (i.e. mono, stereo, etc.) }
    nSamplesPerSec: Longint;  { sample rate }
    nAvgBytesPerSec: Longint; { for buffer estimation }
    nBlockAlign: Word;      { block size of data }
  end;

{ flags for wFormatTag field of WAVEFORMAT }
const
  wave_Format_PCM     = 1;

{ specific waveform format structure for PCM data }
type
  PPCMWaveFormat = ^TPCMWaveFormat;
  TPCMWaveFormat = record
      wf: TWaveFormat;
      wBitsPerSample: Word;
   end;

{ waveform audio function prototypes }
function waveOutGetNumDevs: Word;

function waveOutGetDevCaps(uDeviceID: Word; lpCaps: PWaveOutCaps;
                           uSize: Word): Word;

function waveOutGetVolume(uDeviceID: Word; lpdwVolume: PLongint): Word;
function waveOutSetVolume(uDeviceID: Word; dwVolume: Longint): Word;
function waveOutGetErrorText(uError: Word; lpText: PChar; uSize: Word): Word;
function waveOutOpen(lphWaveOut: PHWaveOut; uDeviceID: Word;
  lpFormat: PWaveFormat; dwCallback, dwInstance, dwFlags: Longint): Word;
function waveOutClose(hWaveOut: PHWaveOut): Word;
function waveOutPrepareHeader(hWaveOut: PHWaveOut; lpWaveOutHdr: PWaveHdr;
  uSize: Word): Word;
function waveOutUnprepareHeader(hWaveOut: PHWaveOut; lpWaveOutHdr: PWaveHdr;
  uSize: Word): Word;
function waveOutWrite(hWaveOut: PHWaveOut; lpWaveOutHdr: PWaveHdr;
  uSize: Word): Word;
function waveOutPause(hWaveOut: PHWaveOut): Word;
function waveOutRestart(hWaveOut: PHWaveOut): Word;
function waveOutReset(hWaveOut: PHWaveOut): Word;
function waveOutBreakLoop(hWaveOut: PHWaveOut): Word;
function waveOutGetPosition(hWaveOut: PHWaveOut; lpInfo: PMMTime;
  uSize: Word): Word;
function waveOutGetPitch(hWaveOut: PHWaveOut; lpdwPitch: PLongint): Word;
function waveOutSetPitch(hWaveOut: PHWaveOut; dwPitch: Longint): Word;

function waveOutGetPlaybackRate(hWaveOut: PHWaveOut;
  lpdwRate: PLongint): Word;

function waveOutSetPlaybackRate(hWaveOut: PHWaveOut; dwRate: Longint): Word;

function waveOutGetID(hWaveOut: PHWaveOut; lpuDeviceID: PWord): Word;
function waveOutMessage(hWaveOut: PHWaveOut; uMessage: Word;
  dw1, dw2: Longint): Longint;

function waveInGetNumDevs: Word;

function waveInGetDevCaps(uDeviceID: Word; lpCaps: PWaveInCaps;
    uSize: Word): Word;
function waveInGetErrorText(uError: Word; lpText: PChar; uSize: Word): Word;


function waveInOpen(lphWaveIn: PHWaveIn; uDeviceID: Word;
  lpFormat: PWaveFormat; dwCallback, dwInstance, dwFlags: Longint): Word;

function waveInClose(hWaveIn: PHWaveIn): Word;

function waveInPrepareHeader(hWaveIn: PHWaveIn; lpWaveInHdr: PWaveHdr;
  uSize: Word): Word;

function waveInUnprepareHeader(hWaveIn: PHWaveIn; lpWaveInHdr: PWaveHdr;
  uSize: Word): Word;

function waveInAddBuffer(hWaveIn: PHWaveIn; lpWaveInHdr: PWaveHdr;
  uSize: Word): Word;

function waveInStart(hWaveIn: PHWaveIn): Word;

function waveInStop(hWaveIn: PHWaveIn): Word;

function waveInReset(hWaveIn: PHWaveIn): Word;

function waveInGetPosition(hWaveIn: PHWaveIn; lpInfo: PMMTime;
  uSize: Word): Word;

function waveInGetID(hWaveIn: PHWaveIn; lpuDeviceID: PWord): Word;

function waveInMessage(hWaveIn: PHWaveIn; uMessage: Word;
  dw1, dw2: Longint): Longint;


{***************************************************************************

                            MIDI audio support

***************************************************************************}

{ MIDI error return values }
const
  midierr_Unprepared    = midierr_Base + 0;   { header not prepared }
  midierr_StillPlaying  = midierr_Base + 1;   { still something playing }
  midierr_NoMap         = midierr_Base + 2;   { no current map }
  midierr_NotReady      = midierr_Base + 3;   { hardware is still busy }
  midierr_NoDevice      = midierr_Base + 4;   { port no longer connected }
  midierr_InvalidSetup  = midierr_Base + 5;   { invalid setup }
  midierr_LastError     = midierr_Base + 5;   { last error in range }

{ MIDI audio data types }
type
  PHMidi = ^HMidi;
  HMidi = Word;

  PHMidiIn = ^HMidiIn;
  HMidiIn = Word;

  PHMidiOut = ^HMidiOut;
  HMidiOut = Word;

type
  TMidiCallBack = TDrvCallBack;

const
  MidiPatchSize   = 128;

type
  PPatchArray = ^TPatchArray;
  TPatchArray = array[0..MidiPatchSize-1] of Word;

  PKeyArray = ^TKeyArray;
  TKeyArray = array[0..MidiPatchSize-1] of Word;


{ MIDI callback messages }
const
  mim_Open        = mm_MIM_Open;
  mim_Close       = mm_MIM_Close;
  mim_Data        = mm_MIM_Data;
  mim_LongData    = mm_MIM_LongData;
  mim_Error       = mm_MIM_Error;
  mim_LongError   = mm_MIM_LongError;
  mom_Open        = mm_MOM_Open;
  mom_Close       = mm_MOM_Close;
  mom_Done        = mm_MOM_Done;

{ device ID for MIDI mapper }
const
  MidiMapper     = -1;
  midi_Mapper    = -1;

{ flags for wFlags parm of midiOutCachePatches(), midiOutCacheDrumPatches() }
const
  midi_Cache_All      = 1;
  midi_Cache_BestFit  = 2;
  midi_Cache_Query    = 3;
  midi_Uncache        = 4;

{ MIDI output device capabilities structure }
type
  PMidiOutCaps = ^TMidiOutCaps;
  TMidiOutCaps = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    vDriverVersion: Version;        { version of the driver }
    szPname: array[0..MaxPNameLen-1] of Char;  { product name (NULL terminated string) }
    wTechnology: Word;           { type of device }
    wVoices: Word;               { # of voices (internal synth only) }
    wNotes: Word;                { max # of notes (internal synth only) }
    wChannelMask: Word;          { channels used (internal synth only) }
    dwSupport: Longint;           { functionality supported by driver }
  end;


{ flags for wTechnology field of MIDIOUTCAPS structure }
const
  mod_MidiPort    = 1;  { output port }
  mod_Synth       = 2;  { generic internal synth }
  mod_SQSynth     = 3;  { square wave internal synth }
  mod_FMSynth     = 4;  { FM internal synth }
  mod_Mapper      = 5;  { MIDI mapper }

{ flags for dwSupport field of MIDIOUTCAPS structure }
const
  midicaps_Volume          = $0001;  { supports volume control }
  midicaps_LRVolume        = $0002;  { separate left-right volume control }
  midicaps_Cache           = $0004;

{ MIDI output device capabilities structure }

type
  PMidiInCaps = ^TMidiInCaps;
  TMidiInCaps = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    vDriverVersion: Version;        { version of the driver }
    szPname: array[0..MaxPNameLen-1] of Char;  { product name (NULL terminated string) }
  end;

{ MIDI data block header }
type
  PMidiHdr = ^TMidiHdr;
  TMidiHdr = record
    lpData: PChar;                 { pointer to locked data block }
    dwBufferLength: Longint;       { length of data in data block }
    dwBytesRecorded: Longint;      { used for input only }
    dwUser: Longint;               { for client's use }
    dwFlags: Longint;              { assorted flags (see defines) }
    lpNext: PMidiHdr;              { reserved for driver }
    reserved: Longint;             { reserved for driver }
  end;


{ flags for dwFlags field of MIDIHDR structure }
const
  mhdr_Done       = $00000001;       { done bit }
  mhdr_Prepared   = $00000002;       { set if header prepared }
  mhdr_InQueue    = $00000004;       { reserved for driver }

{ MIDI function prototypes }

function midiOutGetNumDevs: Word;
function midiOutGetDevCaps(uDeviceID: Word; lpCaps: PMidiOutCaps;
  uSize: Word): Word;
function midiOutGetVolume(uDeviceID: Word; lpdwVolume: PLongint): Word;
function midiOutSetVolume(uDeviceID: Word; dwVolume: Longint): Word;
function midiOutGetErrorText(uError: Word; lpText: PChar; uSize: Word): Word;
function midiOutOpen(lphMidiOut: PHMidiOut; uDeviceID: Word;
  dwCallback, dwInstance, dwFlags: Longint): Word;
function midiOutClose(hMidiOut: PHMidiOut): Word;
function midiOutPrepareHeader(hMidiOut: PHMidiOut; lpMidiOutHdr: PMidiHdr;
  uSize: Word): Word;
function midiOutUnprepareHeader(hMidiOut: PHMidiOut; lpMidiOutHdr: PMidiHdr;
  uSize: Word): Word;
function midiOutShortMsg(hMidiOut: PHMidiOut; dwMsg: Longint): Word;
function midiOutLongMsg(hMidiOut: PHMidiOut; lpMidiOutHdr: PMidiHdr;
  uSize: Word): Word;
function midiOutReset(hMidiOut: PHMidiOut): Word;
function midiOutCachePatches(hMidiOut: PHMidiOut;
  uBank: Word; lpwPatchArray: PWord; uFlags: Word): Word;
function midiOutCacheDrumPatches(hMidiOut: PHMidiOut;
  uPatch: Word; lpwKeyArray: PWord; uFlags: Word): Word;
function midiOutGetID(hMidiOut: PHMidiOut; lpuDeviceID: Word): Word;
function midiOutMessage(hMidiOut: PHMidiOut; uMessage: Word;
  dw1, dw2: Longint): Longint;
function midiInGetNumDevs: Word;
function midiInGetDevCaps(DeviceID: Word; lpCaps: PMidiInCaps;
  uSize: Word): Word;
function midiInGetErrorText(uError: Word; lpText: PChar; uSize: Word): Word;
function midiInOpen(lphMidiIn: PHMidiIn; uDeviceID: Word;
  dwCallback, dwInstance, dwFlags: Longint): Word;
function midiInClose(hMidiIn: PHMidiIn): Word;
function midiInPrepareHeader(hMidiIn: PHMidiIn; lpMidiInHdr: PMidiHdr;
  uSize: Word): Word;
function midiInUnprepareHeader(hMidiIn: PHMidiIn; lpMidiInHdr: PMidiHdr;
  uSize: Word): Word;
function midiInAddBuffer(hMidiIn: PHMidiIn; lpMidiInHdr: PMidiHdr;
  uSize: Word): Word;
function midiInStart(hMidiIn: PHMidiIn): Word;
function midiInStop(hMidiIn: PHMidiIn): Word;
function midiInReset(hMidiIn: PHMidiIn): Word;
function midiInGetID(hMidiIn: PHMidiIn; lpuDeviceID: PWord): Word;

function midiInMessage(hMidiIn: PHMidiIn; uMessage: Word;
  dw1, dw2: Longint): Longint;


{***************************************************************************

                        Auxiliary audio support

***************************************************************************}

{ device ID for aux device mapper }
const
  aux_Mapper     = -1;

{ Auxiliary audio device capabilities structure }
type
  PAuxCaps = ^TAuxCaps;
  TAuxCaps = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    vDriverVersion: Version;        { version of the driver }
    szPname: array[0..MaxPNameLen-1] of Char;  { product name (NULL terminated string) }
    wTechnology: Word;           { type of device }
    dwSupport: Longint;             { functionality supported by driver }
  end;

{ flags for wTechnology field in AUXCAPS structure }
const
  auxcaps_CDAudio    = 1;       { audio from internal CD-ROM drive }
  auxcaps_AuxIn      = 2;       { audio from auxiliary input jacks }

{ flags for dwSupport field in AUXCAPS structure }
const
  auxcaps_Volume     = $0001;  { supports volume control }
  auxcaps_LRVolume   = $0002;  { separate left-right volume control }

{ auxiliary audio function prototypes }
function auxGetNumDevs: Word;
function auxGetDevCaps(uDeviceID: Word; lpCaps: PAuxCaps; uSize: Word): Word;
function auxSetVolume(uDeviceID: Word; dwVolume: Longint): Word;
function auxGetVolume(uDeviceID: Word; lpdwVolume: PLongint): Word;
function auxOutMessage(uDeviceID, uMessage: Word; dw1, dw2: Longint): Longint;


{***************************************************************************

                            Timer support

***************************************************************************}

{ timer error return values }
const
  timerr_NoError        = 0;                  { no error }
  timerr_NoCanDo        = timerr_Base+1;      { request not completed }
  timerr_Struct         = timerr_Base+33;     { time struct size }

{ timer data types }
type
  TTimeCallBack = procedure(uTimerID, uMessage: Word; dwUser, dw1, dw2: Longint);


{ flags for wFlags parameter of timeSetEvent() function }
const
  time_OneShot    = 0;   { program timer for single event }
  time_Periodic   = 1;   { program for continuous periodic event }

{ timer device capabilities data structure }
type
  PTimeCaps = ^TTimeCaps;
  TTimeCaps = record
    wPeriodMin: Word;     { minimum period supported  }
    wPeriodMax: Word;     { maximum period supported  }
  end;


{ timer function prototypes }
function timeGetSystemTime(lpTime: PMMTime; uSize: Word): Word;

function timeGetTime: Longint;
function timeSetEvent(uDelay, uResolution: Word;
  lpFunction: TTimeCallBack; dwUser: Longint; uFlags: Word): Word;
function timeKillEvent(uTimerID: Word): Word;
function timeGetDevCaps(lpTimeCaps: PTimeCaps; uSize: Word): Word;
function timeBeginPeriod(uPeriod: Word): Word;

function timeEndPeriod(uPeriod: Word): Word;


{***************************************************************************

                            Joystick support

***************************************************************************}

{ joystick error return values }
const
  joyerr_NoError        = 0;                  { no error }
  joyerr_Parms          = joyerr_Base+5;      { bad parameters }
  joyerr_NoCanDo        = joyerr_Base+6;      { request not completed }
  joyerr_Unplugged      = joyerr_Base+7;      { joystick is unplugged }

{ constants used with JOYINFO structure and MM_JOY* messages }
const
  joy_Button1         = $0001;
  joy_Button2         = $0002;
  joy_Button3         = $0004;
  joy_Button4         = $0008;
  joy_Button1Chg      = $0100;
  joy_Button2Chg      = $0200;
  joy_Button3Chg      = $0400;
  joy_Button4Chg      = $0800;

{ joystick ID constants }
const
  joystickID1         = 0;
  joystickID2         = 1;

{ joystick device capabilities data structure }
type
  PJoyCaps = ^TJoyCaps;
  TJoyCaps = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    szPname: array[0..MaxPNameLen-1] of Char;  { product name (NULL terminated string) }
    wXmin: Word;                 { minimum x position value }
    wXmax: Word;                 { maximum x position value }
    wYmin: Word;                 { minimum y position value }
    wYmax: Word;                 { maximum y position value }
    wZmin: Word;                 { minimum z position value }
    wZmax: Word;                 { maximum z position value }
    wNumButtons: Word;           { number of buttons }
    wPeriodMin: Word;            { minimum message period when captured }
    wPeriodMax: Word;            { maximum message period when captured }
  end;

{ joystick information data structure }
type
  PJoyInfo = ^TJoyInfo;
  TJoyInfo = record
     wXpos: Word;                 { x position }
     wYpos: Word;                 { y position }
     wZpos: Word;                 { z position }
     wButtons: Word;              { button states }
  end;

{ joystick function prototypes }
function joyGetDevCaps(uJoyID: Word; lpCaps: PJoyCaps; uSize: Word): Word;
function joyGetNumDevs: Word;

function joyGetPos(uJoyID: Word; lpInfo: PJoyInfo): Word;

function joyGetThreshold(uJoyID: Word; lpuThreshold: PWord): Word;

function joyReleaseCapture(uJoyID: Word): Word;

{ Changed first parameter name from "hwnd" to "Handle" }
function joySetCapture(Handle: HWnd; uJoyID, uPeriod: Word;
  bChanged: Bool): Word;

function joySetThreshold(uJoyID, uThreshold: Word): Word;

{***************************************************************************

                        Multimedia File I/O support

***************************************************************************}

{ MMIO error return values }
const
  mmioerr_Base            = 256;
  mmioerr_FileNotFound    = mmioerr_Base + 1;  { file not found }
  mmioerr_OutOfMemory     = mmioerr_Base + 2;  { out of memory }
  mmioerr_CannotOpen      = mmioerr_Base + 3;  { cannot open }
  mmioerr_CannotClose     = mmioerr_Base + 4;  { cannot close }
  mmioerr_CannotRead      = mmioerr_Base + 5;  { cannot read }
  mmioerr_CannotWrite     = mmioerr_Base + 6;  { cannot write }
  mmioerr_CannotSeek      = mmioerr_Base + 7;  { cannot seek }
  mmioerr_CannotExpand    = mmioerr_Base + 8;  { cannot expand file }
  mmioerr_ChunkNotFound   = mmioerr_Base + 9;  { chunk not found }
  mmioerr_Unbuffered      = mmioerr_Base + 10; { file is unbuffered }

{ MMIO constants }
const
  CFSepChar       = '+';             { compound file name separator char. }

{ MMIO data types }
type
  FourCC = Longint;                     { a four character code }

type
  PHMMIO = ^THMMIO;
  THMMIO = Word;      { a handle to an open file }

type
  TMMIOProc = function(lpmmioinfo: PChar; uMessage: Word;
                lParam1, lParam2: Longint): Longint;

{ general MMIO information data structure }
type
  PMMIOInfo = ^TMMIOInfo;
  TMMIOInfo = record
    { general fields }
    dwFlags: Longint;        { general status flags }
    fccIOProc: FourCC;      { pointer to I/O procedure }
    pIOProc: TMMIOProc;        { pointer to I/O procedure }
    wErrorRet: Word;      { place for error to be returned }
    hTask: TTask;          { alternate local task }

    { fields maintained by MMIO functions during buffered I/O }
    cchBuffer: Longint;      { size of I/O buffer (or 0L) }
    pchBuffer: PChar;      { start of I/O buffer (or NULL) }
    pchNext: PChar;        { pointer to next byte to read/write }
    pchEndRead: PChar;     { pointer to last valid byte to read }
    pchEndWrite: PChar;    { pointer to last byte to write }
    lBufOffset: Longint;     { disk offset of start of buffer }

    { fields maintained by I/O procedure }
    lDiskOffset: Longint;    { disk offset of next read or write }
    adwInfo: array[0..2] of Longint;     { data specific to type of MMIOPROC }

    { other fields maintained by MMIO }
    dwReserved1: Longint;    { reserved for MMIO use }
    dwReserved2: Longint;    { reserved for MMIO use }
    hmmio: THMMIO;          { handle to open file }
  end;


{ RIFF chunk information data structure }
type

  PMMCKInfo = ^TMMCKInfo;
  TMMCKInfo = record
    ckid: FourCC;           { chunk ID }
    cksize: Longint;         { chunk size }
    fccType: FourCC;        { form type or list type }
    dwDataOffset: Longint;   { offset of data portion of chunk }
    dwFlags: Longint;        { flags used by MMIO functions }
  end;

{ bit field masks }
const
  mmio_RWMode     = $00000003;      { open file for reading/writing/both }
  mmio_ShareMode  = $00000070;      { file sharing mode number }

{ constants for dwFlags field of MMIOINFO }
const
  mmio_Create    = $00001000;     { create new file (or truncate file) }
  mmio_Parse     = $00000100;     { parse new file returning path }
  mmio_Delete    = $00000200;     { create new file (or truncate file) }
  mmio_Exist     = $00004000;     { checks for existence of file }
  mmio_AllocBuf  = $00010000;     { mmioOpen() should allocate a buffer }
  mmio_GetTemp   = $00020000;     { mmioOpen() should retrieve temp name }

const
  mmio_Dirty     = $10000000;     { I/O buffer is dirty }


{ read/write mode numbers (bit field MMIO_RWMODE) }
const
  mmio_Read       = $00000000;      { open file for reading only }
  mmio_Write      = $00000001;      { open file for writing only }
  mmio_ReadWrite  = $00000002;      { open file for reading and writing }

{ share mode numbers (bit field MMIO_SHAREMODE) }
const
  mmio_Compat     = $00000000;      { compatibility mode }
  mmio_Exclusive  = $00000010;      { exclusive-access mode }
  mmio_DenyWrite  = $00000020;      { deny writing to other processes }
  mmio_DenyRead   = $00000030;      { deny reading to other processes }
  mmio_DenyNone   = $00000040;      { deny nothing to other processes }

{ various MMIO flags }
const
  mmio_FHOpen             = $0010;  { mmioClose: keep file handle open }
  mmio_EmptyBuf           = $0010;  { mmioFlush: empty the I/O buffer }
  mmio_ToUpper            = $0010;  { mmioStringToFOURCC: to u-case }
  mmio_InstallProc    = $00010000;  { mmioInstallIOProc: install MMIOProc }
  mmio_GlobalProc     = $10000000;  { mmioInstallIOProc: install globally }
  mmio_RemoveProc     = $00020000;  { mmioInstallIOProc: remove MMIOProc }
  mmio_FindProc       = $00040000;  { mmioInstallIOProc: find an MMIOProc }
  MMIO_FindChunk          = $0010;  { mmioDescend: find a chunk by ID }
  mmio_FindRIFF           = $0020;  { mmioDescend: find a LIST chunk }
  mmio_FindList           = $0040;  { mmioDescend: find a RIFF chunk }
  mmio_CreateRIFF         = $0020;  { mmioCreateChunk: make a LIST chunk }
  mmio_CreateList         = $0040;  { mmioCreateChunk: make a RIFF chunk }


{ message numbers for MMIOPROC I/O procedure functions }
const
  mmiom_Read      = mmio_Read;       { read }
  mmiom_Write    = mmio_Write;       { write }
  mmiom_Seek              = 2;       { seek to a new position in file }
  mmiom_Open              = 3;       { open file }
  mmiom_Close             = 4;       { close file }
  mmiom_WriteFlush        = 5;       { write and flush }

const
  mmiom_Rename            = 6;       { rename specified file }

const
  mmiom_User         = $8000;       { beginning of user-defined messages }

{ standard four character codes }
const
  FourCC_RIFF = $46464952;   { 'RIFF' }
  FourCC_List = $5453494C;   { 'LIST' }

{ four character codes used to identify standard built-in I/O procedures }
const
  FourCC_DOS  = $20532F44;   { 'DOS '}
  FourCC_MEM  = $204D454D;   { 'MEM '}

{ flags for mmioSeek() }
const
  seek_Set        = 0;               { seek to an absolute position }
  seek_Cur        = 1;               { seek relative to current position }
  seek_End        = 2;               { seek relative to end of file }

{ other constants }
const
  mmio_DefaultBuffer      = 8192;    { default buffer size }

{ MMIO function prototypes }
function mmioStringToFOURCC(sz: PChar; uFlags: Word): FourCC;

{ should return a TMMIOProc }
function mmioInstallIOProc(fccIOProc: FourCC; pIOProc: TMMIOProc;
  dwFlags: Longint): Pointer;

function mmioOpen(szFileName: PChar; lpmmioinfo: PMMIOInfo;
  dwOpenFlags: Longint): THMMIO;
function mmioRename(szFileName: PChar; szNewFileName: PChar;
  lpmmioinfo: PMMIOInfo; dwRenameFlags: Longint): Word;
function mmioClose(hmmio: THMMIO; uFlags: Word): Word;
function mmioRead(hmmio: THMMIO; pch: PChar; cch: Longint): Longint;

function mmioWrite(hmmio: THMMIO; pch: PChar; cch: Longint): Longint;
function mmioSeek(hmmio: THMMIO; lOffset: Longint; iOrigin: Integer): Longint;
function mmioGetInfo(hmmio: THMMIO; lpmmioinfo: PMMIOInfo; uFlags: Word): Word;
function mmioSetInfo(hmmio: THMMIO; lpmmioinfo: PMMIOInfo; uFlags: Word): Word;
function mmioSetBuffer(hmmio: THMMIO; pchBuffer: PChar; cchBuffer: Longint;
  uFlags: Word): Word;
function mmioFlush(hmmio: THMMIO; uFlags: Word): Word;
function mmioAdvance(hmmio: THMMIO; lpmmioinfo: PMMIOInfo; uFlags: Word): Word;
function mmioSendMessage(hmmio: THMMIO; uMessage: Word;
  lParam1, lParam2: Longint): Longint;
function mmioDescend(hmmio: THMMIO; lpck: PMMCKInfo;
  lpckParent: PMMCKInfo; uFlags: Word): Word;
function mmioAscend(hmmio: THMMIO; lpck: PMMCKInfo; uFlags: Word): Word;
function mmioCreateChunk(hmmio: THMMIO; lpck: PMMCKInfo; uFlags: Word): Word;


{***************************************************************************

                            MCI support

***************************************************************************}

type
  TYieldProc = function(uDeviceID: Word; dwYieldData: Longint): Word;

{ MCI function prototypes }
function mciSendCommand(uDeviceID, uMessage: Word;
  dwParam1, dwParam2: Longint): Longint;

function mciSendString(lpstrCommand: PChar; lpstrReturnString: PChar;
  uReturnLength: Word; hWndCallback: HWnd): Longint;

function mciGetDeviceID(lpstrName: PChar): Word;

function mciGetDeviceIDFromElementID(dwElementID: Longint;
  lpstrType: PChar): Word;

function mciGetErrorString(wError: Longint; lpstrBuffer: PChar;
  uLength: Word): Bool;

function mciSetYieldProc(uDeviceID: Word; fpYieldProc: TYieldProc;
  dwYieldData: Longint): Bool;

function mciGetCreatorTask(uDeviceID: Word): TTask;

(* Returns a TYieldProc *)
function mciGetYieldProc(uDeviceID: Word; lpdwYieldData: PLongint): Pointer;


{ MCI error return values }
const
  mcierr_Invalid_Device_ID        = mcierr_Base + 1;
  mcierr_Unrecognized_Keyword     = mcierr_Base + 3;
  mcierr_Unrecognized_Command     = mcierr_Base + 5;
  mcierr_Hardware                 = mcierr_Base + 6;
  mcierr_Invalid_Device_Name      = mcierr_Base + 7;
  mcierr_Out_Of_Memory            = mcierr_Base + 8;
  mcierr_Device_Open              = mcierr_Base + 9;
  mcierr_Cannot_Load_Driver       = mcierr_Base + 10;
  mcierr_Missing_Command_String   = mcierr_Base + 11;
  mcierr_Param_Overflow           = mcierr_Base + 12;
  mcierr_Missing_String_Argument  = mcierr_Base + 13;
  mcierr_Bad_Integer              = mcierr_Base + 14;
  mcierr_Parser_Internal          = mcierr_Base + 15;
  mcierr_Driver_Internal          = mcierr_Base + 16;
  mcierr_Missing_Parameter        = mcierr_Base + 17;
  mcierr_Unsupported_Function     = mcierr_Base + 18;
  mcierr_File_Not_Found           = mcierr_Base + 19;
  mcierr_Device_Not_Ready         = mcierr_Base + 20;
  mcierr_Internal                 = mcierr_Base + 21;
  mcierr_Driver                   = mcierr_Base + 22;
  mcierr_Cannot_Use_All           = mcierr_Base + 23;
  mcierr_Multiple                 = mcierr_Base + 24;
  mcierr_Extension_Not_Found      = mcierr_Base + 25;
  mcierr_OutOfRange               = mcierr_Base + 26;
  mcierr_Flags_Not_Compatible     = mcierr_Base + 28;
  mcierr_File_Not_Saved           = mcierr_Base + 30;
  mcierr_Device_Type_Required     = mcierr_Base + 31;
  mcierr_Device_Locked            = mcierr_Base + 32;
  mcierr_Duplicate_Alias          = mcierr_Base + 33;
  mcierr_Bad_Constant             = mcierr_Base + 34;
  mcierr_Must_Use_Shareable       = mcierr_Base + 35;
  mcierr_Missing_Device_Name      = mcierr_Base + 36;
  mcierr_Bad_Time_Format          = mcierr_Base + 37;
  mcierr_No_Closing_Quote         = mcierr_Base + 38;
  mcierr_Duplicate_Flags          = mcierr_Base + 39;
  mcierr_Invalid_File             = mcierr_Base + 40;
  mcierr_Null_Parameter_Block     = mcierr_Base + 41;
  mcierr_Unnamed_Resource         = mcierr_Base + 42;
  mcierr_New_Requires_Alias       = mcierr_Base + 43;
  mcierr_Notify_On_Auto_Open      = mcierr_Base + 44;
  mcierr_No_Element_Allowed       = mcierr_Base + 45;
  mcierr_NONAPPLICABLE_Function   = mcierr_Base + 46;
  mcierr_Illegal_For_Auto_Open    = mcierr_Base + 47;
  mcierr_Filename_Required        = mcierr_Base + 48;
  mcierr_Extra_Characters         = mcierr_Base + 49;
  mcierr_Device_Not_Installed     = mcierr_Base + 50;
  mcierr_Get_CD                   = mcierr_Base + 51;
  mcierr_Set_CD                   = mcierr_Base + 52;
  mcierr_Set_Drive                = mcierr_Base + 53;
  mcierr_Device_Length            = mcierr_Base + 54;
  mcierr_Device_ORD_Length        = mcierr_Base + 55;
  mcierr_No_Integer               = mcierr_Base + 56;

const
  mcierr_Wave_OutputsInUse        = mcierr_Base + 64;
  mcierr_Wave_SetOutputInUse      = mcierr_Base + 65;
  mcierr_Wave_InputsInUse         = mcierr_Base + 66;
  mcierr_Wave_SetInputInUse       = mcierr_Base + 67;
  mcierr_Wave_OutputUnspecified   = mcierr_Base + 68;
  mcierr_Wave_InputUnspecified    = mcierr_Base + 69;
  mcierr_Wave_OutputsUnsuitable   = mcierr_Base + 70;
  mcierr_Wave_SetOutputUnsuitable = mcierr_Base + 71;
  mcierr_Wave_InputsUnsuitable    = mcierr_Base + 72;
  mcierr_Wave_SetInputUnsuitable  = mcierr_Base + 73;

  mcierr_Seq_Div_Incompatible     = mcierr_Base + 80;
  mcierr_Seq_Port_InUse           = mcierr_Base + 81;
  mcierr_Seq_Port_Nonexistent     = mcierr_Base + 82;
  mcierr_Seq_Port_MapNoDevice     = mcierr_Base + 83;
  mcierr_Seq_Port_MiscError       = mcierr_Base + 84;
  mcierr_Seq_Timer                = mcierr_Base + 85;
  mcierr_Seq_PortUnspecified      = mcierr_Base + 86;
  mcierr_Seq_NoMIDIPresent        = mcierr_Base + 87;

  mcierr_No_Window                = mcierr_Base + 90;
  mcierr_CreateWindow             = mcierr_Base + 91;
  mcierr_File_Read                = mcierr_Base + 92;
  mcierr_File_Write               = mcierr_Base + 93;

{ all custom device driver errors must be >= this value }
const
  mcierr_Custom_Driver_Base       = mcierr_Base + 256;

{ MCI command message identifiers }
const
  mci_Open       = $0803;
  mci_Close      = $0804;
  mci_Escape     = $0805;
  mci_Play       = $0806;
  mci_Seek       = $0807;
  mci_Stop       = $0808;
  mci_Pause      = $0809;
  mci_Info       = $080A;
  mci_GetDevCaps = $080B;
  mci_Spin       = $080C;
  mci_Set        = $080D;
  mci_Step       = $080E;
  mci_Record     = $080F;
  mci_SysInfo    = $0810;
  mci_Break      = $0811;
  mci_Sound      = $0812;
  mci_Save       = $0813;
  mci_Status     = $0814;
  mci_Cue        = $0830;
  mci_Realize    = $0840;
  mci_Window     = $0841;
  mci_Put        = $0842;
  mci_Where      = $0843;
  mci_Freeze     = $0844;
  mci_Unfreeze   = $0845;
  mci_Load       = $0850;
  mci_Cut        = $0851;
  mci_Copy       = $0852;
  mci_Paste      = $0853;
  mci_Update     = $0854;
  mci_Resume     = $0855;
  mci_Delete     = $0856;

{ all custom MCI command messages must be >= this value }
const
  mci_User_Messages               = $400 + drv_MCI_First;

{ device ID for "all devices" }
const
  mci_All_Device_ID               = $FFFF;

{ constants for predefined MCI device types }
const
  mci_DevType_VCR                 = mci_String_Offset + 1;
  mci_DevType_Videodisc           = mci_String_Offset + 2;
  mci_DevType_Overlay             = mci_String_Offset + 3;
  mci_DevType_CD_Audio            = mci_String_Offset + 4;
  mci_DevType_DAT                 = mci_String_Offset + 5;
  mci_DevType_Scanner             = mci_String_Offset + 6;
  mci_DevType_Animation           = mci_String_Offset + 7;
  mci_DevType_Digital_Video       = mci_String_Offset + 8;
  mci_DevType_Other               = mci_String_Offset + 9;
  mci_DevType_Waveform_Audio      = mci_String_Offset + 10;
  mci_DevType_Sequencer           = mci_String_Offset + 11;

  mci_DevType_First              = mci_DevType_VCR;
  mci_DevType_Last               = mci_DevType_Sequencer;

{ return values for 'status mode' command }
const
  mci_Mode_Not_Ready              = mci_String_Offset + 12;
  mci_Mode_Stop                   = mci_String_Offset + 13;
  mci_Mode_Play                   = mci_String_Offset + 14;
  mci_Mode_Record                 = mci_String_Offset + 15;
  mci_Mode_Seek                   = mci_String_Offset + 16;
  mci_Mode_Pause                  = mci_String_Offset + 17;
  mci_Mode_Open                   = mci_String_Offset + 18;

{ constants used in 'set time format' and 'status time format' commands }
const
  mci_Format_Milliseconds         = 0;
  mci_Format_HMS                  = 1;
  mci_Format_MSF                  = 2;
  mci_Format_Frames               = 3;
  mci_Format_SMPTE_24             = 4;
  mci_Format_SMPTE_25             = 5;
  mci_Format_SMPTE_30             = 6;
  mci_Format_SMPTE_30Drop         = 7;
  mci_Format_Bytes                = 8;
  mci_Format_Samples              = 9;
  mci_Format_TMSF                 = 10;

{ MCI time format conversion macros }

function mci_MSF_Minute(msf: Longint): Byte;
inline(
  $58/      { POP AX }
  $5A);     { POP DX }

function mci_MSF_Second(msf: Longint): Byte;
inline(
  $58/      { POP AX }
  $5A/      { POP DX }
  $86/$C4); { XCHG AH,AL }

function mci_MSF_Frame(msf: Longint): Byte;
inline(
  $5A/       { POP DX - reverse order to get hi word in AX }
  $58);      { POP AX }

function mci_Make_MSF(m, s, f: Byte): Longint;
inline(
  $5A/      { POP DX    (f) }
  $32/$F6/  { XOR DH,DH     }
  $5B/      { POP BX    (s) }
  $58/      { POP AX    (m) }
  $8A/$E3); { MOV AH,BL     }

function mci_TMSF_Track(tmsf: Longint): Byte;
inline(
  $58/      { POP AX }
  $5A);     { POP DX }

function mci_TMSF_Minute(msf: Longint): Byte;
inline(
  $58/      { POP AX }
  $5A/      { POP DX }
  $86/$C4); { XCHG AH,AL }

function mci_TMSF_Second(msf: Longint): Byte;
inline(
  $5A/       { POP DX - reverse order to get hi word in AX }
  $58);      { POP AX }

function mci_TMSF_Frame(msf: Longint): Byte;
inline(
  $5A/       { POP DX - reverse order to get hi word in AX }
  $58/       { POP AX }
  $86/$C4);  { XCHG AH,AL }

function mci_Make_TMSF(t, m, s, f: Byte): Longint;
inline(
  $5A/      { POP  DX }
  $86/$D6/  { XCHG DH,DL }
  $5B/      { POP  BX }
  $8A/$D3/  { MOV  DL, BL }
  $58/      { POP  AX }
  $86/$C4/  { XCHG AH,AL }
  $5B/      { POP  BX }
  $8A/$C3); { MOV  AL,BL }


function mci_HMS_Hour(hms: Longint): Byte;
inline(
  $58/      { POP AX }
  $5A);     { POP DX }

function mci_HMS_Minute(hms: Longint): Byte;
inline(
  $58/      { POP AX }
  $5A/      { POP DX }
  $86/$C4); { XCHG AH,AL }

function mci_HMS_Second(hms: Longint): Byte;
inline(
  $5A/       { POP DX - reverse order to get hi word in AX }
  $58);      { POP AX }

function mci_Make_HMS(h, m, s: Byte): Longint;
inline(
  $5A/      { POP DX    (s) }
  $32/$F6/  { XOR DH,DH     }
  $5B/      { POP BX    (m) }
  $58/      { POP AX    (h) }
  $8A/$E3); { MOV AH,BL     }



{ flags for wParam of MM_MCINOTIFY message }
const
  mci_Notify_Successful           = $0001;
  mci_Notify_Superseded           = $0002;
  mci_Notify_Aborted              = $0004;
  mci_Notify_Failure              = $0008;


{ common flags for dwFlags parameter of MCI command messages }
const
  mci_Notify                      = $00000001;
  mci_Wait                        = $00000002;
  mci_From                        = $00000004;
  mci_To                          = $00000008;
  mci_Track                       = $00000010;

{ flags for dwFlags parameter of MCI_OPEN command message }
const
  mci_Open_Shareable              = $00000100;
  mci_Open_Element                = $00000200;
  mci_Open_Alias                  = $00000400;
  mci_Open_Element_ID             = $00000800;
  mci_Open_Type_ID                = $00001000;
  mci_Open_Type                   = $00002000;

{ flags for dwFlags parameter of MCI_SEEK command message }
const
  mci_Seek_To_Start               = $00000100;
  mci_Seek_To_End                 = $00000200;

{ flags for dwFlags parameter of MCI_STATUS command message }
const
  mci_Status_Item                 = $00000100;
  mci_Status_Start                = $00000200;

{ flags for dwItem field of the MCI_STATUS_PARMS parameter block }
const
  mci_Status_Length               = $00000001;
  mci_Status_Position             = $00000002;
  mci_Status_Number_Of_Tracks     = $00000003;
  mci_Status_Mode                 = $00000004;
  mci_Status_Media_Present        = $00000005;
  mci_Status_Time_Format          = $00000006;
  mci_Status_Ready                = $00000007;
  mci_Status_Current_Track        = $00000008;

{ flags for dwFlags parameter of MCI_INFO command message }
const
  mci_Info_Product                = $00000100;
  mci_Info_File                   = $00000200;

{ flags for dwFlags parameter of MCI_GETDEVCAPS command message }
const
  mci_GetDevCaps_Item             = $00000100;

{ flags for dwItem field of the MCI_GETDEVCAPS_PARMS parameter block }
const
  mci_GetDevCaps_Can_Record       = $00000001;
  mci_GetDevCaps_Has_Audio        = $00000002;
  mci_GetDevCaps_Has_Video        = $00000003;
  mci_GetDevCaps_Device_Type      = $00000004;
  mci_GetDevCaps_Uses_Files       = $00000005;
  mci_GetDevCaps_Compound_Device  = $00000006;
  mci_GetDevCaps_Can_Eject        = $00000007;
  mci_GetDevCaps_Can_Play         = $00000008;
  mci_GetDevCaps_Can_Save         = $00000009;

{ flags for dwFlags parameter of MCI_SYSINFO command message }
const
  mci_SysInfo_Quantity            = $00000100;
  mci_SysInfo_Open                = $00000200;
  mci_SysInfo_Name                = $00000400;
  mci_SysInfo_InstallName         = $00000800;

{ flags for dwFlags parameter of MCI_SET command message }
const
  mci_Set_Door_Open               = $00000100;
  mci_Set_Door_Closed             = $00000200;
  mci_Set_Time_Format             = $00000400;
  mci_Set_Audio                   = $00000800;
  mci_Set_Video                   = $00001000;
  mci_Set_On                      = $00002000;
  mci_Set_Off                     = $00004000;

{ flags for dwAudio field of MCI_SET_PARMS or MCI_SEQ_SET_PARMS }
const
  mci_Set_Audio_All               = $00000000;
  mci_Set_Audio_Left              = $00000001;
  mci_Set_Audio_Right             = $00000002;

{ flags for dwFlags parameter of MCI_BREAK command message }
const
  mci_Break_Key                   = $00000100;
  mci_Break_HWnd                  = $00000200;
  mci_Break_Off                   = $00000400;

{ flags for dwFlags parameter of MCI_RECORD command message }
const
  mci_Record_Insert               = $00000100;
  mci_Record_Overwrite            = $00000200;

{ flags for dwFlags parameter of MCI_SOUND command message }
const
  mci_Sound_Name                  = $00000100;

{ flags for dwFlags parameter of MCI_SAVE command message }
const
  mci_Save_File                   = $00000100;

{ flags for dwFlags parameter of MCI_LOAD command message }
const
  mci_Load_File                   = $00000100;

{ generic parameter block for MCI command messages with no special parameters }
type
  PMCI_Generic_Parms = ^TMCI_Generic_Parms;
  TMCI_Generic_Parms = record
    dwCallback: Longint;
  end;

{ parameter block for MCI_OPEN command message }
type
  PMCI_Open_Parms = ^TMCI_Open_Parms;
  TMCI_Open_Parms = record
    dwCallback: Longint;
    wDeviceID: Word;
    wReserved0: Word;
    lpstrDeviceType: PChar;
    lpstrElementName: PChar;
    lpstrAlias: PChar;
  end;

{ parameter block for MCI_PLAY command message }
type
  PMCI_Play_Parms = ^TMCI_Play_Parms;
  TMCI_Play_Parms = record
    dwCallback: Longint;
    dwFrom: Longint;
    dwTo: Longint;
  end;

{ parameter block for MCI_SEEK command message }
type
  PMCI_Seek_Parms = ^TMCI_Seek_Parms;
  TMCI_Seek_Parms = record
    dwCallback: Longint;
    dwTo: Longint;
  end;


{ parameter block for MCI_STATUS command message }
type
  PMCI_Status_Parms = ^TMCI_Status_Parms;
  TMCI_Status_Parms = record
    dwCallback: Longint;
    dwReturn: Longint;
    dwItem: Longint;
    dwTrack: Longint;
  end;

{ parameter block for MCI_INFO command message }
type
  PMCI_Info_Parms = ^TMCI_Info_Parms;
  TMCI_Info_Parms = record
    dwCallback: Longint;
    lpstrReturn: PChar;
    dwRetSize: Longint;
  end;

{ parameter block for MCI_GETDEVCAPS command message }
type
  PMCI_GetDevCaps_Parms = ^TMCI_GetDevCaps_Parms;
  TMCI_GetDevCaps_Parms = record
    dwCallback: Longint;
    dwReturn: Longint;
    dwItem: Longint;
  end;


{ parameter block for MCI_SYSINFO command message }
type
  PMCI_SysInfo_Parms = ^TMCI_SysInfo_Parms;
  TMCI_SysInfo_Parms = record
    dwCallback: Longint;
    lpstrReturn: PChar;
    dwRetSize: Longint;
    dwNumber: Longint;
    wDeviceType: Word;
    wReserved0: Word;
  end;

{ parameter block for MCI_SET command message }
type
  PMCI_Set_Parms = ^TMCI_Set_Parms;
  TMCI_Set_Parms = record
    dwCallback: Longint;
    dwTimeFormat: Longint;
    dwAudio: Longint;
  end;


{ parameter block for MCI_BREAK command message }
type
  PMCI_Break_Parms = ^TMCI_BReak_Parms;
  TMCI_BReak_Parms = record
    dwCallback: Longint;
    nVirtKey: Integer;
    wReserved0: Word;
    hWndBreak: HWnd;
    wReserved1: Word;
  end;

{ parameter block for MCI_SOUND command message }
type
  PMCI_Sound_Parms = ^TMCI_Sound_Parms;
  TMCI_Sound_Parms = record
    dwCallback: Longint;
    lpstrSoundName: PChar;
  end;

{ parameter block for MCI_SAVE command message }
type
  PMCI_Save_Parms = ^TMCI_SaveParms;
  TMCI_SaveParms = record
    dwCallback: Longint;
    lpfilename: PChar;
  end;

{ parameter block for MCI_LOAD command message }
type
  PMCI_Load_Parms = ^TMCI_Load_Parms;
  TMCI_Load_Parms = record
    dwCallback: Longint;
    lpfilename: PChar;
  end;

{ parameter block for MCI_RECORD command message }
type
  PMCI_Record_Parms = ^TMCI_Record_Parms;
  TMCI_Record_Parms = record
    dwCallback: Longint;
    dwFrom: Longint;
    dwTo: Longint;
  end;


{ MCI extensions for videodisc devices }

{ flag for dwReturn field of MCI_STATUS_PARMS }
{ MCI_STATUS command, (dwItem == MCI_STATUS_MODE) }
const
  mci_VD_Mode_Park                = mci_VD_Offset + 1;

{ flag for dwReturn field of MCI_STATUS_PARMS }
{ MCI_STATUS command, (dwItem == MCI_VD_STATUS_MEDIA_TYPE) }
const
  mci_VD_Media_CLV                = mci_VD_Offset + 2;
  mci_VD_Media_CAV                = mci_VD_Offset + 3;
  mci_VD_Media_Other              = mci_VD_Offset + 4;

const
  mci_VD_Format_Track             = $4001;

{ flags for dwFlags parameter of MCI_PLAY command message }
const
  mci_VD_Play_Reverse             = $00010000;
  mci_VD_Play_Fast                = $00020000;
  mci_VD_Play_Speed               = $00040000;
  mci_VD_Play_Scan                = $00080000;
  mci_VD_Play_Slow                = $00100000;

{ flag for dwFlags parameter of MCI_SEEK command message }
const
  mci_VD_Seek_Reverse             = $00010000;

{ flags for dwItem field of MCI_STATUS_PARMS parameter block }
const
  mci_VD_Status_Speed             = $00004002;
  mci_VD_Status_Forward           = $00004003;
  mci_VD_Status_Media_Type        = $00004004;
  mci_VD_Status_Side              = $00004005;
  mci_VD_Status_Disc_Size         = $00004006;

{ flags for dwFlags parameter of MCI_GETDEVCAPS command message }
const
  mci_VD_GetDevCaps_CLV           = $00010000;
  mci_VD_GetDevCaps_CAV           = $00020000;

  mci_VD_Spin_Up                  = $00010000;
  mci_VD_Spin_Down                = $00020000;

{ flags for dwItem field of MCI_GETDEVCAPS_PARMS parameter block }
const
  mci_VD_GetDevCaps_Can_Reverse   = $00004002;
  mci_VD_GetDevCaps_Fast_Rate     = $00004003;
  mci_VD_GetDevCaps_Slow_Rate     = $00004004;
  mci_VD_GetDevCaps_Normal_Rate   = $00004005;

{ flags for the dwFlags parameter of MCI_STEP command message }
const
  mci_VD_Step_Frames              = $00010000;
  mci_VD_Step_Reverse             = $00020000;

{ flag for the MCI_ESCAPE command message }
const
  mci_VD_Escape_String            = $00000100;

{ parameter block for MCI_PLAY command message }
type
  PMCI_VD_Play_Parms = ^TMCI_VD_Play_Parms;
  TMCI_VD_Play_Parms = record
    dwCallback: Longint;
    dwFrom: Longint;
    dwTo: Longint;
    dwSpeed: Longint;
  end;

{ parameter block for MCI_STEP command message }
type
  PMCI_VD_Step_Parms = ^TMCI_VD_Step_Parms;
  TMCI_VD_Step_Parms = record
    dwCallback: Longint;
    dwFrames: Longint;
  end;

{ parameter block for MCI_ESCAPE command message }
type
  PMCI_VD_Escape_Parms = ^TMCI_VD_Escape_Parms;
  TMCI_VD_Escape_Parms = record
    dwCallback: Longint;
    lpstrCommand: PChar;
  end;


{ MCI extensions for waveform audio devices }

{ flags for the dwFlags parameter of MCI_OPEN command message }
const
  mci_Wave_Open_Buffer            = $00010000;

{ flags for the dwFlags parameter of MCI_SET command message }
const
  mci_Wave_Set_FormatTag          = $00010000;
  mci_Wave_Set_Channels           = $00020000;
  mci_Wave_Set_SamplesPerSec      = $00040000;
  mci_Wave_Set_AvgBytesPerSec     = $00080000;
  mci_Wave_Set_BlockAlign         = $00100000;
  mci_Wave_Set_BitsPerSample      = $00200000;

{ flags for the dwFlags parameter of MCI_STATUS, MCI_SET command messages }
const
  mci_Wave_Input                  = $00400000;
  mci_Wave_Output                 = $00800000;

{ flags for the dwItem field of MCI_STATUS_PARMS parameter block }
const
  mci_Wave_Status_FormatTag       = $00004001;
  mci_Wave_Status_Channels        = $00004002;
  mci_Wave_Status_SamplesPerSec   = $00004003;
  mci_Wave_Status_AvgBytesPerSec  = $00004004;
  mci_Wave_Status_BlockAlign      = $00004005;
  mci_Wave_Status_BitsPerSample   = $00004006;
  mci_Wave_Status_Level           = $00004007;

{ flags for the dwFlags parameter of MCI_SET command message }
const
  mci_Wave_Set_AnyInput           = $04000000;
  mci_Wave_Set_AnyOutput          = $08000000;

{ flags for the dwFlags parameter of MCI_GETDEVCAPS command message }
const
  mci_Wave_GetDevCaps_Inputs      = $00004001;
  mci_Wave_GetDevCaps_Outputs     = $00004002;

{ parameter block for MCI_OPEN command message }
type
  PMCI_Wave_Open_Parms = ^TMCI_Wave_Open_Parms;
  TMCI_Wave_Open_Parms = record
    dwCallback: Longint;
    wDeviceID: Word;
    wReserved0: Word;
    lpstrDeviceType: PChar;
    lpstrElementName: PChar;
    lpstrAlias: PChar;
    dwBufferSeconds: Longint;
  end;

{ parameter block for MCI_DELETE command message }
type
  PMCI_Wave_Delete_Parms = ^TMCI_Wave_Delete_Parms;
  TMCI_Wave_Delete_Parms = record
    dwCallback: Longint;
    dwFrom: Longint;
    dwTo: Longint;
  end;

{ parameter block for MCI_SET command message }
type
  PMCI_Wave_Set_Parms = ^TMCI_Wave_Set_Parms;
  TMCI_Wave_Set_Parms = record
    dwCallback: Longint;
    dwTimeFormat: Longint;
    dwAudio: Longint;
    wInput: Word;
    wReserved0: Word;
    wOutput: Word;
    wReserved1: Word;
    wFormatTag: Word;
    wReserved2: Word;
    nChannels: Word;
    wReserved3: Word;
    nSamplesPerSec: Longint;
    nAvgBytesPerSec: Longint;
    nBlockAlign: Word;
    wReserved4: Word;
    wBitsPerSample: Word;
    wReserved5: Word;
  end;


{ MCI extensions for MIDI sequencer devices }

{ flags for the dwReturn field of MCI_STATUS_PARMS parameter block }
{ MCI_STATUS command, (dwItem == MCI_SEQ_STATUS_DIVTYPE) }
const
  mci_Seq_Div_PPQN            = 0 + mci_Seq_Offset;
  mci_Seq_Div_SMPTE_24        = 1 + mci_Seq_Offset;
  mci_Seq_Div_SMPTE_25        = 2 + mci_Seq_Offset;
  mci_Seq_Div_SMPTE_30Drop    = 3 + mci_Seq_Offset;
  mci_Seq_Div_SMPTE_30        = 4 + mci_Seq_Offset;

{ flags for the dwMaster field of MCI_SEQ_SET_PARMS parameter block }
{ MCI_SET command, (dwFlags == MCI_SEQ_SET_MASTER) }
const
  mci_Seq_Format_SongPtr      = $4001;
  mci_Seq_File                = $4002;
  mci_Seq_MIDI                = $4003;
  mci_Seq_SMPTE               = $4004;
  mci_Seq_None                = 65533;

{ flags for the dwItem field of MCI_STATUS_PARMS parameter block }
const
  mci_Seq_Status_Tempo            = $00004002;
  mci_Seq_Status_Port             = $00004003;
  mci_Seq_Status_Slave            = $00004007;
  mci_Seq_Status_Master           = $00004008;
  mci_Seq_Status_Offset           = $00004009;
  mci_Seq_Status_DivType          = $0000400A;

{ flags for the dwFlags parameter of MCI_SET command message }
const
  mci_Seq_Set_Tempo               = $00010000;
  mci_Seq_Set_Port                = $00020000;
  mci_Seq_Set_Slave               = $00040000;
  mci_Seq_Set_Master              = $00080000;
  mci_Seq_Set_Offset              = $01000000;

{ parameter block for MCI_SET command message }
type
  PMCI_Seq_Set_Parms = ^TMCI_Seq_Set_Parms;
  TMCI_Seq_Set_Parms = record
    dwCallback: Longint;
    dwTimeFormat: Longint;
    dwAudio: Longint;
    dwTempo: Longint;
    dwPort: Longint;
    dwSlave: Longint;
    dwMaster: Longint;
    dwOffset: Longint;
  end;


{ MCI extensions for animation devices }

{ flags for dwFlags parameter of MCI_OPEN command message }
const
  mci_Anim_Open_WS                = $00010000;
  mci_Anim_Open_Parent            = $00020000;
  mci_Anim_Open_NoStatic          = $00040000;

{ flags for dwFlags parameter of MCI_PLAY command message }
const
  mci_Anim_Play_Speed             = $00010000;
  mci_Anim_Play_Reverse           = $00020000;
  mci_Anim_Play_Fast              = $00040000;
  mci_Anim_Play_Slow              = $00080000;
  mci_Anim_Play_Scan              = $00100000;

{ flags for dwFlags parameter of MCI_STEP command message }
const
  mci_Anim_Step_Reverse           = $00010000;
  mci_Anim_Step_Frames            = $00020000;

{ flags for dwItem field of MCI_STATUS_PARMS parameter block }
const
  mci_Anim_Status_Speed           = $00004001;
  mci_Anim_Status_Forward         = $00004002;
  mci_Anim_Status_HWnd            = $00004003;
  mci_Anim_Status_HPal            = $00004004;
  mci_Anim_Status_Stretch         = $00004005;

{ flags for the dwFlags parameter of MCI_INFO command message }
const
  mci_Anim_Info_Text              = $00010000;

{ flags for dwItem field of MCI_GETDEVCAPS_PARMS parameter block }
const
  mci_Anim_GetDevCaps_Can_Reverse = $00004001;
  mci_Anim_GetDevCaps_Fast_Rate   = $00004002;
  mci_Anim_GetDevCaps_Slow_Rate   = $00004003;
  mci_Anim_GetDevCaps_Normal_Rate = $00004004;
  mci_Anim_GetDevCaps_Palettes    = $00004006;
  mci_Anim_GetDevCaps_Can_Stretch = $00004007;
  mci_Anim_GetDevCaps_Max_Windows = $00004008;

{ flags for the MCI_REALIZE command message }
const
  mci_Anim_Realize_Norm           = $00010000;
  mci_Anim_Realize_Bkgd           = $00020000;

{ flags for dwFlags parameter of MCI_WINDOW command message }
const
  mci_Anim_Window_HWnd            = $00010000;
  mci_Anim_Window_State           = $00040000;
  mci_Anim_Window_Text            = $00080000;
  mci_Anim_Window_Enable_Stretch  = $00100000;
  mci_Anim_Window_Disable_Stretch = $00200000;

{ flags for hWnd field of MCI_ANIM_WINDOW_PARMS parameter block }
{ MCI_WINDOW command message, (dwFlags == MCI_ANIM_WINDOW_HWND) }
const
  mci_Anim_Window_Default         = $00000000;

{ flags for dwFlags parameter of MCI_PUT command message }
const
  mci_Anim_RECT                   = $00010000;
  mci_Anim_Put_Source             = $00020000;
  mci_Anim_Put_Destination        = $00040000;

{ flags for dwFlags parameter of MCI_WHERE command message }
const
  mci_Anim_Where_Source           = $00020000;
  mci_Anim_Where_Destination      = $00040000;

{ flags for dwFlags parameter of MCI_UPDATE command message }
const
  mci_Anim_Update_HDC             = $00020000;

{ parameter block for MCI_OPEN command message }
type
  PMCI_Anim_Open_Parms = ^TMCI_Anim_Open_Parms;
  TMCI_Anim_Open_Parms = record
    dwCallback: Longint;
    wDeviceID: Word;
    wReserved0: Word;
    lpstrDeviceType: PChar;
    lpstrElementName: PChar;
    lpstrAlias: PChar;
    dwStyle: Longint;
    hWndParent: HWnd;
    wReserved1: Word;
  end;

{ parameter block for MCI_PLAY command message }
type
  PMCI_Anim_Play_Parms = ^TMCI_Anim_Play_Parms;
  TMCI_Anim_Play_Parms = record
    dwCallback: Longint;
    dwFrom: Longint;
    dwTo: Longint;
    dwSpeed: Longint;
  end;

{ parameter block for MCI_STEP command message }
type
  PMCI_Anim_Step_Parms = ^TMCI_Anim_Step_Parms;
  TMCI_Anim_Step_Parms = record
    dwCallback: Longint;
    dwFrames: Longint;
  end;

{ parameter block for MCI_WINDOW command message }
type
  PMCI_Anim_Window_Parms = ^TMCI_Anim_Window_Parms;
  TMCI_Anim_Window_Parms = record
    dwCallback: Longint;
    Wnd: HWnd;  { formerly "hWnd" }
    wReserved1: Word;
    nCmdShow: Word;
    wReserved2: Word;
    lpstrText: PChar;
  end;

{ parameter block for MCI_PUT, MCI_UPDATE, MCI_WHERE command messages }
type
  PMCI_Anim_Rect_Parms = ^ TMCI_Anim_Rect_Parms;
  TMCI_Anim_Rect_Parms = record
    dwCallback: Longint;
    rc: TRect;
  end;

{ parameter block for MCI_UPDATE PARMS }
type
  PMCI_Anim_Update_Parms = ^TMCI_Anim_Update_Parms;
  TMCI_Anim_Update_Parms = record
    dwCallback: Longint;
    rc: TRect;
    hDC: HDC;
  end;


{ MCI extensions for video overlay devices }

{ flags for dwFlags parameter of MCI_OPEN command message }
const
  mci_Ovly_Open_WS                = $00010000;
  mci_Ovly_Open_Parent            = $00020000;

{ flags for dwFlags parameter of MCI_STATUS command message }
const
  mci_Ovly_Status_HWnd            = $00004001;
  mci_Ovly_Status_Stretch         = $00004002;

{ flags for dwFlags parameter of MCI_INFO command message }
const
  mci_Ovly_Info_Text              = $00010000;

{ flags for dwItem field of MCI_GETDEVCAPS_PARMS parameter block }
const
  mci_Ovly_GetDevCaps_Can_Stretch = $00004001;
  mci_Ovly_GetDevCaps_Can_Freeze  = $00004002;
  mci_Ovly_GetDevCaps_Max_Windows = $00004003;

{ flags for dwFlags parameter of MCI_WINDOW command message }
const
  mci_Ovly_Window_HWnd            = $00010000;
  mci_Ovly_Window_State           = $00040000;
  mci_Ovly_Window_Text            = $00080000;
  mci_Ovly_Window_Enable_Stretch  = $00100000;
  mci_Ovly_Window_Disable_Stretch = $00200000;

{ flags for hWnd parameter of MCI_OVLY_WINDOW_PARMS parameter block }
const
  mci_Ovly_Window_Default         = $00000000;

{ flags for dwFlags parameter of MCI_PUT command message }
const
  mci_Ovly_Rect                   = $00010000;
  mci_Ovly_Put_Source             = $00020000;
  mci_Ovly_Put_Destination        = $00040000;
  mci_Ovly_Put_Frame              = $00080000;
  mci_Ovly_Put_Video              = $00100000;

{ flags for dwFlags parameter of MCI_WHERE command message }
const
  mci_Ovly_Where_Source           = $00020000;
  mci_Ovly_Where_Destination      = $00040000;
  mci_Ovly_Where_Frame            = $00080000;
  mci_Ovly_Where_Video            = $00100000;

{ parameter block for MCI_OPEN command message }
type
  PMCI_Ovly_Open_Parms = ^TMCI_Ovly_Open_Parms;
  TMCI_Ovly_Open_Parms = record
    dwCallback: Longint;
    wDeviceID: Word;
    wReserved0: Word;
    lpstrDeviceType: PChar;
    lpstrElementName: PChar;
    lpstrAlias: PChar;
    dwStyle: Longint;
    hWndParent: HWnd;
    wReserved1: Word;
  end;

{ parameter block for MCI_WINDOW command message }
type
  PMCI_Ovly_Window_Parms = ^TMCI_Ovly_Window_Parms;
  TMCI_Ovly_Window_Parms = record
    dwCallback: Longint;
    WHandle: HWnd; { formerly "hWnd"}
    wReserved1: Word;
    nCmdShow: Word;
    wReserved2: Word;
    lpstrText: PChar;
  end;

{ parameter block for MCI_PUT, MCI_UPDATE, and MCI_WHERE command messages }
type
  PMCI_Ovly_Rect_Parms = ^ TMCI_Ovly_Rect_Parms;
  TMCI_Ovly_Rect_Parms = record
    dwCallback: Longint;
    rc: TRect;
  end;

{ parameter block for MCI_SAVE command message }
type
  PMCI_Ovly_Save_Parms = ^TMCI_Ovly_Save_Parms;
  TMCI_Ovly_Save_Parms = record
    dwCallback: Longint;
    lpfilename: PChar;
    rc: TRect;
  end;

{ parameter block for MCI_LOAD command message }
type
  PMCI_Ovly_Load_Parms = ^TMCI_Ovly_Load_Parms;
  TMCI_Ovly_Load_Parms = record
    dwCallback: Longint;
    lpfilename: PChar;
    rc: TRect;
  end;


{***************************************************************************

                        DISPLAY Driver extensions

***************************************************************************}

const
  Caps1           = 94;          { other caps }
  c1_Transparent  = $0001;       { new raster cap }
  NewTransparent  = 3;           { use with SetBkMode() }
  QueryrOPSupport = 40;          { use to determine ROP support }

{***************************************************************************

                        DIB Driver extensions

***************************************************************************}
const
  SelectDIB       = 41;                      { DIB.DRV select dib escape }

function DIBIndex(N: Integer): LongInt;
inline(
  $58/          { POP   AX }
  $BA/$FF/$10); { MOV   DX,10FFH }

{***************************************************************************

                        ScreenSaver support

    The current application will receive a syscommand of SC_SCREENSAVE just
    before the screen saver is invoked.  If the app wishes to prevent a
    screen save, return a non-zero value, otherwise call DefWindowProc().

***************************************************************************}

const
  sc_ScreenSave   = $F140;

implementation

function mmsystemGetVersion;                 external 'MMSYSTEM' index 5;
procedure OutputDebugStr;                    external 'MMSYSTEM' index 30;
function sndPlaySound;                       external 'MMSYSTEM' index 2;
function waveOutGetNumDevs;                  external 'MMSYSTEM' index 401;
function waveOutGetDevCaps;                  external 'MMSYSTEM' index 402;
function waveOutGetVolume;                   external 'MMSYSTEM' index 415;
function waveOutSetVolume;                   external 'MMSYSTEM' index 416;
function waveOutGetErrorText;                external 'MMSYSTEM' index 403;
function waveOutOpen;                        external 'MMSYSTEM' index 404;
function waveOutClose;                       external 'MMSYSTEM' index 405;
function waveOutPrepareHeader;               external 'MMSYSTEM' index 406;
function waveOutUnprepareHeader;             external 'MMSYSTEM' index 407;
function waveOutWrite;                       external 'MMSYSTEM' index 408;
function waveOutPause;                       external 'MMSYSTEM' index 409;
function waveOutRestart;                     external 'MMSYSTEM' index 410;
function waveOutReset;                       external 'MMSYSTEM' index 411;
function waveOutBreakLoop;                   external 'MMSYSTEM' index 419;
function waveOutGetPosition;                 external 'MMSYSTEM' index 412;
function waveOutGetPitch;                    external 'MMSYSTEM' index 413;
function waveOutSetPitch;                    external 'MMSYSTEM' index 414;
function waveOutGetPlaybackRate;             external 'MMSYSTEM' index 417;
function waveOutSetPlaybackRate;             external 'MMSYSTEM' index 418;
function waveOutGetID;                       external 'MMSYSTEM' index 420;
function waveOutMessage;                     external 'MMSYSTEM' index 421;
function waveInGetNumDevs;                   external 'MMSYSTEM' index 501;
function waveInGetDevCaps;                   external 'MMSYSTEM' index 502;
function waveInGetErrorText;                 external 'MMSYSTEM' index 503;
function waveInOpen;                         external 'MMSYSTEM' index 504;
function waveInClose;                        external 'MMSYSTEM' index 505;
function waveInPrepareHeader;                external 'MMSYSTEM' index 506;
function waveInUnprepareHeader;              external 'MMSYSTEM' index 507;
function waveInAddBuffer;                    external 'MMSYSTEM' index 508;
function waveInStart;                        external 'MMSYSTEM' index 509;
function waveInStop;                         external 'MMSYSTEM' index 510;
function waveInReset;                        external 'MMSYSTEM' index 511;
function waveInGetPosition;                  external 'MMSYSTEM' index 512;
function waveInGetID;                        external 'MMSYSTEM' index 513;
function waveInMessage;                      external 'MMSYSTEM' index 514;
function midiOutGetNumDevs;                  external 'MMSYSTEM' index 201;
function midiOutGetDevCaps;                  external 'MMSYSTEM' index 202;
function midiOutGetVolume;                   external 'MMSYSTEM' index 211;
function midiOutSetVolume;                   external 'MMSYSTEM' index 212;
function midiOutGetErrorText;                external 'MMSYSTEM' index 203;
function midiOutOpen;                        external 'MMSYSTEM' index 204;
function midiOutClose;                       external 'MMSYSTEM' index 205;
function midiOutPrepareHeader;               external 'MMSYSTEM' index 206;
function midiOutUnprepareHeader;             external 'MMSYSTEM' index 207;
function midiOutShortMsg;                    external 'MMSYSTEM' index 208;
function midiOutLongMsg;                     external 'MMSYSTEM' index 209;
function midiOutReset;                       external 'MMSYSTEM' index 210;
function midiOutCachePatches;                external 'MMSYSTEM' index 213;
function midiOutCacheDrumPatches;            external 'MMSYSTEM' index 214;
function midiOutGetID;                       external 'MMSYSTEM' index 215;
function midiOutMessage;                     external 'MMSYSTEM' index 216;
function midiInGetNumDevs;                   external 'MMSYSTEM' index 301;
function midiInGetDevCaps;                   external 'MMSYSTEM' index 302;
function midiInGetErrorText;                 external 'MMSYSTEM' index 303;
function midiInOpen;                         external 'MMSYSTEM' index 304;
function midiInClose;                        external 'MMSYSTEM' index 305;
function midiInPrepareHeader;                external 'MMSYSTEM' index 306;
function midiInUnprepareHeader;              external 'MMSYSTEM' index 307;
function midiInAddBuffer;                    external 'MMSYSTEM' index 308;
function midiInStart;                        external 'MMSYSTEM' index 309;
function midiInStop;                         external 'MMSYSTEM' index 310;
function midiInReset;                        external 'MMSYSTEM' index 311;
function midiInGetID;                        external 'MMSYSTEM' index 312;
function midiInMessage;                      external 'MMSYSTEM' index 313;
function auxGetNumDevs;                      external 'MMSYSTEM' index 350;
function auxGetDevCaps;                      external 'MMSYSTEM' index 351;
function auxSetVolume;                       external 'MMSYSTEM' index 353;
function auxGetVolume;                       external 'MMSYSTEM' index 352;
function auxOutMessage;                      external 'MMSYSTEM' index 354;
function timeGetSystemTime;                  external 'MMSYSTEM' index 601;
function timeGetTime;                        external 'MMSYSTEM' index 607;
function timeSetEvent;                       external 'MMSYSTEM' index 602;
function timeKillEvent;                      external 'MMSYSTEM' index 603;
function timeGetDevCaps;                     external 'MMSYSTEM' index 604;
function timeBeginPeriod;                    external 'MMSYSTEM' index 605;
function timeEndPeriod;                      external 'MMSYSTEM' index 606;
function joyGetDevCaps;                      external 'MMSYSTEM' index 102;
function joyGetNumDevs;                      external 'MMSYSTEM' index 101;
function joyGetPos;                          external 'MMSYSTEM' index 103;
function joyGetThreshold;                    external 'MMSYSTEM' index 104;
function joyReleaseCapture;                  external 'MMSYSTEM' index 105;
function joySetCapture;                      external 'MMSYSTEM' index 106;
function joySetThreshold;                    external 'MMSYSTEM' index 107;
function mmioStringToFOURCC;                 external 'MMSYSTEM' index 1220;
function mmioInstallIOProc;                  external 'MMSYSTEM' index 1221;
function mmioOpen;                           external 'MMSYSTEM' index 1210;
function mmioRename;                         external 'MMSYSTEM' index 1226;
function mmioClose;                          external 'MMSYSTEM' index 1211;
function mmioRead;                           external 'MMSYSTEM' index 1212;
function mmioWrite;                          external 'MMSYSTEM' index 1213;
function mmioSeek;                           external 'MMSYSTEM' index 1214;
function mmioGetInfo;                        external 'MMSYSTEM' index 1215;
function mmioSetInfo;                        external 'MMSYSTEM' index 1216;
function mmioSetBuffer;                      external 'MMSYSTEM' index 1217;
function mmioFlush;                          external 'MMSYSTEM' index 1218;
function mmioAdvance;                        external 'MMSYSTEM' index 1219;
function mmioSendMessage;                    external 'MMSYSTEM' index 1222;
function mmioDescend;                        external 'MMSYSTEM' index 1223;
function mmioAscend;                         external 'MMSYSTEM' index 1224;
function mmioCreateChunk;                    external 'MMSYSTEM' index 1225;
function mciSendCommand;                     external 'MMSYSTEM' index 701;
function mciSendString;                      external 'MMSYSTEM' index 702;
function mciGetDeviceID;                     external 'MMSYSTEM' index 703;
function mciGetDeviceIDFromElementID;        external 'MMSYSTEM' index 715;
function mciGetErrorString;                  external 'MMSYSTEM' index 706;
function mciSetYieldProc;                    external 'MMSYSTEM' index 714;
function mciGetCreatorTask;                  external 'MMSYSTEM' index 717;
function mciGetYieldProc;                    external 'MMSYSTEM' index 716;

end.
