unit PluginManager;

interface

uses
  System.Classes, System.Generics.Collections, PluginInterface, System.SysUtils;

type
  TPluginManager = class
  private
    FPlugins: TList<IPlugin>;
    FPluginHandles: TList<THandle>;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadPlugin(const FileName: string): Boolean;
    procedure UnloadPlugins;
    function GetPluginCount: Integer;
    function GetPlugin(Index: Integer): IPlugin;
  end;

implementation

uses
  Winapi.Windows;

type
  TGetPluginProcedure = function: IPlugin; stdcall;

constructor TPluginManager.Create;
begin
  inherited Create;
  FPlugins := TList<IPlugin>.Create;
  FPluginHandles := TList<THandle>.Create;
end;

destructor TPluginManager.Destroy;
begin
  UnloadPlugins;
  FPlugins.Free;
  FPluginHandles.Free;
  inherited;
end;

function TPluginManager.LoadPlugin(const FileName: string): Boolean;
var
  Handle: THandle;
  GetPluginProc: TGetPluginProcedure;
  Plugin: IPlugin;
begin
  Result := False;

  // DLL laden
  Handle := LoadLibrary(PChar(FileName));
  if Handle <> 0 then
  begin
    // Funktion aus DLL laden
    @GetPluginProc := GetProcAddress(Handle, 'GetPlugin');
    if Assigned(GetPluginProc) then
    begin
      // Plugin-Instanz erzeugen
      Plugin := GetPluginProc;
      if Assigned(Plugin) then
      begin
        // Plugin initialisieren und speichern
        Plugin.Initialize;
        FPlugins.Add(Plugin);
        FPluginHandles.Add(Handle);
        Result := True;
      end
      else
        FreeLibrary(Handle);
    end
    else
      FreeLibrary(Handle);
  end;
end;

procedure TPluginManager.UnloadPlugins;
var
  i: Integer;
begin
  // Wichtig: Erst alle Plugins beenden
  for i := 0 to FPlugins.Count - 1 do
  begin
    try
      FPlugins[i].Shutdown;
    except
      // Fehler abfangen, falls Plugin-Shutdown fehlschlägt
    end;
  end;

  // Dann alle Interface-Referenzen freigeben
  for i := 0 to FPlugins.Count - 1 do
  begin
    FPlugins[i] := nil;
  end;

  // Erst danach die DLLs entladen
  for i := 0 to FPluginHandles.Count - 1 do
  begin
    if FPluginHandles[i] <> 0 then
      FreeLibrary(FPluginHandles[i]);
  end;

  FPlugins.Clear;
  FPluginHandles.Clear;
end;

//procedure TPluginManager.UnloadPlugins;
//var
//  i: Integer;
//begin
//  // Alle Plugins beenden und entladen
//  for i := 0 to FPlugins.Count - 1 do
//  begin
//    FPlugins[i].Shutdown;
//    FreeLibrary(FPluginHandles[i]);
//  end;
//
//  FPlugins.Clear;
//  FPluginHandles.Clear;
//end;

function TPluginManager.GetPluginCount: Integer;
begin
  Result := FPlugins.Count;
end;

function TPluginManager.GetPlugin(Index: Integer): IPlugin;
begin
  Result := FPlugins[Index];
end;

end.
