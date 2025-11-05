unit FMX.MyComponents.Utils;

interface

uses
  System.SysUtils
  , System.Classes
  , FMX.Forms, FMX.Types, FMX.Controls
  ;

type
  TFMXStyleAvail = (saLight, saDark);

  TDesignModuleUtils = class(TDataModule)
    DarkStyleBook: TStyleBook;
    LightStyleBook: TStyleBook;
  end;

procedure UpdateFormStyleFromIDE(const AForm: TForm);
procedure UpdateFormStyle(const AForm: TForm; const AStyle: TFMXStyleAvail);

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.IOUtils
  , System.UITypes
  , Vcl.Themes
  , FMX.Styles
  , FMX.Styles.Objects
  , FMX.Graphics
  //WARNING: you must define this directive to use this unit outside the IDE
{$IFNDEF UseClockLabelCompEditorAtRunTime}
  , ToolsAPI
  {$IF (CompilerVersion >= 27.0)}, BrandingAPI{$IFEND}
  {$IF (CompilerVersion >= 32.0)}, IDETheme.Utils{$IFEND}
{$ENDIF}
  ;

procedure UpdateFormStyle(const AForm: TForm; const AStyle: TFMXStyleAvail);
var
  LDesignModuleUtils: TDesignModuleUtils;
begin
  if Assigned(AForm.StyleBook) then
    AForm.StyleBook.Free;
  LDesignModuleUtils := TDesignModuleUtils.Create(AForm);
  case AStyle of
    saLight: AForm.StyleBook := LDesignModuleUtils.LightStyleBook;
    saDark: AForm.StyleBook := LDesignModuleUtils.DarkStyleBook;
  end;
end;

procedure UpdateFormStyleFromIDE(const AForm: TForm);
{$IFNDEF UseClockLabelCompEditorAtRunTime}
  {$IF (CompilerVersion >= 32.0)}
  var
    LDesignModuleUtils: TDesignModuleUtils;
    LStyle: TCustomStyleServices;
  {$IFEND}
{$ENDIF}
begin
{$IFNDEF UseClockLabelCompEditorAtRunTime}
  {$IF (CompilerVersion >= 32.0)}
  if ThemeProperties <> nil then
    LStyle := ThemeProperties.StyleServices
  else
    LStyle := nil;

  if Assigned(LStyle) then
  begin
    LDesignModuleUtils := TDesignModuleUtils.Create(AForm);
    //Mapping VCL-IDE Style with FMX Style
    if Pos('Dark', LStyle.Name) > 0 then //Win10IDE_Dark
      AForm.StyleBook := LDesignModuleUtils.DarkStyleBook
    else ////Other Light Styles
      AForm.StyleBook := LDesignModuleUtils.LightStyleBook;
  end;
  //ChangeFontSettings(AForm, LIsDarkStyle);
  {$IFEND}
{$ENDIF}
end;

end.
