unit CaseBranching;

interface
uses Base, vcl.graphics, Vcl.ExtCtrls, Types, CorrectAction,
     DrawShapes, DetermineDimensions, MinMaxInt;
type

  TCaseBranching = class(TOperator)
  private
    FCond: TStringArr;
  private
    function GetMaxHeightOfCond: Integer;
  protected
    procedure CreateBlock; override;
    procedure CreateBlockStarting(AStartIndex: Integer; const ABlockWidth: Integer);
    procedure InitializeBlock; override;
    procedure InitializeBlockStarting(const AStartIndex: Integer);

    function GetOptimaWidth: Integer; override;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
    function GetOptimalYLast: Integer; override;
  public
    constructor Create(const AAction : String;
        const ACond: TStringArr; ABaseBlock: TBlock);
    procedure Draw; override;
    function IsPre�Operator: Boolean; override;

    procedure ChangeActionWithCond(const AAction: String; const ACond: TStringArr);

    property Cond: TStringArr read Fcond;

    function Clone: TStatement; override;
  end;

implementation

  constructor TCaseBranching.Create(const AAction : String; const ACond: TStringArr;
                                    ABaseBlock: TBlock);
  begin
    FCond:= ACond;
    inherited Create(AAction, ABaseBlock);
  end;

  procedure TCaseBranching.ChangeActionWithCond(const AAction: String; const ACond: TStringArr);
  var
    I: Integer;
    PrevCond: TStringArr;
  begin

    PrevCond:= FCond;
    FCond:= ACond;

    // Check what conditions have changed
    for I := 0 to Min(High(PrevCond), High(FCond)) do
      if FCond[I] <> PrevCond[I] then
        Blocks[I].SetOptimalXLastBlock;

    // Remove blocks if the amount of conditions has decreased
    for I := Length(FCond) to High(Blocks) do
      Blocks[I].Destroy;

    // Setting a new amount for blocks
    SetLength(FBlocks, Length(FCond));

    // Add new blocks if the amount of conditions has increased
    if Length(PrevCond) <= High(FCond) then
    begin
      // Set the width to zero, to untie the X of the last block. In the future
      // will set the optimal width
      Blocks[High(PrevCond)].ChangeXLastBlock(Blocks[High(PrevCond)].XStart);

      // �reate and initialize new blocks. Set the width to zero, in the future
      // will set the optimal width
      CreateBlockStarting(Length(PrevCond), 0);
      InitializeBlockStarting(Length(PrevCond));

      // Set the optimal width of the last block, as promised :)
      Blocks[High(PrevCond)].SetOptimalXLastBlock;

      // Set dimensions after adding
      for I := Length(PrevCond) to High(FCond) do
        Blocks[I].Statements.GetLast.Install;
    end;

    // Changing the action
    ChangeAction(AAction);
  end;

  function TCaseBranching.Clone: TStatement;
  var
    I: Integer;
    ResultOperator: TOperator;
  begin
    Result:= inherited;
    TCaseBranching(Result).FCond:= Self.FCond;
  end;

  function TCaseBranching.GetMaxHeightOfCond: Integer;
  var
    I: Integer;
    CurrConditionHeight: Integer;
  begin
    Result:= GetTextHeight(BaseBlock.Canvas, FCond[0]);
    for I := 1 to High(FCond) do
    begin
      CurrConditionHeight:= GetTextHeight(BaseBlock.Canvas, FCond[I]);
      if CurrConditionHeight > Result then
        Result:= CurrConditionHeight;
    end;
  end;

  function TCaseBranching.GetOptimalYLast: Integer;
  begin
    Result:= FYStart + GetMaxHeightOfCond + GetTextHeight(BaseBlock.Canvas, FAction) + 4 * YIndentText;
  end;

  function TCaseBranching.GetOptimaWidth: Integer;
  begin
    Result:= (GetTextWidth(BaseBlock.Canvas, FAction) + 2 * XMinIndentText) *
             (GetTextHeight(BaseBlock.Canvas, FAction) + 2 * YIndentText) div YIndentText;
  end;

  function TCaseBranching.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  begin
    Result:= GetTextWidth(BaseBlock.Canvas, FCond[FindBlockIndex(ABlock.XStart)]) + 2 * XMinIndentText;
  end;

  procedure TCaseBranching.CreateBlock;
  begin
    SetLength(FBlocks, Length(FCond));
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

  function TCaseBranching.IsPre�Operator: Boolean;
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
    YTriangleHeight:= FYStart + GetTextHeight(BaseBlock.Canvas, FAction) + 2 * YIndentText;

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
      LeftTriangleWidth * (GetTextHeight(BaseBlock.Canvas, FAction) +  YIndentText) div (YTriangleHeight - FYStart)
      +
      (BaseBlock.XLast - BaseBlock.XStart) * YIndentText div (YTriangleHeight - FYStart) div 2
      -
      GetTextWidth(BaseBlock.Canvas, FAction) div 2
      ,
      FYStart + YIndentText, Action);

    // Drawing the conditions
    Inc(YTriangleHeight, YIndentText);
    for I := 0 to High(FCond) do
      DrawText(BaseBlock.Canvas,
        Blocks[I].XStart + ((Blocks[I].XLast - Blocks[I].XStart) div 2)
        - (GetTextWidth(BaseBlock.Canvas, FCond[I]) div 2),
        YTriangleHeight, FCond[I]);

    // Drawing child blocks
    for I := 0 to High(FBlocks) do
      FBlocks[I].DrawBlock;
  end;

end.
