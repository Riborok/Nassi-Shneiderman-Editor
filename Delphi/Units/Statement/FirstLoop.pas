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
    function IsPreñOperator: Boolean; override;
  end;

implementation

  function TFirstLoop.IsPreñOperator: Boolean;
  begin
    Result:= True;
  end;

  procedure TFirstLoop.InitializeBlock;
  begin
    FBlocks[0].AddLast(DefaultBlock.CreateUncertainty);
  end;

  function TFirstLoop.GetOptimalYLast: Integer;
  begin
    Result := FYStart + GetTextHeight(BaseBlock.Canvas, FAction) + 2 * YIndentText;
  end;

  procedure TFirstLoop.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, BaseBlock.Canvas);

    DrawRectangle(BaseBlock.XStart, GetXLastStrip, FYLast, GetYBottom, BaseBlock.Canvas);

    EraseLine(BaseBlock.XStart +  1, GetXLastStrip, FYLast, FYLast, BaseBlock.Canvas);

    DrawText(BaseBlock.Canvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) div 2)
      - (GetTextWidth(BaseBlock.Canvas, Action) div 2), FYStart + YIndentText, Action);

    FBlocks[0].DrawBlock;
  end;

end.
