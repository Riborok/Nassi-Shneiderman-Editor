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
  var
    NewStatement: TStatement;
  begin
    NewStatement:= DefaultBlock.CreateUncertainty(FYLast, FBlocks[0], FImage);
    FBlocks[0].Statements.Add(NewStatement);
    NewStatement.SetOptimalYLast;
  end;

  function TFirstLoop.GetOptimalYLast: Integer;
  begin
    Result := FYStart + GetTextHeight(FImage.Canvas, FAction) + 2 * YIndentText;
  end;

  procedure TFirstLoop.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, FImage);

    DrawRectangle(BaseBlock.XStart, GetXLastStrip, FYLast, GetYBottom, FImage);

    Erase(BaseBlock.XStart +  1, GetXLastStrip, FYLast, FYLast, FImage.Canvas);

    DrawText(FImage.Canvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) div 2)
      - (GetTextWidth(FImage.Canvas, Action) div 2), FYStart + YIndentText, Action);

    FBlocks[0].DrawBlock;
  end;

end.
