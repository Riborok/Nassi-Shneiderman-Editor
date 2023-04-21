unit Base;

interface
uses Vcl.graphics, ArrayList, MinMaxInt, DetermineDimensions, Types;
type
  TBlock = class;

  { TBaseStatement }
  // Define abstract class TStatement
  // This class is a base class for all statements and is abstract
  // UncertaintySymbol is a constant field used to represent an unknown value
  // in the statement
  TStatement = class abstract
  public const
    UncertaintySymbol = '';
  protected

    // FYStart and FYLast are used to store the Y position of the statement
    FYStart, FYLast: Integer;

    // FAction stores the text of the statement
    FAction: String;
    FActionSize: TSize;


    FYIndentText, FXMinIndentText: Integer;

    // FBaseBlock is a reference to the block that the statement belongs to
    FBaseBlock: TBlock;

    // Set the bottommost part
    procedure SetYBottom(const AYBottom: Integer); virtual;

    // Get the optimal lower part
    function GetMaxOptimalYBottom: Integer; virtual;

    // Lowers the statement on Offset
    procedure Lower(const AOffset: Integer);

    // Returns whether the current Y last is optimal
    function HasOptimalYLast: boolean;

    // Get the optimal Y last
    function GetOptimalYLast: Integer; virtual; abstract;

    // Returns the optimal block width
    function GetOptimaWidth: Integer; virtual; abstract;

    procedure RedefineStatement;

    // This method is abstract and will be implemented by subclasses to determine
    // the size of the statement
    procedure SetInitiaXLast; virtual;

    // After changing the Y coordinate, need to call the procedure in order to
    // change the Y coordinates of others
    procedure FixYStatementsPosition;

    procedure SetTextSize; virtual;
    procedure SetActionSizes;

    // These methods are abstract and will be implemented by subclasses to draw
    procedure Draw; virtual; abstract;

  public
    // This constructor creates an uncertainty statement
    constructor CreateUncertainty(const ABaseBlock: TBlock);

    // Create
    constructor Create(const AAction : String; const ABaseBlock: TBlock); virtual;

    // These properties return the text of the statement and base block
    property Action: String read FAction;
    property BaseBlock: TBlock read FBaseBlock;

    // Returnts the Y statrt coordinate
    property YStart: Integer read FYStart;

    // Returns the Y coordinate of the bottommost part
    function GetYBottom: Integer; virtual;

    // Change action
    procedure ChangeAction(const AAction: String);

    // Set the optimal Y last
    procedure SetOptimalYLast;

    // Set the dimensions after adding and if this statement is the last one,
    // it asks the previous to set the optimal height
    procedure Install;

    function Clone: TStatement; virtual;
  end;

  { TStatementClass }
  TStatementClass = class of TStatement;

  { TBlockArr }
  TBlockArr = array of TBlock;

  { TOperator }
  TOperator = class abstract(TStatement)
  protected
    FBlocks: TBlockArr;

    procedure CreateBlock; virtual; abstract;
    procedure InitializeBlock; virtual; abstract;

    procedure SetYBottom(const AYBottom: Integer); override;
    function GetMaxOptimalYBottom: Integer; override;

    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; virtual; abstract;

    function FindBlockIndex(const AXStart: Integer): Integer;

    function GetBlockYStart: Integer;

    procedure SetInitiaXLast; override;
  public
    constructor Create(const AAction : String; const ABaseBlock: TBlock); override;
    destructor Destroy; override;

    function IsPreсOperator : Boolean; virtual; abstract;

    function GetYBottom: Integer; override;

    property YLast: Integer read FYLast;
    property Blocks: TBlockArr read FBlocks;

    function Clone: TStatement; override;
  end;

  { TBlock }
  TBlock = class
  private
    // FCanvas is a reference to the canvas used for drawing
    FCanvas: TCanvas;

    FXStart, FXLast: Integer;
    FStatements: TArrayList<TStatement>;
    FBaseOperator: TOperator;

    procedure ChangeYStatement(AIndex: Integer = 0);

    procedure MoveRightExceptXLast(const AOffset: Integer);

    function FindOptimalXLast: Integer;

    function GetLastStatement: TStatement;

    function FindStatementIndex(const AFYStart: Integer): Integer;

    procedure RemoveStatementAt(const Index: Integer);

    function Clone(const ABaseOperator: TOperator): TBlock;
  public
    constructor Create(const AXStart, AXLast: Integer; const ABaseOperator: TOperator;
                       const ACanvas: TCanvas);
    destructor Destroy; override;

    property XStart: Integer read FXStart;
    property XLast: Integer read FXLast;
    property Canvas: TCanvas read FCanvas;
    property BaseOperator: TOperator read FBaseOperator;
    property Statements: TArrayList<TStatement> read FStatements;

    procedure AddStatementBefore(const AStatement: TStatement; const AInsertedStatement: TStatement);
    procedure AddStatementAfter(const AStatement: TStatement; const AInsertedStatement: TStatement);
    procedure AddStatementLast(const AStatement: TStatement);
    procedure AddFirstStatement(const AStatement: TStatement; const AYStart: Integer);

    procedure AddBlockPartAfter(const AStatement: TStatement; const AComplexStatement: TStatement);

    function Remove(const AStatement: TStatement): Integer;

    procedure SetOptimalXLastBlock;

    procedure ChangeXLastBlock(const ANewXLast: Integer);
    procedure MoveRight(const AOffset: Integer);

    procedure DrawBlock;

    procedure RedefineSizes;
  end;

  var
    DefaultBlock: TStatementClass = nil;

