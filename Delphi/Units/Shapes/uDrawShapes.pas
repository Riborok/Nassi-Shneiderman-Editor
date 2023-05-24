unit uDrawShapes;

interface
uses
  Vcl.graphics, System.Types, System.SysUtils, uConstants, uAdditionalTypes,
  uBase, System.UITypes;

procedure DrawRect(const AXStart, AXLast, AYStart, AYLast : Integer;
                   const ACanvas: TCanvas);

procedure DrawInvertedTriangle(const AXStart, AXMiddle, AXLast, AYStart,
                               AYLast : Integer; const ACanvas: TCanvas);

procedure ColorizeRect(const ACanvas: TCanvas; const ARect: TRect; const AColor: TColor);

procedure DrawUnfinishedVertRectForLoop(const AXStart, AXLast, AYStart, AYMiddle,
                AYLast: Integer; const ACanvas: TCanvas);

procedure DrawUnfinishedHorRectForLoop(const AXStart, AXMiddle, AXLast,
                     AYStart, AYLast: Integer; const ACanvas: TCanvas);

procedure DrawLine(const AXStart, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);

procedure DrawText(const ACanvas: TCanvas; const AX, AY: Integer; const AText: string);

function CreateRect(const AStatement: TStatement): TRect; inline;

procedure DrawArrow(const ACanvas: TCanvas; const AX, AStartY, AEndY: Integer;
                    const AColor: TColor);
implementation

  procedure DrawUnfinishedVertRectForLoop(const AXStart, AXLast, AYStart, AYMiddle,
                       AYLast: Integer; const ACanvas: TCanvas);
  begin
    ACanvas.MoveTo(AXStart, AYStart);
    ACanvas.LineTo(AXStart, AYLast);
    ACanvas.LineTo(AXLast, AYLast);
    ACanvas.LineTo(AXLast, AYMiddle);
  end;

  procedure DrawUnfinishedHorRectForLoop(const AXStart, AXMiddle, AXLast,
                       AYStart, AYLast: Integer; const ACanvas: TCanvas);
  begin
    ACanvas.MoveTo(AXStart, AYStart);
    ACanvas.LineTo(AXLast, AYStart);
    ACanvas.LineTo(AXLast, AYLast);
    ACanvas.LineTo(AXMiddle, AYLast);
  end;

  procedure DrawLine(const AXStart, AXLast, AYStart, AYLast : Integer;
                     const ACanvas: TCanvas);
  begin
    ACanvas.MoveTo(AXStart, AYStart);
    ACanvas.LineTo(AXLast, AYLast);
  end;

  procedure DrawRect(const AXStart, AXLast, AYStart, AYLast : Integer;
                     const ACanvas: TCanvas);
  begin
    ACanvas.MoveTo(AXStart, AYStart);
    ACanvas.LineTo(AXLast, AYStart);
    ACanvas.LineTo(AXLast, AYLast);
    ACanvas.LineTo(AXStart, AYLast);
    ACanvas.LineTo(AXStart, AYStart);
  end;

  procedure DrawInvertedTriangle(const AXStart, AXMiddle, AXLast, AYStart,
                                 AYLast : Integer; const ACanvas: TCanvas);
  begin
    ACanvas.MoveTo(AXStart, AYStart);
    ACanvas.LineTo(AXMiddle, AYLast);
    ACanvas.LineTo(AXLast, AYStart);
  end;

  function CreateRect(const AStatement: TStatement): TRect; inline;
  begin
    Result:= Rect(AStatement.BaseBlock.XStart, AStatement.YStart,
                  AStatement.BaseBlock.XLast, AStatement.GetYBottom);
  end;

  procedure ColorizeRect(const ACanvas: TCanvas; const ARect: TRect; const AColor: TColor);
  begin
    ACanvas.Brush.Color := AColor;
    ACanvas.FillRect(ARect);
  end;

  procedure DrawText(const ACanvas: TCanvas; const AX, AY: Integer; const AText: string);
  var
    Lines: TStringDynArray;
    Indent: Integer;
    I: Integer;
  begin
    ACanvas.Brush.Style := bsClear;

    Lines := AText.Split([sLineBreak]);

    Indent := ACanvas.TextHeight(Space);

    for I := 0 to High(Lines) do
      ACanvas.TextOut(AX, AY + I * Indent, Lines[I]);
  end;

  procedure DrawArrow(const ACanvas: TCanvas; const AX, AStartY, AEndY: Integer;
                      const AColor: TColor);
  var
    Points: array [0..2] of TPoint;
    Offset, ArrowHeight, ArrowWidth: Integer;
  begin
    ACanvas.Brush.Color:= AColor;

    ArrowHeight := Abs(AEndY - AStartY);
    ArrowWidth := ArrowHeight div 2;
    if AStartY > AEndY then
      Offset := -ArrowHeight
    else
      Offset := ArrowHeight;
    Points[0] := Point(AX, AStartY);
    Points[1] := Point(AX - ArrowWidth, AStartY + Offset);
    Points[2] := Point(AX + ArrowWidth, AStartY + Offset);
    ACanvas.Polygon(Points);
  end;

end.

