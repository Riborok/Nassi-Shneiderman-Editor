unit Loop;

interface
uses Base, Vcl.ExtCtrls, DetermineDimensions;

type
  TLoop = class abstract(TOperator)
  protected const
    FBlockCount = 1;
  protected
    FBlock: TBlockArr;
    procedure CreateBlock(const ABaseBlock: TBlock); override;
    function GetAmountOfPixelCorrection: Integer;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
    procedure SetInitiaXLast; override;
    function GetOptimaWidth: Integer; override;
  public
    function GetXLastStrip: Integer;
    function GetBlocks: TBlockArr; override;
    function GetBlockCount: Integer; override;
  end;


implementation

  procedure TLoop.CreateBlock(const ABaseBlock: TBlock);
  begin
    SetLength(FBlock, FBlockCount);
    FBlock[0] := TBlock.Create(GetXLastStrip, ABaseBlock.XLast, Self);
  end;

  function TLoop.GetOptimaWidth: Integer;
  begin
    Result := GetTextWidth(FImage.Canvas, FAction) + 2 * XMinIndentText;
  end;

  procedure TLoop.SetInitiaXLast;
  begin
    FBlock[0].SetOptimalXLastBlock;
  end;

  function TLoop.GetXLastStrip: Integer;
  begin
    Result:= FBaseBlock.XStart + GetAmountOfPixelCorrection;
  end;

  function TLoop.GetAmountOfPixelCorrection: Integer;
  begin
    Result:= 2 * FImage.Canvas.Font.Size + 5;
  end;

  function TLoop.GetBlocks: TBlockArr;
  begin
    Result:= FBlock;
  end;

  function TLoop.GetBlockCount: Integer;
  begin
    Result:= FBlockCount;
  end;

  function TLoop.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  begin
    Result:= -1;

    if ABlock = FBlock[0] then
      Result:= GetOptimaWidth + GetXLastStrip;
  end;

end.
