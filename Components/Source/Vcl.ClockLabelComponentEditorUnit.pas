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
unit VCL.ClockLabelComponentEditorUnit;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Vcl.Controls,
  Vcl.StdCtrls,
  System.Classes,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.ClockLabel;

type
  TClockLabelEditor = class(TForm)
    BottomPanel: TPanel;
    OKButton: TButton;
    ApplyButton: TButton;
    CancelButton: TButton;
    HelpButton: TButton;
    PropertiesPanel: TPanel;
    ClockTypeGroupBox: TGroupBox;
    ClockTypeComboBox: TComboBox;
    SpecialFontGroupBox: TGroupBox;
    SpecialFontComboBox: TComboBox;
    PreviewLabel: TLabel;
    ClockLabel: TClockLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBoxSelect(Sender: TObject);
  private
    FUpdating: Boolean;
    FSourceClockLabel: TClockLabel;
    procedure ApplyAttributes;
    procedure InitGUI;
    procedure UpdateFromGUI;
    procedure UpdateSizeGUI;
  protected
  public
  end;

function EditClockLabel(const AClockLabel: TClockLabel): Boolean;

implementation

{$R *.dfm}

uses
  Vcl.Themes
  , Vcl.Graphics
  //WARNING: you must define this directive to use this unit outside the IDE
{$IFNDEF UseClockLabelCompEditorAtRunTime}
  , ToolsAPI
  , BrandingAPI
  {$IF (CompilerVersion >= 32.0)}, IDETheme.Utils{$IFEND}
{$ENDIF}
  , Winapi.ShellAPI
  , System.Contnrs
  , System.SysUtils
  , System.TypInfo
  ;

var
  //To save position of the Editor
  SavedBounds: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);

function EditClockLabel(const AClockLabel: TClockLabel): Boolean;
var
  LEditor: TClockLabelEditor;
begin
  LEditor := TClockLabelEditor.Create(nil);
  try
    //Assign attributes of target component
    LEditor.FSourceClockLabel := AClockLabel;
    LEditor.ClockLabel.Assign(AClockLabel);
    Result := LEditor.ShowModal = mrOk;
    SavedBounds := LEditor.BoundsRect;
    if Result then
      AClockLabel.Invalidate;
  finally
    LEditor.Free;
  end;
end;

{ TClockLabelEditor }

procedure TClockLabelEditor.ApplyAttributes;
begin
  Screen.Cursor := crHourglass;
  try
    //Assign attributes to target ClockLabel
    FSourceClockLabel.Assign(ClockLabel);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TClockLabelEditor.ApplyButtonClick(Sender: TObject);
begin
  ApplyAttributes;
  UpdateFromGUI;
end;

procedure TClockLabelEditor.FormCreate(Sender: TObject);
{$IFNDEF UseClockLabelCompEditorAtRunTime}
  {$IF (CompilerVersion >= 32.0)}
  var
    LStyle: TCustomStyleServices;
  {$IFEND}
{$ENDIF}
begin
{$IFNDEF UseClockLabelCompEditorAtRunTime}
  {$IF (CompilerVersion >= 32.0)}
    {$IF (CompilerVersion <= 34.0)}
    if UseThemeFont then
      Self.Font.Assign(GetThemeFont);
    {$IFEND}
    {$IF CompilerVersion > 34.0}
    if TIDEThemeMetrics.Font.Enabled then
      Self.Font.Assign(TIDEThemeMetrics.Font.GetFont);
    {$IFEND}

    if ThemeProperties <> nil then
    begin
      LStyle := ThemeProperties.StyleServices;
      StyleElements := StyleElements - [seClient];
      Color := LStyle.GetSystemColor(clWindow);
      BottomPanel.StyleElements := BottomPanel.StyleElements - [seClient];
      BottomPanel.ParentBackground := False;
      BottomPanel.Color := LStyle.GetSystemColor(clBtnFace);
      IDEThemeManager.RegisterFormClass(TClockLabelEditor);
      ThemeProperties.ApplyTheme(Self);
    end;
  {$IFEND}
{$ENDIF}
end;

procedure TClockLabelEditor.InitGUI;
var
  I: TClockLabelType;
  S: TSpecialFont;
  LPos: Integer;
  LFontName, LDrawName: string;
begin
  //Init caption and version
  Caption := Format(Caption, [CLOCK_LABEL_VERSION]);
  //Init ClockTypeComboBox
  for I := Low(TClockLabelType) to High(TClockLabelType) do
  begin
    LDrawName := GetEnumName(TypeInfo(TClockLabelType), Ord(I));
    LPos := ClockTypeComboBox.Items.Add(LDrawName);
    if I = FSourceClockLabel.ClockType then
      ClockTypeComboBox.ItemIndex := LPos;
  end;

  //Init SpecialFontComboBox
  for S := Low(TSpecialFont) to High(TSpecialFont) do
  begin
    LFontName := SpecialFontNames[S];
    LPos := SpecialFontComboBox.Items.Add(LFontName);
    if S = FSourceClockLabel.SpecialFont then
      SpecialFontComboBox.ItemIndex := LPos;
  end;
  UpdateFromGUI;
end;

procedure TClockLabelEditor.UpdateSizeGUI;
begin
  FUpdating := True;
  try
    Screen.Cursor := crHourGlass;
    InitGUI;
  finally
    FUpdating := False;
    Screen.Cursor := crDefault;
  end;
end;

procedure TClockLabelEditor.FormShow(Sender: TObject);
begin
  UpdateSizeGUI;

  if SavedBounds.Right - SavedBounds.Left > 0 then
    SetBounds(SavedBounds.Left, SavedBounds.Top, SavedBounds.Width, SavedBounds.Height);
end;

procedure TClockLabelEditor.HelpButtonClick(Sender: TObject);
begin
  ShellExecute(handle, 'open',
    PChar(CLOCK_LABEL_PROJECT_URL), nil, nil, SW_SHOWNORMAL)
end;

procedure TClockLabelEditor.OKButtonClick(Sender: TObject);
begin
  ApplyAttributes;
end;

procedure TClockLabelEditor.ComboBoxSelect(Sender: TObject);
begin
  UpdateFromGUI;
end;

procedure TClockLabelEditor.UpdateFromGUI;
begin
  ClockLabel.ClockType := TClockLabelType(ClockTypeComboBox.ItemIndex);
  ClockLabel.SpecialFont := TSpecialFont(SpecialFontComboBox.ItemIndex);
end;

end.
