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
    function IsPreņOperator: Boolean; override;
  end;

implementation

  function TLastLoop.IsPreņOperator: Boolean;
  begin
    Result:= False;
  end;

  procedure TLastLoop.InitializeBlock;
  var
    NewStatement: TStatement;
  begin
    NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[0], FImage);
    FBlocks[0].AddLast(NewStatement);
  end;

  procedure TLastLoop.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, GetBlockYBottom, FYLast, FImage);

    DrawRectangle(BaseBlock.XStart, GetXLastStrip, FBlocks[0].Statements[0].YStart,
                                                              GetBlockYBottom, FImage);

    Erase(BaseBlock.XStart +  1, GetXLastStrip, GetBlockYBottom, GetBlockYBottom, FImage.Canvas);

    DrawText(FImage.Canvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) div 2)
      - (GetTextWidth(FImage.Canvas, Action) div 2), GetBlockYBottom + YIndentText, Action);

    FBlocks[0].DrawBlock;
  end;

  function TLastLoop.GetOptimalYLast: Integer;
  begin
    Result := GetBlockYBottom + GetTextHeight(FImage.Canvas, FAction) + 2 * XMinIndentText;
  end;

  function TLastLoop.GetBlockYBottom: Integer;
  begin
    Result:= FBlocks[0].Statements.GetLast.GetYBottom;
  end;

end.
