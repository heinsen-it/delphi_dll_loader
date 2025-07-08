program delphi_dll_loader;

uses
  Vcl.Forms,
  u_main in 'u_main.pas' {_main},
  PluginInterface in 'PluginInterface.pas',
  PluginManager in 'PluginManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(T_main, _main);
  Application.Run;
end.
