object _main: T_main
  Left = 0
  Top = 0
  Caption = '_main'
  ClientHeight = 641
  ClientWidth = 905
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object btn_load: TButton
    Left = 168
    Top = 24
    Width = 123
    Height = 73
    Caption = 'Lade Button'
    TabOrder = 0
    OnClick = btnLoadPluginsClick
  end
  object btn_execute: TButton
    Left = 168
    Top = 128
    Width = 123
    Height = 73
    Caption = 'Ausf'#252'hren'
    TabOrder = 1
    OnClick = btnExecutePluginClick
  end
  object lbPlugins: TListBox
    Left = 576
    Top = 0
    Width = 329
    Height = 641
    Align = alRight
    ItemHeight = 15
    TabOrder = 2
  end
end
