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
unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ClockLabel, FMX.MyComponents.Utils;

type
  TfmMain = class(TForm)
    MatrixClockLabel: TClockLabel;
    AlarmClockLabel: TClockLabel;
    hhmmClockLabel: TClockLabel;
    AppStyleRadioGroup: TGroupBox;
    RadioButtonLightStyle: TRadioButton;
    AlarmButton: TButton;
    MatrixButton: TButton;
    RadioButtonDarkStyle: TRadioButton;
    hhmmButton: TButton;
    procedure AlarmButtonClick(Sender: TObject);
    procedure MatrixButtonClick(Sender: TObject);
    procedure RadioButtonDarkStyleClick(Sender: TObject);
    procedure RadioButtonLightStyleClick(Sender: TObject);
    procedure hhmmButtonClick(Sender: TObject);
  private
  public
  end;

var
  fmMain: TfmMain;

implementation

uses
  System.DateUtils
{$IFDEF UseClockLabelCompEditorAtRunTime}
  , FMX.ClockLabelComponentEditorUnit
{$ENDIF}
  ;

{$R *.fmx}


procedure TfmMain.RadioButtonDarkStyleClick(Sender: TObject);
begin
  UpdateFormStyle(Self, saDark);
end;

procedure TfmMain.RadioButtonLightStyleClick(Sender: TObject);
begin
  UpdateFormStyle(Self, saLight);
end;

procedure TfmMain.AlarmButtonClick(Sender: TObject);
begin
{$IFDEF UseClockLabelCompEditorAtRunTime}
  EditClockLabel(AlarmClockLabel);
{$ENDIF}
end;

procedure TfmMain.hhmmButtonClick(Sender: TObject);
begin
{$IFDEF UseClockLabelCompEditorAtRunTime}
  EditClockLabel(hhmmClockLabel);
{$ENDIF}
end;

procedure TfmMain.MatrixButtonClick(Sender: TObject);
begin
{$IFDEF UseClockLabelCompEditorAtRunTime}
  EditClockLabel(MatrixClockLabel);
{$ENDIF}
end;

initialization
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

end.
