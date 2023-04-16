﻿unit Base;

interface
uses Vcl.graphics, System.Generics.Collections, ArrayList, MinMaxInt, Vcl.ExtCtrls;
type
  TBlock = class;

  { TBaseStatement }
  // Define abstract class TStatement
  // This class is a base class for all statements and is abstract
  // UncertaintySymbol is a constant field used to represent an unknown value
  // in the statement
  TStatement = class abstract
  protected const
    UncertaintySymbol = '?';
  protected

    // FYStart and FYLast are used to store the Y position of the statement
    FYStart, FYLast: Integer;

    // FAction stores the text of the statement
    FAction: String;

    // FBaseBlock is a reference to the block that the statement belongs to
    FBaseBlock: TBlock;

    // FImage is a reference to the image used for drawing
    FImage: TImage;

    // These functions are used to get the Y and X indentation of the statement
    function YIndentText : Integer;
    function XMinIndentText : Integer;

    // Set the bottommost part
    procedure SetYBottom(const AYBottom: Integer); virtual;

    // Get the optimal lower part
    function GetOptimalYBottom: Integer; virtual;

    // After changing the Y coordinate, need to call the procedure in order to
    // change the Y coordinates of others
    procedure FixYStatementsPosition;

    // Lowers the statement on Offset
    procedure Lower(const Offset: Integer);

    // Returns whether the current Y last is optimal
    function HasOptimalYLast: boolean;

    // Get the optimal Y last
    function GetOptimalYLast: Integer; virtual; abstract;

    // Returns the optimal block width
    function GetOptimaWidth: Integer; virtual; abstract;

    // This method is abstract and will be implemented by subclasses to determine
    // the size of the statement
    procedure SetInitiaXLast; virtual;

    // Set the dimensions after adding and if this statement is the last one,
    // it asks the previous to set the optimal height
    procedure InstalAfterAdding; virtual;

    procedure RedefineSizes;

  public
    // This constructor creates an uncertainty statement
    constructor CreateUncertainty(const ABaseBlock: TBlock; const AImage: TImage);

    // Create
    constructor Create(const AAction : String; const ABaseBlock: TBlock; const AImage: TImage);

    // These properties return the text of the statement and base block
    property Action: String read FAction;
    property BaseBlock: TBlock read FBaseBlock;

    // Returnts the Y statrt coordinate
    property YStart: Integer read FYStart;

    // Returns the Y coordinate of the bottommost part
    function GetYBottom: Integer; virtual;

    // These methods are abstract and will be implemented by subclasses to draw
    procedure Draw; virtual; abstract;

    // Change action
    procedure ChangeAction(const AAction: String);

    // Set the optimal Y last
    procedure SetOptimalYLast;
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
    function GetOptimalYBottom: Integer; override;

    function GetOptimalWidthForBlock(const Block: TBlock): Integer; virtual; abstract;

    procedure SetInitiaXLast; override;

    procedure InstalAfterAdding; override;

    function FindBlockIndex(const FXStart: Integer): Integer;
  public
    destructor Destroy; override;

    function IsPreсOperator : Boolean; virtual; abstract;

    function GetBlockYStart: Integer;
    function GetYBottom: Integer; override;

    property YLast: Integer read FYLast;
    property Blocks: TBlockArr read FBlocks;
  end;

  { TBlock }
  TBlock = class
  private
    FXStart, FXLast: Integer;
    FStatements: TArrayList<TStatement>;
    FBaseOperator: TOperator;

    procedure ChangeYStatement(AIndex: Integer = 0);

    function FindOptimalXLast: Integer;
    procedure SetOptimalXLastBlock;

    procedure MoveRightExceptXLast(const AOffset: Integer);
    procedure MoveRight(const AOffset: Integer);
    procedure ChangeXLastBlock(const ANewXLast: Integer);

    function GetLastStatement: TStatement;

    function FindStatementIndex(const FYStart: Integer): Integer;
  public
    constructor Create(const AXStart, AXLast: Integer; const ABaseOperator: TOperator);
    destructor Destroy; override;

    property XStart: Integer read FXStart;
    property XLast: Integer read FXLast;
    property BaseOperator: TOperator read FBaseOperator;
    property Statements: TArrayList<TStatement> read FStatements;

    procedure AddAfter(const AStatement: TStatement; const AInsertedStatement: TStatement);
    procedure AddLast(const AStatement: TStatement);
    procedure AddFirstStatement(const AStatement: TStatement; const AYStart: Integer);

    procedure DeleteStatement(const AStatement: TStatement);

    procedure DrawBlock;

    procedure RedefineSizes;
  end;

  var
    DefaultBlock: TStatementClass = nil;

