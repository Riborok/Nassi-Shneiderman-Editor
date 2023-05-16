unit frmGetAction;

interface

uses
  Winapi.Windows, System.Classes, uConstants,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TWriteAction = class(TForm)
    MemoAction: TMemo;
    btnOK: TButton;
    btnCancel: TButton;
    procedure MemoActionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function TryGetAction(var AAction: String): Boolean;
  end;

var
  WriteAction: TWriteAction;

implementation

  {$R *.dfm}

  function TWriteAction.TryGetAction(var AAction: String): Boolean;
  begin
    MemoAction.Text := AAction;
    MemoAction.SelStart := 0;
    MemoAction.SelLength := Length(MemoAction.Text);

    ShowModal;

    if Self.ModalResult = MrOk then
    begin
      Result:= True;
      AAction:= MemoAction.Lines.Text;
    end
    else
      Result:= False;
  end;

  procedure TWriteAction.FormCreate(Sender: TObject);
  begin
    MemoAction.MaxLength := MaxTextLength;
    MemoAction.Font.Size := mmFontSize;
    MemoAction.Font.Name := mmFontName;

    Self.Width := Round(Screen.Width / 5);
    Self.Height := Round(Screen.Height / 3.6);

    btnOK.Width := Round((Self.Width - btnCancel.Margins.Left - btnOK.Margins.Right) / 2.1);
    btnCancel.Width := btnOK.Width;

    btnOK.Height := Round(Self.Height / 7.9);
    btnCancel.Height := btnOK.Height;
  end;

  procedure TWriteAction.FormShow(Sender: TObject);
  begin
    Left := (Screen.Width - Width) shr 1;
    Top := (Screen.Height - Height) shr 1;
    MemoAction.SetFocus;
  end;

  procedure TWriteAction.MemoActionKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
  begin
    if Key = VK_ESCAPE then
      ModalResult := mrCancel
    else if (Key = VK_RETURN) and not (ssShift in Shift) then
      ModalResult := mrOk;
  end;

end.
