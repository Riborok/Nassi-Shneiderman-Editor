﻿unit FirstLoop;

interface
uses DrawShapes, Loop;
type

  TFirstLoop = class(TLoop)
  protected
    function GetOptimalYLast: Integer; override;
    procedure Draw; override;
  public
    function IsPreсOperator: Boolean; override;
  end;

implementation

  function TFirstLoop.IsPreсOperator: Boolean;
  begin
    Result:= True;
  end;

  function TFirstLoop.GetOptimalYLast: Integer;
  begin
    Result := FYStart + FActionSize.Height + FYIndentText shl 1;
  end;

  procedure TFirstLoop.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, BaseBlock.Canvas);

    DrawRectangle(BaseBlock.XStart, GetXLastStrip, FYLast, GetYBottom, BaseBlock.Canvas);

    EraseLine(BaseBlock.XStart +  1, GetXLastStrip, FYLast, FYLast, BaseBlock.Canvas);

    DrawText(BaseBlock.Canvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) shr 1)
      - (FActionSize.Width shr 1), FYStart + FYIndentText, Action);

    FBlocks[0].DrawBlock;
  end;

end.
