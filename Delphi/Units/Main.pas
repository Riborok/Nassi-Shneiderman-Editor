﻿unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ProcessStatement, BlockController,
  Base, FirstLoop, IfBranching, CaseBranching, LastLoop, StatementSearch, DrawShapes,
  Vcl.StdCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ToolWin, SwitchStatements,
  Vcl.ComCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, AdditionalTypes,
  Types;

type
  TScrollBox= Class(VCL.Forms.TScrollBox)
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  private
    FOnScrollVert: TNotifyEvent;
    FOnScrollHorz: TNotifyEvent;
  public
   Property OnScrollVert:TNotifyEvent read FOnScrollVert Write FonScrollVert;
   Property OnScrollHorz:TNotifyEvent read FOnScrollHorz Write FonScrollHorz;
  End;

  TNassiShneiderman = class(TForm)
    tbSelectFigType: TToolBar;
    ilIcons: TImageList;
    ScrollBox: TScrollBox;
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
    tmRedrawingMovements: TTimer;
    actChangeAction: TAction;
    actChangeAction1: TMenuItem;
    PaintBox: TPaintBox;

    procedure FormCreate(Sender: TObject);

    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DblClick(Sender: TObject);

    procedure AddBefore(Sender: TObject);
    procedure AddAfter(Sender: TObject);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure MICopyClick(Sender: TObject);
    procedure MICutClick(Sender: TObject);
    procedure MIInsetClick(Sender: TObject);
    procedure DeleteStatement(Sender: TObject);
    procedure Sort(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tmRedrawingTimer(Sender: TObject);
    procedure actChangeActionExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PaintBoxPaint(Sender: TObject);
  private
    FMainBlock : TBlock;
    FDedicatedStatement: TStatement;

    FBufferBlock: TBlock;

    FPrevMousePos: TPoint;
    FIsMouseDown: Boolean;
    FCarryBlock: TBlock;

    FHighlightColor: TColor;

    FPen: TPen;
    FFont: TFont;

    procedure MyScroll(Sender: TObject);
    function GetVisibleImageScreen: TVisibleImageRect;
    procedure SetScrollPos(const AStatement: TStatement);

  private const
    SchemeInitialIndent = 10;
    SchemeInitialFontSize = 13;
    SchemeInitialPenWidth = 2;
    SchemeInitialFont = 'Courier new';
  public
    destructor Destroy;
  end;

var
  NassiShneiderman: TNassiShneiderman;

implementation

  {$R *.dfm}

  procedure TScrollBox.WMHScroll(var Message: TWMHScroll);
  begin
     inherited;
     if Assigned(FOnScrollHorz) then
      FOnScrollHorz(Self);
  end;

  procedure TScrollBox.WMVScroll(var Message: TWMVScroll);
  begin
     inherited;
     if Assigned(FOnScrollVert) then
      FOnScrollVert(Self);
  end;

  procedure TNassiShneiderman.MyScroll(Sender: TObject);
  begin
    if GetKeyState(VK_LBUTTON) >= 0 then
      PaintBox.Invalidate;
  end;

  function TNassiShneiderman.GetVisibleImageScreen: TVisibleImageRect;
  begin
    Result.FTopLeft := PaintBox.ScreenToClient(ScrollBox.ClientToScreen(Point(0, 0)));
    Result.FBottomRight := PaintBox.ScreenToClient(
          ScrollBox.ClientToScreen(Point(ScrollBox.Width, ScrollBox.Height)));
  end;

  destructor TNassiShneiderman.Destroy;
  begin
    FMainBlock.Destroy;
    FBufferBlock.Destroy;

    FPen.Destroy;
    FFont.Destroy;
    inherited;
  end;

  procedure TNassiShneiderman.FormCreate(Sender: TObject);
  begin
    Self.DoubleBuffered := True;
    Constraints.MinWidth := 960;
    Constraints.MinHeight := 540;

    ScrollBox.OnScrollVert := MyScroll;
    ScrollBox.OnScrollHorz := MyScroll;

    actDelete.ShortCut := ShortCut(VK_DELETE, []);
    actChangeAction.ShortCut := ShortCut(VK_RETURN, []);

    FHighlightColor:= clYellow;

    FPen:= TPen.Create;
    FFont:= TFont.Create;

    FFont.Size := SchemeInitialFontSize;
    FFont.Name := SchemeInitialFont;
    FFont.Color := clBlack;
    FFont.Style := [];

    FPen.Color := clBlack;
    FPen.Width := SchemeInitialPenWidth;
    FPen.Style := psSolid;

    PaintBox.Canvas.Font := FFont;
    PaintBox.Canvas.Pen := FPen;

    FDedicatedStatement:= nil;
    FCarryBlock:= nil;

    Base.DefaultBlock:= TProcessStatement;

    FBufferBlock:= TBlock.Create(0, 0, nil, PaintBox.Canvas);
    FBufferBlock.AddFirstStatement(Base.DefaultBlock.CreateUncertainty(FBufferBlock));

    FMainBlock:= TBlock.Create(SchemeInitialIndent, 0, nil, PaintBox.Canvas);
    FMainBlock.AddFirstStatement(Base.DefaultBlock.CreateUncertainty(FMainBlock),
                                                            SchemeInitialIndent);
    FIsMouseDown:= False;
    PaintBox.Invalidate;
  end;

  procedure TNassiShneiderman.SetScrollPos(const AStatement: TStatement);
  const
    Stock = 42;
  var
    VisibleImageScreen: TVisibleImageRect;
  begin
    VisibleImageScreen:= GetVisibleImageScreen;

    case GetBlockMask(AStatement.BaseBlock, VisibleImageScreen) of
      $09 {1001}:
         ScrollBox.HorzScrollBar.Position:= ScrollBox.HorzScrollBar.Position +
         AStatement.BaseBlock.XLast - VisibleImageScreen.FBottomRight.X + Stock;
      $06 {1100}:
         ScrollBox.HorzScrollBar.Position:= AStatement.BaseBlock.XStart - Stock;
    end;

    case GetStatementMask(AStatement, VisibleImageScreen) of
      $09 {1001}:
         ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position +
         AStatement.GetYBottom - VisibleImageScreen.FBottomRight.Y + Stock;
      $06 {1100}:
         ScrollBox.VertScrollBar.Position := AStatement.YStart - Stock;
    end;
  end;

  procedure TNassiShneiderman.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    case Key of
      VK_LEFT:
      begin
        SetHorizontalMovement(FDedicatedStatement, FMainBlock, SwitchStatements.BackwardDir);
        SetScrollPos(FDedicatedStatement);
        PaintBox.Invalidate;
      end;
      VK_RIGHT:
      begin
        SetHorizontalMovement(FDedicatedStatement, FMainBlock, SwitchStatements.ForwardDir);
        SetScrollPos(FDedicatedStatement);
        PaintBox.Invalidate;
      end;
      VK_UP:
      begin
        SetVerticalMovement(FDedicatedStatement, FMainBlock, SwitchStatements.BackwardDir);
        SetScrollPos(FDedicatedStatement);
        PaintBox.Invalidate;
      end;
      VK_DOWN:
      begin
        SetVerticalMovement(FDedicatedStatement, FMainBlock, SwitchStatements.ForwardDir);
        SetScrollPos(FDedicatedStatement);
        PaintBox.Invalidate;
      end;
    end;
  end;

  procedure TNassiShneiderman.PaintBoxPaint(Sender: TObject);
  const
    Stock = 420;
  var
    VisibleImageRect: TVisibleImageRect;
  begin
    PaintBox.Canvas.Font := FFont;
    PaintBox.Canvas.Pen := FPen;

    VisibleImageRect:= GetVisibleImageScreen;
    VisibleImageRect.Expand(Stock);

    PaintBox.Width := FMainBlock.XLast + Stock;
    PaintBox.Height := FMainBlock.Statements.GetLast.GetYBottom + Stock;

    if FDedicatedStatement <> nil then
      ColorizeRect(PaintBox.Canvas, FDedicatedStatement.BaseBlock.XStart,
                FDedicatedStatement.BaseBlock.XLast, FDedicatedStatement.YStart,
                FDedicatedStatement.GetYBottom, FHighlightColor);

    if FCarryBlock <> nil then
      FCarryBlock.DrawBlock(VisibleImageRect);

    FMainBlock.DrawBlock(VisibleImageRect);
    //DrawCoordinates(PaintBox.Canvas, 50);
  end;

  procedure TNassiShneiderman.ScrollBoxMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
    var Handled: Boolean);
  const
    ScrotStep = 42 shl 1;
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

    if not tmRedrawingMovements.Enabled then
      tmRedrawingMovements.Enabled := True;

    MousePos:= PaintBox.ScreenToClient(Mouse.CursorPos);
    MouseMove(Sender, Shift, MousePos.X, MousePos.Y);
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

  procedure TNassiShneiderman.MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
    FDedicatedStatement := BinarySearchStatement(X, Y, FMainBlock);

    PaintBox.Invalidate;

    if FDedicatedStatement <> nil then
    begin
      if (Button = mbLeft) and (ssAlt in Shift) then
      begin
        if FIsMouseDown then
          FCarryBlock.Destroy;

        FCarryBlock:= TBlock.Create(
          FDedicatedStatement.BaseBlock.XStart,
          FDedicatedStatement.BaseBlock.XLast,
          nil,
          FDedicatedStatement.BaseBlock.Canvas
        );

        FCarryBlock.AddFirstStatement(FDedicatedStatement.Clone);

        FIsMouseDown := True;
        FPrevMousePos.X := X;
        FPrevMousePos.Y := Y;
      end
      else if Button = mbRight then
        PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    end;

  end;

  procedure TNassiShneiderman.tmRedrawingTimer(Sender: TObject);
  begin
    tmRedrawingMovements.Enabled:= False;

    PaintBox.Invalidate;
  end;

  procedure TNassiShneiderman.MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
  begin
    if FIsMouseDown and (ssLeft in Shift) then
    begin
      if not tmRedrawingMovements.Enabled then
        tmRedrawingMovements.Enabled := True;

      FCarryBlock.MoveRight(X - FPrevMousePos.X);
      FCarryBlock.MoveDown(Y - FPrevMousePos.Y);

      FPrevMousePos := Point(X, Y);
    end;
  end;

  procedure TNassiShneiderman.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
    if (Button = mbLeft) and FIsMouseDown then
    begin
      FIsMouseDown := False;

      if FCarryBlock <> nil then
      begin
        FCarryBlock.Destroy;
        FCarryBlock:= nil;
      end;

      PaintBox.Invalidate;
    end;
  end;

  procedure TNassiShneiderman.MICopyClick(Sender: TObject);
  var
    I: Integer;
  begin
    if FDedicatedStatement <> nil then
    begin
      for I := 0 to FBufferBlock.Statements.Count - 1 do
        FBufferBlock.RemoveStatementAt(I);

      FBufferBlock.Assign(FDedicatedStatement.BaseBlock);

      FBufferBlock.AddStatementLast(FDedicatedStatement.Clone);
    end;
  end;

  procedure TNassiShneiderman.MICutClick(Sender: TObject);
  begin
    if FDedicatedStatement <> nil then
    begin
      MICopyClick(Sender);

      DeleteStatement(Sender);
    end;
  end;

  procedure TNassiShneiderman.MIInsetClick(Sender: TObject);
  var
    I: Integer;
  begin
    if (FBufferBlock.Statements.Count <> 0) and (FDedicatedStatement <> nil) then
    begin
      FDedicatedStatement.BaseBlock.AddBlockAfter(FDedicatedStatement, FBufferBlock);

      FBufferBlock.Assign(FDedicatedStatement.BaseBlock);
      FDedicatedStatement:= FBufferBlock.Statements.GetLast;
      for I := 0 to FBufferBlock.Statements.Count - 1 do
        FBufferBlock.Statements[I]:= FBufferBlock.Statements[I].Clone;

      PaintBox.Invalidate;
    end;
  end;

  procedure TNassiShneiderman.AddBefore(Sender: TObject);
  var
    NewStatement: TStatement;
  begin

    if FDedicatedStatement <> nil then
    begin
      NewStatement:= CreateStatement(ConvertToBlockType(TComponent(Sender).Tag),
                                     FDedicatedStatement.BaseBlock, Self);

      if NewStatement <> nil then
      begin
        FDedicatedStatement.BaseBlock.AddStatementBefore(FDedicatedStatement, NewStatement);
        FDedicatedStatement:= NewStatement;
      end;

      PaintBox.Invalidate;
    end;
  end;

  procedure TNassiShneiderman.Sort(Sender: TObject);
  begin
    TCaseBranching(FDedicatedStatement).SortConditions(TComponent(Sender).Tag);
    PaintBox.Invalidate;
  end;

  procedure TNassiShneiderman.AddAfter(Sender: TObject);
  var
    NewStatement: TStatement;
  begin

    if FDedicatedStatement <> nil then
    begin
      NewStatement:= CreateStatement(ConvertToBlockType(TComponent(Sender).Tag),
                                     FDedicatedStatement.BaseBlock, Self);

      if NewStatement <> nil then
      begin
        FDedicatedStatement.BaseBlock.AddStatementAfter(FDedicatedStatement, NewStatement);
        FDedicatedStatement:= NewStatement;
      end;

      PaintBox.Invalidate;
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

      Block.Install(Index);

      FDedicatedStatement:= Block.Statements[Index];

      PaintBox.Invalidate;
    end;
  end;

  procedure TNassiShneiderman.DblClick(Sender: TObject);
  var
    MousePos: TPoint;
    Statement: TStatement;
  begin
    MousePos := PaintBox.ScreenToClient(Mouse.CursorPos);

    Statement := BinarySearchStatement(MousePos.X, MousePos.Y, FMainBlock);

    if Statement <> nil then
      TryChangeContent(Statement, Self);

    PaintBox.Invalidate;
  end;

  procedure TNassiShneiderman.actChangeActionExecute(Sender: TObject);
  begin
    if FDedicatedStatement <> nil then
    begin
      TryChangeContent(FDedicatedStatement, Self);
      PaintBox.Invalidate;
    end;
  end;

end.
