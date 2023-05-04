unit uBlockManager;

interface
uses
  uBase, uCommands, uAutoClearStack, Vcl.ExtCtrls, uSwitchStatements,
  Winapi.Windows, uAdditionalTypes, uDrawShapes, Vcl.Graphics, frmGetAction,
  frmGet�ase�onditions, uCaseBranching;
type

  TBlockManager = class
  public type
    TSetScrollPosProc = procedure(const AStatement: TStatement) of object;
  private const
    SchemeInitialIndent = 10;
  private
    FMainBlock : TBlock;
    FDedicatedStatement: TStatement;
    FCarryBlock: TBlock;
    FBufferBlock: TBlock;
    FUndoStack, FRedoStack: TAutoClearStack<ICommand>;
    FPaintBox: TPaintBox;
    FHighlightColor: TColor;

    { DedicatedStatement }
    procedure ChangeDedicated(const AStatement: TStatement);
  public
    constructor Create(const APaintBox: TPaintBox; const AHighlightColor: TColor);
    destructor Destroy;
    property MainBlock: TBlock read FMainBlock;
    property CarryBlock: TBlock read FCarryBlock;
    property BufferBlock: TBlock read FBufferBlock;
    property UndoStack: TAutoClearStack<ICommand> read FUndoStack;
    property RedoStack: TAutoClearStack<ICommand> read FRedoStack;
    property HighlightColor: TColor write FHighlightColor;
    property DedicatedStatement: TStatement read FDedicatedStatement write ChangeDedicated;

    { BufferBlock }
    procedure TryCutDedicated;
    procedure TryCopyDedicated;
    procedure TryDeleteDedicated;

    procedure TryInsertBufferBlock;

    { DedicatedStatement }
    procedure TryMoveDedicated(const ASetScrollPosProc: TSetScrollPosProc; const AKey: Integer);
    procedure TryChangeDedicatedText;

    procedure TryAddNewStatement(const AStatementClass: TStatementClass;
                                 const isAfterDedicated: Boolean);

    procedure SortDedicatedCase(const ASortNumber: Integer);

    { CarryBlock }
    procedure CreateCarryBlock;
    procedure MoveCarryBlock(const ADeltaX, ADeltaY: Integer);
    procedure DestroyCarryBlock;

    { Interactions with statements }
    class function CreateStatement(const AStatementClass: TStatementClass;
           const ABaseBlock: TBlock): TStatement;

    { Stacks }
    procedure UndoExecute;
    procedure RedoExecute;

    { View update }
    procedure Draw(const AVisibleImageRect: TVisibleImageRect);
  end;

