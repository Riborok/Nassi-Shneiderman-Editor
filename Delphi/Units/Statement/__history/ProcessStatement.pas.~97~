unit ProcessStatement;

interface
uses Base, DrawShapes;
type

  TProcessStatement = class(TStatement)
  protected
    function GetOptimaWidth: Integer; override;
    function GetOptimalYLast: Integer; override;
    procedure Draw; override;
  end;

implementation

  function TProcessStatement.GetOptimaWidth: Integer;
  begin
    result:= FActionSize.Width + FXMinIndentText shl 1;
  end;

  procedure TProcessStatement.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, BaseBlock.Canvas);

    DrawText(BaseBlock.Canvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) shr 1)
      - (FActionSize.Width shr 1), FYStart + FYIndentText, Action);
  end;

  function TProcessStatement.GetOptimalYLast: Integer;
  begin
    Result := FYStart + FActionSize.Height + FYIndentText shl 1;
  end;

end.