implementation

  { TStatement }

  constructor TStatement.CreateUncertainty(const ABaseBlock: TBlock);
  begin
    FAction := UncertaintySymbol;
    FBaseBlock:= ABaseBlock;
    SetTextSize;
  end;

  constructor TStatement.Create(const AAction : String; const ABaseBlock: TBlock);
  begin
    FAction := AAction;
    FBaseBlock:= ABaseBlock;
    SetTextSize;
  end;

  procedure TStatement.SetTextSize;
  begin
    SetActionSizes;
    FYIndentText:= BaseBlock.FCanvas.Font.Size + 3;
    FXMinIndentText:= BaseBlock.FCanvas.Font.Size + 5;
  end;

  procedure TStatement.SetActionSizes;
  begin
    FActionSize.Width:= GetTextWidth(BaseBlock.Canvas, FAction);
    FActionSize.Height:= GetTextHeight(BaseBlock.Canvas, FAction);
  end;

  procedure TStatement.RedefineStatement;
  var
    I: Integer;
    Blocks: TBlockArr;
  begin
    SetTextSize;
    SetOptimalYLast;
    if Self is TOperator then
    begin
      Blocks:= TOperator(Self).FBlocks;
      for I := 0 to High(Blocks) do
        Blocks[I].RedefineSizes;
    end;
  end;

  function TStatement.HasOptimalYLast : Boolean;
  begin
    Result:= FYLast = GetOptimalYLast;
  end;

  procedure TStatement.ChangeAction(const AAction: String);
  begin
    FAction := AAction;
    SetActionSizes;

    BaseBlock.SetOptimalXLastBlock;
    SetOptimalYLast;
    FixYStatementsPosition;
  end;

  procedure TStatement.SetInitiaXLast;
  begin
    BaseBlock.SetOptimalXLastBlock;
  end;

  function TStatement.GetYBottom: Integer;
  begin
    Result:= FYLast;
  end;

  procedure TStatement.SetYBottom(const AYBottom: Integer);
  begin
    FYLast:= AYBottom;
  end;

  function TStatement.GetMaxOptimalYBottom: Integer;
  begin
    Result:= GetOptimalYLast;
  end;

  procedure TStatement.FixYStatementsPosition;
  var
    Index: Integer;
    CurrBlock: TBlock;
    CurrOperator: TOperator;
    procedure AlignBlocks(const ABlockArr: TBlockArr);
    var
      I, MaxYLast, CurrYLast: Integer;
    begin

      MaxYLast := ABlockArr[0].GetLastStatement.GetMaxOptimalYBottom;
      for I := 1 to High(ABlockArr) do
      begin
        CurrYLast := ABlockArr[I].GetLastStatement.GetMaxOptimalYBottom;;
        if MaxYLast < CurrYLast then
          MaxYLast := CurrYLast;
      end;

      for I := 0 to High(ABlockArr) do
        if ABlockArr[I].GetLastStatement.GetYBottom <> MaxYLast then
          ABlockArr[I].GetLastStatement.SetYBottom(MaxYLast);
    end;
  begin

    // Find the statement index in the block
    Index := BaseBlock.FindStatementIndex(Self.FYStart);

    // Shift all statements after and childrens
    BaseBlock.ChangeYStatement(Index);

    if Self is TOperator then
    begin
      CurrOperator:= TOperator(Self);
      if Length(CurrOperator.FBlocks) > 1 then
        AlignBlocks(CurrOperator.FBlocks);
    end;

    // Next, shift the statements in all basic blocks
    CurrBlock:= BaseBlock;
    while CurrBlock.BaseOperator <> nil do
    begin
      CurrOperator:= CurrBlock.BaseOperator;
      CurrBlock:= CurrBlock.BaseOperator.BaseBlock;

      if Length(CurrOperator.FBlocks) > 1 then
        AlignBlocks(CurrOperator.FBlocks);

      Index := CurrBlock.FindStatementIndex(CurrOperator.FYStart);
      CurrBlock.ChangeYStatement(Index + 1);
    end;
  end;

  procedure TStatement.SetOptimalYLast;
  begin
    FYLast := GetOptimalYLast;
  end;

  procedure TStatement.Lower(const AOffset: Integer);
  begin
    Inc(FYStart, AOffset);
    Inc(FYLast, AOffset);
  end;

  procedure TStatement.Install;
  begin
    SetOptimalYLast;
    SetInitiaXLast;
    FixYStatementsPosition;
  end;

  function TStatement.Clone: TStatement;
  begin
    Result:= TStatementClass(Self.ClassType).CreateUncertainty(Self.BaseBlock);

    Result.FAction:= Self.FAction;

    Result.FActionSize:= Self.FActionSize;

    Result.FYIndentText := Self.FYIndentText;
    Result.FXMinIndentText := Self.FXMinIndentText;

    Result.FYStart:= Self.FYStart;
    Result.FYLast:= Self.FYLast;
  end;

  { TBlock }

  destructor TBlock.Destroy;
  var
    I: Integer;
  begin

    for I := 0 to FStatements.Count - 1 do
      FStatements[I].Destroy;

    FStatements.Destroy;
    inherited;
  end;

  constructor TBlock.Create(const AXStart, AXLast: Integer;
                       const ABaseOperator: TOperator; const ACanvas: TCanvas);
  begin
    FStatements := TArrayList<TStatement>.Create(7);

    FXStart := AXStart;
    FXLast := AXLast;
    FCanvas := ACanvas;

    FBaseOperator := ABaseOperator;
  end;

  procedure TBlock.RedefineSizes;
  var
    I: Integer;
  begin
    for I := 0 to FStatements.Count - 1 do
      FStatements[I].RedefineStatement;
    SetOptimalXLastBlock;
  end;

  procedure TBlock.AddStatementBefore(const AStatement: TStatement;
            const AInsertedStatement: TStatement);
  var
    Index: Integer;
  begin
    Index:= FindStatementIndex(AStatement.FYStart);

    AInsertedStatement.FYStart:= AStatement.FYStart;
    AInsertedStatement.FBaseBlock:= Self;
    FStatements.Insert(AInsertedStatement, Index);

    if (AStatement.FAction = TStatement.UncertaintySymbol) and (AStatement.ClassType = DefaultBlock) then
      Self.RemoveStatementAt(Index + 1);
  end;

  procedure TBlock.AddStatementAfter(const AStatement: TStatement;
            const AInsertedStatement: TStatement);
  var
    Index: Integer;
  begin
    Index:= FindStatementIndex(AStatement.FYStart) + 1;

    if Index <> FStatements.Count then
    begin
      AInsertedStatement.FYStart:= AStatement.GetYBottom;
      AInsertedStatement.FBaseBlock:= Self;
      FStatements.Insert(AInsertedStatement, Index);

      if (AStatement.FAction = TStatement.UncertaintySymbol) and (AStatement.ClassType = DefaultBlock) then
        Self.RemoveStatementAt(Index + 1);
    end
    else
      AddStatementLast(AInsertedStatement);
  end;

  procedure TBlock.AddStatementLast(const AStatement: TStatement);
  var
    PrevStatement: TStatement;
  begin
    FStatements.Add(AStatement);

    if FStatements.Count = 1 then
      AStatement.FYStart:= BaseOperator.FYLast
    else
    begin
      PrevStatement:= FStatements[FStatements.Count - 2];
      PrevStatement.SetYBottom(PrevStatement.GetMaxOptimalYBottom);
      AStatement.FYStart:= PrevStatement.GetYBottom;

      if (PrevStatement.FAction = TStatement.UncertaintySymbol) and (PrevStatement.ClassType = DefaultBlock) then
      begin
        AStatement.FYStart:= PrevStatement.FYStart;
        Self.RemoveStatementAt(FStatements.Count - 2);
      end;
    end;

    AStatement.FBaseBlock:= Self;
  end;

  procedure TBlock.AddFirstStatement(const AStatement: TStatement; const AYStart: Integer);
  begin
    FStatements.Add(AStatement);
    AStatement.FYStart:= AYStart;
    AStatement.FBaseBlock:= Self;
  end;

  procedure TBlock.AddBlockPartAfter(const AStatement: TStatement; const AComplexStatement: TStatement);
  var
    Offset, I: Integer;
    Blocks: TBlockArr;
  begin
    Offset:= Self.XStart - AComplexStatement.BaseBlock.XStart;

    Self.AddStatementAfter(AStatement, AComplexStatement);

    if AComplexStatement is TOperator then
    begin
      Blocks:= TOperator(AComplexStatement).Blocks;
      for I := 0 to High(Blocks) do
        Blocks[I].MoveRight(Offset);
      Blocks[High(Blocks)].ChangeXLastBlock(XLast);
    end;
  end;

  function TBlock.Remove(const AStatement: TStatement): Integer;
  begin
    Result:= FindStatementIndex(AStatement.FYStart);
    RemoveStatementAt(Result);

    if Result = FStatements.Count then
      Dec(Result);
  end;

  procedure TBlock.RemoveStatementAt(const Index: Integer);
  var
    Statement: TStatement;
  begin
    Statement:= FStatements[Index];
    FStatements.Delete(Index);
    if FStatements.Count = 0 then
    begin
      FStatements.Add(DefaultBlock.CreateUncertainty(Self));
      FStatements[0].FYStart:= Statement.FYStart;
    end;
    Statement.Destroy;
  end;

  procedure TBlock.ChangeYStatement(AIndex: Integer = 0);
  var
    I, J: Integer;
    Blocks: TBlockArr;
  begin

    if AIndex = 0 then
    begin
      if BaseOperator <> nil then
        FStatements[AIndex].Lower(BaseOperator.GetBlockYStart - FStatements[AIndex].FYStart);

      if FStatements[AIndex] is TOperator then
      begin
        Blocks:= TOperator(FStatements[AIndex]).FBlocks;
        for J := 0 to High(Blocks) do
          Blocks[J].ChangeYStatement;
      end;

      Inc(AIndex);
    end;

    for I := AIndex to FStatements.Count - 1 do
    begin

      FStatements[I].Lower(FStatements[I - 1].GetYBottom - FStatements[I].FYStart);

      if FStatements[I] is TOperator then
      begin
        Blocks:= TOperator(FStatements[I]).FBlocks;
        for J := 0 to High(Blocks) do
          Blocks[J].ChangeYStatement;
      end;
    end;

    if (BaseOperator <> nil) and not BaseOperator.IsPreсOperator then
      BaseOperator.SetOptimalYLast;
  end;

  function TBlock.FindOptimalXLast: Integer;
  var
    I, CurrOptimalX: Integer;
    Blocks: TBlockArr;
    procedure CheckNewOptimalX;
    begin
      if CurrOptimalX > Result then
        Result:= CurrOptimalX;
    end;
  begin

    Result:= -1;

    for I := 0 to FStatements.Count - 1 do
    begin

      CurrOptimalX:= FXStart + FStatements[I].GetOptimaWidth;
      CheckNewOptimalX;

      if FStatements[I] is TOperator then
      begin
        Blocks:= TOperator(FStatements[I]).FBlocks;
        CurrOptimalX:= Blocks[High(Blocks)].FindOptimalXLast;
        CheckNewOptimalX;
      end;
    end;

    if BaseOperator <> nil then
    begin
      CurrOptimalX:= FXStart + BaseOperator.GetOptimalWidthForBlock(Self);
      CheckNewOptimalX;
    end;

  end;

  procedure TBlock.MoveRightExceptXLast(const AOffset: Integer);
  var
    I, J: Integer;
    Blocks: TBlockArr;
  begin
    Inc(FXStart, AOffset);
    for I := 0 to FStatements.Count - 1 do
      if FStatements[I] is TOperator then
      begin
        Blocks:= TOperator(FStatements[I]).FBlocks;
        for J := 0 to High(Blocks) - 1 do
          Blocks[J].MoveRight(AOffset);

        Blocks[High(Blocks)].MoveRightExceptXLast(AOffset);
      end;
  end;

  procedure TBlock.MoveRight(const AOffset: Integer);
  var
    I, J: Integer;
    Blocks: TBlockArr;
  begin
    Inc(FXStart, AOffset);
    Inc(FXLast, AOffset);
    for I := 0 to FStatements.Count - 1 do
      if FStatements[I] is TOperator then
      begin
        Blocks:= TOperator(FStatements[I]).FBlocks;
        for J := 0 to High(Blocks) do
          Blocks[J].MoveRight(AOffset);
      end;
  end;

  procedure TBlock.ChangeXLastBlock(const ANewXLast: Integer);
  var
    I: Integer;
    Blocks: TBlockArr;
  begin
    FXLast:= ANewXLast;
    for I := 0 to FStatements.Count - 1 do
      if FStatements[I] is TOperator then
      begin
        Blocks:= TOperator(FStatements[I]).FBlocks;
        Blocks[High(Blocks)].ChangeXLastBlock(ANewXLast);
      end;
  end;

  procedure TBlock.SetOptimalXLastBlock;
  var
    CurrBlock: TBlock;
    NewXLast, OldXLast: Integer;
    I, J, Index: Integer;
    Blocks: TBlockArr;
  begin
    OldXLast:= Self.FXLast;
    CurrBlock:= Self;

    while (CurrBlock.BaseOperator <> nil) and
                    (CurrBlock.BaseOperator.BaseBlock.FXLast = OldXLast) do
      CurrBlock:= CurrBlock.BaseOperator.BaseBlock;

    NewXLast:= CurrBlock.FindOptimalXLast;

    CurrBlock.ChangeXLastBlock(NewXLast);

    if CurrBlock.FBaseOperator <> nil then
    begin
      CurrBlock:= CurrBlock.FBaseOperator.BaseBlock;

      for I := 0 to CurrBlock.FStatements.Count - 1 do
        if CurrBlock.FStatements[I] is TOperator then
        begin

          Blocks:= TOperator(CurrBlock.FStatements[I]).FBlocks;

          for J := 0 to High(Blocks) do
            if Blocks[J].FXLast = NewXLast then
            begin
              Index:= J + 1;
              break;
            end;

          for J := Index to High(Blocks) - 1 do
            Blocks[J].MoveRight(Blocks[J - 1].FXLast - Blocks[J].FXStart);

          J:= High(Blocks);
          if Index <= J then
          begin
            Blocks[J].MoveRightExceptXLast(Blocks[J - 1].FXLast - Blocks[J].FXStart);

            Blocks[J].SetOptimalXLastBlock;
          end;

        end;
    end;

  end;

  function TBlock.FindStatementIndex(const AFYStart: Integer): Integer;
  var
    L, R, M: Integer;
  begin

    L := 0;
    R := FStatements.Count - 1;
    Result := -1;

    while L <= R do
    begin

      M := (L + R) shr 1;

      if FStatements[M].FYStart = AFYStart then
        Exit(M)

      else if FStatements[M].FYStart < AFYStart then
        L := M + 1
      else
        R := M - 1;
    end;

  end;

  procedure TBlock.DrawBlock;
  var
    I: Integer;
  begin
    for I := 0 to FStatements.Count - 1 do
      FStatements[I].Draw;
  end;

  function TBlock.GetLastStatement: TStatement;
  begin
    if (BaseOperator = nil) or BaseOperator.IsPreсOperator then
      Result:= FStatements.GetLast
    else
      Result:= BaseOperator;
  end;

  function TBlock.Clone(const ABaseOperator: TOperator): TBlock;
  var
    I: Integer;
    NewStatements: TStatement;
  begin
    Result:= TBlock.Create(Self.FXStart, Self.FXLast,
                   ABaseOperator, Self.FCanvas);

    Result.FStatements:= TArrayList<TStatement>.Create(Self.FStatements.Count);

    for I := 0 to Self.FStatements.Count - 1 do
    begin
      NewStatements:= Self.FStatements[I].Clone;
      NewStatements.FBaseBlock:= Result;
      Result.FStatements.Add(NewStatements);
    end;
  end;

  { TOperator }
  constructor TOperator.Create(const AAction : String; const ABaseBlock: TBlock);
  begin
    inherited Create(AAction, ABaseBlock);
    CreateBlock;
    InitializeBlock;
  end;

  destructor TOperator.Destroy;
  var
    I: Integer;
  begin

    for I := 0 to High(FBlocks) do
      FBlocks[I].Destroy;

    inherited;
  end;

  function TOperator.FindBlockIndex(const AXStart: Integer): Integer;
  var
    L, R, M: Integer;
  begin

    L := 0;
    R := High(FBlocks);
    Result := -1;

    while L <= R do
    begin

      M := (L + R) shr 1;

      if FBlocks[M].FXStart = AXStart then
        Exit(M)

      else if FBlocks[M].FXStart < AXStart then
        L := M + 1
      else
        R := M - 1;
    end;

  end;

  function TOperator.GetBlockYStart: Integer;
  begin
    case IsPreсOperator of
      True: Result := FYLast;
      False: Result := FYStart;
    end;
  end;

  procedure TOperator.SetInitiaXLast;
  var
    I: Integer;
  begin
    for I := 0 to High(FBlocks) do
      FBlocks[I].SetOptimalXLastBlock;
  end;

  function TOperator.GetYBottom: Integer;
  var
    I: Integer;
  begin
    case IsPreсOperator of
      True: Result:= FBlocks[0].FStatements.GetLast.GetYBottom;
      False: Result := FYLast;
    end;
  end;

  procedure TOperator.SetYBottom(const AYBottom: Integer);
  var
    I: Integer;
  begin
    case IsPreсOperator of
      True:
        for I := 0 to High(FBlocks) do
          FBlocks[I].Statements.GetLast.SetYBottom(AYBottom);
      False: FYLast := AYBottom;
    end;
  end;

  function TOperator.GetMaxOptimalYBottom: Integer;
  var
    I: Integer;
  begin
    Result := -1;
    case IsPreсOperator of
      True:
        for I := 0 to High(FBlocks) do
          Result := Max(Result, FBlocks[I].Statements.GetLast.GetMaxOptimalYBottom);
      False: Result := GetOptimalYLast;
    end;
  end;

  function TOperator.Clone: TStatement;
  var
    I: Integer;
    ResultOperator: TOperator;
  begin
    Result:= inherited;
    ResultOperator:= TOperator(Result);
    SetLength(ResultOperator.FBlocks, Length(Self.Blocks));

    for I := 0 to High(Self.Blocks) do
      ResultOperator.FBlocks[I]:= Self.FBlocks[I].Clone(ResultOperator);
  end;
end.