implementation

  { TStatement }

  constructor TStatement.CreateUncertainty(const ABaseBlock: TBlock; const AImage: TImage);
  begin
    Create(UncertaintySymbol, ABaseBlock, AImage);
  end;

  constructor TStatement.Create(const AAction : String; const ABaseBlock: TBlock;
                                const AImage: TImage);
  begin
    FBaseBlock := ABaseBlock;

    FImage := AImage;

    FAction := AAction;
  end;

  procedure TStatement.RedefineSizes;
  var
    I: Integer;
    Blocks: TBlockArr;
  begin
    SetOptimalYLast;
    if Self is TOperator then
    begin
      Blocks:= TOperator(Self).FBlocks;
      for I := 0 to High(Blocks) do
        Blocks[I].RedefineSizes;
    end;
  end;

  function TStatement.YIndentText : Integer;
  begin
    Result:= FImage.Canvas.Font.Size + 3;
  end;

  function TStatement.XMinIndentText : Integer;
  begin
    Result:= FImage.Canvas.Font.Size + 5;
  end;

  function TStatement.HasOptimalYLast : Boolean;
  var
    PrevYLast: Integer;
  begin
    Result:= FYLast = GetOptimalYLast;
  end;

  procedure TStatement.ChangeAction(const AAction: String);
  begin

    FAction := AAction;

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

  function TStatement.GetOptimalYBottom: Integer;
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

      MaxYLast := ABlockArr[0].GetLastStatement.GetOptimalYBottom;
      for I := 1 to High(ABlockArr) do
      begin
        CurrYLast := ABlockArr[I].GetLastStatement.GetOptimalYBottom;;
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

      Index := CurrBlock.FindStatementIndex(CurrOperator.FYStart);
      CurrBlock.ChangeYStatement(Index + 1);

      if Length(CurrOperator.FBlocks) > 1 then
        AlignBlocks(CurrOperator.FBlocks);
    end;
  end;

  procedure TStatement.SetOptimalYLast;
  begin
    FYLast := GetOptimalYLast;
  end;

  procedure TStatement.Lower(const Offset: Integer);
  begin
    Inc(FYStart, Offset);
    Inc(FYLast, Offset);
  end;

  procedure TStatement.InstalAfterAdding;
  begin
    SetOptimalYLast;
    FixYStatementsPosition;
    SetInitiaXLast;
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
                                              const ABaseOperator: TOperator);
  begin
    FStatements := TArrayList<TStatement>.Create(4);

    FXStart := AXStart;
    FXLast := AXLast;

    FBaseOperator := ABaseOperator;
  end;

  procedure TBlock.RedefineSizes;
  var
    I: Integer;
  begin
    SetOptimalXLastBlock;
    for I := 0 to FStatements.Count - 1 do
      FStatements[I].RedefineSizes;
  end;

  procedure TBlock.AddAfter(const AStatement: TStatement;
            const AInsertedStatement: TStatement);
  var
    Index: Integer;
  begin
    Index:= FindStatementIndex(AStatement.FYStart) + 1;

    if Index <> FStatements.Count then
    begin
      AInsertedStatement.FYStart:= AStatement.GetYBottom;
      FStatements.Insert(AInsertedStatement, Index);
      AInsertedStatement.InstalAfterAdding;
    end
    else
      AddLast(AInsertedStatement);
  end;

  procedure TBlock.AddLast(const AStatement: TStatement);
  begin
    FStatements.Add(AStatement);

    if FStatements.Count = 1 then
      AStatement.FYStart:= BaseOperator.FYLast
    else
      AStatement.FYStart:= FStatements[FStatements.Count - 2].GetYBottom;

    if (BaseOperator <> nil) and (Length(BaseOperator.FBlocks) > 1) and
                                           (FStatements.Count > 1) then
      FStatements[FStatements.Count - 2].SetOptimalYLast;

    AStatement.InstalAfterAdding;
  end;

  procedure TBlock.AddFirstStatement(const AStatement: TStatement; const AYStart: Integer);
  begin
    FStatements.Add(AStatement);
    AStatement.FYStart:= AYStart;
  end;

  procedure TBlock.DeleteStatement(const AStatement: TStatement);
  var
    Index: Integer;
  begin

    Index:= FindStatementIndex(AStatement.FYStart);
    FStatements.Delete(Index);

    if FStatements.Count = 0 then
    begin
      AddLast(DefaultBlock.CreateUncertainty(Self, AStatement.FImage));
      FStatements[0].FixYStatementsPosition;
    end
    else if Index = 0 then
      if BaseOperator = nil then
      begin
        FStatements[Index].Lower(AStatement.FYStart - FStatements[Index].FYStart);
        FStatements[Index].FixYStatementsPosition;
      end
      else
        BaseOperator.FixYStatementsPosition
    else
      FStatements[Index - 1].FixYStatementsPosition;

    SetOptimalXLastBlock;

    AStatement.Destroy;
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

    Result:= 0;

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

  function TBlock.FindStatementIndex(const FYStart: Integer): Integer;
  var
    L, R, M: Integer;
  begin

    L := 0;
    R := FStatements.Count - 1;
    Result := -1;

    while L <= R do
    begin

      M := (L + R) div 2;

      if FStatements[M].FYStart = FYStart then
        Exit(M)

      else if FStatements[M].FYStart < FYStart then
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

  { TOperator }
  destructor TOperator.Destroy;
  var
    I: Integer;
  begin

    for I := 0 to High(FBlocks) do
      FBlocks[I].Destroy;

    inherited;
  end;

  function TOperator.FindBlockIndex(const FXStart: Integer): Integer;
  var
    L, R, M: Integer;
  begin

    L := 0;
    R := High(FBlocks);
    Result := -1;

    while L <= R do
    begin

      M := (L + R) div 2;

      if FBlocks[M].FXStart = FXStart then
        Exit(M)

      else if FBlocks[M].FXStart < FXStart then
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
    Result := 0;
    case IsPreсOperator of
      True:
        for I := 0 to High(FBlocks) do
          Result := Max(Result, FBlocks[I].FStatements.GetLast.GetYBottom);
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

  function TOperator.GetOptimalYBottom: Integer;
  var
    I: Integer;
  begin
    Result := 0;
    case IsPreсOperator of
      True:
        for I := 0 to High(FBlocks) do
          Result := Max(Result, FBlocks[I].Statements.GetLast.GetOptimalYBottom);
      False: Result := GetOptimalYLast;
    end;
  end;

  procedure TOperator.InstalAfterAdding;
  begin
    CreateBlock;
    InitializeBlock;

    inherited;
  end;

end.
