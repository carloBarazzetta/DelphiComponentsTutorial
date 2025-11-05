program FMX.ClockLabelDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in '..\..\Source\MainForm.pas' {fmMain};
  //FMX.ClockLabelComponentEditorUnit in '..\..\..\..\Components\Source\FMX.ClockLabelComponentEditorUnit.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'FMX - ClockLabel Demo';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
