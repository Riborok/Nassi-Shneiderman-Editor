unit frmGlobalSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  uIfBranching, uConstants, uBase, uBlockManager, UITypes;
type
  TGlobalSettingsDialog = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lbInfo: TLabel;
    lbTrue: TLabel;
    mmTrue: TMemo;
    lbFalse: TLabel;
    mmFalse: TMemo;
    plIf: TPanel;
    plDefault: TPanel;
    lbDefAct: TLabel;
    mmDefAct: TMemo;
    plColors: TPanel;
    lbColors: TLabel;
    shpHighlight: TShape;
    shpArrow: TShape;
    shpOK: TShape;
    shpCancel: TShape;
    lnHighlightColor: TLabel;
    lbArrow: TLabel;
    lbOK: TLabel;
    lbCancel: TLabel;
    btnRestore: TButton;
    procedure btnRestoreClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure shpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private type
    TResetSettings = procedure;
  private
    FColorDialog : TColorDialog;
    FResetSettings : TResetSettings;
    procedure SetValues;
  public
    constructor Create(const AOwner: TComponent; const AColorDialog: TColorDialog;
                       const AResetSettings : TResetSettings);
    function Execute: Boolean;
  end;

implementation

{$R *.dfm}

  procedure TGlobalSettingsDialog.btnRestoreClick(Sender: TObject);
  begin
    FResetSettings;
    SetValues;
    btnOK.SetFocus;
  end;

  constructor TGlobalSettingsDialog.Create(const AOwner: TComponent; const AColorDialog: TColorDialog;
                                           const AResetSettings : TResetSettings);
  begin
    inherited Create(AOwner);
    FColorDialog := AColorDialog;
    FResetSettings := AResetSettings;

    mmTrue.MaxLength := MaxTextLength;
    mmTrue.Font.Size := mmFontSize;
    mmTrue.Font.Name := mmFontName;

    mmFalse.MaxLength := MaxTextLength;
    mmFalse.Font.Size := mmFontSize;
    mmFalse.Font.Name := mmFontName;
  end;

  procedure TGlobalSettingsDialog.SetValues;
  begin
    mmTrue.Text := TIfBranching.TrueCond;
    mmFalse.Text := TIfBranching.FalseCond;

    mmDefAct.Text := DefaultAction;
    with TBlockManager do
    begin
      shpHighlight.Brush.Color := HighlightColor;
      shpArrow.Brush.Color := ArrowColor;
      shpOK.Brush.Color := OKColor;
      shpCancel.Brush.Color := CancelColor;
    end;
  end;

  procedure TGlobalSettingsDialog.shpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
    if FColorDialog.Execute then
      case TComponent(Sender).Tag of
        0: shpHighlight.Brush.Color := FColorDialog.Color;
        1: shpArrow.Brush.Color := FColorDialog.Color;
        2: shpOK.Brush.Color := FColorDialog.Color;
        3: shpCancel.Brush.Color := FColorDialog.Color;
      end;
  end;

  function TGlobalSettingsDialog.Execute : Boolean;
  begin
    ShowModal;
    if ModalResult = mrOk then
    begin
      Result:= True;

      TIfBranching.TrueCond := mmTrue.Text;
      TIfBranching.FalseCond := mmFalse.Text;
      DefaultAction := mmDefAct.Text;

      with TBlockManager do
      begin
        HighlightColor := shpHighlight.Brush.Color;
        ArrowColor := shpArrow.Brush.Color;
        OKColor := shpOK.Brush.Color;
        CancelColor := shpCancel.Brush.Color;
      end;
    end
    else
      Result:= False;
  end;

  procedure TGlobalSettingsDialog.KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    if Key = VK_ESCAPE then
      ModalResult := mrCancel
    else if (Key = VK_RETURN) and not (ssShift in Shift) then
      ModalResult := mrOk;
  end;

procedure TGlobalSettingsDialog.FormShow(Sender: TObject);
  begin
    Left := (Screen.Width - Width) shr 1;
    Top := (Screen.Height - Height) shr 1;
    SetValues;
  end;

end.
