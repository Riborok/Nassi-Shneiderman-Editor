unit FirstLoop;

interface
uses Base, Vcl.graphics, Vcl.ExtCtrls, DrawShapes, DetermineDimensions, Loop;
type

  TFirstLoop = class(TLoop)
  protected
    procedure InitializeBlock; override;
    function GetOptimalYLast: Integer; override;
  public
    procedure Draw; override;
    function IsPreņOperator: Boolean; override;
  end;

implementation

  function TFirstLoop.IsPreņOperator: Boolean;
  begin
    Result:= True;
  end;

  procedure TFirstLoop.InitializeBlock;
  begin
    FBlocks[0].AddLast(DefaultBlock.CreateUncertainty(FCanvas));
  end;

  function TFirstLoop.GetOptimalYLast: Integer;
  begin
    Result := FYStart + GetTextHeight(FCanvas, FAction) + 2 * YIndentText;
  end;

  procedure TFirstLoop.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, FCanvas);

    DrawRectangle(BaseBlock.XStart, GetXLastStrip, FYLast, GetYBottom, FCanvas);

    EraseLine(BaseBlock.XStart +  1, GetXLastStrip, FYLast, FYLast, FCanvas);

    DrawText(FCanvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) div 2)
      - (GetTextWidth(FCanvas, Action) div 2), FYStart + YIndentText, Action);

    FBlocks[0].DrawBlock;
  end;

end.
