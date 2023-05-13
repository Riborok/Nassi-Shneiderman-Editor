﻿unit uBase;

interface
uses Vcl.graphics, uArrayList, uMinMaxInt, uDetermineDimensions, System.Types,
     uAdditionalTypes;
type
  TBlock = class;

  { TBaseStatement }
  // Define abstract class TStatement
  // This class is a base class for all statements and is abstract
  // DefaultSymbol is a constant field used to represent an unknown value
  // in the statement
  TStatement = class abstract
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

    procedure RedefineStatement; virtual;

    procedure SetTextSize; virtual;
    procedure SetActionSizes;

    // These methods are abstract and will be implemented by subclasses to draw
    procedure Draw; virtual; abstract;

    procedure Initialize; virtual;
  public
    // Create
    constructor Create(const AAction : String; const ABaseBlock: TBlock); overload;
    constructor Create(const AAction : String); overload; virtual;

    // These properties return the text of the statement and base block
    property Action: String read FAction;
    property BaseBlock: TBlock read FBaseBlock write FBaseBlock;

    // Returnts the Y statrt coordinate
    property YStart: Integer read FYStart;
    property YLast: Integer read FYLast;

    property YIndentText: Integer read FYIndentText;

    // Returns the Y coordinate of the bottommost part
    function GetYBottom: Integer; virtual;

    // Change action
    procedure ChangeAction(const AAction: String);

    // Set the optimal Y last
    procedure SetOptimalYLast;

    procedure SwapYStart(const AStatement: TStatement);

    function Clone: TStatement; virtual;

  function GetMask(const AVisibleImageRect: TVisibleImageRect;
                   const isTOperator: Boolean): Integer; inline;
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

    procedure SetYBottom(const AYBottom: Integer); override;
    function GetMaxOptimalYBottom: Integer; override;

    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; virtual; abstract;

    function GetBlockYStart: Integer;

    procedure DrawBlocks(const AVisibleImageRect: TVisibleImageRect);

    procedure RedefineStatement; override;

    procedure Initialize; override;

    procedure InitializeBlocks(StartIndex: Integer = 0);
    procedure InstallCanvas(const ACanvas: TCanvas);
    procedure SetBlockTextSize;
  public
    constructor Create(const AAction : String); override;
    destructor Destroy; override;

    function IsPreсOperator : Boolean; virtual; abstract;

    function GetYBottom: Integer; override;

    property Blocks: TBlockArr read FBlocks;

    function Clone: TStatement; override;

    function FindBlockIndex(const AXStart: Integer): Integer;
    function GetOffsetFromXStart: Integer; virtual;
    procedure MoveRightChildrens(const AOffset : Integer);
    procedure MoveDownChildrens(const AOffset : Integer);
    procedure SetXLastForChildrens(const AXLast : Integer);
    procedure AlignBlocks;
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

    function Clone(const ABaseOperator: TOperator): TBlock;

    procedure Insert(var AIndex: Integer;const AInsertedStatement: TStatement);
    procedure RemoveStatementAt(const Index: Integer);

    procedure ChangeXStartBlock(const ANewXStart: Integer);

    // After changing the Y coordinate, need to call the procedure in order to
    // change the Y coordinates of others
    procedure FixYStatementsPosition(const Index: Integer);
  public
    constructor Create(const ABaseOperator: TOperator); overload;
    constructor Create(const AXStart: Integer; const ACanvas: TCanvas); overload;
    constructor Create(const AXStart: Integer; const ABaseOperator: TOperator); overload;
    destructor Destroy; override;

    property XStart: Integer read FXStart;
    property XLast: Integer read FXLast;
    property Canvas: TCanvas read FCanvas;
    property BaseOperator: TOperator read FBaseOperator;
    property Statements: TArrayList<TStatement> read FStatements;

    procedure InsertBlock(AIndex: Integer; const AInsertedBlock: TBlock);
    procedure InsertWithResizing(AIndex: Integer;const AInsertedStatement: TStatement);

    procedure AddUnknownStatement(const AStatement: TStatement; const AYStart: Integer);
    procedure AddStatement(const AStatement: TStatement);
    procedure AssignStatement(const AIndex: Integer; const AStatement : TStatement);

    function Extract(const AStatement: TStatement): Integer;
    function ExtractStatementAt(const AIndex: Integer) : TStatement;

    procedure MoveRight(const AOffset: Integer);
    procedure MoveDown(const AOffset: Integer);
    procedure ChangeXLastBlock(const ANewXLast: Integer);

    procedure SetOptimalXLastBlock;

    procedure DrawBlock(const AVisibleImageRect: TVisibleImageRect);

    procedure Assign(const ASource: TBlock);

    procedure RedefineSizes(const AIndex: Integer = 0);

    function FindStatementIndex(const AFYStart: Integer): Integer;

    procedure SetNewActionForDefaultStatements(const AOldDefaultAction: string);

    // Set the dimensions after adding and if this statement is the last one,
    // it asks the previous to set the optimal height
    procedure Install(const Index: Integer);

    function GetMask(const AVisibleImageRect: TVisibleImageRect): Integer; inline;
  end;

  var
    DefaultStatement: TStatementClass = nil;
    DefaultAction : string;
  function isDefaultStatement(const AStatement: TStatement): Boolean;

