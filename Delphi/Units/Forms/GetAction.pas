unit GetAction;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TWriteAction = class(TForm)
    Panel: TPanel;
    MemoAction: TMemo;
    btnOK: TButton;
    constructor Create(AOwner: TComponent; ACurrAction: String);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure MemoActionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetAction: String;
  end;

var
  WriteAction: TWriteAction;

implementation

  {$R *.dfm}

  function TWriteAction.GetAction: String;
  begin
    Result:= MemoAction.Lines.Text
  end;

  constructor TWriteAction.Create(AOwner: TComponent; ACurrAction: String);
  var
    OwnerControl: TControl;
  begin
    inherited Create(AOwner);

    if AOwner is TControl then
    begin
      OwnerControl := TControl(AOwner);
      Left := OwnerControl.Left + (OwnerControl.Width - Width) shr 1;
      Top := OwnerControl.Top + (OwnerControl.Height - Height) shr 1;
    end
    else
    begin
      Left := (Screen.Width - Width) shr 1;
      Top := (Screen.Height - Height) shr 1;
    end;

    MemoAction.Text := ACurrAction;
    MemoAction.SelStart := 0;
    MemoAction.SelLength := Length(MemoAction.Text);
  end;

  procedure TWriteAction.FormCreate(Sender: TObject);
  begin
    Constraints.MinWidth := 350;
    Constraints.MinHeight := 250;
  end;

  procedure TWriteAction.MemoActionKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
  begin
    if (Key = VK_RETURN) and not (ssShift in Shift) then
      ModalResult := mrOk;
  end;

  procedure TWriteAction.btnOKClick(Sender: TObject);
  begin
    ModalResult := mrOk;
  end;

end.
