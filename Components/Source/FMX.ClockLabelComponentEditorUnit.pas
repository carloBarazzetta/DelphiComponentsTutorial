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
unit FMX.ClockLabelComponentEditorUnit;

interface

uses
  FMX.Controls,
  FMX.StdCtrls, 
  System.Classes, 
  System.SysUtils, 
  FMX.Forms, 
  FMX.ClockLabel,
  FMX.Types, 
  FMX.Controls.Presentation, 
  FMX.ListBox;

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
    procedure ClockTypeComboBoxClosePopup(Sender: TObject);
    procedure SpecialFontComboBoxClosePopup(Sender: TObject);
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

{$R *.fmx}

uses
  System.UITypes
  , Winapi.Messages
  , Winapi.Windows
  , Winapi.shellApi
  , FMX.Graphics
  , FMX.MyComponents.Utils
  //WARNING: you must define this directive to use this unit outside the IDE
{$IFNDEF UseClockLabelCompEditorAtRunTime}
  , ToolsAPI
  , BrandingAPI
  {$IF (CompilerVersion >= 32.0)}, IDETheme.Utils{$IFEND}
{$ENDIF}
  , System.Contnrs
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
    SavedBounds := LEditor.Bounds;
    if Result then
      AClockLabel.Repaint;
  finally
    LEditor.Free;
  end;
end;

{ TClockLabelEditor }

procedure TClockLabelEditor.ApplyAttributes;
begin
  //Assign attributes to target ClockLabel
  FSourceClockLabel.Assign(ClockLabel);
end;

procedure TClockLabelEditor.ApplyButtonClick(Sender: TObject);
begin
  ApplyAttributes;
  UpdateFromGUI;
end;

procedure TClockLabelEditor.ClockTypeComboBoxClosePopup(Sender: TObject);
begin
  UpdateFromGUI;
end;

procedure TClockLabelEditor.FormCreate(Sender: TObject);
begin
  UpdateFormStyleFromIDE(Self);
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
    InitGUI;
  finally
    FUpdating := False;
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
  ShellExecute(0, 'open',
    PChar(CLOCK_LABEL_PROJECT_URL), nil, nil, SW_SHOWNORMAL)
end;

procedure TClockLabelEditor.OKButtonClick(Sender: TObject);
begin
  ApplyAttributes;
end;

procedure TClockLabelEditor.SpecialFontComboBoxClosePopup(Sender: TObject);
begin
  UpdateFromGUI;
end;

procedure TClockLabelEditor.UpdateFromGUI;
begin
  ClockLabel.ClockType := TClockLabelType(ClockTypeComboBox.ItemIndex);
  ClockLabel.SpecialFont := TSpecialFont(SpecialFontComboBox.ItemIndex);
end;

end.
