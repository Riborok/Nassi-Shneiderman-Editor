object GlobalSettingsDialog: TGlobalSettingsDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Global Settings Dialog'
  ClientHeight = 342
  ClientWidth = 786
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
    Left = 695
    Top = 14
    Width = 78
    Height = 30
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
    Left = 695
    Top = 50
    Width = 78
    Height = 30
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    TabStop = False
  end
  object plIf: TPanel
    Left = 8
    Top = 8
    Width = 669
    Height = 161
    ParentBackground = False
    TabOrder = 2
    object lbFalse: TLabel
      Left = 8
      Top = 39
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
      Left = 6
      Top = 6
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
      Left = 344
      Top = 39
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
      Left = 8
      Top = 66
      Width = 313
      Height = 86
      TabStop = False
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
      OnKeyDown = KeyDown
    end
    object mmTrue: TMemo
      Left = 344
      Top = 66
      Width = 313
      Height = 86
      TabStop = False
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
      OnKeyDown = KeyDown
    end
  end
  object plDefault: TPanel
    Left = 343
    Top = 175
    Width = 334
    Height = 162
    TabOrder = 3
    object lbDefAct: TLabel
      Left = 9
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
      Left = 9
      Top = 31
      Width = 313
      Height = 122
      TabStop = False
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
      OnKeyDown = KeyDown
    end
  end
  object plColors: TPanel
    Left = 8
    Top = 175
    Width = 329
    Height = 162
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
      Top = 131
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
      Top = 131
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
      Top = 104
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
      Top = 104
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
    Left = 683
    Top = 298
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
