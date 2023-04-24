﻿unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ProcessStatement,
  Base, FirstLoop, IfBranching, CaseBranching, LastLoop, StatementSearch, DrawShapes,
  Vcl.StdCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ToolWin, GetСaseСonditions,
  Vcl.ComCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, GetAction, AdditionalTypes,
  AdjustBorders;

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

    procedure FormCreate(Sender: TObject);

    procedure ClearAndRedraw(const AVisibleImageRect: TVisibleImageRect);

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
    procedure tmRedrawingMovementsTimer(Sender: TObject);
    { Private declarations }
  private
    FMainBlock : TBlock;
    FDedicatedStatement: TStatement;

    FPrevMousePos: TPoint;
    FIsMouseDown: Boolean;
    FCarryBlock: TBlock;

    FHighlightColor: TColor;

    procedure MyScroll(Sender: TObject);

    function TryGetAction(var AAction: String): Boolean;
    function TryGetCond(var AInitialStr: TStringArr): Boolean;
    function CreateStatement(const AStatementClass: TStatementClass; const ABaseBlock: TBlock): TStatement;
    class function ConvertToBlockType(const AIndex: Integer): TStatementClass;
    function GetVisibleImageScreen: TVisibleImageRect;

  private const
    SchemeInitialIndent = 10;
    SchemeInitialFontSize = 14;
    SchemeInitialFont = 'Times New Roman';
  public
    { Public declarations }
  end;

var
  NassiShneiderman: TNassiShneiderman;

  BufferBlock: TBlock;

implementation

  {$R *.dfm}

  procedure TScrollBox.WMHScroll(var Message: TWMHScroll);
  begin
     inherited;
     if Assigned(FOnScrollHorz) then  FOnScrollHorz(Self);
  end;

  procedure TScrollBox.WMVScroll(var Message: TWMVScroll);
  begin
     inherited;
     if Assigned(FOnScrollVert) then  FOnScrollVert(Self);
  end;

  procedure TNassiShneiderman.MyScroll(Sender: TObject);
  begin
    ClearAndRedraw(GetVisibleImageScreen);
  end;

  function TNassiShneiderman.GetVisibleImageScreen: TVisibleImageRect;
  var
    ImageRect: TRect;
  begin
    Result.FTopLeft := Image.ScreenToClient(ScrollBox.ClientToScreen(Point(0, 0)));
    Result.FBottomRight := Image.ScreenToClient(ScrollBox.ClientToScreen(Point(ScrollBox.Width, ScrollBox.Height)));
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

    ScrollBox.OnScrollVert := MyScroll;
    ScrollBox.OnScrollHorz := MyScroll;

    FDedicatedStatement:= nil;
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

    ClearAndRedraw(GetVisibleImageScreen);
  end;

  procedure TNassiShneiderman.ClearAndRedraw(const AVisibleImageRect: TVisibleImageRect);
  var
    TopLeft, BottomRight: TPoint;
  begin
    Clear(Image.Canvas, AVisibleImageRect);

    DefineBorders(FMainBlock.XLast, FMainBlock.Statements.GetLast.GetYBottom, Image);

    if FDedicatedStatement <> nil then
      ColorizeRectangle(Image.Canvas, FDedicatedStatement.BaseBlock.XStart, FDedicatedStatement.BaseBlock.XLast,
                      FDedicatedStatement.YStart, FDedicatedStatement.GetYBottom, FHighlightColor);

    FMainBlock.DrawBlock(AVisibleImageRect);
    DrawCoordinates(Image.Canvas, 50);
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
    ClearAndRedraw(GetVisibleImageScreen);
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

    ClearAndRedraw(GetVisibleImageScreen);

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

  procedure TNassiShneiderman.tmRedrawingMovementsTimer(Sender: TObject);
  var
    VisibleImageRect: TVisibleImageRect;
  begin
    tmRedrawingMovements.Enabled:= False;

    VisibleImageRect := GetVisibleImageScreen;

    ClearAndRedraw(VisibleImageRect);
    FCarryBlock.DrawBlock(VisibleImageRect);
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
      ClearAndRedraw(GetVisibleImageScreen);

      FIsMouseDown := False;
      tmRedrawingMovements.Enabled := False;

      if FCarryBlock <> nil then
      begin
        FCarryBlock.Destroy;
        FCarryBlock:= nil;
      end;
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

      ClearAndRedraw(GetVisibleImageScreen);
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

      ClearAndRedraw(GetVisibleImageScreen);
    end;
  end;

  procedure TNassiShneiderman.Sort(Sender: TObject);
  begin
    TCaseBranching(FDedicatedStatement).SortConditions(TComponent(Sender).Tag);
    ClearAndRedraw(GetVisibleImageScreen);
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

      ClearAndRedraw(GetVisibleImageScreen);
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

      ClearAndRedraw(GetVisibleImageScreen);
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

    ClearAndRedraw(GetVisibleImageScreen);
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

  initialization
  BufferBlock:= TBlock.Create(0, 0, nil, nil);

end.
