object PenDialog: TPenDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Pen'
  ClientHeight = 134
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Scaled = False
  OnShow = FormShow
  TextHeight = 13
  object CurrColor: TShape
    Left = 16
    Top = 95
    Width = 113
    Height = 27
    OnMouseDown = CurrColorMouseDown
  end
  object lbLineType: TLabel
    Left = 16
    Top = 8
    Width = 69
    Height = 19
    Caption = 'Line type:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object lbThickness: TLabel
    Left = 168
    Top = 8
    Width = 73
    Height = 19
    Caption = 'Thickness:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object lbColor: TLabel
    Left = 16
    Top = 70
    Width = 45
    Height = 19
    Caption = 'Color:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object btnOK: TButton
    Left = 300
    Top = 31
    Width = 79
    Height = 27
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
    Left = 300
    Top = 68
    Width = 79
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 1
  end
  object cbLineType: TComboBox
    Left = 16
    Top = 31
    Width = 113
    Height = 27
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Items.Strings = (
      'Solid'
      'Dash'
      'Dot'
      'DashDot'
      'DashDotDot')
  end
  object cbThickness: TComboBox
    Left = 168
    Top = 31
    Width = 113
    Height = 27
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnChange = cbThicknessChange
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10')
  end
end
