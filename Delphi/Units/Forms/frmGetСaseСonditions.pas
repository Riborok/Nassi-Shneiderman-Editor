unit frmGet�ase�onditions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uAdditionalTypes, uStack, uConstants,
  Vcl.ExtCtrls;

type
  TWrite�ase�onditions = class(TForm)
    ScrollBox: TScrollBox;
    btnOK: TButton;
    lbAdd: TLabel;
    btnAdd: TButton;
    lbDel: TLabel;
    btnDelete: TButton;
    btnCancel: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure btnDeleteClick(Sender: TObject);
    destructor Destroy;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FMemoStack: TStack<TMemo>;
    FLabelStack: TStack<TLabel>;
    FIndent: Integer;
    procedure CreateMemo(const AText: string = '');
  public
    { Public declarations }
    function TryGetCond(var ACond: TStringArr): Boolean;
  private const
    MinAmount = 2;
    MaxAmount = 142;
  end;

var
  Write�ase�onditions: TWrite�ase�onditions;

implementation

{$R *.dfm}
  function TWrite�ase�onditions.TryGetCond(var ACond: TStringArr): Boolean;
  var
    I: Integer;
    Memo: TMemo;
  begin
    FIndent:= 0;
    for I := 0 to High(ACond) do
      CreateMemo(ACond[i]);

    for I := Length(ACond) + 1 to MinAmount do
      CreateMemo;

    FMemoStack.Peek.SelStart := 0;
    FMemoStack.Peek.SelLength := Length(FMemoStack.Peek.Text);

    ShowModal;

    if ModalResult = MrOk then
    begin
      Result:= True;

      SetLength(ACond, FMemoStack.Count);

      for I := FMemoStack.Count - 1 downto 0 do
      begin
        Memo:= FMemoStack.Pop;
        ACond[I]:= Memo.Lines.Text;
        Memo.Destroy;
      end;
    end
    else
      Result:= False;

    for I:= FMemoStack.Count - 1 downto 0 do
      FMemoStack.Pop.Destroy;

    for I:= FLabelStack.Count - 1 downto 0 do
      FLabelStack.Pop.Destroy;

  end;

  destructor TWrite�ase�onditions.Destroy;
  begin
    FMemoStack.Destroy;
    FLabelStack.Destroy;

    inherited;
  end;

  procedure TWrite�ase�onditions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    if Key = VK_ESCAPE then
      ModalResult := mrCancel
    else if (Key = VK_RETURN) and not (ssShift in Shift) then
      ModalResult := mrOk;
  end;

  procedure TWrite�ase�onditions.btnAddClick(Sender: TObject);
  begin
    if FMemoStack.Count <= MaxAmount then
      CreateMemo;
  end;

  procedure TWrite�ase�onditions.btnDeleteClick(Sender: TObject);
  begin
    if FMemoStack.Count > MinAmount then
    begin
      FMemoStack.Pop.Destroy;
      FLabelStack.Pop.Destroy;
    end;
  end;

  procedure TWrite�ase�onditions.CreateMemo(const AText: string = '');
  var
    Memo: TMemo;
    LabelCaption: TLabel;
  begin
    LabelCaption := TLabel.Create(ScrollBox);
    LabelCaption.Parent := ScrollBox;
    LabelCaption.Font.Size := mmFontSize;
    LabelCaption.Font.Name := mmFontName;
    LabelCaption.Caption := 'Condition ' + IntToStr(FMemoStack.Count);
    LabelCaption.AlignWithMargins := True;
    LabelCaption.Margins.Top := 20;
    LabelCaption.Align := alTop;
    LabelCaption.Top := FIndent;
    Inc(FIndent, LabelCaption.Width);

    Memo := TMemo.Create(ScrollBox);
    Memo.Parent := ScrollBox;
    Memo.ScrollBars := ssBoth;
    Memo.Text := AText;
    Memo.Align := alTop;
    Memo.Font.Size := mmFontSize;
    Memo.Font.Name := mmFontName;
    Memo.MaxLength := MaxTextLength;
    Memo.Top:= FIndent;
    Inc(FIndent, Memo.Width);

    FMemoStack.Push(Memo);
    FLabelStack.Push(LabelCaption);

    ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Range;
  end;

  procedure TWrite�ase�onditions.FormCreate(Sender: TObject);
  begin
    FMemoStack:= TStack<TMemo>.Create;
    FLabelStack:= TStack<TLabel>.Create;
  end;

  procedure TWrite�ase�onditions.FormShow(Sender: TObject);
  begin
    Left := (Screen.Width - Width) shr 1;
    Top := (Screen.Height - Height) shr 1;
    FMemoStack.Peek.SetFocus;
  end;

  procedure TWrite�ase�onditions.ScrollBoxMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
  const
    ScrotStep = 42 shl 1;
  begin
    if WheelDelta > 0 then
      ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position - ScrotStep
    else
      ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position + ScrotStep;
  end;

end.