implementation

  destructor TBlockManager.Destroy;
  begin
    FMainBlock.Destroy;
    FBufferBlock.Destroy;

    FUndoStack.Destroy;
    FRedoStack.Destroy;

    inherited;
  end;

  constructor TBlockManager.Create(const APaintBox: TPaintBox; const AHighlightColor: TColor);
  begin
    FPaintBox:= APaintBox;
    FHighlightColor:= AHighlightColor;

    FUndoStack := TAutoClearStack<ICommand>.Create;
    FRedoStack := TAutoClearStack<ICommand>.Create;

    FDedicatedStatement:= nil;
    FCarryBlock:= nil;

    FBufferBlock:= TBlock.Create(0, FPaintBox.Canvas);
    FBufferBlock.AddStatement(uBase.DefaultStatement.CreateUncertainty(FBufferBlock));

    FMainBlock:= TBlock.Create(SchemeInitialIndent, FPaintBox.Canvas);
    FMainBlock.AddUnknownStatement(uBase.DefaultStatement.CreateUncertainty(FMainBlock),
                                                            SchemeInitialIndent);
  end;

  { BufferBlock }
  procedure TBlockManager.TryCutDedicated;
  begin
    TryCopyDedicated;
    TryDeleteDedicated;
  end;

  procedure TBlockManager.TryCopyDedicated;
  begin
    if FDedicatedStatement <> nil then
    begin
      FBufferBlock.Destroy;

      FBufferBlock := TBlock.Create(nil);
      FBufferBlock.Assign(FDedicatedStatement.BaseBlock);

      FBufferBlock.AddStatement(FDedicatedStatement.Clone);
    end;
  end;

  procedure TBlockManager.TryDeleteDedicated;
  begin
    if (FDedicatedStatement <> nil) and not isDefaultStatement(FDedicatedStatement) then
    begin
      FRedoStack.Clear;
      FUndoStack.Push(TCommandDelStatement.Create(FDedicatedStatement));
      FUndoStack.Peek.Execute;

      FDedicatedStatement:= nil;
      FPaintBox.Invalidate;
    end;
  end;

  procedure TBlockManager.TryInsertBufferBlock;
  var
    BaseBlock: TBlock;
    I: Integer;
  begin
    if (FBufferBlock.Statements.Count <> 0) and (FDedicatedStatement <> nil) then
    begin
      for I := FBufferBlock.Statements.Count - 1 downto 0 do
        if isDefaultStatement(FBufferBlock.Statements[I]) then
        begin
          FBufferBlock.ExtractStatementAt(I);
          FBufferBlock.Install(I);
        end;

      if (FBufferBlock.Statements.Count <> 1) or not isDefaultStatement(FBufferBlock.Statements[0]) then
      begin
        BaseBlock:= FDedicatedStatement.BaseBlock;

        FRedoStack.Clear;
        FUndoStack.Push(TCommandAddBlock.Create(BaseBlock,
                        BaseBlock.FindStatementIndex(FDedicatedStatement.YStart) + 1,
                        FBufferBlock));
        FUndoStack.Peek.Execute;

        FDedicatedStatement:= FBufferBlock.Statements.GetLast;

        FBufferBlock := TBlock.Create(nil);
        FBufferBlock.Assign(FDedicatedStatement.BaseBlock);
        FBufferBlock.AddStatement(FDedicatedStatement.Clone);

        FPaintBox.Invalidate;
      end;
    end;
  end;

  { DedicatedStatement }
  procedure TBlockManager.TryMoveDedicated(const ASetScrollPosProc: TSetScrollPosProc; const AKey: Integer);
  begin
    case AKey of
      VK_LEFT:
      begin
        SetHorizontalMovement(FDedicatedStatement, FMainBlock, uSwitchStatements.BackwardDir);
        ASetScrollPosProc(FDedicatedStatement);
        FPaintBox.Invalidate;
      end;
      VK_RIGHT:
      begin
        SetHorizontalMovement(FDedicatedStatement, FMainBlock, uSwitchStatements.ForwardDir);
        ASetScrollPosProc(FDedicatedStatement);
        FPaintBox.Invalidate;
      end;
      VK_UP:
      begin
        SetVerticalMovement(FDedicatedStatement, FMainBlock, uSwitchStatements.BackwardDir);
        ASetScrollPosProc(FDedicatedStatement);
        FPaintBox.Invalidate;
      end;
      VK_DOWN:
      begin
        SetVerticalMovement(FDedicatedStatement, FMainBlock, uSwitchStatements.ForwardDir);
        ASetScrollPosProc(FDedicatedStatement);
        FPaintBox.Invalidate;
      end;
    end;
  end;

  procedure TBlockManager.TryAddNewStatement(const AStatementClass: TStatementClass;
                                             const isAfterDedicated: Boolean);
  var
    NewStatement: TStatement;
    Block: TBlock;
  begin
    if FDedicatedStatement <> nil then
    begin
      NewStatement:= CreateStatement(AStatementClass,
                                     FDedicatedStatement.BaseBlock);

      if (NewStatement <> nil) and not isDefaultStatement(NewStatement) then
      begin
        FRedoStack.Clear;
        Block:= FDedicatedStatement.BaseBlock;
        FUndoStack.Push(TCommandAddStatement.Create(Block,
                        Block.FindStatementIndex(FDedicatedStatement.YStart) +
                        Ord(isAfterDedicated),
                        NewStatement));
        FUndoStack.Peek.Execute;

        FDedicatedStatement:= NewStatement;
      end;

      FPaintBox.Invalidate;
    end;
  end;

  procedure TBlockManager.TryChangeDedicatedText;
  var
    Action: String;
  begin
    if FDedicatedStatement <> nil then
    begin
      Action := FDedicatedStatement.Action;
      if FDedicatedStatement is TCaseBranching then
      begin
        var CaseBranching: TCaseBranching:= TCaseBranching(FDedicatedStatement);
        var Cond: TStringArr:= CaseBranching.Conds;
        if (WriteAction.TryGetAction(Action)) and (Write�ase�onditions.TryGetCond(Cond)) then
        begin
          FRedoStack.Clear;
          FUndoStack.Push(TCommnadChangeContent.Create(FDedicatedStatement, Action, Cond));
          FUndoStack.Peek.Execute;
          FPaintBox.Invalidate;
        end;
      end
      else if WriteAction.TryGetAction(Action) then
      begin
        FRedoStack.Clear;
        FUndoStack.Push(TCommnadChangeContent.Create(FDedicatedStatement, Action, nil));
        FUndoStack.Peek.Execute;
        FPaintBox.Invalidate;
      end;
    end;
  end;

  procedure TBlockManager.SortDedicatedCase(const ASortNumber: Integer);
  begin
    FRedoStack.Clear;

    FUndoStack.Push(TCommandCaseSort.Create(TCaseBranching(FDedicatedStatement),
                    ASortNumber));
    FUndoStack.Peek.Execute;

    FPaintBox.Invalidate;
  end;

  procedure TBlockManager.ChangeDedicated(const AStatement: TStatement);
  begin
    FDedicatedStatement:= AStatement;
    FPaintBox.Invalidate;
  end;

  { CarryBlock }
  procedure TBlockManager.CreateCarryBlock;
  begin
    FCarryBlock:= TBlock.Create(nil);
    FCarryBlock.Assign(FDedicatedStatement.BaseBlock);

    FCarryBlock.AddStatement(FDedicatedStatement.Clone);
  end;

  procedure TBlockManager.MoveCarryBlock(const ADeltaX, ADeltaY: Integer);
  begin
    FCarryBlock.MoveRight(ADeltaX);
    FCarryBlock.MoveDown(ADeltaY);
  end;

  procedure TBlockManager.DestroyCarryBlock;
  begin
    FCarryBlock.Destroy;
    FCarryBlock:= nil;

    FPaintBox.Invalidate;
  end;

  { Interactions with statements }
  class function TBlockManager.CreateStatement(const AStatementClass: TStatementClass;
                          const ABaseBlock: TBlock): TStatement;
  var
    Action: String;
  begin
    Result:= nil;
    Action := '';
    if WriteAction.TryGetAction(Action) then
    begin

      if AStatementClass = TCaseBranching then
      begin
        var Cond: TStringArr:= nil;
        if Write�ase�onditions.TryGetCond(Cond) then
          Result:= TCaseBranching.Create(Action, Cond);
      end
      else
        Result:= AStatementClass.Create(Action);
    end;
  end;

  { Stacks }
  procedure TBlockManager.UndoExecute;
  var
    Commamd: ICommand;
  begin
    if FUndoStack.Count <> 0 then
    begin
      Commamd:= FUndoStack.Pop;
      Commamd.Undo;
      FRedoStack.Push(Commamd);

      FDedicatedStatement := nil;

      FPaintBox.Invalidate;
    end;
  end;

  procedure TBlockManager.RedoExecute;
  var
    Commamd: ICommand;
  begin
    if FUndoStack.Count <> 0 then
    begin
      Commamd:= FUndoStack.Pop;
      Commamd.Undo;
      FRedoStack.Push(Commamd);

      FDedicatedStatement := nil;

      FPaintBox.Invalidate;
    end;
  end;

  { View update }
  procedure TBlockManager.Draw(const AVisibleImageRect: TVisibleImageRect);
  const
    Stock = 420;
  begin
    AVisibleImageRect.Expand(Stock);
    FPaintBox.Width := FMainBlock.XLast + Stock;
    FPaintBox.Height := FMainBlock.Statements.GetLast.GetYBottom + Stock;

    if FDedicatedStatement <> nil then
      ColorizeRect(FPaintBox.Canvas, FDedicatedStatement.BaseBlock.XStart,
                   FDedicatedStatement.BaseBlock.XLast,
                   FDedicatedStatement.YStart,
                   FDedicatedStatement.GetYBottom,
                   FHighlightColor);

    if FCarryBlock <> nil then
      FCarryBlock.DrawBlock(AVisibleImageRect);

    FMainBlock.DrawBlock(AVisibleImageRect);
    //DrawCoordinates(FPaintBox.Canvas, 50);
  end;
end.
