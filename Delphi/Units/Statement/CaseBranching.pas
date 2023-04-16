unit CaseBranching;

interface
uses Base, vcl.graphics, Vcl.ExtCtrls, Types, CorrectAction,
     DrawShapes, DetermineDimensions;
type

  TCaseBranching = class(TOperator)
  private
    FCond: TStringArr;
  private
    function GetMaxHeightOfCond: Integer;
  protected
    procedure CreateBlock; override;
    procedure InitializeBlock; override;
    function GetOptimaWidth: Integer; override;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
    function GetOptimalYLast: Integer; override;
  public
    constructor Create(const AAction : String;
        const ACond: TStringArr; const ABaseBlock: TBlock; const AImage: TImage);
    procedure Draw; override;
    function IsPreņOperator: Boolean; override;
  end;

implementation

  constructor TCaseBranching.Create(const AAction : String;
        const ACond: TStringArr; const ABaseBlock: TBlock; const AImage: TImage);
  var
    I: Integer;
  begin
    inherited Create(AAction, ABaseBlock, AImage);
    if Length(ACond) > 1 then
      FCond:= ACond;
  end;

  function TCaseBranching.GetMaxHeightOfCond: Integer;
  var
    I: Integer;
    CurrConditionHeight: Integer;
  begin
    Result:= GetTextHeight(FImage.Canvas, FCond[0]);
    for I := 1 to High(FBlocks) do
    begin
      CurrConditionHeight:= GetTextHeight(FImage.Canvas, FCond[I]);
      if CurrConditionHeight > Result then
        Result:= CurrConditionHeight;
    end;
  end;

  function TCaseBranching.GetOptimalYLast: Integer;
  begin
    Result:= FYStart + GetMaxHeightOfCond + GetTextHeight(FImage.Canvas, FAction) + 4 * YIndentText;
  end;

  function TCaseBranching.GetOptimaWidth: Integer;
  begin
    Result:= (GetTextWidth(FImage.Canvas, FAction) + 2 * XMinIndentText) *
             (GetTextHeight(FImage.Canvas, FAction) + 2 * YIndentText) div YIndentText;
  end;

  function TCaseBranching.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  var
    I: Integer;
  begin
    I:= FindBlockIndex(ABlock.XStart);
    Result:= GetTextWidth(FImage.Canvas, FCond[I]) + 2 * XMinIndentText;
  end;

  procedure TCaseBranching.CreateBlock;
  var
    I, BlockSpacing: Integer;
  begin
    SetLength(FBlocks, Length(FCond));

    BlockSpacing:= (BaseBlock.XLast - BaseBlock.XStart) div Length(FBlocks);

    FBlocks[0]:= TBlock.Create(FBaseBlock.XStart,
                       FBaseBlock.XStart + BlockSpacing, Self);

    for I := 1 to High(FBlocks) - 1 do
      FBlocks[I]:= TBlock.Create(FBlocks[I-1].XLast,
                         FBlocks[I-1].XLast + BlockSpacing, Self);


    FBlocks[High(FBlocks)]:= TBlock.Create(FBlocks[High(FBlocks) - 1].XLast, FBaseBlock.XLast, Self);
  end;

  procedure TCaseBranching.InitializeBlock;
  var
    I: Integer;
  begin
    for I := 0 to High(FBlocks) do
      FBlocks[I].AddFirstStatement(DefaultBlock.CreateUncertainty(FBlocks[I], FImage), FYLast);
  end;

  function TCaseBranching.IsPreņOperator: Boolean;
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
    YTriangleHeight:= FYStart + GetTextHeight(FImage.Canvas, FAction) + 2 * YIndentText;

    // Drawing the main block
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, FImage);

    // Drawing a triangle
    DrawInvertedTriangle(BaseBlock.XStart, FBlocks[High(FBlocks)].XStart,
          BaseBlock.XLast, FYStart, YTriangleHeight, FImage.Canvas);

    // Draw a line that connects the vertex of the triangle and
    // the lower base of the operator
    DrawLine(FBlocks[High(FBlocks)].XStart, FBlocks[High(FBlocks)].XStart,
             YTriangleHeight, FYLast, FImage.Canvas);

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
          FYLast, FImage.Canvas);
    end;

    { End }

    // Drawing the action
    DrawText(FImage.Canvas,
      BaseBlock.XStart
      +
      LeftTriangleWidth * (GetTextHeight(FImage.Canvas, FAction) +  YIndentText) div (YTriangleHeight - FYStart)
      +
      (BaseBlock.XLast - BaseBlock.XStart) * YIndentText div (YTriangleHeight - FYStart) div 2
      -
      GetTextWidth(FImage.Canvas, FAction) div 2
      ,
      FYStart + YIndentText, Action);

    // Drawing the conditions
    Inc(YTriangleHeight, YIndentText);
    for I := 0 to High(FCond) do
      DrawText(FImage.Canvas,
        Blocks[I].XStart + ((Blocks[I].XLast - Blocks[I].XStart) div 2)
        - (GetTextWidth(FImage.Canvas, FCond[I]) div 2),
        YTriangleHeight, FCond[I]);

    // Drawing child blocks
    for I := 0 to High(FBlocks) do
      FBlocks[I].DrawBlock;
  end;

end.
