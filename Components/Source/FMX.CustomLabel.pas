unit FMX.CustomLabel;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.StdCtrls,
  System.Types, FMX.Graphics
  {$IFDEF MSWINDOWS}
  , Winapi.Windows
  {$ENDIF}
  {$IFDEF ANDROID}
  , Androidapi.JNI.GraphicsContentViewText, Androidapi.Helpers,
    Androidapi.JNIBridge, Androidapi.JNI.JavaTypes
  {$ENDIF}
  {$IFDEF IOS}
  , iOSapi.CoreGraphics, iOSapi.CoreText, iOSapi.Foundation,
    Macapi.Helpers, Macapi.ObjectiveC
  {$ENDIF}
  {$IFDEF MACOS}
  , Macapi.CoreFoundation, Macapi.CoreText, Macapi.Helpers
  {$ENDIF}
  ;

implementation

{$IFDEF MSWINDOWS}
function LoadFontWindows(FontData: TBytes; const AFontName: string): THandle;
var
  FontHandle: THandle;
begin
  FontHandle := AddFontMemResourceEx(@FontData[0], Length(FontData), nil, @FontsCount);
  Result := FontHandle;
end;
{$ENDIF}

{$IFDEF ANDROID}
procedure LoadFontAndroid(FontData: TBytes; const AFontName: string);
var
  TypeFace: JTypeface;
  TempFile: string;
  FileStream: TFileStream;
begin
  // Android richiede un file fisico, creiamo un file temporaneo
  TempFile := TPath.Combine(TPath.GetTempPath, AFontName+'.ttf');
  FileStream := TFileStream.Create(TempFile, fmCreate);
  try
    FileStream.Write(FontData[0], Length(FontData));
  finally
    FileStream.Free;
  end;

  // Carica il typeface
  TypeFace := TJTypeface.JavaClass.createFromFile(StringToJString(TempFile));
  if not Assigned(TypeFace) then
    raise Exception.Create('Cannot Load Custom Font');
end;
{$ENDIF}

{$IFDEF IOS}
function LoadFontIOS(FontData: TBytes; const AFontName: string): string;
var
  DataProvider: CGDataProviderRef;
  FontRef: CGFontRef;
  Data: NSData;
  Error: CFErrorRef;
  FontName: CFStringRef;
begin
  Result := '';

  // Crea NSData dai bytes
  Data := TNSData.Wrap(TNSData.alloc.initWithBytes(@FontData[0], Length(FontData)));

  // Crea il data provider
  DataProvider := CGDataProviderCreateWithCFData((Data as ILocalObject).GetObjectID);
  if DataProvider <> nil then
  begin
    // Crea il font
    FontRef := CGFontCreateWithDataProvider(DataProvider);
    CGDataProviderRelease(DataProvider);

    if FontRef <> nil then
    begin
      // Registra il font
      Error := nil;
      if CTFontManagerRegisterGraphicsFont(FontRef, @Error) then
      begin
        // Ottieni il nome del font
        FontName := CGFontCopyPostScriptName(FontRef);
        if FontName <> nil then
        begin
          Result := CFStringRefToStr(FontName);
          CFRelease(FontName);
        end;
      end;
      CGFontRelease(FontRef);
    end;
  end;
end;
{$ENDIF}

{$IFDEF MACOS}
function LoadFontMacOS(FontData: TBytes): string;
var
  DataProvider: CGDataProviderRef;
  FontRef: CGFontRef;
  Data: CFDataRef;
  Error: CFErrorRef;
  FontName: CFStringRef;
begin
  Result := '';

  // Crea CFData dai bytes
  Data := CFDataCreate(kCFAllocatorDefault, @FontData[0], Length(FontData));
  if Data <> nil then
  begin
    // Crea il data provider
    DataProvider := CGDataProviderCreateWithCFData(Data);
    CFRelease(Data);

    if DataProvider <> nil then
    begin
      // Crea il font
      FontRef := CGFontCreateWithDataProvider(DataProvider);
      CGDataProviderRelease(DataProvider);

      if FontRef <> nil then
      begin
        // Registra il font
        Error := nil;
        if CTFontManagerRegisterGraphicsFont(FontRef, @Error) then
        begin
          // Ottieni il nome del font
          FontName := CGFontCopyPostScriptName(FontRef);
          if FontName <> nil then
          begin
            Result := CFStringRefToStr(FontName);
            CFRelease(FontName);
          end;
        end;
        CGFontRelease(FontRef);
      end;
    end;
  end;
end;
{$ENDIF}

{ TCustomLabel }

constructor TCustomLabel.Create(AOwner: TComponent);
begin
  inherited;
  FCustomFontLoaded := False;
  FCustomFontName := '';
end;

procedure TCustomLabel.LoadCustomFont(const AFontName: string);
var
  ResStream: TResourceStream;
  FontData: TBytes;
begin
  // Carica solo una volta per tutta l'applicazione
  if FGlobalFontLoaded then
  begin
    FCustomFontName := FGlobalFontName;
    FCustomFontLoaded := True;
    Exit;
  end;

  try
    // Carica la risorsa
    ResStream := TResourceStream.Create(HInstance, AFontName,
      PChar(CUSTOM_FONT_RESTYPE));
    try
      SetLength(FontData, ResStream.Size);
      ResStream.Read(FontData[0], ResStream.Size);

      // Carica il font in base alla piattaforma
      {$IFDEF MSWINDOWS}
      FCustomFontName := LoadFontWindows(FontData);
      {$ENDIF}
      {$IFDEF ANDROID}
      FCustomFontName := LoadFontAndroid(FontData);
      {$ENDIF}
      {$IFDEF IOS}
      FCustomFontName := LoadFontIOS(FontData);
      {$ENDIF}
      {$IFDEF MACOS}
      FCustomFontName := LoadFontMacOS(FontData);
      {$ENDIF}

      FCustomFontLoaded := (FCustomFontName <> '');

      // Salva globalmente
      if FCustomFontLoaded then
      begin
        FGlobalFontName := FCustomFontName;
        FGlobalFontLoaded := True;
      end;
    finally
      ResStream.Free;
    end;
  except
    on E: Exception do
    begin
      FCustomFontLoaded := False;
      // Log dell'errore se necessario
    end;
  end;
end;

procedure TCustomLabel.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
    LoadCustomFont;
end;

procedure TCustomLabel.ApplyCustomFont;
begin
  if FCustomFontLoaded and (FCustomFontName <> '') then
  begin
    TextSettings.Font.Family := FCustomFontName;
    // Imposta altre proprietà del font se necessario
    TextSettings.Font.Size := 14;
  end;
end;

procedure Register;
begin
  RegisterComponents('Custom', [TCustomLabel]);
end;

end.
