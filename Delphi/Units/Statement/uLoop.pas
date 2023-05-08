unit uLoop;

interface
uses uBase;

type
  TLoop = class abstract(TOperator)
  private const
    FBlockCount = 1;
  protected
    FCountPixelCorrection: Integer;
    procedure CreateBlock; override;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
    function GetOptimaWidth: Integer; override;
    procedure SetTextSize; override;
    function GetXLastStrip: Integer;
  public
    property CountPixelCorrection: Integer read FCountPixelCorrection;
    function Clone: TStatement; override;
    function GetOffsetFromXStart: Integer; override;
  end;


implementation

  procedure TLoop.CreateBlock;
  begin
    SetLength(FBlocks, FBlockCount);
    FBlocks[0] := TBlock.Create(Self);
    FBlocks[0].Statements.Add(DefaultStatement.CreateDefault(FBlocks[0]));
  end;

  procedure TLoop.SetTextSize;
  begin
    inherited;
    FCountPixelCorrection:= BaseBlock.Canvas.Font.Size shl 1 + 5;
  end;

  function TLoop.GetOptimaWidth: Integer;
  begin
    Result := FActionSize.Width + FXMinIndentText shl 1;
  end;

  function TLoop.GetXLastStrip: Integer;
  begin
    Result:= FBaseBlock.XStart + FCountPixelCorrection;
  end;

  function TLoop.GetOffsetFromXStart: Integer;
  begin
    Result:= FCountPixelCorrection;
  end;

  function TLoop.Clone: TStatement;
  begin
    Result:= inherited;
    TLoop(Result).FCountPixelCorrection := Self.FCountPixelCorrection;
  end;

  function TLoop.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  begin
    Result:= -1;

    if ABlock = FBlocks[0] then
      Result:= GetOptimaWidth - GetXLastStrip;
  end;

end.
