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
unit VCL.ClockLabel;

interface

{$R *.dcr}

uses
  System.SysUtils
  , System.Classes
  , Vcl.Controls
  , Vcl.StdCtrls
  , Vcl.ExtCtrls
  , Winapi.Messages
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
  TClockLabel = class(TCustomLabel)
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
    //Windows messages
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    procedure Loaded; override;
    procedure AssignTo(Dest: TPersistent); override;
    procedure Change; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    //Inherited Properties
    property Align;
    property Alignment default TAlignment.taCenter; //default changed
    property Anchors;
    property AutoSize;
    property BiDiMode;
    //property Caption; //Do not publish Caption
    property Color nodefault;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EllipsisPosition;
    property Enabled;
    property FocusControl;
    property Font;
    property GlowSize; // Windows Vista only
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowHint;
    property Touch;
    property Transparent;
    property Layout;
    property Visible;
    property WordWrap;
    property StyleElements;
    property StyleName;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnGesture;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnStartDock;
    property OnStartDrag;

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
  WinApi.Windows
  , System.UITypes
  , Vcl.Forms
  ;

const
  DEFAULT_DISPLAYFORMAT = 'hh:mm:ss';

var
  _DotMatrixFontHandle: THandle;
  _AlarmClockFontHandle: THandle;

function LoadResourceFontByName(const ResourceName : string) : THandle;
var
  ResStream  : TResourceStream;
  FontsCount : DWORD;
begin
  ResStream := TResourceStream.Create(hInstance, ResourceName, RT_FONT);
  try
    Result := AddFontMemResourceEx(ResStream.Memory, ResStream.Size, nil, @FontsCount);
  finally
    ResStream.Free;
  end;
end;

{ TClockLabel }

procedure TClockLabel.AssignTo(Dest: TPersistent);
begin
  if Dest is TClockLabel then
  begin
    TClockLabel(Dest).ClockType := Self.ClockType;
    TClockLabel(Dest).DisplayFormat := Self.DisplayFormat;
    TClockLabel(Dest).TimerInterval := Self.TimerInterval;
    TClockLabel(Dest).Caption := Self.Caption;
    TClockLabel(Dest).Font.Assign(Self.Font);
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

procedure TClockLabel.CMEnabledChanged(var Message: TMessage);
begin
  FClockTimer.Enabled := Self.Enabled;
  inherited;
end;

procedure TClockLabel.CMFontChanged(var Message: TMessage);
var
  S: TSpecialFont;
begin
  for S := Low(TSpecialFont) to High(TSpecialFont) do
  begin
    if SameText(SpecialFontNames[S], Font.Name) then
      FSpecialFont := S;
  end;
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
  Alignment := taCenter;

  //Timer active only at Run-Time
  if not IsDesignTime then
    FClockTimer.OnTimer := ClockTimerTimer;

  //Init Caption
  UpdateClockLabel;
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
      Font.Name := SpecialFontNames[AValue]
    else if (Parent is TWinControl) then
      Font.Name := Screen.IconFont.Name;
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
  Self.Caption := FormatDateTime(FDisplayFormat, LTime);
  Change;
end;

initialization
  //Load custom Font from resource
  _DotMatrixFontHandle := LoadResourceFontByName('TCLOCKLABEL_5X7DOTMATRIX');
  _AlarmClockFontHandle := LoadResourceFontByName('TCLOCKLABEL_ALARMCLOCK');

finalization
  if _DotMatrixFontHandle <> 0 then
    RemoveFontMemResourceEx(_DotMatrixFontHandle);
  if _AlarmClockFontHandle <> 0 then
    RemoveFontMemResourceEx(_AlarmClockFontHandle);

end.
