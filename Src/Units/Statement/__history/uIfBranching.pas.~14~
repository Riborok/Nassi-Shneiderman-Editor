unit uIfBranching;

interface
uses uBase, uDrawShapes, uMinMaxInt, uDetermineDimensions, uAdditionalTypes, uConstants;
type

  TIfBranching = class(TOperator)
  private const
    FBlockCount = 2;
  private class var
    FTrueCond, FFalseCond: string;
  private
    FTrueSize, FFalseSize: TSize;
    function GetAvailablePartWidth(const APartWidth, ATextHeight: Integer): Integer;
    function GetMinValidPartWidth(const ATextHeight, ATextWidth: Integer): Integer;
  protected
    procedure SetTextSize; override;
    function GetOptimaWidth: Integer; override;
    procedure CreateBlock; override;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
    function GetOptimalYLast: Integer; override;
    procedure Draw; override;
  public
    function IsPreсOperator: Boolean; override;
    function Clone: TStatement; override;

    class property TrueCond: string read FTrueCond write FTrueCond;
    class property FalseCond: string read FFalseCond write FFalseCond;
  end;

implementation

  procedure TIfBranching.SetTextSize;
  begin
    inherited;
    FTrueSize := GetTextSize(BaseBlock.Canvas, FTrueCond);

    FFalseSize := GetTextSize(BaseBlock.Canvas, FFalseCond);
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

  function TIfBranching.GetOptimalYLast: Integer;
  begin
    Result := FYStart + Max(FTrueSize.Height, FFalseSize.Height) +
              FActionSize.Height + 3 * FYIndentText;
  end;

  function TIfBranching.IsPreсOperator: Boolean;
  begin
    Result:= True;
  end;

  procedure TIfBranching.CreateBlock;
  begin
    SetLength(FBlocks, FBlockCount);
    FBlocks[0]:= TBlock.Create(Self);
    FBlocks[1]:= TBlock.Create(Self);
    FBlocks[0].Statements.Add(DefaultStatement.CreateDefault(FBlocks[0]));
    FBlocks[1].Statements.Add(DefaultStatement.CreateDefault(FBlocks[1]));
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
  begin
    if ABlock = FBlocks[0] then
      Result:= GetMinValidPartWidth(FTrueSize.Height, FTrueSize.Width)
    else
      Result:= GetMinValidPartWidth(FFalseSize.Height, FFalseSize.Width);
  end;

  procedure TIfBranching.Draw;
  begin

    // Drawing the main block
    DrawRect(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, BaseBlock.Canvas);

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
                    FYStart + FYIndentText shl 1 + FActionSize.Height, FTrueCond);

    // Drawing the False text
    DrawText(BaseBlock.Canvas,
                    FBlocks[1].XLast - GetAvailablePartWidth(
                    FBlocks[1].XLast - FBlocks[1].XStart, FFalseSize.Height) shr 1 -
                    FFalseSize.Width shr 1,
                    FYStart + FYIndentText shl 1 + FActionSize.Height, FFalseCond);
  end;

end.
