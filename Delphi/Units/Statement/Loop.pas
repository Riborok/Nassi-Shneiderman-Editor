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
    procedure InitializeBlock; override;
  public
    function GetXLastStrip: Integer;
  end;


implementation

  procedure TLoop.CreateBlock;
  begin
    SetLength(FBlocks, FBlockCount);
    FBlocks[0] := TBlock.Create(GetXLastStrip, FBaseBlock.XLast, Self, BaseBlock.Canvas);
  end;

  procedure TLoop.InitializeBlock;
  var
    NewStatement: TStatement;
  begin
    NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[0]);
    FBlocks[0].Statements.Add(NewStatement);
    NewStatement.SetOptimalYLast;
  end;

  function TLoop.GetOptimaWidth: Integer;
  begin
    Result := GetTextWidth(BaseBlock.Canvas, FAction) + 2 * XMinIndentText;
  end;

  function TLoop.GetXLastStrip: Integer;
  begin
    Result:= FBaseBlock.XStart + GetAmountOfPixelCorrection;
  end;

  function TLoop.GetAmountOfPixelCorrection: Integer;
  begin
    Result:= 2 * BaseBlock.Canvas.Font.Size + 5;
  end;

  function TLoop.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  begin
    Result:= -1;

    if ABlock = FBlocks[0] then
      Result:= GetOptimaWidth - GetXLastStrip;
  end;

end.
