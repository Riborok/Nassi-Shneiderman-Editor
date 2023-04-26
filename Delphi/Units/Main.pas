﻿unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ProcessStatement, BlockController,
  Base, FirstLoop, IfBranching, CaseBranching, LastLoop, StatementSearch, DrawShapes,
  Vcl.StdCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ToolWin, SwitchStatements,
  Vcl.ComCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, AdditionalTypes,
  AdjustBorders, Types;

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
    tmRedrawingMovements: TTimer;
    actChangeAction: TAction;
    actChangeAction1: TMenuItem;

    procedure FormCreate(Sender: TObject);

    procedure Redraw(const AVisibleImageRect: TVisibleImageRect);

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
    procedure tmRedrawingTimer(Sender: TObject);
    procedure actChangeActionExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FMainBlock : TBlock;
    FDedicatedStatement: TStatement;

    FPrevMousePos: TPoint;
    FIsMouseDown: Boolean;
    FCarryBlock: TBlock;

    FHighlightColor: TColor;

    procedure MyScroll(Sender: TObject);
    function GetVisibleImageScreen: TVisibleImageRect;

  private const
    SchemeInitialIndent = 10;
    SchemeInitialFontSize = 14;
    SchemeInitialFont = 'Times New Roman';
  end;

var
  NassiShneiderman: TNassiShneiderman;

  BufferBlock: TBlock;

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
      Redraw(GetVisibleImageScreen);
  end;

  function TNassiShneiderman.GetVisibleImageScreen: TVisibleImageRect;
  const
    Stock = 420;
  begin
    Result.FTopLeft := Image.ScreenToClient(ScrollBox.ClientToScreen(Point(-Stock, -Stock)));
    Result.FBottomRight := Image.ScreenToClient(
          ScrollBox.ClientToScreen(Point(ScrollBox.Width + Stock, ScrollBox.Height + Stock)));
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
    actChangeAction.ShortCut := ShortCut(VK_RETURN, []);

    ScrollBox.OnScrollVert := MyScroll;
    ScrollBox.OnScrollHorz := MyScroll;

    FDedicatedStatement:= nil;
    FCarryBlock:= nil;

    Constraints.MinWidth := 960;
    Constraints.MinHeight := 540;

    Base.DefaultBlock:= TProcessStatement;

    Self.DoubleBuffered := True;

    Image.Canvas.Font.Size := SchemeInitialFontSize;

    Image.Canvas.Font.Name := SchemeInitialFont;

    FHighlightColor:= clYellow;

    FMainBlock:= TBlock.Create(SchemeInitialIndent, 0, nil, Image.Canvas);

    NewStatement:= TProcessStatement.CreateUncertainty(FMainBlock);
    FMainBlock.AddFirstStatement(NewStatement, SchemeInitialIndent);
    NewStatement.Install;

    Redraw(GetVisibleImageScreen);
  end;

  procedure TNassiShneiderman.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    case Key of
      VK_LEFT:
      begin
        SetHorizontalMovement(FDedicatedStatement, FMainBlock, SwitchStatements.BackwardDir);
        Redraw(GetVisibleImageScreen);
      end;
      VK_RIGHT:
      begin
        SetHorizontalMovement(FDedicatedStatement, FMainBlock, SwitchStatements.ForwardDir);
        Redraw(GetVisibleImageScreen);
      end;
      VK_UP:
      begin
        SetVerticalMovement(FDedicatedStatement, FMainBlock, SwitchStatements.BackwardDir);
        Redraw(GetVisibleImageScreen);
      end;
      VK_DOWN:
      begin
        SetVerticalMovement(FDedicatedStatement, FMainBlock, SwitchStatements.ForwardDir);
        Redraw(GetVisibleImageScreen);
      end;
    end;
  end;

  procedure TNassiShneiderman.Redraw(const AVisibleImageRect: TVisibleImageRect);
  begin
    Clear(Image.Canvas, AVisibleImageRect);

    DefineBorders(FMainBlock.XLast, FMainBlock.Statements.GetLast.GetYBottom, Image);

    if FDedicatedStatement <> nil then
      ColorizeRectangle(Image.Canvas, FDedicatedStatement.BaseBlock.XStart,
                FDedicatedStatement.BaseBlock.XLast, FDedicatedStatement.YStart,
                FDedicatedStatement.GetYBottom, FHighlightColor);

    if FCarryBlock <> nil then
      FCarryBlock.DrawBlock(AVisibleImageRect);

    FMainBlock.DrawBlock(AVisibleImageRect);
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
    if not tmRedrawingMovements.Enabled then
      tmRedrawingMovements.Enabled := True;

    MousePos:= Image.ScreenToClient(Mouse.CursorPos);
    ImageMouseMove(Sender, Shift, MousePos.X, MousePos.Y);
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

    Redraw(GetVisibleImageScreen);

    if FDedicatedStatement <> nil then
    begin
      if (Button = mbLeft) and (ssAlt in Shift) then
      begin
        FCarryBlock:= TBlock.Create(
          FDedicatedStatement.BaseBlock.XStart,
          FDedicatedStatement.BaseBlock.XLast,
          nil,
          Image.Canvas
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

    Redraw(GetVisibleImageScreen);
  end;

  procedure TNassiShneiderman.ImageMouseMove(Sender: TObject; Shift: TShiftState;
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

  procedure TNassiShneiderman.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
    if (Button = mbLeft) and FIsMouseDown then
    begin
      FIsMouseDown := False;
      tmRedrawingMovements.Enabled := False;

      if FCarryBlock <> nil then
      begin
        FCarryBlock.Destroy;
        FCarryBlock:= nil;
      end;

      Redraw(GetVisibleImageScreen);
    end;
  end;

  procedure TNassiShneiderman.MICopyClick(Sender: TObject);
  var
    I: Integer;
  begin
    if FDedicatedStatement <> nil then
    begin
      for I := 0 to BufferBlock.Statements.Count - 1 do
        BufferBlock.RemoveStatementAt(I);

      BufferBlock.Assign(FDedicatedStatement.BaseBlock);

      BufferBlock.AddFirstStatement(FDedicatedStatement.Clone);
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
    if (BufferBlock.Statements.Count <> 0) and (FDedicatedStatement <> nil) then
    begin
      FDedicatedStatement.BaseBlock.AddBlockAfter(FDedicatedStatement, BufferBlock);

      for I := 0 to BufferBlock.Statements.Count - 1 do
        BufferBlock.Statements[I].Install;

      BufferBlock.Assign(FDedicatedStatement.BaseBlock);
      FDedicatedStatement:= BufferBlock.Statements.GetLast;
      for I := 0 to BufferBlock.Statements.Count - 1 do
        BufferBlock.Statements[I]:= BufferBlock.Statements[I].Clone;

      Redraw(GetVisibleImageScreen);
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
        NewStatement.Install;
        FDedicatedStatement:= NewStatement;
      end;

      Redraw(GetVisibleImageScreen);
    end;
  end;

  procedure TNassiShneiderman.Sort(Sender: TObject);
  begin
    TCaseBranching(FDedicatedStatement).SortConditions(TComponent(Sender).Tag);
    Redraw(GetVisibleImageScreen);
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
        NewStatement.Install;
        FDedicatedStatement:= NewStatement;
      end;

      Redraw(GetVisibleImageScreen);
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

      Redraw(GetVisibleImageScreen);
    end;
  end;

  procedure TNassiShneiderman.ImageDblClick(Sender: TObject);
  var
    MousePos: TPoint;
    Statement: TStatement;
  begin
    MousePos := Image.ScreenToClient(Mouse.CursorPos);

    Statement := BinarySearchStatement(MousePos.X, MousePos.Y, FMainBlock);

    if Statement <> nil then
      TryChangeContent(Statement, Self);

    Redraw(GetVisibleImageScreen);
  end;

  procedure TNassiShneiderman.actChangeActionExecute(Sender: TObject);
  begin
    if FDedicatedStatement <> nil then
    begin
      TryChangeContent(FDedicatedStatement, Self);
      Redraw(GetVisibleImageScreen);
    end;
  end;

  initialization
  BufferBlock:= TBlock.Create(0, 0, nil, nil);

end.
