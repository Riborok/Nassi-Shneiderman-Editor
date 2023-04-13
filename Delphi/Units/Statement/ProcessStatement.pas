﻿unit ProcessStatement;

interface
uses Base, vcl.graphics, DrawShapes, Vcl.ExtCtrls, DetermineDimensions;
type

  TProcessStatement = class(TStatement)
  protected
    function GetOptimaWidth: Integer; override;
    procedure SetInitiaXLast; override;
    function GetOptimalYLast: Integer; override;
  public
    procedure Draw; override;
  end;

implementation

  function TProcessStatement.GetOptimaWidth: Integer;
  begin
    result:= GetTextWidth(FImage.Canvas, FAction) + 2 * XMinIndentText;
  end;

  procedure TProcessStatement.SetInitiaXLast;
  begin
    BaseBlock.SetOptimalXLastBlock;
  end;

  procedure TProcessStatement.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, FImage);

    DrawText(FImage.Canvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) div 2)
      - (GetTextWidth(FImage.Canvas, Action) div 2), FYStart + YIndentText, Action);
  end;

  function TProcessStatement.GetOptimalYLast: Integer;
  begin
    Result := FYStart + GetTextHeight(FImage.Canvas, FAction) + 2 * YIndentText;
  end;

end.
