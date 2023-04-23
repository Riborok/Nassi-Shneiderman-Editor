unit IfBranching;

interface
uses Base, DrawShapes, MinMaxInt, DetermineDimensions, Types;
type

  TIfBranching = class(TOperator)
  private const
    FBlockCount = 2;
  private class var
    TrueCond, FalseCond: String;
  private
    FTrueSize, FFalseSize: TSize;
    function GetAvailablePartWidth(const APartWidth, ATextHeight: Integer): Integer;
    function GetMinValidPartWidth(const ATextHeight, ATextWidth: Integer): Integer;
  protected
    procedure SetTextSize; override;
    function GetOptimaWidth: Integer; override;
    procedure CreateBlock; override;
    procedure InitializeBlock; override;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
    function GetOptimalYLast: Integer; override;
    procedure Draw; override;
  public
    function IsPreсOperator: Boolean; override;
    class procedure ChangeConditions(const ATrue, AFalse: String);
    function Clone: TStatement; override;
  end;

implementation

  procedure TIfBranching.SetTextSize;
  begin
    inherited;
    FTrueSize := GetTextSize(BaseBlock.Canvas, TrueCond);

    FFalseSize := GetTextSize(BaseBlock.Canvas, FalseCond);
  end;

  function TIfBranching.Clone: TStatement;
  var
    ResultIf: TIfBranching;
  begin
    Result:= inherited;
    ResultIf:= TIfBranching(Result);

    ResultIf.FTrueSize := Self.FTrueSize;

    ResultIf.FFalseSize := Self.FFalseSize;
  end;

  class procedure TIfBranching.ChangeConditions(const ATrue, AFalse: String);
  begin
    TrueCond:= ATrue;
    FalseCond:= AFalse;
  end;

  function TIfBranching.GetOptimalYLast: Integer;
  begin
    Result := FYStart + Max(FTrueSize.Height, FFalseSize.Height) + FActionSize.Height + 3 * FYIndentText;
  end;

  function TIfBranching.IsPreсOperator: Boolean;
  begin
    Result:= True;
  end;

  procedure TIfBranching.CreateBlock;
  begin
    SetLength(FBlocks, FBlockCount);

    FBlocks[0]:= TBlock.Create(FBaseBlock.XStart,
                       (FBaseBlock.XStart + FBaseBlock.XLast) shr 1, Self, BaseBlock.Canvas);

    FBlocks[1]:= TBlock.Create(FBlocks[0].XLast, FBaseBlock.XLast, Self, BaseBlock.Canvas);
  end;

  procedure TIfBranching.InitializeBlock;
  var
    NewStatement: TStatement;
  begin
    NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[0]);
    FBlocks[0].Statements.Add(NewStatement);
    NewStatement.SetOptimalYLast;

    NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[1]);
    FBlocks[1].Statements.Add(NewStatement);
    NewStatement.SetOptimalYLast;
  end;

  function TIfBranching.GetAvailablePartWidth(const APartWidth, ATextHeight: Integer): Integer;
  begin
    Result:= APartWidth *
             (FYLast - FYStart - ATextHeight - FYIndentText) div (FYLast - FYStart);
  end;

  function TIfBranching.GetMinValidPartWidth(const ATextHeight,
                                             ATextWidth: Integer): Integer;
  begin
    Result:= (ATextWidth + FXMinIndentText shl 1) *
             (FYLast - FYStart) div (FYLast - FYStart - ATextHeight - FYIndentText);
  end;

  function TIfBranching.GetOptimaWidth: Integer;
  begin
    Result:= GetMinValidPartWidth(FActionSize.Height, FActionSize.Width);
  end;

  function TIfBranching.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  var
    I: Integer;
  begin
    if ABlock = FBlocks[0] then
      Result:= GetMinValidPartWidth(FTrueSize.Height, FTrueSize.Width)
    else if ABlock = FBlocks[1] then
      Result:= GetMinValidPartWidth(FFalseSize.Height, FFalseSize.Width);
  end;

  procedure TIfBranching.Draw;
  begin

    // Drawing the main block
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, BaseBlock.Canvas);

    // Drawing a triangle
    DrawInvertedTriangle(BaseBlock.XStart, FBlocks[1].XStart, BaseBlock.XLast,
                                                FYStart, FYLast, BaseBlock.Canvas);

    // Drawing the action
    DrawText(BaseBlock.Canvas,
      FBlocks[0].XStart +
      GetAvailablePartWidth(FBlocks[0].XLast - FBlocks[0].XStart, FTrueSize.Height + FYIndentText) +
      GetAvailablePartWidth(BaseBlock.XLast - BaseBlock.XStart, FActionSize.Height) shr 1 -
      FActionSize.Width shr 1,
      FYStart + FYIndentText, Action);

    // Drawing the True text
    DrawText(BaseBlock.Canvas,
                    FBlocks[0].XStart + GetAvailablePartWidth(
                    FBlocks[0].XLast - FBlocks[0].XStart, FTrueSize.Height) shr 1 -
                    FTrueSize.Width shr 1,
                    FYStart + FYIndentText shl 1 + FActionSize.Height, TrueCond);

    // Drawing the False text
    DrawText(BaseBlock.Canvas,
                    FBlocks[1].XLast - GetAvailablePartWidth(
                    FBlocks[1].XLast - FBlocks[1].XStart, FFalseSize.Height) shr 1 -
                    FFalseSize.Width shr 1,
                    FYStart + FYIndentText shl 1 + FActionSize.Height, FalseCond);

    // Drawing child blocks
    FBlocks[0].DrawBlock;
    FBlocks[1].DrawBlock;
  end;


  initialization
  TIfBranching.TrueCond := 'False';
  TIfBranching.FalseCond := 'True';

end.
