unit frmPenSetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Types;

type
  TPenDialog = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    cbLineType: TComboBox;
    CurrColor: TShape;
    lbLineType: TLabel;
    lbThickness: TLabel;
    cbThickness: TComboBox;
    lbColor: TLabel;
    procedure FormShow(Sender: TObject);
    procedure CurrColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbThicknessChange(Sender: TObject);
  private
    { Private declarations }
    FPen: TPen;
    FColorDialog: TColorDialog;
    class function GetIndexStyle(const AStyle: TPenStyle): Integer;
    class function GetStyle(const AIndex: Integer): TPenStyle;
  public
    { Public declarations }
    property Pen: TPen read FPen;
    constructor Create(const AOwner: TComponent; const AColorDialog: TColorDialog);
    destructor Destroy; override;
    function Execute: Boolean;
  end;

implementation

{$R *.dfm}

  class function TPenDialog.GetIndexStyle(const AStyle: TPenStyle): Integer;
  begin
    case AStyle of
      psSolid: Result:= 0;
      psDash: Result:= 1;
      psDot: Result:= 2;
      psDashDot: Result:= 3;
      psDashDotDot: Result:= 4;
    end;
  end;

  class function TPenDialog.GetStyle(const AIndex: Integer): TPenStyle;
  begin
    case AIndex of
      0: Result:= psSolid;
      1: Result:= psDash;
      2: Result:= psDot;
      3: Result:= psDashDot;
      4: Result:= psDashDotDot;
    end;
  end;

  constructor TPenDialog.Create(const AOwner: TComponent; const AColorDialog: TColorDialog);
  begin
    inherited Create(AOwner);
    FPen:= TPen.Create;
    FColorDialog:= AColorDialog;
  end;

  procedure TPenDialog.FormShow(Sender: TObject);
  begin
    Left := (Screen.Width - Width) shr 1;
    Top := (Screen.Height - Height) shr 1;

    CurrColor.Brush.Color:= FPen.Color;
    cbThickness.ItemIndex := FPen.Width - 1;

    cbLineType.Enabled:= cbThickness.ItemIndex = 0;
    if cbLineType.Enabled then
      cbLineType.ItemIndex := GetIndexStyle(FPen.Style)
    else
      cbLineType.ItemIndex := 0;
  end;

  procedure TPenDialog.cbThicknessChange(Sender: TObject);
  begin
    cbLineType.Enabled:= cbThickness.ItemIndex = 0;
    if not cbLineType.Enabled then
      cbLineType.ItemIndex := 0;
  end;

  procedure TPenDialog.CurrColorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
    if FColorDialog.Execute then
      CurrColor.Brush.Color:= FColorDialog.Color;
  end;

  destructor TPenDialog.Destroy;
  begin
    FPen.Destroy;
  end;

  function TPenDialog.Execute: Boolean;
  begin
    ShowModal;
    if ModalResult = mrOk then
    begin
      Result:= True;
      FPen.Color:= FColorDialog.Color;
      FPen.Style:= GetStyle(cbLineType.ItemIndex);
      FPen.Width:= cbThickness.ItemIndex + 1;
    end
    else
      Result:= False;
  end;

end.
