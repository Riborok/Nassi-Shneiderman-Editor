unit DrawShapes;

interface
uses Vcl.graphics, System.Types, System.SysUtils, Constants, AdditionalTypes;

procedure DrawRect(const AXStart, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);

procedure DrawInvertedTriangle(const AXStart, AXMiddle, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);

procedure ColorizeRect(const ACanvas: TCanvas; const AXStart, AXLast, AYStart, AYLast: Integer; const AColor: TColor);

procedure DrawUnfinishedVertRectForLoop(const AXStart, AXLast, AYStart, AYMiddle,
                AYLast: Integer; const ACanvas: TCanvas);

procedure DrawUnfinishedHorRectForLoop(const AXStart, AXMiddle, AXLast,
                     AYStart, AYLast: Integer; const ACanvas: TCanvas);

procedure DrawLine(const AXStart, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);

procedure DrawText(const ACanvas: TCanvas; const AX, AY: Integer; const AText: string);

// Потом убрать нада
procedure DrawCoordinates(Canvas: TCanvas; Step: Integer);
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

  procedure DrawLine(const AXStart, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);
  begin
    ACanvas.MoveTo(AXStart, AYStart);
    ACanvas.LineTo(AXLast, AYLast);
  end;

  procedure DrawRect(const AXStart, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);
  begin
    ACanvas.MoveTo(AXStart, AYStart);
    ACanvas.LineTo(AXLast, AYStart);
    ACanvas.LineTo(AXLast, AYLast);
    ACanvas.LineTo(AXStart, AYLast);
    ACanvas.LineTo(AXStart, AYStart);
  end;

  procedure DrawInvertedTriangle(const AXStart, AXMiddle, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);
  begin
    ACanvas.MoveTo(AXStart, AYStart);
    ACanvas.LineTo(AXMiddle, AYLast);
    ACanvas.LineTo(AXLast, AYStart);
  end;

  procedure ColorizeRect(const ACanvas: TCanvas; const AXStart, AXLast, AYStart, AYLast: Integer; const AColor: TColor);
  var
    SavedColor: TColor;
  begin
    SavedColor := ACanvas.Brush.Color;

    ACanvas.Brush.Color := AColor;
    ACanvas.FillRect(Rect(AXStart, AYStart, AXLast, AYLast));

    ACanvas.Brush.Color := SavedColor;
  end;

  procedure DrawText(const ACanvas: TCanvas; const AX, AY: Integer; const AText: string);
  var
    Lines: TStringDynArray;
    Indent: Integer;
    I: Integer;
    SavedColor: TColor;
  begin
    SavedColor := ACanvas.Brush.Color;
    ACanvas.Brush.Style := bsClear;

    Lines := AText.Split([sLineBreak]);

    Indent := ACanvas.TextHeight(Space);

    for I := 0 to High(Lines) do
      ACanvas.TextOut(AX, AY + I * Indent, Lines[I]);

    ACanvas.Brush.Color := SavedColor;
  end;

  procedure DrawCoordinates(Canvas: TCanvas; Step: Integer);
  var
    i, PrevFontSize: Integer;
  begin
    PrevFontSize:= Canvas.Font.Size;
    Canvas.Font.Size:= 7;

    for i := 0 to Canvas.ClipRect.Height div Step do
    begin
      Canvas.MoveTo(0, i * Step);
      Canvas.TextOut(5, i * Step - 10, IntToStr(i * Step));
    end;

    for i := 0 to Canvas.ClipRect.Width div Step do
    begin
      Canvas.MoveTo(i * Step, 0);
      Canvas.TextOut(i * Step + 5, 5, IntToStr(i * Step));
    end;

    Canvas.Font.Size:= PrevFontSize;
  end;

end.