implementation

  function isDefaultStatement(const AStatement: TStatement): Boolean;
  begin
    Result:= (AStatement.FAction = DefaultAction) and
             (AStatement is DefaultStatement);
  end;

  { TStatement }

  constructor TStatement.Create(const AAction : String; const ABaseBlock: TBlock);
  begin
    FBaseBlock:= ABaseBlock;
    Create(AAction);
  end;

  constructor TStatement.Create(const AAction : String);
  begin
    FAction := AAction;
    inherited Create;
  end;

  procedure TStatement.SetTextSize;
  const
    Stock = 5;
  begin
    SetActionSizes;
    FYIndentText:= BaseBlock.FCanvas.Font.Size + BaseBlock.FCanvas.Pen.Width + Stock;
    FXMinIndentText:= BaseBlock.FCanvas.Font.Size + BaseBlock.FCanvas.Pen.Width + Stock;
  end;

  procedure TStatement.SetActionSizes;
  begin
    FActionSize:= GetTextSize(BaseBlock.Canvas, FAction);
  end;

  procedure TStatement.RedefineStatement;
  begin
    SetTextSize;
    SetOptimalYLast;
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
    BaseBlock.FixYStatementsPosition(BaseBlock.FindStatementIndex(FYStart));
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

  procedure TStatement.SetOptimalYLast;
  begin
    FYLast := GetOptimalYLast;
  end;

  procedure TStatement.Lower(const AOffset: Integer);
  begin
    Inc(FYStart, AOffset);
    Inc(FYLast, AOffset);
  end;

  procedure TStatement.Initialize;
  begin
    SetOptimalYLast;
    BaseBlock.SetOptimalXLastBlock;
  end;

  procedure TStatement.SwapYStart(const AStatement: TStatement);
  var
    Temp: Integer;
  begin
    Temp := Self.YStart;
    Self.FYStart := AStatement.FYStart;
    AStatement.FYStart := Temp;
  end;

  function TStatement.Clone: TStatement;
  begin
    Result:= TStatementClass(Self.ClassType).Create(DefaultAction, Self.BaseBlock);

    Result.FAction:= Self.FAction;

    Result.FActionSize:= Self.FActionSize;

    Result.FYIndentText := Self.FYIndentText;
    Result.FXMinIndentText := Self.FXMinIndentText;

    Result.FYStart:= Self.FYStart;
    Result.FYLast:= Self.FYLast;
  end;

  function TStatement.GetMask(const AVisibleImageRect: TVisibleImageRect;
                              const isTOperator: Boolean): Integer;
  var
    YLast: Integer;
  begin
    if isTOperator and (TOperator(Self).GetOffsetFromXStart <> 0) then
      YLast := GetYBottom
    else
      YLast:= FYLast;

    Result :=
    {X--- : }
      Ord(FYStart >= AVisibleImageRect.FTopLeft.Y) shl 3 or
    {-X-- : }
      Ord(YLast <= AVisibleImageRect.FBottomRight.Y) shl 2 or
    {--X- : }
      Ord(FYStart <= AVisibleImageRect.FBottomRight.Y) shl 1 or
    {---X : }
      Ord(YLast >= AVisibleImageRect.FTopLeft.Y);
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

  constructor TBlock.Create(const ABaseOperator: TOperator);
  begin
    FStatements := TArrayList<TStatement>.Create(14);
    FBaseOperator := ABaseOperator;
  end;

  constructor TBlock.Create(const AXStart: Integer; const ACanvas: TCanvas);
  begin
    FStatements := TArrayList<TStatement>.Create(14);
    FCanvas := ACanvas;
    FXStart := AXStart;
  end;

  constructor TBlock.Create(const AXStart: Integer; const ABaseOperator: TOperator);
  begin
    FStatements := TArrayList<TStatement>.Create(14);
    FXStart := AXStart;
    FBaseOperator := ABaseOperator;
  end;

  procedure TBlock.RedefineSizes(const AIndex: Integer = 0);
  var
    I: Integer;
  begin
    for I := AIndex to FStatements.Count - 1 do
      FStatements[I].RedefineStatement;

    FixYStatementsPosition(AIndex);

    SetOptimalXLastBlock;
  end;

  procedure TBlock.Insert(var AIndex: Integer; const AInsertedStatement: TStatement);
  begin
    AInsertedStatement.FBaseBlock:= Self;
    AInsertedStatement.SetTextSize;
    FStatements.Insert(AInsertedStatement, AIndex);

    if (FStatements.Count = 2) and (isDefaultStatement(Statements[AIndex xor 1])) then
    begin
      AInsertedStatement.FYStart:= Statements[AIndex xor 1].FYStart;
      Self.RemoveStatementAt(AIndex xor 1);
      AIndex:= 0;
    end
    else if AIndex = FStatements.Count - 1 then
    begin
      FStatements[AIndex - 1].
            SetYBottom(FStatements[AIndex - 1].GetMaxOptimalYBottom);
      AInsertedStatement.FYStart:= Statements[AIndex - 1].GetYBottom;
    end
    else if AIndex <> 0 then
      AInsertedStatement.FYStart:= Statements[AIndex - 1].GetYBottom
    else
      AInsertedStatement.FYStart:= Statements[AIndex + 1].FYStart;
  end;

  procedure TBlock.InsertWithResizing(AIndex: Integer; const AInsertedStatement: TStatement);
  begin
    Insert(AIndex, AInsertedStatement);

    AInsertedStatement.Initialize;

    FixYStatementsPosition(AIndex + 1);
  end;

  procedure TBlock.AddUnknownStatement(const AStatement: TStatement; const AYStart: Integer);
  begin
    AddStatement(AStatement);

    AStatement.FYStart:= AYStart;

    AStatement.Initialize;

    FixYStatementsPosition(0);
  end;

  procedure TBlock.AddStatement(const AStatement: TStatement);
  begin
    FStatements.Add(AStatement);
    AStatement.FBaseBlock := Self;
    AStatement.SetTextSize;
  end;

  procedure TBlock.AssignStatement(const AIndex: Integer; const AStatement : TStatement);
  begin
    FStatements[AIndex] := AStatement;
    AStatement.FBaseBlock := Self;
    AStatement.SetTextSize;
  end;

  procedure TBlock.InsertBlock(AIndex: Integer; const AInsertedBlock: TBlock);
  var
    I: Integer;
  begin
    AInsertedBlock.MoveRight(Self.FXStart - AInsertedBlock.FXStart);
    AInsertedBlock.ChangeXLastBlock(Self.FXLast);

    for I := 0 to AInsertedBlock.FStatements.Count - 1 do
    begin
      Inc(AIndex, I);
      Self.Insert(AIndex, AInsertedBlock.FStatements[I]);
      if AInsertedBlock.FStatements[I] is TOperator then
        TOperator(AInsertedBlock.FStatements[I]).InstallCanvas(FCanvas);
    end;
    Dec(AIndex, AInsertedBlock.FStatements.Count - 1);

    RedefineSizes(AIndex);
  end;

  function TBlock.Extract(const AStatement: TStatement): Integer;
  begin
    Result:= FindStatementIndex(AStatement.FYStart);

    ExtractStatementAt(Result);
  end;

  function TBlock.ExtractStatementAt(const AIndex: Integer) : TStatement;
  begin
    Result:= FStatements[AIndex];
    FStatements.Delete(AIndex);
    if FStatements.Count = 0 then
    begin
      AddStatement(DefaultStatement.Create(DefaultAction, Self));
      FStatements[0].FYStart:= Result.FYStart;
    end
    else if (Result.BaseBlock.BaseOperator = nil) and (AIndex = 0) then
      FStatements[0].FYStart:= Result.FYStart;
  end;

  procedure TBlock.RemoveStatementAt(const Index: Integer);
  begin
    ExtractStatementAt(Index).Destroy;
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
    procedure CheckNewOptimalX(var AResult: Integer; const ACurrOptimalX: Integer); inline;
    begin
      if ACurrOptimalX > AResult then
        AResult:= ACurrOptimalX;
    end;
  begin
    Result:= -1;

    for I := 0 to FStatements.Count - 1 do
    begin

      CurrOptimalX:= FXStart + FStatements[I].GetOptimaWidth;
      CheckNewOptimalX(Result, CurrOptimalX);

      if FStatements[I] is TOperator then
      begin
        Blocks:= TOperator(FStatements[I]).FBlocks;
        CurrOptimalX:= Blocks[High(Blocks)].FindOptimalXLast;
        CheckNewOptimalX(Result, CurrOptimalX);
      end;
    end;

    if BaseOperator <> nil then
    begin
      CurrOptimalX:= FXStart + BaseOperator.GetOptimalWidthForBlock(Self);
      CheckNewOptimalX(Result, CurrOptimalX);
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
    I: Integer;
  begin
    Inc(FXStart, AOffset);
    Inc(FXLast, AOffset);
    for I := 0 to FStatements.Count - 1 do
      if FStatements[I] is TOperator then
        TOperator(FStatements[I]).MoveRightChildrens(AOffset);
  end;

  procedure TBlock.MoveDown(const AOffset: Integer);
  var
    I: Integer;
  begin
    for I := 0 to FStatements.Count - 1 do
    begin
      FStatements[I].Lower(AOffset);
      if FStatements[I] is TOperator then
        TOperator(FStatements[I]).MoveDownChildrens(AOffset);
    end;
  end;

  procedure TBlock.ChangeXStartBlock(const ANewXStart: Integer);
  var
    I: Integer;
    Blocks: TBlockArr;
  begin
    FXStart:= ANewXStart;
    for I := 0 to FStatements.Count - 1 do
      if FStatements[I] is TOperator then
      begin
        Blocks:= TOperator(FStatements[I]).FBlocks;
        Blocks[High(Blocks)].ChangeXStartBlock(ANewXStart);
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
    I, Index: Integer;
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
      Blocks:= CurrBlock.FBaseOperator.FBlocks;

      Index:= CurrBlock.FBaseOperator.FindBlockIndex(CurrBlock.FXStart) + 1;

      for I := Index to High(Blocks) - 1 do
        Blocks[I].MoveRight(Blocks[I - 1].FXLast - Blocks[I].FXStart);

      I:= High(Blocks);
      Blocks[I].MoveRightExceptXLast(Blocks[I - 1].FXLast - Blocks[I].FXStart);
      Blocks[I].SetOptimalXLastBlock;
    end;
  end;

  procedure TBlock.SetNewActionForDefaultStatements(const AOldDefaultAction: string);
  var
    Blocks : TBlockArr;
    I, J: Integer;
  begin
    I:= 0;
    while I < Statements.Count - 1 do
    begin

      if Statements[I] is TOperator then
      begin
        Blocks := TOperator(Statements[I]).Blocks;
        for J := 0 to High(Blocks) do
          Blocks[J].SetNewActionForDefaultStatements(AOldDefaultAction);
      end;

      if Statements[I] is DefaultStatement then
      begin
        if Statements[I].FAction = AOldDefaultAction then
          Statements[I].ChangeAction(DefaultAction)
        else if Statements[I].FAction = DefaultAction then
        begin
          RemoveStatementAt(I);
          Dec(I);
        end;
      end;

      Inc(I);
    end;
    I:= Statements.Count - 1;
    if Statements[I] is DefaultStatement then
    begin
      if Statements[I].FAction = AOldDefaultAction then
        Statements[I].ChangeAction(DefaultAction)
      else if Statements[I].FAction = DefaultAction then
        RemoveStatementAt(I);
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

  procedure TBlock.FixYStatementsPosition(const Index: Integer);
  var
    CurrBlock: TBlock;
    CurrOperator: TOperator;
  begin

    // Shift all statements after and childrens
    ChangeYStatement(Index);

    if FStatements[Index] is TOperator then
      TOperator(FStatements[Index]).AlignBlocks;

    // Next, shift the statements in all basic blocks
    CurrBlock:= Self;
    while CurrBlock.BaseOperator <> nil do
    begin
      CurrOperator:= CurrBlock.BaseOperator;
      CurrBlock:= CurrOperator.BaseBlock;

      CurrOperator.AlignBlocks;

      CurrBlock.ChangeYStatement(CurrBlock.FindStatementIndex(CurrOperator.FYStart) + 1);
    end;
  end;

  procedure TBlock.Install(const Index: Integer);
  var
    I: Integer;
    Blocks: TBlockArr;
    CurrOperator: TOperator;
  begin
    FStatements[Index].SetOptimalYLast;

    if FStatements[Index] is TOperator then
    begin
      CurrOperator:= TOperator(FStatements[Index]);
      Blocks:= CurrOperator.Blocks;
      Blocks[0].SetOptimalXLastBlock;
      Blocks[0].GetLastStatement.SetYBottom(Blocks[0].GetLastStatement.GetOptimalYLast);
      for I := 1 to High(Blocks) - 1 do
      begin
        Blocks[I].SetOptimalXLastBlock;
        Blocks[I].GetLastStatement.SetYBottom(Blocks[I].GetLastStatement.GetOptimalYLast);
      end;
      CurrOperator.AlignBlocks;
    end
    else
      Self.SetOptimalXLastBlock;

    FixYStatementsPosition(Index);
  end;

  procedure TBlock.DrawBlock(const AVisibleImageRect: TVisibleImageRect);
  var
    L, R, M: Integer;
    CurrStatement: TStatement;
    isTOperator: Boolean;
  begin
    L := 0;
    R := FStatements.Count - 1;

    while L < R do
    begin
      M := (L + R) shr 1;
      case FStatements[M].GetMask(AVisibleImageRect, FStatements[M] is TOperator) of
        $0F {1111}, $03 {0011}, $07 {0111}, $0B {1011}:
          R := M;
        $09 {1001}:
          R := M - 1;
        else
          L := M + 1;
      end;
    end;

    if R >= 0 then
    begin
      if (R <> 0) and (FStatements[R - 1] is TOperator) then
        TOperator(FStatements[R - 1]).DrawBlocks(AVisibleImageRect);

      for M := R to FStatements.Count - 1 do
      begin
        CurrStatement:= FStatements[M];
        isTOperator:= CurrStatement is TOperator;
        if isTOperator then
          TOperator(CurrStatement).DrawBlocks(AVisibleImageRect);
        case CurrStatement.GetMask(AVisibleImageRect, isTOperator) of
          $0F {1111}, $03 {0011}, $07 {0111}, $0B {1011}:
            CurrStatement.Draw;
          else
            Break;
        end;
      end;
    end;
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
    Result:= TBlock.Create(ABaseOperator);
    Result.FCanvas:= Self.FCanvas;
    Result.FXStart:= Self.FXStart;
    Result.FXLast:= Self.FXLast;

    Result.FStatements:= TArrayList<TStatement>.Create(Self.FStatements.Count);

    for I := 0 to Self.FStatements.Count - 1 do
    begin
      NewStatements:= Self.FStatements[I].Clone;
      NewStatements.FBaseBlock:= Result;
      Result.FStatements.Add(NewStatements);
    end;
  end;

  procedure TBlock.Assign(const ASource: TBlock);
  begin
    Self.FXStart:= ASource.FXStart;
    Self.FXLast:= ASource.FXLast;
    Self.FCanvas:= ASource.FCanvas;
  end;

  function TBlock.GetMask(const AVisibleImageRect: TVisibleImageRect): Integer;
  begin
    Result :=
    {X--- : }
      Ord(FXStart >= AVisibleImageRect.FTopLeft.X) shl 3 or
    {-X-- : }
      Ord(FXLast <= AVisibleImageRect.FBottomRight.X) shl 2 or
    {--X- : }
      Ord(FXStart <= AVisibleImageRect.FBottomRight.X) shl 1 or
    {---X : }
      Ord(FXLast >= AVisibleImageRect.FTopLeft.X);
  end;

  { TOperator }
  constructor TOperator.Create(const AAction : String);
  begin
    inherited;
    CreateBlock;
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

  procedure TOperator.InitializeBlocks(StartIndex: Integer = 0);
  var
    I: Integer;
    BlockYStart: Integer;
    procedure SetYPos(const ABlock: TBlock; const AYStart: Integer); inline;
    begin
      ABlock.Statements[0].FYStart := AYStart;
      ABlock.Statements[0].SetOptimalYLast;
      ABlock.ChangeYStatement(0);
    end;
  begin
    InstallCanvas(FBaseBlock.FCanvas);
    SetBlockTextSize;
    BlockYStart:= GetBlockYStart;

    if StartIndex = 0 then
    begin
      SetYPos(Blocks[StartIndex], BlockYStart);

      Blocks[StartIndex].FXStart:= BaseBlock.FXStart + GetOffsetFromXStart;
      Blocks[StartIndex].ChangeXLastBlock(Blocks[StartIndex].FindOptimalXLast);

      Inc(StartIndex);
    end;

    for I := StartIndex to High(Blocks) - 1 do
    begin
      SetYPos(Blocks[I], BlockYStart);

      Blocks[I].FXStart:= Blocks[I - 1].FXLast;
      Blocks[I].ChangeXLastBlock(Blocks[I].FindOptimalXLast);
    end;

    if Length(Blocks) > 1 then
      Blocks[High(Blocks)].FXStart:= Blocks[High(Blocks) - 1].FXLast;

    SetYPos(Blocks[High(Blocks)], BlockYStart);
    Blocks[High(Blocks)].FXLast:= BaseBlock.FXLast;

    AlignBlocks;
  end;

  function TOperator.GetYBottom: Integer;
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

  procedure TOperator.DrawBlocks(const AVisibleImageRect: TVisibleImageRect);
  var
    L, R, M: Integer;
  begin
    L := 0;
    R := High(FBlocks);

    while L < R do
    begin
      M := (L + R) shr 1;
      case FBlocks[M].GetMask(AVisibleImageRect) of
        $0F {1111}, $03 {0011}, $07 {0111}, $0B {1011}:
          R := M;
        $09 {1001}:
          R := M - 1;
        else
          L := M + 1;
      end;
    end;

    if R >= 0 then
      for M := R to High(FBlocks) do
      begin
        case FBlocks[M].GetMask(AVisibleImageRect) of
          $0F {1111}, $03 {0011}, $07 {0111}, $0B {1011}:
            FBlocks[M].DrawBlock(AVisibleImageRect);
          else
            Break;
        end;
      end;
  end;

  procedure TOperator.AlignBlocks;
  var
    I, MaxYLast, CurrYLast: Integer;
  begin
    if Length(FBlocks) > 1 then
    begin
      MaxYLast := FBlocks[0].GetLastStatement.GetMaxOptimalYBottom;
      for I := 1 to High(FBlocks) do
      begin
        CurrYLast := FBlocks[I].GetLastStatement.GetMaxOptimalYBottom;;
        if MaxYLast < CurrYLast then
          MaxYLast := CurrYLast;
      end;

      for I := 0 to High(FBlocks) do
        if FBlocks[I].GetLastStatement.GetYBottom <> MaxYLast then
          FBlocks[I].GetLastStatement.SetYBottom(MaxYLast);
    end;
  end;

  procedure TOperator.Initialize;
  begin
    case IsPreсOperator of
      True:
      begin
        SetOptimalYLast;
        InitializeBlocks;
      end;
      False:
      begin
        InitializeBlocks;
        SetOptimalYLast;
      end;
    end;
    BaseBlock.SetOptimalXLastBlock;
  end;

  procedure TOperator.RedefineStatement;
  var
    I, CurrXStart: Integer;
  begin
    inherited;

    CurrXStart:= BaseBlock.FXStart + GetOffsetFromXStart;
    if CurrXStart <> FBlocks[0].FXStart then
      FBlocks[0].ChangeXStartBlock(CurrXStart);

    for I := 0 to High(FBlocks) do
      FBlocks[I].RedefineSizes;
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

  function TOperator.GetOffsetFromXStart: Integer;
  begin
    Result:= 0;
  end;

  procedure TOperator.InstallCanvas(const ACanvas: TCanvas);
  var
    I, J: Integer;
  begin
    for I := 0 to High(Blocks) do
    begin
      Blocks[I].FCanvas:= ACanvas;
      for J := 0 to Blocks[I].FStatements.Count - 1 do
        if Blocks[I].FStatements[J] is TOperator then
          TOperator(Blocks[I].FStatements[J]).InstallCanvas(ACanvas);
    end;
  end;

  procedure TOperator.SetBlockTextSize;
  var
    I, J: Integer;
  begin
    for I := 0 to High(FBlocks) do
      for J := 0 to FBlocks[I].Statements.Count - 1 do
      begin
        FBlocks[I].Statements[J].SetTextSize;
        if FBlocks[I].Statements[J] is TOperator then
          TOperator(FBlocks[I].Statements[J]).SetBlockTextSize;
      end;
  end;

  procedure TOperator.MoveRightChildrens(const AOffset : Integer);
  var
    I: Integer;
  begin
    for I := 0 to High(FBlocks) do
      FBlocks[I].MoveRight(AOffset);
  end;

  procedure TOperator.MoveDownChildrens(const AOffset : Integer);
  var
    I: Integer;
  begin
    for I := 0 to High(FBlocks) do
      FBlocks[I].MoveDown(AOffset);
  end;

  procedure TOperator.SetXLastForChildrens(const AXLast : Integer);
  begin
    FBlocks[High(FBlocks)].ChangeXLastBlock(AXLast);
  end;

end.
