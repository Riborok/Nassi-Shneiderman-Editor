object WriteAction: TWriteAction
  Left = 0
  Top = 0
  Anchors = [akLeft, akRight, akBottom]
  Caption = 'WriteAction'
  ClientHeight = 194
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 342
    Height = 194
    Align = alClient
    Caption = 'Panel'
    TabOrder = 0
    ExplicitWidth = 340
    ExplicitHeight = 199
    object MemoAction: TMemo
      Left = 1
      Top = 1
      Width = 340
      Height = 155
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      Lines.Strings = (
        'MemoAction')
      ScrollBars = ssBoth
      TabOrder = 0
      OnKeyDown = MemoActionKeyDown
      ExplicitWidth = 338
      ExplicitHeight = 160
    end
    object btnOK: TButton
      Left = 1
      Top = 152
      Width = 340
      Height = 41
      Align = alBottom
      Caption = 'OK'
      TabOrder = 1
      OnClick = btnOKClick
      ExplicitLeft = 0
      ExplicitTop = 153
    end
  end
end