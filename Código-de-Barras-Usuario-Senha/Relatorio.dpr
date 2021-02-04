program Relatorio;

uses
  Vcl.Forms,
  untRelatorio in 'untRelatorio.pas' {frmRelatorio},
  untConstante in 'biblioteca\untConstante.pas',
  untFuncao in 'biblioteca\untFuncao.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmRelatorio, frmRelatorio);
  Application.Run;
end.
