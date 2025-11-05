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
unit FMX.ComponentsIDETools;

interface

procedure Register;

implementation

uses
  System.Classes
  , DesignIntf
  , Designer
  , DesignEditors
  , FMX.Controls
  , WinApi.Windows
  , WinApi.ShellAPI
  , FMX.ClockLabel
  , FMX.ClockLabelComponentEditorUnit
  ;

const
  ITEM_COMPONENT_EDITOR = 0;
  ITEM_GITHUB_URL = 1;
  ITEMS_COUNT = 2;

type
  TClockLabelComponentEditor = class(TComponentEditor)
  private
    function GetClockLabel: TClockLabel;
  public
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

procedure Register;
begin
  RegisterComponents('MyComponentsFMX', [TClockLabel]);

  RegisterComponentEditor(TClockLabel, TClockLabelComponentEditor);
end;

{ TClockLabelComponentEditor }
procedure TClockLabelComponentEditor.ExecuteVerb(Index: Integer);
begin
  if Index = ITEM_COMPONENT_EDITOR then
  begin
    if EditClockLabel(GetClockLabel) then
      Designer.Modified;
  end
  else if Index = ITEM_GITHUB_URL then
  ShellExecute(0, 'open',
    PChar(CLOCK_LABEL_PROJECT_URL),
      nil, nil, SW_SHOWNORMAL);
end;

function TClockLabelComponentEditor.GetClockLabel: TClockLabel;
begin
  Result := GetComponent as TClockLabel;
end;

function TClockLabelComponentEditor.GetVerb(Index: Integer): string;
begin
  if Index = ITEM_COMPONENT_EDITOR then
    Result := 'Clock Label Editor...'
  else if Index = ITEM_GITHUB_URL then
    Result := 'Project page on GitHub...';
end;

function TClockLabelComponentEditor.GetVerbCount: Integer;
begin
  Result := ITEMS_COUNT;
end;

end.
