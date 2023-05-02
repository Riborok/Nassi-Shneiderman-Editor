unit PenSetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TPenDialog = class(TForm)
    ColorDialog: TColorDialog;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FPen: TPen;
  public
    { Public declarations }
    property Pen: TPen read FPen;
    destructor Destroy; override;
    function Execute: Boolean;
  end;

implementation

{$R *.dfm}

  procedure TPenDialog.FormCreate(Sender: TObject);
  begin
    FPen:= TPen.Create;
  end;

  procedure TPenDialog.FormShow(Sender: TObject);
  begin
    Left := (Screen.Width - Width) shr 1;
    Top := (Screen.Height - Height) shr 1;
  end;

  destructor TPenDialog.Destroy;
  begin
    FPen.Destroy;
  end;

  function TPenDialog.Execute: Boolean;
  begin
    ShowModal;
  end;

end.
