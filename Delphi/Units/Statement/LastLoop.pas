unit LastLoop;

interface
uses Base, vcl.graphics, Vcl.ExtCtrls, DrawShapes, DetermineDimensions, Loop;
type

  TLastLoop = class(TLoop)
  private
    function GetBlockYBottom: Integer;
  protected
    function GetOptimalYLast: Integer; override;
  public
    procedure Draw; override;
    function IsPreņOperator: Boolean; override;
  end;

implementation

  function TLastLoop.IsPreņOperator: Boolean;
  begin
    Result:= False;
  end;

  procedure TLastLoop.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, GetBlockYBottom, FYLast, BaseBlock.Canvas);

    DrawRectangle(BaseBlock.XStart, GetXLastStrip, FBlocks[0].Statements[0].YStart,
                                                              GetBlockYBottom, BaseBlock.Canvas);

    EraseLine(BaseBlock.XStart +  1, GetXLastStrip, GetBlockYBottom, GetBlockYBottom, BaseBlock.Canvas);

    DrawText(BaseBlock.Canvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) div 2)
      - (GetTextWidth(BaseBlock.Canvas, Action) div 2), GetBlockYBottom + YIndentText, Action);

    FBlocks[0].DrawBlock;
  end;

  function TLastLoop.GetOptimalYLast: Integer;
  begin
    Result := GetBlockYBottom + GetTextHeight(BaseBlock.Canvas, FAction) + 2 * XMinIndentText;
  end;

  function TLastLoop.GetBlockYBottom: Integer;
  begin
    Result:= FBlocks[0].Statements.GetLast.GetYBottom;
  end;

end.
