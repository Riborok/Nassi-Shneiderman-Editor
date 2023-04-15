unit Get�ase�onditions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Types, ArrayList, Constants,
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
    constructor Create(AOwner: TComponent; const ACond: TStringArr);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure btnDeleteClick(Sender: TObject);
    destructor Destroy;
  private
    { Private declarations }
    FMemoList: TArrayList<TMemo>;
    FLabelList: TArrayList<TLabel>;
    procedure CreateMemo(const AText: string = '');
  public
    { Public declarations }
    property MemoList: TArrayList<TMemo> read FMemoList;
  end;

var
  Write�ase�onditions: TWrite�ase�onditions;

implementation

{$R *.dfm}

  constructor TWrite�ase�onditions.Create(AOwner: TComponent; const ACond: TStringArr);
  var
    OwnerControl: TControl;
    I: Integer;
  begin
    if Length(ACond) > 1 then
    begin
      inherited Create(AOwner);

      FMemoList:= TArrayList<TMemo>.Create(4);
      FLabelList:= TArrayList<TLabel>.Create(4);

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

      for I := 0 to Length(ACond) - 1 do
        CreateMemo(ACond[i]);
    end;
  end;

  destructor TWrite�ase�onditions.Destroy;
  var
    I: Integer;
  begin
    for I:= 0 to FMemoList.Count - 1 do
      FMemoList[I].Destroy;

    for I:= 0 to FLabelList.Count - 1 do
      FLabelList[I].Destroy;

    FMemoList.Destroy;
    FLabelList.Destroy;

    inherited;
  end;

  procedure TWrite�ase�onditions.btnAddClick(Sender: TObject);
  begin
    CreateMemo;
  end;

  procedure TWrite�ase�onditions.btnDeleteClick(Sender: TObject);
  var
    Memo: TMemo;
    LabelCaption: TLabel;
  begin
    if FMemoList.Count > 2 then
    begin
      Memo:= FMemoList.GetLast;
      LabelCaption:= FLabelList.GetLast;

      FMemoList.Delete(FMemoList.Count - 1);
      FLabelList.Delete(FLabelList.Count - 1);

      if Panel.Height - Memo.Height - LabelCaption.Height >= Self.Height - ScrollBox.Top then
        Panel.Height := Panel.Height - Memo.Height - LabelCaption.Height;

      Memo.Destroy;
      LabelCaption.Destroy;
    end;
  end;

  procedure TWrite�ase�onditions.btnOKClick(Sender: TObject);
  begin
    ModalResult := mrOk;
  end;

  procedure TWrite�ase�onditions.CreateMemo(const AText: string = '');
  var
    Memo: TMemo;
    LabelCaption: TLabel;
    Panel: TPanel;
  begin
    {Panel := TPanel.Create(ScrollBox);
    Panel.Parent := ScrollBox;
    Panel.Top := Memo.Top;
    Panel.Height := 30;
    Panel.Align := alTop;}

    Memo := TMemo.Create(ScrollBox);
    Memo.Parent := ScrollBox;
    Memo.ScrollBars := ssBoth;
    Memo.Text := AText;
    Memo.Align := alTop;
    Memo.Font.Size := FontSize;
    Memo.Font.Name := FontName;


    if FMemoList.Count > 0 then
      Memo.Top := TMemo(FMemoList[FMemoList.Count - 1]).Top +
                TMemo(FMemoList[FMemoList.Count - 1]).Height
    else
      Memo.Top := 50;

    LabelCaption := TLabel.Create(ScrollBox);
    LabelCaption.Parent := ScrollBox;
    LabelCaption.Font.Size := FontSize;
    LabelCaption.Font.Name := FontName;
    LabelCaption.Caption := 'Condition ' + IntToStr(FMemoList.Count + 1);
    LabelCaption.Top := Memo.Top;
    LabelCaption.Align := alTop;

    FMemoList.Add(Memo);
    FLabelList.Add(LabelCaption);

    ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Range;
  end;

  procedure TWrite�ase�onditions.FormCreate(Sender: TObject);
  begin
    Constraints.MinWidth := 550;
    Constraints.MinHeight := 400;
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
