unit Loop;

interface
uses Base, Vcl.ExtCtrls, DetermineDimensions;

type
  TLoop = class abstract(TOperator)
  private const
    FBlockCount = 1;
  protected
    procedure CreateBlock; override;
    function GetAmountOfPixelCorrection: Integer;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
    function GetOptimaWidth: Integer; override;
  public
    function GetXLastStrip: Integer;
  end;


implementation

  procedure TLoop.CreateBlock;
  begin
    SetLength(FBlocks, FBlockCount);
    FBlocks[0] := TBlock.Create(GetXLastStrip, FBaseBlock.XLast, Self);
  end;

  function TLoop.GetOptimaWidth: Integer;
  begin
    Result := GetTextWidth(FCanvas, FAction) + 2 * XMinIndentText;
  end;

  function TLoop.GetXLastStrip: Integer;
  begin
    Result:= FBaseBlock.XStart + GetAmountOfPixelCorrection;
  end;

  function TLoop.GetAmountOfPixelCorrection: Integer;
  begin
    Result:= 2 * FCanvas.Font.Size + 5;
  end;

  function TLoop.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  begin
    Result:= -1;

    if ABlock = FBlocks[0] then
      Result:= GetOptimaWidth - GetXLastStrip;
  end;

end.
