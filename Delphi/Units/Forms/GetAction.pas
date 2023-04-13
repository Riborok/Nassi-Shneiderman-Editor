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
    constructor Create(AOwner: TComponent; CurrAction: String = '');
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure MemoActionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WriteAction: TWriteAction;

implementation

{$R *.dfm}

  constructor TWriteAction.Create(AOwner: TComponent; CurrAction: String = '');
  var
    OwnerControl: TControl;
  begin
    inherited Create(AOwner);

    if OwnerControl is TControl then
    begin
      OwnerControl := TControl(AOwner);
      Left := OwnerControl.Left + (OwnerControl.Width - Width) div 2;
      Top := OwnerControl.Top + (OwnerControl.Height - Height) div 2;
    end
    else
    begin
      Left := (Screen.Width - Width) div 2;
      Top := (Screen.Height - Height) div 2;
    end;

    MemoAction.Text := CurrAction;
  end;

  procedure TWriteAction.FormCreate(Sender: TObject);
  begin
    Constraints.MinWidth := 300;
    Constraints.MinHeight := 200;
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