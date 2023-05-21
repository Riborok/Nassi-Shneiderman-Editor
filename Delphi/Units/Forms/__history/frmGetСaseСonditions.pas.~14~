unit frmGetÑaseÑonditions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uAdditionalTypes, uStack, uConstants,
  Vcl.ExtCtrls;

type
  TWriteÑaseÑonditions = class(TForm)
    ScrollBox: TScrollBox;
    btnOK: TButton;
    lbAdd: TLabel;
    btnAdd: TButton;
    lbDel: TLabel;
    btnDelete: TButton;
    btnCancel: TButton;
    Panel: TPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure btnDeleteClick(Sender: TObject);
    destructor Destroy;
    procedure FormShow(Sender: TObject);
  private type
    TCondSet = record
      LabelCaption : TLabel;
      Memo : TMemo;
    end;
  private
    { Private declarations }
    FCondSetStack: TStack<TCondSet>;
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
  WriteÑaseÑonditions: TWriteÑaseÑonditions;

implementation

{$R *.dfm}
  function TWriteÑaseÑonditions.TryGetCond(var ACond: TStringArr): Boolean;
  var
    I: Integer;
    CondSet: TCondSet;
  begin
    FIndent:= 0;
    for I := 0 to High(ACond) do
      CreateMemo(ACond[i]);

    for I := Length(ACond) + 1 to MinAmount do
      CreateMemo;

    FCondSetStack.Peek.Memo.SelStart := 0;
    FCondSetStack.Peek.Memo.SelLength := Length(FCondSetStack.Peek.Memo.Text);

    ShowModal;

    if ModalResult = MrOk then
    begin
      Result:= True;

      SetLength(ACond, FCondSetStack.Count);

      for I := FCondSetStack.Count - 1 downto 0 do
      begin
        CondSet:= FCondSetStack.Pop;
        ACond[I]:= CondSet.Memo.Lines.Text;
        CondSet.Memo.Destroy;
        CondSet.LabelCaption.Destroy;
      end;
    end
    else
    begin
      Result:= False;

      for I:= FCondSetStack.Count - 1 downto 0 do
      begin
        CondSet:= FCondSetStack.Pop;
        CondSet.Memo.Destroy;
        CondSet.LabelCaption.Destroy;
      end;
    end;
  end;

  destructor TWriteÑaseÑonditions.Destroy;
  begin
    FCondSetStack.Destroy;

    inherited;
  end;

  procedure TWriteÑaseÑonditions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    if Key = VK_ESCAPE then
      ModalResult := mrCancel
    else if (Key = VK_RETURN) and not (ssShift in Shift) then
      ModalResult := mrOk;
  end;

  procedure TWriteÑaseÑonditions.btnAddClick(Sender: TObject);
  begin
    if FCondSetStack.Count <= MaxAmount then
      CreateMemo;
  end;

  procedure TWriteÑaseÑonditions.btnDeleteClick(Sender: TObject);
  var
    CondSet: TCondSet;
  begin
    if FCondSetStack.Count > MinAmount then
    begin
      CondSet:= FCondSetStack.Pop;
      CondSet.LabelCaption.Destroy;
      CondSet.Memo.Destroy;
    end;
  end;

  procedure TWriteÑaseÑonditions.CreateMemo(const AText: string = '');
  var
    CondSet: TCondSet;
  begin
    with CondSet do
    begin
      LabelCaption := TLabel.Create(ScrollBox);
      LabelCaption.Parent := ScrollBox;
      LabelCaption.Font.Size := mmFontSize;
      LabelCaption.Font.Name := mmFontName;
      LabelCaption.Caption := 'Condition ' + IntToStr(FCondSetStack.Count);
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
    end;

    FCondSetStack.Push(CondSet);

    ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Range;
  end;

  procedure TWriteÑaseÑonditions.FormCreate(Sender: TObject);
  begin
    FCondSetStack:= TStack<TCondSet>.Create;

    Self.Width := (lbAdd.Width + lbDel.Width) shl 1;
    Self.Height := Round(Screen.Height / 1.55);

    btnOK.Width := Round(Self.Width / 2.1);
    btnCancel.Width := btnOK.Width;

    btnOK.Height := Round(Self.Height / 18.34);
    btnCancel.Height := btnOK.Height;
  end;

  procedure TWriteÑaseÑonditions.FormShow(Sender: TObject);
  begin
    Left := (Screen.Width - Width) shr 1;
    Top := (Screen.Height - Height) shr 1;
    FCondSetStack.Peek.Memo.SetFocus;
  end;

  procedure TWriteÑaseÑonditions.ScrollBoxMouseWheel(Sender: TObject;
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
