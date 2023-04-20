﻿unit ProcessStatement;

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
    result:= FActWidth + 2 * FXMinIndentText;
  end;

  procedure TProcessStatement.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, BaseBlock.Canvas);

    DrawText(BaseBlock.Canvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) div 2)
      - (FActWidth div 2), FYStart + FYIndentText, Action);
  end;

  function TProcessStatement.GetOptimalYLast: Integer;
  begin
    Result := FYStart + FActHeight + 2 * FYIndentText;
  end;

end.
