﻿unit Main;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ProcessStatement,
  Base, FirstLoop, IfBranching, CaseBranching, LastLoop, StatementSearch, DrawShapes,
  Vcl.StdCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ToolWin, GetСaseСonditions,
  Vcl.ComCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, GetAction, Types,
  AdjustBorders;

type
  TNassiShneiderman = class(TForm)
    tbSelectFigType: TToolBar;
    ilIcons: TImageList;
    ScrollBox: TScrollBox;
    Image: TImage;
    PopupMenu: TPopupMenu;
    MIAdd: TMenuItem;
    MIAfter: TMenuItem;
    MIBefore: TMenuItem;
    MIAftProcess: TMenuItem;
    MIAftBranch: TMenuItem;
    MIAftMultBranch: TMenuItem;
    MIAftTestLoop: TMenuItem;
    MIAftRevTestLoop: TMenuItem;
    MIBefProcess: TMenuItem;
    MIBefBranch: TMenuItem;
    MIBefMultBranch: TMenuItem;
    MIBefTestLoop: TMenuItem;
    MIBefRevTestLoop: TMenuItem;
    MICut: TMenuItem;
    MICopy: TMenuItem;
    MIInset: TMenuItem;
    alActions: TActionList;
    actAfterProcess: TAction;
    actAfterIfBranch: TAction;
    actAfterMultBranch: TAction;
    actAfterLoop: TAction;
    actAfterRevLoop: TAction;
    tbProcess: TToolButton;
    tbIfBranch: TToolButton;
    tbMultBranch: TToolButton;
    tbLoop: TToolButton;
    tbRevLoop: TToolButton;
    actBeforeProcess: TAction;
    actBeforeIfBranch: TAction;
    actBeforeMultBranch: TAction;
    actBeforeLoop: TAction;
    actBeforeRevLoop: TAction;
    actCopy: TAction;
    actInsert: TAction;
    actCut: TAction;
    N1: TMenuItem;
    N3: TMenuItem;
    actDelete: TAction;
    MIDel: TMenuItem;
    actSortAsc: TAction;
    actSortDesc: TAction;
    MIDescSort: TMenuItem;
    MIAscSort: TMenuItem;
    N2: TMenuItem;

    procedure FormCreate(Sender: TObject);

    procedure ClearAndRedraw;

    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageDblClick(Sender: TObject);

    procedure AddBefore(Sender: TObject);
    procedure AddAfter(Sender: TObject);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MICopyClick(Sender: TObject);
    procedure MICutClick(Sender: TObject);
    procedure MIInsetClick(Sender: TObject);
    procedure DeleteStatement(Sender: TObject);
    procedure Sort(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    { Private declarations }
  private
    FMainBlock : TBlock;
    FDedicatedStatement: TStatement;

    FPrevMousePos: TPoint;
    FIsMouseDown: Boolean;
    FCarryBlock: TBlock;

    FHighlightColor: TColor;

    function TryGetAction(var AAction: String): Boolean;
    function TryGetCond(var AInitialStr: TStringArr): Boolean;
    function CreateStatement(const AStatementClass: TStatementClass; const ABaseBlock: TBlock): TStatement;
    class function ConvertToBlockType(const AIndex: Integer): TStatementClass;
    procedure GetVisibleImageRect(out TopLeft, BottomRight: TPoint);
  private const
    SchemeInitialIndent = 10;
    SchemeInitialFontSize = 14;
    SchemeInitialFont = 'Times New Roman';
  public
    { Public declarations }
  end;

var
  NassiShneiderman: TNassiShneiderman;
  BufferStatement: TStatement;

implementation

  {$R *.dfm}

  procedure TNassiShneiderman.GetVisibleImageRect(out TopLeft, BottomRight: TPoint);
  begin
    TopLeft.X := Image.Left - ScrollBox.HorzScrollBar.Position;
    TopLeft.Y := Image.Top - ScrollBox.VertScrollBar.Position;
    BottomRight.X := TopLeft.X + ScrollBox.ClientWidth;
    BottomRight.Y := TopLeft.Y + ScrollBox.ClientHeight;
  end;

  procedure TNassiShneiderman.FormClose(Sender: TObject;
  var Action: TCloseAction);
  begin
    FMainBlock.Destroy;
  end;

  procedure TNassiShneiderman.FormCreate(Sender: TObject);
  var
    NewStatement: TStatement;
  begin
    actDelete.ShortCut := ShortCut(VK_DELETE, []);

    FDedicatedStatement:= nil;
    BufferStatement:= nil;
    FCarryBlock:= nil;

    Constraints.MinWidth := 960;
    Constraints.MinHeight := 540;

    Base.DefaultBlock:= TProcessStatement;

    Self.DoubleBuffered := true;

    Image.Canvas.Font.Size := SchemeInitialFontSize;

    Image.Canvas.Font.Name := SchemeInitialFont;

    FHighlightColor:= clYellow;

    FMainBlock:= TBlock.Create(SchemeInitialIndent, 0, nil, Image.Canvas);

    NewStatement:= TProcessStatement.CreateUncertainty(FMainBlock);
    FMainBlock.AddFirstStatement(NewStatement, SchemeInitialIndent);
    NewStatement.Install;

    ClearAndRedraw;
  end;

  procedure TNassiShneiderman.ClearAndRedraw;
  begin
    Clear(Image.Canvas);
    DefineBorders(FMainBlock.XLast, FMainBlock.Statements.GetLast.GetYBottom, Image);

    if FDedicatedStatement <> nil then
      ColorizeRectangle(Image.Canvas, FDedicatedStatement.BaseBlock.XStart, FDedicatedStatement.BaseBlock.XLast,
                      FDedicatedStatement.YStart, FDedicatedStatement.GetYBottom, FHighlightColor);

    FMainBlock.DrawBlock;
    //ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Range;
    //ScrollBox.HorzScrollBar.Position := ScrollBox.HorzScrollBar.Range;
    //DrawCoordinates(Image.Canvas, 50);
  end;

  procedure TNassiShneiderman.ScrollBoxMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
    var Handled: Boolean);
  const
    ScrotStep = 42;
  begin
    if ssShift in Shift then
    begin
      if WheelDelta > 0 then
        ScrollBox.HorzScrollBar.Position := ScrollBox.HorzScrollBar.Position - ScrotStep
      else
        ScrollBox.HorzScrollBar.Position := ScrollBox.HorzScrollBar.Position + ScrotStep;
    end
    else
    begin
      if WheelDelta > 0 then
        ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position - ScrotStep
      else
        ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position + ScrotStep;
    end;
  end;

  procedure TNassiShneiderman.PopupMenuPopup(Sender: TObject);
  begin
    if FDedicatedStatement is TCaseBranching then
    begin
      MIAscSort.Visible:= True;
      MIDescSort.Visible:= True;
    end
    else
    begin
      MIAscSort.Visible:= False;
      MIDescSort.Visible:= False;
    end;
  end;

  procedure TNassiShneiderman.ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
    FDedicatedStatement := BinarySearchStatement(X, Y, FMainBlock);

    ClearAndRedraw;

    if FDedicatedStatement <> nil then
      case Button of
        mbRight: PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
        mbLeft:
          begin
            FCarryBlock:= TBlock.Create(
              FDedicatedStatement.BaseBlock.XStart,
              FDedicatedStatement.BaseBlock.XLast,
              nil,
              Image.Canvas
            );

            FCarryBlock.AddFirstStatement(FDedicatedStatement.Clone,
                                          FDedicatedStatement.YStart);

            FIsMouseDown := True;
            FPrevMousePos.X := X;
            FPrevMousePos.Y := Y;
          end;
      end;

  end;

  procedure TNassiShneiderman.ImageMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
  begin
    if FIsMouseDown and (ssLeft in Shift) then
    begin

      FCarryBlock.MoveRight(X - FPrevMousePos.X);
      FCarryBlock.MoveDown(Y - FPrevMousePos.Y);

      ClearAndRedraw;
      FCarryBlock.DrawBlock;

      FPrevMousePos := Point(X, Y);
    end;
  end;

  procedure TNassiShneiderman.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
    if (Button = mbLeft) and FIsMouseDown then
    begin
      FIsMouseDown := False;

      FCarryBlock.Destroy;

      ClearAndRedraw;
    end;
  end;

