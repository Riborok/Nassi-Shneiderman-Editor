unit uBlockManager;

interface
uses
  uBase, uCommands, uAutoClearStack, Vcl.ExtCtrls, uSwitchStatements,
  Winapi.Windows, uAdditionalTypes, uDrawShapes, Vcl.Graphics, frmGetAction,
  frmGetCaseConditions, uCaseBranching, uMinMaxInt, uStatementSearch, Types,
  uIfBranching, uConstants;
type

  TBlockManager = class
  private type
    TSetScrollPosProc = procedure(const AStatement: TStatement) of object;

    THoveredStatement = record
    private type
      TState = (stBefore = 0, stAfter = 1, stSwap, stCancel);
    public
      Statement: TStatement;
      Rect: TRect;
      State: TState;
    end;
  private const
    SchemeInitialFontSize = 13;
    SchemeInitialFont = 'Courier new';
    SchemeInitialFontColor: TColor = clBlack;
    SchemeInitialFontStyles: TFontStyles = [];

    SchemeInitialPenColor: TColor = clBlack;
    SchemeInitialPenWidth = 1;
    SchemeInitialPenStyle: TPenStyle = psSolid;
    SchemeInitialPenMode: TPenMode = pmCopy;
  private class var
    FBufferBlock: TBlock;
    FCarryBlock: TBlock;
    FHoveredStatement: THoveredStatement;

    FHighlightColor, FArrowColor, FOKColor, FCancelColor: TColor;
  private
    FSchemeName : string;
    FMainBlock : TBlock;
    FDedicatedStatement: TStatement;
    FPaintBox: TPaintBox;

    FUndoStack, FRedoStack: TAutoClearStack<ICommand>;

    FZoomFactor : Real;
    FPenWidthWithoutZoom, FFontHeightWithoutZoom : Integer;
    FPen: TPen;
    FFont: TFont;

    FPathToFile: string;
    FisSaved: Boolean;

    procedure AddToUndoStack(ACommand: ICommand);

    procedure ChangeDedicated(const AStatement: TStatement);
    procedure ChangeMainBlock(const ANewBlock: TBlock);

    procedure SetPathToFile(const APath: string);
  public
    constructor Create(const APaintBox: TPaintBox; const ASchemeName: string);
    destructor Destroy; override;
    property SchemeName: string read FSchemeName write FSchemeName;
    property MainBlock: TBlock read FMainBlock write ChangeMainBlock;

    property DedicatedStatement: TStatement read FDedicatedStatement write ChangeDedicated;
    property UndoStack: TAutoClearStack<ICommand> read FUndoStack;
    property RedoStack: TAutoClearStack<ICommand> read FRedoStack;

    procedure RecoverAfterZoom;

    property ZoomFactor: Real read FZoomFactor write FZoomFactor;
    property PenWidthWithoutZoom: Integer read FPenWidthWithoutZoom write FPenWidthWithoutZoom;
    procedure SetPenWidth; inline;
    property FontHeightWithoutZoom: Integer read FFontHeightWithoutZoom write FFontHeightWithoutZoom;
    procedure SetFontHeight; inline;
    property Font: TFont read FFont;
    property Pen: TPen read FPen;
    property PaintBox: TPaintBox read FPaintBox;

    property PathToFile: string read FPathToFile write SetPathToFile;
    property isSaved: Boolean read FisSaved write FisSaved;

    class property CarryBlock: TBlock read FCarryBlock;
    class property BufferBlock: TBlock read FBufferBlock write FBufferBlock;

    class property HighlightColor: TColor read FHighlightColor write FHighlightColor;
    class property ArrowColor: TColor read FArrowColor write FArrowColor;
    class property OKColor: TColor read FOKColor write FOKColor;
    class property CancelColor: TColor read FCancelColor write FCancelColor;

    { MainBlock }
    procedure RedefineMainBlock;
    procedure ChangeGlobalSettings(const AOldDefaultAction: string);
    function isDefaultMainBlock: Boolean;

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

    procedure TrySortDedicatedCase(const ASortNumber: Integer);

    { CarryBlock }
    procedure CreateCarryBlock;
    procedure MoveCarryBlock(const ADeltaX, ADeltaY: Integer);
    procedure DefineHover(const AX, AY: Integer);
    procedure TryDrawCarryBlock(const AVisibleImageRect: TVisibleImageRect); inline;
    procedure TryTakeAction;
    procedure DestroyCarryBlock;

    { Interactions with statements }
    class function CreateStatement(const AStatementClass: TStatementClass;
           const ABaseBlock: TBlock): TStatement; static;

    { Stacks }
    procedure TryUndo;
    procedure TryRedo;

    { View update }
    procedure Draw(const AVisibleImageRect: TVisibleImageRect);
    procedure Activate; inline;
  end;

