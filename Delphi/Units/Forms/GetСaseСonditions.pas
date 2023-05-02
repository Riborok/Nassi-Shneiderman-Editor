unit Get�ase�onditions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdditionalTypes, Stack, Constants,
  Vcl.ExtCtrls;

type
  TWrite�ase�onditions = class(TForm)
    ScrollBox: TScrollBox;
    btnOK: TButton;
    AddCondition: TLabel;
    btnAdd: TButton;
    Label1: TLabel;
    btnDelete: TButton;
    Panel: TPanel;
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
    procedure CreateMemo(const AText: string = '');
  public
    { Public declarations }
    function TryGetCond(var ACond: TStringArr): Boolean;
  private const
    MinCond = 2;
    MaxCond = 100;
  end;

var
  Write�ase�onditions: TWrite�ase�onditions;

implementation

{$R *.dfm}
  function TWrite�ase�onditions.TryGetCond(var ACond: TStringArr): Boolean;
  var
    I: Integer;
    Memo: TMemo;
    LabelCaption: TLabel;
  begin
    for I := 0 to High(ACond) do
      CreateMemo(ACond[i]);

    for I := Length(ACond) + 1 to MinCond do
      CreateMemo;

    FMemoStack.Peek.SelStart := 0;
    FMemoStack.Peek.SelLength := Length(FMemoStack.Peek.Text);

    ShowModal;

    if Self.ModalResult = MrOk then
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
    begin
      Memo:= FMemoStack.Pop;
      Memo.Destroy;
    end;

    for I:= FLabelStack.Count - 1 downto 0 do
    begin
      LabelCaption:= FLabelStack.Pop;
      LabelCaption.Destroy;
    end;

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
    if (Key = VK_RETURN) and not (ssShift in Shift) then
      ModalResult := mrOk;
  end;

  procedure TWrite�ase�onditions.btnAddClick(Sender: TObject);
  begin
    if FMemoStack.Count < MaxCond then
      CreateMemo;
  end;

  procedure TWrite�ase�onditions.btnDeleteClick(Sender: TObject);
  var
    Memo: TMemo;
    LabelCaption: TLabel;
  begin
    if FMemoStack.Count > MinCond then
    begin
      Memo:= FMemoStack.Pop;
      LabelCaption:= FLabelStack.Pop;

      if Panel.Height - Memo.Height - LabelCaption.Height >= Self.Height - ScrollBox.Top then
        Panel.Height := Panel.Height - Memo.Height - LabelCaption.Height;

      Memo.Destroy;
      LabelCaption.Destroy;
    end;
  end;

  procedure TWrite�ase�onditions.CreateMemo(const AText: string = '');
  const
    FontSize = 14;
    FontName = 'Times New Roman';
  var
    Memo: TMemo;
    LabelCaption: TLabel;
  begin

    Memo := TMemo.Create(ScrollBox);
    Memo.Parent := ScrollBox;
    Memo.ScrollBars := ssBoth;
    Memo.Text := AText;
    Memo.Align := alTop;
    Memo.Font.Size := FontSize;
    Memo.Font.Name := FontName;

    if FMemoStack.Count > 0 then
      Memo.Top := FMemoStack.Peek.Top + FMemoStack.Peek.Height
    else
      Memo.Top := 0;

    LabelCaption := TLabel.Create(ScrollBox);
    LabelCaption.Parent := ScrollBox;
    LabelCaption.Font.Size := FontSize;
    LabelCaption.Font.Name := FontName;
    LabelCaption.Caption := 'Condition ' + IntToStr(FMemoStack.Count + 1);
    LabelCaption.Top := Memo.Top;
    LabelCaption.AlignWithMargins := True;
    LabelCaption.Margins.Top := 20;
    LabelCaption.Align := alTop;

    FMemoStack.Push(Memo);
    FLabelStack.Push(LabelCaption);

    ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Range;
  end;

  procedure TWrite�ase�onditions.FormCreate(Sender: TObject);
  begin
    Constraints.MinWidth := 550;
    Constraints.MinHeight := 700;

    Left := (Screen.Width - Width) shr 1;
    Top := (Screen.Height - Height) shr 1;

    FMemoStack:= TStack<TMemo>.Create;
    FLabelStack:= TStack<TLabel>.Create;
  end;

  procedure TWrite�ase�onditions.FormShow(Sender: TObject);
  begin
    FMemoStack.Peek.SetFocus;
  end;

  procedure TWrite�ase�onditions.ScrollBoxMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
  const
    ScrotStep = 42;
  begin
    if WheelDelta > 0 then
      ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position - ScrotStep
    else
      ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position + ScrotStep;
  end;

end.
