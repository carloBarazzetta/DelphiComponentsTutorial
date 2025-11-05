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
program Vcl.ClockLabelDemo;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  MainForm in '..\..\Source\MainForm.pas' {fmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ClockLabel Demo - Copyright (c) Ethea S.r.l.';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
