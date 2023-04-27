unit CaseBranching;

interface
uses Base, AdditionalTypes, DrawShapes, DetermineDimensions, MinMaxInt, CaseBlockSorting;
type

  TCaseBranching = class(TOperator)
  private
    FConds: TStringArr;
    FCondsSizes: TSizeArr;
    function GetMaxHeightOfConds: Integer;
    procedure SetCondSize(const AIndex: Integer);
    procedure RepositionBlocksByX;
  protected
    procedure SetTextSize; override;
    procedure CreateBlock; override;
    procedure CreateBlockStarting(AStartIndex: Integer; const ABlockWidth: Integer);
    procedure InitializeBlock; override;
    procedure InitializeBlockStarting(const AStartIndex: Integer);

    function GetOptimaWidth: Integer; override;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
    function GetOptimalYLast: Integer; override;

    procedure Draw; override;
  public
    constructor Create(const AAction : String;
        const AConds: TStringArr; const ABaseBlock: TBlock);
    function IsPreсOperator: Boolean; override;

    procedure ChangeActionWithConds(const AAction: String; const AConds: TStringArr);

    function Clone: TStatement; override;

    procedure SortConditions(const SortNumber: Integer);

    property Conds: TStringArr read FConds;
  end;

implementation

  constructor TCaseBranching.Create(const AAction : String; const AConds: TStringArr;
                                    const ABaseBlock: TBlock);
  begin
    FConds:= AConds;
    SetLength(FCondsSizes, Length(AConds));
    inherited Create(AAction, ABaseBlock);
  end;

  procedure TCaseBranching.SetCondSize(const AIndex: Integer);
  begin
    FCondsSizes[AIndex] := GetTextSize(BaseBlock.Canvas, FConds[AIndex]);
  end;

  procedure TCaseBranching.SortConditions(const SortNumber: Integer);
  var
    Compare: TCompareFunction;
    LastBlock: TBlock;
  begin
    case SortNumber of
      0: Compare:= CompareStrAsc;
      1: Compare:= CompareStrDesc;
    end;

    // Finding the last block before sorting
    LastBlock:= FBlocks[High(FBlocks)];

    // Decrease the last x by 1 to untie it from the base block
    LastBlock.ChangeXLastBlock(LastBlock.XLast - 1);

    // Sorting blocks
    QuickSort(FConds, FCondsSizes, FBlocks, Compare);

    // Move the blocks in a new order
    RepositionBlocksByX;

    // Set the optimal length for the last block before sorting
    LastBlock.SetOptimalXLastBlock;

    // Stretch the new last block to the base
    LastBlock:= FBlocks[High(FBlocks)];
    LastBlock.ChangeXLastBlock(FBaseBlock.XLast);
  end;

  procedure TCaseBranching.RepositionBlocksByX;
  var
    I: Integer;
  begin
    FBlocks[0].MoveRight(BaseBlock.XStart - FBlocks[0].XStart);

    for I := 1 to High(FBlocks) do
      FBlocks[I].MoveRight(FBlocks[I - 1].XLast - FBlocks[I].XStart);
  end;

  procedure TCaseBranching.SetTextSize;
  var
    I: Integer;
  begin
    inherited;
    for I := 0 to High(FConds) do
      SetCondSize(I);
  end;

  procedure TCaseBranching.ChangeActionWithConds(const AAction: String; const AConds: TStringArr);
  var
    I: Integer;
    PrevCond: TStringArr;
  begin

    PrevCond:= FConds;
    FConds:= AConds;

    SetLength(FCondsSizes, Length(AConds));

    // Check what conditions have changed
    for I := 0 to Min(High(PrevCond), High(FConds)) do
      if FConds[I] <> PrevCond[I] then
      begin
        SetCondSize(I);
        FBlocks[I].SetOptimalXLastBlock;
      end;

    // Remove blocks if the amount of conditions has decreased
    for I := Length(FConds) to High(FBlocks) do
      FBlocks[I].Destroy;

    // Setting a new amount for blocks
    SetLength(FBlocks, Length(AConds));

    // Add new blocks if the amount of conditions has increased
    if Length(PrevCond) <= High(FConds) then
    begin
      // Set the width to one, to untie the X of the last block. In the future
      // will set the optimal width
      FBlocks[High(PrevCond)].ChangeXLastBlock(FBlocks[High(PrevCond)].XStart + 1);

      // Сreate and initialize new blocks. Set the width to one. In the future
      // will set the optimal width
      CreateBlockStarting(Length(PrevCond), 1);
      InitializeBlockStarting(Length(PrevCond));

      // Set the optimal width of the last block
      FBlocks[High(PrevCond)].SetOptimalXLastBlock;

      // Set dimensions after adding
      for I := Length(PrevCond) to High(FConds) do
      begin
        SetCondSize(I);
        FBlocks[I].Statements[0].Install;
      end;
    end;

    // Changing the action
    ChangeAction(AAction);
  end;

  function TCaseBranching.Clone: TStatement;
  var
    ResultCase: TCaseBranching;
  begin
    Result:= inherited;

    ResultCase:= TCaseBranching(Result);

    ResultCase.FConds:= Self.FConds;

    ResultCase.FCondsSizes:= Self.FCondsSizes;
  end;

  function TCaseBranching.GetMaxHeightOfConds: Integer;
  var
    I: Integer;
  begin
    Result:= FCondsSizes[0].Height;
    for I := 1 to High(FConds) do
      if FCondsSizes[I].Height > Result then
        Result:= FCondsSizes[I].Height;
  end;

  function TCaseBranching.GetOptimalYLast: Integer;
  begin
    Result:= FYStart + GetMaxHeightOfConds + FActionSize.Height + FYIndentText shl 2;
  end;

  function TCaseBranching.GetOptimaWidth: Integer;
  begin
    Result:= (FActionSize.Width + FXMinIndentText shl 1) *
             (FActionSize.Height + FYIndentText shl 1) div FYIndentText;
  end;

  function TCaseBranching.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  begin
    Result:= FCondsSizes[FindBlockIndex(ABlock.XStart)].Width + FXMinIndentText shl 1;
  end;

  procedure TCaseBranching.CreateBlock;
  begin
    SetLength(FBlocks, Length(FConds));
    CreateBlockStarting(0, (BaseBlock.XLast - BaseBlock.XStart) div Length(FBlocks));
  end;

  procedure TCaseBranching.CreateBlockStarting(AStartIndex: Integer; const ABlockWidth: Integer);
  var
    I: Integer;
  begin
    if AStartIndex = 0 then
    begin
      FBlocks[0]:= TBlock.Create(FBaseBlock.XStart, FBaseBlock.XStart + ABlockWidth, Self, BaseBlock.Canvas);
      Inc(AStartIndex);
    end;

    for I := AStartIndex to High(FBlocks) - 1 do
      FBlocks[I]:= TBlock.Create(FBlocks[I-1].XLast,
                        FBlocks[I-1].XLast + ABlockWidth, Self, BaseBlock.Canvas);

    FBlocks[High(FBlocks)]:= TBlock.Create(FBlocks[High(FBlocks) - 1].XLast,
                        FBaseBlock.XLast, Self, BaseBlock.Canvas);
  end;

  procedure TCaseBranching.InitializeBlock;
  begin
    InitializeBlockStarting(0);
  end;

  procedure TCaseBranching.InitializeBlockStarting(const AStartIndex: Integer);
  var
    I: Integer;
    NewStatement: TStatement;
  begin
    for I := AStartIndex to High(FBlocks) do
    begin
      NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[I]);
      FBlocks[I].Statements.Add(NewStatement);
      NewStatement.SetOptimalYLast;
    end;
  end;

  function TCaseBranching.IsPreсOperator: Boolean;
  begin
    Result:= True;
  end;

  procedure TCaseBranching.Draw;
  var
    I: Integer;
    YTriangleHeight : Integer;
    LeftTriangleWidth : Integer;
    PartLeftTriangleWidth : Integer;
  begin

    // Calculate the height of a triangle
    YTriangleHeight:= FYStart + FActionSize.Height + FYIndentText shl 1;

    // Drawing the main block
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, BaseBlock.Canvas);

    // Drawing a triangle
    DrawInvertedTriangle(BaseBlock.XStart, FBlocks[High(FBlocks)].XStart,
          BaseBlock.XLast, FYStart, YTriangleHeight, BaseBlock.Canvas);

    // Draw a line that connects the vertex of the triangle and
    // the lower base of the operator
    DrawLine(FBlocks[High(FBlocks)].XStart, FBlocks[High(FBlocks)].XStart,
             YTriangleHeight, FYLast, BaseBlock.Canvas);

    { Draw the lines that connect the side of the triangle to the side of the block }

    // Calculate the width to the left of the vertex of the triangle
    LeftTriangleWidth:= 0;
    for I := 0 to High(FBlocks) - 1 do
      Inc(LeftTriangleWidth, FBlocks[I].XLast - FBlocks[I].XStart);

    // Find the Y coordinate for each block
    PartLeftTriangleWidth:= LeftTriangleWidth;
    for I := 0 to High(FBlocks) - 2 do
    begin
      Dec(PartLeftTriangleWidth, FBlocks[I].XLast - FBlocks[I].XStart);

      DrawLine(FBlocks[I].XLast, FBlocks[I].XLast,
          YTriangleHeight - (YTriangleHeight - FYStart) * PartLeftTriangleWidth div LeftTriangleWidth,
          FYLast, BaseBlock.Canvas);
    end;

    { End }

    // Drawing the action
    DrawText(BaseBlock.Canvas,
      BaseBlock.XStart
      +
      LeftTriangleWidth * (FActionSize.Height +  FYIndentText) div (YTriangleHeight - FYStart)
      +
      (BaseBlock.XLast - BaseBlock.XStart) * FYIndentText div (YTriangleHeight - FYStart) shr 1
      -
      FActionSize.Width shr 1
      ,
      FYStart + FYIndentText, Action);

    // Drawing the conditions
    Inc(YTriangleHeight, FYIndentText);
    for I := 0 to High(FConds) do
      DrawText(BaseBlock.Canvas,
        FBlocks[I].XStart + ((FBlocks[I].XLast - FBlocks[I].XStart) shr 1)
        - (FCondsSizes[I].Width shr 1),
        YTriangleHeight, FConds[I]);

  end;

end.
