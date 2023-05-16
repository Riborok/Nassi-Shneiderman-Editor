object PenDialog: TPenDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Pen'
  ClientHeight = 130
  ClientWidth = 396
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object CurrColor: TShape
    Left = 16
    Top = 96
    Width = 113
    Height = 24
    OnMouseDown = CurrColorMouseDown
  end
  object lbLineType: TLabel
    Left = 16
    Top = 8
    Width = 70
    Height = 19
    Caption = 'Line type:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbThickness: TLabel
    Left = 168
    Top = 8
    Width = 75
    Height = 19
    Caption = 'Thickness:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbColor: TLabel
    Left = 16
    Top = 71
    Width = 44
    Height = 19
    Caption = 'Color:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btnOK: TButton
    Left = 300
    Top = 31
    Width = 77
    Height = 30
    Caption = 'OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 300
    Top = 67
    Width = 77
    Height = 30
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 1
  end
  object cbLineType: TComboBox
    Left = 16
    Top = 34
    Width = 113
    Height = 24
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
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
    Top = 33
    Width = 113
    Height = 24
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
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
