unit LastLoop;

interface
uses Base, vcl.graphics, Vcl.ExtCtrls, DrawShapes, DetermineDimensions, Loop;
type

  TLastLoop = class(TLoop)
  private
    function GetBlockYBottom: Integer;
  protected
    procedure InitializeBlock; override;
    function GetOptimalYLast: Integer; override;
  public
    procedure Draw; override;
    function IsPreñOperator: Boolean; override;
  end;

implementation

  function TLastLoop.IsPreñOperator: Boolean;
  begin
    Result:= False;
  end;

  procedure TLastLoop.InitializeBlock;
  begin
    FBlocks[0].AddLast(DefaultBlock.CreateUncertainty(FCanvas));
  end;

  procedure TLastLoop.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, GetBlockYBottom, FYLast, FCanvas);

    DrawRectangle(BaseBlock.XStart, GetXLastStrip, FBlocks[0].Statements[0].YStart,
                                                              GetBlockYBottom, FCanvas);

    EraseLine(BaseBlock.XStart +  1, GetXLastStrip, GetBlockYBottom, GetBlockYBottom, FCanvas);

    DrawText(FCanvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) div 2)
      - (GetTextWidth(FCanvas, Action) div 2), GetBlockYBottom + YIndentText, Action);

    FBlocks[0].DrawBlock;
  end;

  function TLastLoop.GetOptimalYLast: Integer;
  begin
    Result := GetBlockYBottom + GetTextHeight(FCanvas, FAction) + 2 * XMinIndentText;
  end;

  function TLastLoop.GetBlockYBottom: Integer;
  begin
    Result:= FBlocks[0].Statements.GetLast.GetYBottom;
  end;

end.
