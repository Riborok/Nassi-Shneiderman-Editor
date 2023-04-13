unit DrawShapes;

interface
uses Vcl.graphics, System.StrUtils, System.Types, System.SysUtils, MinMaxInt, Vcl.ExtCtrls, AdjustBorders;

procedure DrawRectangle(const AXStart, AXLast, AYStart, AYLast : Integer; const AImage: TImage);
procedure DrawInvertedTriangle(const AXStart, AXMiddle, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);
procedure ColorizeRectangle(const ACanvas: TCanvas; const AXStart, AXLast, AYStart, AYLast: Integer; const AColor: TColor);

procedure DrawText(const ACanvas: TCanvas; const AX, AY: Integer; const AText: string);

procedure Clear(const ACanvas: TCanvas);

procedure Erase(const AXStart, AXLast, AYStart, AYLast: Integer; const ACanvas: TCanvas);

procedure DrawCoordinates(Canvas: TCanvas; Step: Integer);
implementation

  procedure Erase(const AXStart, AXLast, AYStart, AYLast: Integer; const ACanvas: TCanvas);
  var
    SavedPenColor: TColor;
  begin
    SavedPenColor := ACanvas.Pen.Color;

    ACanvas.Pen.Color := ACanvas.Pixels[AXStart, AYStart + 1];

    ACanvas.MoveTo(AXStart, AYStart);
    ACanvas.LineTo(AXLast, AYLast);

    ACanvas.Pen.Color := SavedPenColor;
  end;

  procedure DrawRectangle(const AXStart, AXLast, AYStart, AYLast : Integer; const AImage: TImage);
  begin
    AdjustRightBorder(AXLast, AImage);
    AdjustDownBorder(AYLast, AImage);

    AImage.Canvas.MoveTo(AXStart, AYStart);
    AImage.Canvas.LineTo(AXLast, AYStart);
    AImage.Canvas.LineTo(AXLast, AYLast);
    AImage.Canvas.LineTo(AXStart, AYLast);
    AImage.Canvas.LineTo(AXStart, AYStart);
  end;

  procedure DrawInvertedTriangle(const AXStart, AXMiddle, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);
  begin
    ACanvas.MoveTo(AXStart, AYStart);
    ACanvas.LineTo(AXMiddle, AYLast);
    ACanvas.LineTo(AXLast, AYStart);
  end;

  procedure ColorizeRectangle(const ACanvas: TCanvas; const AXStart, AXLast, AYStart, AYLast: Integer; const AColor: TColor);
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
    LineHeight: Integer;
    I: Integer;
    SavedColor: TColor;
  begin
    SavedColor := ACanvas.Brush.Color;
    ACanvas.Brush.Style := bsClear;

    Lines := SplitString(AText, sLineBreak);

    LineHeight := ACanvas.TextHeight(' ') div 2;

    for I := 0 to High(Lines) do
      ACanvas.TextOut(AX, AY + I * LineHeight, Lines[i]);

    ACanvas.Brush.Color := SavedColor;
  end;

  procedure Clear(const ACanvas: TCanvas);
  begin
    ACanvas.FillRect(Rect(0, 0, ACanvas.ClipRect.Right, ACanvas.ClipRect.Bottom));
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
