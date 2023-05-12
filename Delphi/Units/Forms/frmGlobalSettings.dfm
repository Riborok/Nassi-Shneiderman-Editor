object GlobalSettingsDialog: TGlobalSettingsDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Global settings dialog'
  ClientHeight = 333
  ClientWidth = 829
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 744
    Top = 24
    Width = 65
    Height = 25
    Caption = 'OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 744
    Top = 55
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    TabStop = False
  end
  object plIf: TPanel
    Left = 8
    Top = 8
    Width = 354
    Height = 317
    ParentBackground = False
    TabOrder = 2
    object lbFalse: TLabel
      Left = 16
      Top = 192
      Width = 102
      Height = 21
      Caption = 'Label FALSE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbInfo: TLabel
      Left = 16
      Top = 4
      Width = 261
      Height = 21
      Caption = #1057'onditions for the branching block'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbTrue: TLabel
      Left = 16
      Top = 48
      Width = 95
      Height = 21
      Caption = 'Label TRUE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object mmFalse: TMemo
      Left = 16
      Top = 219
      Width = 313
      Height = 86
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      Lines.Strings = (
        'MemoAction')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object mmTrue: TMemo
      Left = 16
      Top = 75
      Width = 313
      Height = 86
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      Lines.Strings = (
        'MemoAction')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object plDefault: TPanel
    Left = 379
    Top = 8
    Width = 343
    Height = 129
    TabOrder = 3
    object lbDefAct: TLabel
      Left = 16
      Top = 4
      Width = 103
      Height = 21
      Caption = 'Default action'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object mmDefAct: TMemo
      Left = 8
      Top = 31
      Width = 313
      Height = 86
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      Lines.Strings = (
        'MemoAction')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object plColors: TPanel
    Left = 379
    Top = 146
    Width = 343
    Height = 179
    TabOrder = 4
    object lbColors: TLabel
      Left = 8
      Top = 9
      Width = 143
      Height = 21
      Caption = 'Colorful highlighter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object shpHighlight: TShape
      Left = 8
      Top = 67
      Width = 113
      Height = 22
      OnMouseDown = shpMouseDown
    end
    object shpArrow: TShape
      Tag = 1
      Left = 8
      Top = 147
      Width = 113
      Height = 22
      OnMouseDown = shpMouseDown
    end
    object shpOK: TShape
      Tag = 2
      Left = 200
      Top = 67
      Width = 113
      Height = 22
      OnMouseDown = shpMouseDown
    end
    object shpCancel: TShape
      Tag = 3
      Left = 200
      Top = 147
      Width = 113
      Height = 22
      OnMouseDown = shpMouseDown
    end
    object lnHighlightColor: TLabel
      Left = 8
      Top = 40
      Width = 110
      Height = 21
      Caption = 'Highlight color'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbArrow: TLabel
      Left = 8
      Top = 120
      Width = 92
      Height = 21
      Caption = 'Arrow '#1089'olor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbOK: TLabel
      Left = 200
      Top = 40
      Width = 67
      Height = 21
      Caption = 'Ok '#1089'olor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbCancel: TLabel
      Left = 200
      Top = 120
      Width = 95
      Height = 21
      Caption = 'Cancel color'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
  end
  object btnRestore: TButton
    Left = 728
    Top = 286
    Width = 97
    Height = 39
    Caption = 'Restore Defaults'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    TabStop = False
    StyleElements = []
    OnClick = btnRestoreClick
  end
end
