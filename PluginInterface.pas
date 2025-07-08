unit PluginInterface;

interface

type
  IPlugin = interface
    ['{A1B2C3D4-E5F6-4788-9ABC-DEF012345678}'] // Eindeutige GUID
    function GetName: string;
    function GetDescription: string;
    procedure Initialize;
    procedure Execute;
    procedure Shutdown;
  end;

implementation

end.