procedure TNassiShneiderman.MICopyClick(Sender: TObject);
  begin
    if FDedicatedStatement <> nil then
    begin
      if BufferStatement <> nil then
        BufferStatement.Destroy;
      BufferStatement:= FDedicatedStatement.Clone;
    end;
  end;

  procedure TNassiShneiderman.MICutClick(Sender: TObject);
  begin
    if FDedicatedStatement <> nil then
    begin
      if BufferStatement <> nil then
        BufferStatement.Destroy;
      BufferStatement:= FDedicatedStatement.Clone;
      DeleteStatement(Sender);
    end;
  end;

  procedure TNassiShneiderman.MIInsetClick(Sender: TObject);
  begin
    if (BufferStatement <> nil) and (FDedicatedStatement <> nil) then
    begin
      FDedicatedStatement.BaseBlock.AddBlockPartAfter(FDedicatedStatement, BufferStatement);

      BufferStatement.Install;

      FDedicatedStatement:= BufferStatement;
      BufferStatement:= BufferStatement.Clone;

      ClearAndRedraw;
    end;
  end;

  procedure TNassiShneiderman.AddBefore(Sender: TObject);
  var
    NewStatement: TStatement;
  begin

    if FDedicatedStatement <> nil then
    begin
      NewStatement:= CreateStatement(ConvertToBlockType(TComponent(Sender).Tag),
                                                 FDedicatedStatement.BaseBlock);

      if NewStatement <> nil then
      begin
        FDedicatedStatement.BaseBlock.AddStatementBefore(FDedicatedStatement, NewStatement);
        NewStatement.Install;
        FDedicatedStatement:= NewStatement;
      end;

      ClearAndRedraw;
    end;
  end;

  procedure TNassiShneiderman.Sort(Sender: TObject);
  begin
    TCaseBranching(FDedicatedStatement).SortConditions(TComponent(Sender).Tag);
    ClearAndRedraw;
  end;

  procedure TNassiShneiderman.AddAfter(Sender: TObject);
  var
    NewStatement: TStatement;
  begin

    if FDedicatedStatement <> nil then
    begin
      NewStatement:= CreateStatement(ConvertToBlockType(TComponent(Sender).Tag), FDedicatedStatement.BaseBlock);

      if NewStatement <> nil then
      begin
        FDedicatedStatement.BaseBlock.AddStatementAfter(FDedicatedStatement, NewStatement);
        NewStatement.Install;
        FDedicatedStatement:= NewStatement;
      end;

      ClearAndRedraw;
    end;
  end;

  procedure TNassiShneiderman.DeleteStatement(Sender: TObject);
  var
    Block: TBlock;
    Index: Integer;
  begin
    if FDedicatedStatement <> nil then
    begin
      Block:= FDedicatedStatement.BaseBlock;
      Index:= Block.Remove(FDedicatedStatement);
      Block.Statements[Index].Install;

      FDedicatedStatement:= Block.Statements[Index];

      ClearAndRedraw;
    end;
  end;

  procedure TNassiShneiderman.ImageDblClick(Sender: TObject);
  var
    MousePos: TPoint;
    Statement: TStatement;
    Action: String;
    Cond: TStringArr;
    CaseBranching: TCaseBranching;
  begin
    MousePos := Image.ScreenToClient(Mouse.CursorPos);

    Statement := BinarySearchStatement(MousePos.X, MousePos.Y, FMainBlock);

    if Statement <> nil then
    begin
      Action := Statement.Action;

      if TryGetAction(Action) then
      begin
        if Statement is TCaseBranching then
        begin
          CaseBranching:= TCaseBranching(Statement);
          Cond:= CaseBranching.Conds;
          if TryGetCond(Cond) then
            CaseBranching.ChangeActionWithConds(Action, Cond);
        end
        else
          Statement.ChangeAction(Action);

      end;
    end;

    ClearAndRedraw;
  end;

  function TNassiShneiderman.CreateStatement(const AStatementClass: TStatementClass;
                                             const ABaseBlock: TBlock): TStatement;
  var
    Action: String;
    Cond: TStringArr;
  begin
    Result:= nil;
    Action := '';

    if TryGetAction(Action) then
    begin

      if AStatementClass = TCaseBranching then
      begin
        Cond:= nil;
        if TryGetCond(Cond) then
          Result:= TCaseBranching.Create(Action, Cond, ABaseBlock);
      end
      else
        Result:= AStatementClass.Create(Action, ABaseBlock);
    end;
  end;

  class function TNassiShneiderman.ConvertToBlockType(const AIndex: Integer): TStatementClass;
  begin
    case AIndex of
      0 : Result:= TProcessStatement;
      1 : Result:= TIfBranching;
      2 : Result:= TCaseBranching;
      3 : Result:= TFirstLoop;
      4 : Result:= TLastLoop;
    end;
  end;

  function TNassiShneiderman.TryGetCond(var AInitialStr: TStringArr): Boolean;
  var
    WriteСaseСonditions: TWriteСaseСonditions;
  begin
    WriteСaseСonditions := TWriteСaseСonditions.Create(Self, AInitialStr);
    WriteСaseСonditions.ShowModal;

    if WriteСaseСonditions.ModalResult = mrOk then
    begin
      Result:= True;
      AInitialStr:= WriteСaseСonditions.GetСaseСonditions;
    end
    else
      Result:= False;

    WriteСaseСonditions.Destroy;
  end;

  function TNassiShneiderman.TryGetAction(var AAction: String): Boolean;
  var
    WriteActionForm: TWriteAction;
  begin
    WriteActionForm := TWriteAction.Create(Self, AAction);
    WriteActionForm.ShowModal;

    if WriteActionForm.ModalResult = mrOk then
    begin
      Result:= True;
      AAction:= WriteActionForm.GetAction;
    end
    else
      Result:= False;

    WriteActionForm.Destroy;
  end;

end.
