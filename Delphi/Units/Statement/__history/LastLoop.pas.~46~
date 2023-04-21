unit LastLoop;

interface
uses DrawShapes, Loop;
type

  TLastLoop = class(TLoop)
  private
    function GetBlockYBottom: Integer;
  protected
    function GetOptimalYLast: Integer; override;
    procedure Draw; override;
  public
    function IsPreсOperator: Boolean; override;
  end;

implementation

  function TLastLoop.IsPreсOperator: Boolean;
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
      - (FActionSize.Width div 2), GetBlockYBottom + FYIndentText, Action);

    FBlocks[0].DrawBlock;
  end;

  function TLastLoop.GetOptimalYLast: Integer;
  begin
    Result := GetBlockYBottom + FActionSize.Height + 2 * FXMinIndentText;
  end;

  function TLastLoop.GetBlockYBottom: Integer;
  begin
    Result:= FBlocks[0].Statements.GetLast.GetYBottom;
  end;

end.
