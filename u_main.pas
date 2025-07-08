unit u_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, PluginInterface, PluginManager;

type
  T_main = class(TForm)
    btn_load: TButton;
    btn_execute: TButton;
    lbPlugins: TListBox;
    procedure btnLoadPluginsClick(Sender: TObject);
    procedure btnExecutePluginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FPluginManager: TPluginManager;
    procedure UpdatePluginList;
  public
    { Public-Deklarationen }
  end;

var
  _main: T_main;

implementation

{$R *.dfm}

procedure T_main.FormCreate(Sender: TObject);
begin
  FPluginManager := TPluginManager.Create;
end;

procedure T_main.FormDestroy(Sender: TObject);
begin
  FPluginManager.UnloadPlugins;
  FPluginManager.Free;
end;

procedure T_main.UpdatePluginList;
var
  i: Integer;
begin
  lbPlugins.Clear;
  for i := 0 to FPluginManager.GetPluginCount - 1 do
    lbPlugins.Items.Add(FPluginManager.GetPlugin(i).GetName);
end;

procedure T_main.btnLoadPluginsClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := 'Plugin-Dateien (*.dll)|*.dll';
    OpenDialog.Options := [ofAllowMultiSelect, ofFileMustExist];

    if OpenDialog.Execute then
    begin
      for var FileName in OpenDialog.Files do
      begin
        if FPluginManager.LoadPlugin(FileName) then
          ShowMessage('Plugin geladen: ' + FileName)
        else
          ShowMessage('Fehler beim Laden des Plugins: ' + FileName);
      end;

      UpdatePluginList;
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure T_main.btnExecutePluginClick(Sender: TObject);
begin
  if (lbPlugins.ItemIndex >= 0) and (lbPlugins.ItemIndex < FPluginManager.GetPluginCount) then
    FPluginManager.GetPlugin(lbPlugins.ItemIndex).Execute
  else
    ShowMessage('Bitte wählen Sie ein Plugin aus.');
end;

end.
