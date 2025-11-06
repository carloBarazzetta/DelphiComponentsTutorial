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
unit VCL.ComponentsIDETools;

interface

{$R MyComponentsSplash.res}

procedure Register;

implementation

uses
  System.SysUtils
  , System.Classes
  , ToolsAPI
  , DesignIntf
  , Designer
  , DesignEditors
  , VCLEditors
  , Vcl.Graphics
  , Vcl.Imaging.PngImage
  , Vcl.Controls
  , WinApi.Windows
  , WinApi.ShellAPI
  , Vcl.ClockLabel
  , Vcl.ClockLabelComponentEditorUnit
  ;

const
  MY_COMPONENTS_VERSION = '1.0.0';
  ABOUT_RES_NAME = 'MYCOMPSPLASH48PNG';
  SPLASH_RES_NAME = 'MYCOMPSPLASH48PNG';
  RsAboutTitle = 'Ethea Sample Components';
  RsAboutDescription = 'Ethea - Sample Components (VCL) - https://github.com/carloBarazzetta/DelphiComponentsTutorial/' + sLineBreak +
    'Sample Components for VCL (TClockLabel)';
  RsAboutLicense = 'Apache 2.0 (Free/Opensource)';
var
  AboutBoxServices: IOTAAboutBoxServices = nil;
  AboutBoxIndex: Integer;

function CreateBitmapFromPngRes(const AResName: string): Vcl.Graphics.TBitmap;
var
  LPngImage: TPngImage;
  LResStream: TResourceStream;
begin
  LPngImage := nil;
  try
    Result := Vcl.Graphics.TBitmap.Create;
    LPngImage := TPngImage.Create;
    LResStream := TResourceStream.Create(HInstance, AResName, RT_RCDATA);
    try
      LPngImage.LoadFromStream(LResStream);
      Result.Assign(LPngImage);
    finally
      LResStream.Free;
    end;
  finally
    LPngImage.Free;
  end;
end;

procedure RegisterAboutBox;
var
  LBitmap: Vcl.Graphics.TBitmap;
begin
  Supports(BorlandIDEServices,IOTAAboutBoxServices, AboutBoxServices);
  LBitmap := CreateBitmapFromPngRes(ABOUT_RES_NAME);
  try
    AboutBoxIndex := AboutBoxServices.AddPluginInfo(
      RsAboutTitle+' '+MY_COMPONENTS_VERSION,
      RsAboutDescription, LBitmap.Handle, False, RsAboutLicense);
  finally
    LBitmap.Free;
  end;
end;

procedure UnregisterAboutBox;
begin
  if (AboutBoxIndex <> 0) and Assigned(AboutBoxServices) then
  begin
    AboutBoxServices.RemovePluginInfo(AboutBoxIndex);
    AboutBoxIndex := 0;
    AboutBoxServices := nil;
  end;
end;

procedure RegisterWithSplashScreen;
var
  LBitmap: Vcl.Graphics.TBitmap;
begin
  LBitmap := CreateBitmapFromPngRes(SPLASH_RES_NAME);
  try
    SplashScreenServices.AddPluginBitmap(
      RsAboutTitle+' '+MY_COMPONENTS_VERSION,
      LBitmap.Handle, False, RsAboutLicense, '');
  finally
    LBitmap.Free;
  end;
end;

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
  RegisterWithSplashScreen;

  RegisterComponents('Sample Components', [TClockLabel]);

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

initialization
  RegisterAboutBox;

finalization
  UnRegisterAboutBox;

end.
