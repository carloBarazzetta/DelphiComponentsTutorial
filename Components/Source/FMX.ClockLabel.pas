{******************************************************************************}
{                                                                              }
{  Delphi Components Tutorial: Example Components Delphi                       }
{                                                                              }
{  Copyright (c) 2025 (Ethea S.r.l.)                                           }
{  Author: Carlo Barazzetta                                                    }
{  Contributors:                                                               }
{                                                                              }
{  https://github.com/carloBarazzetta/DelphiComponentsTutorial                 }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
unit FMX.ClockLabel;

interface

{$R *.dcr}

uses
  System.SysUtils
  , System.Classes
  , FMX.Types
  , FMX.Controls
  , FMX.Controls.Presentation
  , FMX.StdCtrls
  ;

const
  CLOCK_LABEL_VERSION = '1.0.0';
  CLOCK_LABEL_PROJECT_URL = 'https://github.com/carloBarazzetta/DelphiComponentsTutorial';

type
  TClockLabelType = (ctCustomClock, ctClassicClock, ctHourMinutesClock, ctMillisecondsClock);
  TSpecialFont = (sfOther, sfDotMatrix, sfAlarmClock);

const
  SpecialFontNames : Array[TSpecialFont] of string =
    ('Other Font', '5x7 DOT Matrix', 'alarm clock');

type
  TClockLabel = class(TLabel)
  private
    //Instance Data for Component
    FDisplayFormat: string;
    FClockLabelType: TClockLabelType;
    FSpecialFont: TSpecialFont;

    //Internal Object
    FClockTimer: TTimer;

    //Method Pointers to Hold Custom Events
    FOnChange: TNotifyEvent;

    procedure ClockTimerTimer(Sender: TObject);
    procedure UpdateClockLabel;

    function IsDesignTime: Boolean;

    //Storing functions
    function StoreDisplayFormat: Boolean;
    
    //Property Setter and Getter
    procedure SetDisplayFormat(const AValue: string);
    function GetInterval: Cardinal;
    procedure SetInterval(const AValue: Cardinal);
    procedure SetClockLabelType(const AValue: TClockLabelType);
    procedure SetSpecialFont(const AValue: TSpecialFont);
  protected
    procedure Loaded; override;
    procedure AssignTo(Dest: TPersistent); override;
    procedure Change; dynamic;
    procedure EnabledChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    //Inherited Properties
    property Align default TAlignLayout.Center; //changed the default value
    property Text stored False; //Do not store Text
    //My Properties
    property ClockType: TClockLabelType read FClockLabelType write SetClockLabelType default ctClassicClock;
    property DisplayFormat: string read FDisplayFormat write SetDisplayFormat stored StoreDisplayFormat;
    property SpecialFont: TSpecialFont read FSpecialFont write SetSpecialFont default sfOther;
    property TimerInterval: Cardinal read GetInterval write SetInterval default 1000;

    //My Event-handlers
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  System.UITypes
  {$IFDEF MSWINDOWS}
  , WinApi.Windows
  , WinApi.Messages
  {$ENDIF}
  , FMX.Graphics
  ;

const
  DEFAULT_DISPLAYFORMAT = 'hh:mm:ss';

{$IFDEF MSWINDOWS}
var
  _DotMatrixFontHandle: THandle;
  _AlarmClockFontHandle: THandle;

function LoadResourceFontByName(const ResourceName : string) : THandle;
//var
//  ResStream  : TResourceStream;
//  FontsCount : DWORD;
begin
  //Do not works in FireMonkey/Windows: https://quality.embarcadero.com/browse/RSP-16207
  Result := 0;
(*
  ResStream := TResourceStream.Create(hInstance, ResourceName, RT_FONT);
  try
    Result := AddFontMemResourceEx(ResStream.Memory, ResStream.Size, nil, @FontsCount);
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  finally
    ResStream.Free;
  end;
*)
end;
{$ENDIF}

{ TClockLabel }

procedure TClockLabel.AssignTo(Dest: TPersistent);
begin
  if Dest is TClockLabel then
  begin
    TClockLabel(Dest).Enabled := Self.Enabled;
    TClockLabel(Dest).ClockType := Self.ClockType;
    TClockLabel(Dest).DisplayFormat := Self.DisplayFormat;
    TClockLabel(Dest).TimerInterval := Self.TimerInterval;
    TClockLabel(Dest).Text := Self.Text;
    TClockLabel(Dest).TextSettings.Font.Assign(Self.TextSettings.Font);
    TClockLabel(Dest).SpecialFont := Self.SpecialFont;
  end
  else
    inherited;
end;

procedure TClockLabel.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TClockLabel.ClockTimerTimer(Sender: TObject);
begin
  UpdateClockLabel;
end;

procedure TClockLabel.EnabledChanged;
begin
  FClockTimer.Enabled := Self.Enabled;
  inherited;
end;

constructor TClockLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //Creates internal component
  FClockTimer := TTimer.Create(nil);

  //Default Values of Instance Data
  FDisplayFormat := DEFAULT_DISPLAYFORMAT;
  FClockLabelType := ctClassicClock;

  //Default Values for inherited properties
  Align := TAlignLayout.Center;
  Text := '00:00:00';

  //Timer active only at Run-Time
  if not IsDesignTime then
    FClockTimer.OnTimer := ClockTimerTimer;
end;

destructor TClockLabel.Destroy;
begin
  FClockTimer.Enabled := False;
  FreeAndNil(FClockTimer);
  inherited;
end;

function TClockLabel.GetInterval: Cardinal;
begin
  Result := FClockTimer.Interval;
end;

function TClockLabel.IsDesignTime: Boolean;
begin
  Result := TComponentStateItem.csDesigning in ComponentState;
end;

procedure TClockLabel.Loaded;
begin
  inherited;
  UpdateClockLabel;
end;

procedure TClockLabel.SetClockLabelType(const AValue: TClockLabelType);
begin
  if FClockLabelType <> AValue then
  begin
    case AValue of
      ctClassicClock: begin DisplayFormat := DEFAULT_DISPLAYFORMAT; TimerInterval := 1000; end;
      ctHourMinutesClock: begin DisplayFormat := 'hh:mm'; TimerInterval := 1000; end;
      ctMillisecondsClock: begin DisplayFormat := 'hh:mm:ss.zzz'; TimerInterval := 10; end;
    end;
    FClockLabelType := AValue;
  end;
end;

procedure TClockLabel.SetDisplayFormat(const AValue: string);
begin
  if AValue <> FDisplayFormat then
  begin
    FDisplayFormat := AValue;
    FClockLabelType := ctCustomClock;
    UpdateClockLabel;
  end;
end;

procedure TClockLabel.SetInterval(const AValue: Cardinal);
begin
  if FClockTimer.Interval <> AValue then
  begin
    FClockTimer.Interval := AValue;
    FClockLabelType := ctCustomClock;
  end;
end;

procedure TClockLabel.SetSpecialFont(const AValue: TSpecialFont);
begin
  if FSpecialFont <> AValue then
  begin
    if AValue <> sfOther then
    begin
      TextSettings.Font.Family := SpecialFontNames[AValue];
      StyledSettings := StyledSettings - [TStyledSetting.Family];
    end
    else
      StyledSettings := StyledSettings + [TStyledSetting.Family];
    FSpecialFont := AValue;
  end;
end;

function TClockLabel.StoreDisplayFormat: Boolean;
begin
  Result := FDisplayFormat <> DEFAULT_DISPLAYFORMAT;
end;

procedure TClockLabel.UpdateClockLabel;
var
  LTime: TDateTime;
begin
  if not IsDesignTime then
    LTime := Now()
  else
    LTime := EncodeTime(0,0,0,0);
  Self.Text := FormatDateTime(FDisplayFormat, LTime);
  Change;
end;

{$IFDEF MSWINDOWS}
initialization
  //Load custom Font from resource
  _DotMatrixFontHandle := LoadResourceFontByName('TCLOCKLABEL_5X7DOTMATRIX');
  _AlarmClockFontHandle := LoadResourceFontByName('TCLOCKLABEL_ALARMCLOCK');

finalization
  if _DotMatrixFontHandle <> 0 then
    RemoveFontMemResourceEx(_DotMatrixFontHandle);
  if _AlarmClockFontHandle <> 0 then
    RemoveFontMemResourceEx(_AlarmClockFontHandle);
{$ENDIF}

end.