implementation

  procedure TBlockManager.RecoverAfterZoom;
  begin
    SetFontHeight;
    SetPenWidth;
    FMainBlock.SetStartIndent(Round(SchemeIndent * FZoomFactor));
  end;

  procedure TBlockManager.SetFontHeight;
  begin
    FFont.Height := Round(FFontHeightWithoutZoom * FZoomFactor);
    if FFont.Height = 0 then
      FFont.Height := 1;
  end;

  procedure TBlockManager.SetPenWidth;
  begin
    FPen.Width := Round(FPenWidthWithoutZoom * FZoomFactor);
    if FPen.Width = 0 then
      FPen.Width := 1;
  end;

  procedure TBlockManager.SetPathToFile(const APath: string);
  begin
    FisSaved:= True;

    FPathToFile:= APath;
  end;

  procedure TBlockManager.AddToUndoStack(ACommand: ICommand);
  begin
    FisSaved:= False;

    FRedoStack.Clear;
    FUndoStack.Push(ACommand);
    FUndoStack.Peek.Execute;
  end;

  destructor TBlockManager.Destroy;
  begin
    FPen.Destroy;
    FFont.Destroy;

    FUndoStack.Destroy;
    FRedoStack.Destroy;

    FMainBlock.Destroy;

    inherited;
  end;

  constructor TBlockManager.Create(const APaintBox: TPaintBox; const ASchemeName: string);
  begin
    FSchemeName := ASchemeName;
    FZoomFactor := 1;

    FPaintBox:= APaintBox;
    FPen := TPen.Create;
    FFont := TFont.Create;

    FFont.Size := SchemeInitialFontSize;
    FFont.Name := SchemeInitialFont;
    FFont.Color := SchemeInitialFontColor;
    FFont.Style := SchemeInitialFontStyles;

    FPen.Color := SchemeInitialPenColor;
    FPen.Width := SchemeInitialPenWidth;
    FPen.Style := SchemeInitialPenStyle;
    FPen.Mode := SchemeInitialPenMode;

    FPenWidthWithoutZoom := FPen.Width;
    FFontHeightWithoutZoom := FFont.Height;

    FPaintBox.Canvas.Font := FFont;
    FPaintBox.Canvas.Pen := FPen;

    FUndoStack := TAutoClearStack<ICommand>.Create;
    FRedoStack := TAutoClearStack<ICommand>.Create;

    FDedicatedStatement:= nil;
    FCarryBlock:= nil;
    FMainBlock:= nil;
    PathToFile:= '';
    FisSaved:= False;

    FMainBlock:= TBlock.Create(SchemeIndent, FPaintBox.Canvas);
    FMainBlock.AddUnknownStatement(uBase.DefaultStatement.Create(DefaultAction, FMainBlock),
                                                            SchemeIndent);

    Activate;
  end;

  { MainBlock }
  procedure TBlockManager.RedefineMainBlock;
  begin
    FPaintBox.Canvas.Font:= FFont;
    FPaintBox.Canvas.Pen:= FPen;
    MainBlock.RedefineSizes;
    FPaintBox.Invalidate;
  end;

  procedure TBlockManager.ChangeGlobalSettings(const AOldDefaultAction: string);
  begin
    if AOldDefaultAction <> DefaultAction then
    begin
      if (FDedicatedStatement is DefaultStatement) and
         (FDedicatedStatement.Action = DefaultAction) then
        FDedicatedStatement := nil;
      MainBlock.SetNewActionForDefaultStatements(AOldDefaultAction);
    end;
    TIfBranching.RedefineSizesForIfBranching(MainBlock);
    FPaintBox.Invalidate;
  end;

  procedure TBlockManager.ChangeMainBlock(const ANewBlock: TBlock);
  begin
    if FMainBlock <> nil then
      FMainBlock.Destroy;
    FMainBlock:= ANewBlock;
    FDedicatedStatement := nil;
    PaintBox.Invalidate;
  end;

  function TBlockManager.isDefaultMainBlock: Boolean;
  begin
    Result:= (FUndoStack.Count = 0) and (FRedoStack.Count = 0) and isDefaultStatement(FMainBlock.Statements[0]);
  end;

  { BufferBlock }
  procedure TBlockManager.TryCutDedicated;
  begin
    TryCopyDedicated;
    TryDeleteDedicated;
  end;

  procedure TBlockManager.TryCopyDedicated;
  begin
    if (FDedicatedStatement <> nil) and not isDefaultStatement(FDedicatedStatement) then
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
      AddToUndoStack(TCommandDelStatement.Create(FDedicatedStatement));

      FDedicatedStatement:= nil;
      FPaintBox.Invalidate;
    end;
  end;

  procedure TBlockManager.TryInsertBufferBlock;
  var
    Statement: TStatement;
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
        Statement:= FDedicatedStatement;
        FDedicatedStatement:= FBufferBlock.Statements.GetLast;

        AddToUndoStack(TCommandAddBlock.Create(Statement.BaseBlock,
                       Statement.BaseBlock.FindStatementIndex(Statement.YStart) + 1,
                       FBufferBlock));

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
        Block:= FDedicatedStatement.BaseBlock;
        AddToUndoStack(TCommandAddStatement.Create(Block,
                        Block.FindStatementIndex(FDedicatedStatement.YStart) +
                        Ord(isAfterDedicated),
                        NewStatement));

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
        if (WriteAction.TryGetAction(Action)) and (WriteCaseConditions.TryGetCond(Cond)) then
        begin
          AddToUndoStack(TCommnadChangeContent.Create(FDedicatedStatement, Action, Cond));
          FPaintBox.Invalidate;
        end;
      end
      else if WriteAction.TryGetAction(Action) then
      begin
        AddToUndoStack(TCommnadChangeContent.Create(FDedicatedStatement, Action, nil));
        FPaintBox.Invalidate;
      end;
    end;
  end;

  procedure TBlockManager.TrySortDedicatedCase(const ASortNumber: Integer);
  begin
    if FDedicatedStatement is TCaseBranching then
    begin
      AddToUndoStack(TCommandCaseSort.Create(TCaseBranching(FDedicatedStatement),
                     ASortNumber));

      FPaintBox.Invalidate;
    end;
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

    FPaintBox.Invalidate;
  end;

  procedure TBlockManager.DefineHover(const AX, AY: Integer);
  const
    Indent = 5;
  begin
    FHoveredStatement.Statement:= nil;
    FHoveredStatement.State := stCancel;

    if FDedicatedStatement is TOperator then
    begin
      var Block: TBlock:= BinarySearchBlock(TOperator(FDedicatedStatement).Blocks, AX);
      if Block <> nil then
        FHoveredStatement.Statement:= BinarySearchStatement(AX, AY, Block);
    end;

    if FHoveredStatement.Statement = nil then
    begin
      FHoveredStatement.Statement:= BinarySearchStatement(AX, AY, FMainBlock);
      if FHoveredStatement.Statement = nil then
        Exit;

      FHoveredStatement.Rect:= CreateRect(FHoveredStatement.Statement);

      if FHoveredStatement.Statement <> FDedicatedStatement then
      begin

        var YStart: Integer := FHoveredStatement.Statement.YStart;
        var YLast: Integer := FHoveredStatement.Statement.YLast;

        if (FHoveredStatement.Statement is TOperator) and
           not TOperator(FHoveredStatement.Statement).IsPreņOperator then
        begin
          YStart:= TOperator(FHoveredStatement.Statement).Blocks[0].Statements.GetLast.GetYBottom;
          YLast := FHoveredStatement.Statement.GetYBottom;
        end;

        if AY >= YLast - FHoveredStatement.Statement.YIndentText then
        begin
          FHoveredStatement.Rect.Top:= YLast - FHoveredStatement.Statement.YIndentText;
          FHoveredStatement.Rect.Bottom:= YLast;
          FHoveredStatement.State := stAfter;
        end
        else if AY <= YStart + FHoveredStatement.Statement.YIndentText then
        begin
          FHoveredStatement.Rect.Top:= YStart;
          FHoveredStatement.Rect.Bottom:= YStart + FHoveredStatement.Statement.YIndentText;
          FHoveredStatement.State := stBefore;
        end
        else if FHoveredStatement.Statement is TOperator then
        begin
          var BaseOperator: TOperator:= TOperator(FHoveredStatement.Statement);
          var CurrBlock: TBlock := FDedicatedStatement.BaseBlock;
          while CurrBlock.BaseOperator <> nil do
          begin
            if CurrBlock.BaseOperator = BaseOperator then
              Exit;
            CurrBlock := CurrBlock.BaseOperator.BaseBlock;
          end;
          FHoveredStatement.State := stSwap;
        end
        else if not isDefaultStatement(FHoveredStatement.Statement) then
          FHoveredStatement.State := stSwap;
      end;
    end
    else
      FHoveredStatement.Rect:= CreateRect(FHoveredStatement.Statement);

    if isDefaultStatement(FDedicatedStatement) then
    begin
      FHoveredStatement.State := stCancel;
      if FHoveredStatement.Statement <> nil then
        FHoveredStatement.Rect:= CreateRect(FHoveredStatement.Statement);
    end;
  end;

  procedure TBlockManager.TryDrawCarryBlock(const AVisibleImageRect: TVisibleImageRect);
  const
    Offset = 3;
  begin
    if FCarryBlock <> nil then
    begin
      if FHoveredStatement.Statement <> nil then
        case FHoveredStatement.State of
          stAfter:
          begin
            ColorizeRect(FPaintBox.Canvas, FHoveredStatement.Rect, FOKColor);
            DrawArrow(FPaintBox.Canvas,
                     FHoveredStatement.Rect.Width shr 1 +
                     FHoveredStatement.Rect.Left,
                     FHoveredStatement.Rect.Bottom,
                     FHoveredStatement.Rect.Top + Offset,
                     FArrowColor);
            if (FHoveredStatement.Statement is TOperator) and
                     TOperator(FHoveredStatement.Statement).IsPreņOperator then
            begin
              FHoveredStatement.Rect.Right:= FHoveredStatement.Statement.BaseBlock.XStart +
                                TOperator(FHoveredStatement.Statement).GetOffsetFromXStart;
              FHoveredStatement.Rect.Bottom:= FHoveredStatement.Statement.GetYBottom;
              ColorizeRect(FPaintBox.Canvas, FHoveredStatement.Rect, FOKColor);
            end;
          end;
          stBefore:
          begin
            ColorizeRect(FPaintBox.Canvas, FHoveredStatement.Rect, FOKColor);
            DrawArrow(FPaintBox.Canvas,
                     FHoveredStatement.Rect.Width shr 1 +
                     FHoveredStatement.Rect.Left,
                     FHoveredStatement.Rect.Top,
                     FHoveredStatement.Rect.Bottom - Offset,
                     FArrowColor);
            if (FHoveredStatement.Statement is TOperator) and
                  not TOperator(FHoveredStatement.Statement).IsPreņOperator then
            begin
              FHoveredStatement.Rect.Right:= FHoveredStatement.Statement.BaseBlock.XStart +
                                TOperator(FHoveredStatement.Statement).GetOffsetFromXStart;
              FHoveredStatement.Rect.Top:= FHoveredStatement.Statement.YStart;
              ColorizeRect(FPaintBox.Canvas, FHoveredStatement.Rect, FOKColor);
            end;
          end;
          stSwap:
            ColorizeRect(FPaintBox.Canvas, FHoveredStatement.Rect, FOKColor);
          stCancel:
            ColorizeRect(FPaintBox.Canvas, FHoveredStatement.Rect, FCancelColor);
        end;
      FCarryBlock.DrawBlock(AVisibleImageRect);
    end;
  end;

  procedure TBlockManager.TryTakeAction;
  begin
    if FHoveredStatement.Statement <> nil then
      case FHoveredStatement.State of
        stBefore, stAfter:
          AddToUndoStack(TCommandTransferAnotherBlock.Create(
                         FHoveredStatement.Statement,
                         Boolean(Ord(FHoveredStatement.State)),
                         FDedicatedStatement));
        stSwap:
          AddToUndoStack(TCommandSwapStatements.Create(
                         FHoveredStatement.Statement,
                         FDedicatedStatement));
      end;
  end;

  procedure TBlockManager.DestroyCarryBlock;
  begin
    FCarryBlock.Destroy;
    FCarryBlock:= nil;

    FHoveredStatement.State := stCancel;
    FHoveredStatement.Statement := nil;

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
        if WriteCaseConditions.TryGetCond(Cond) then
          Result:= TCaseBranching.Create(Action, Cond);
      end
      else
        Result:= AStatementClass.Create(Action);
    end;
  end;

  { Stacks }
  procedure TBlockManager.TryUndo;
  var
    Commamd: ICommand;
  begin
    if FUndoStack.Count <> 0 then
    begin
      FisSaved:= False;

      Commamd:= FUndoStack.Pop;
      Commamd.Undo;
      FRedoStack.Push(Commamd);

      FDedicatedStatement := nil;

      FPaintBox.Invalidate;
    end;
  end;

  procedure TBlockManager.TryRedo;
  var
    Commamd: ICommand;
  begin
    if FRedoStack.Count <> 0 then
    begin
      FisSaved:= False;

      Commamd:= FRedoStack.Pop;
      Commamd.Execute;
      FUndoStack.Push(Commamd);

      FDedicatedStatement := nil;

      FPaintBox.Invalidate;
    end;
  end;

  { View update }
  procedure TBlockManager.Draw(const AVisibleImageRect: TVisibleImageRect);
  const
    Stock = 42 shl 2;
    Correction = 5;
  var
    StockWithScaling : Integer;
  begin
    FPaintBox.Canvas.Font := FFont;
    FPaintBox.Canvas.Pen := FPen;
    StockWithScaling := Round(Stock * FZoomFactor);

    FPaintBox.Width := Max(FMainBlock.XLast + StockWithScaling,
                       AVisibleImageRect.FBottomRight.X -
                       AVisibleImageRect.FTopLeft.X - Correction);
    FPaintBox.Height := Max(FMainBlock.Statements.GetLast.GetYBottom + StockWithScaling,
                        AVisibleImageRect.FBottomRight.Y -
                        AVisibleImageRect.FTopLeft.Y - Correction);

    AVisibleImageRect.Expand(StockWithScaling);

    if FDedicatedStatement <> nil then
      ColorizeRect(FPaintBox.Canvas,CreateRect(FDedicatedStatement), FHighlightColor);

    TryDrawCarryBlock(AVisibleImageRect);

    FMainBlock.DrawBlock(AVisibleImageRect);
  end;

  procedure TBlockManager.Activate;
  begin
    FPaintBox.Invalidate;
  end;
end.
