unit DrawShapes;

interface
uses Vcl.graphics, System.StrUtils, System.Types, System.SysUtils, MinMaxInt, Vcl.ExtCtrls;

procedure DrawRectangle(const AXStart, AXLast, AYStart, AYLast : Integer; const AImage: TImage);
procedure DrawInvertedTriangle(const AXStart, AXMiddle, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);
procedure ColorizeRectangle(const ACanvas: TCanvas; const AXStart, AXLast, AYStart, AYLast: Integer; const AColor: TColor);

function GetTextHeight(const ACanvas: TCanvas; const AText: string): Integer;
procedure DrawText(const ACanvas: TCanvas; const AX, AY: Integer; const AText: string);
function GetTextWidth(const FCanvas: TCanvas; const Text: string): Integer;

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

  procedure AdjustRightBoundary(AXLast: Integer; const AImage: TImage);
  begin
    Inc(AXLast, 10);
    if AXLast > AImage.Picture.Bitmap.Width then
      AImage.Picture.Bitmap.Width := AImage.Width;

  end;

  procedure AdjustDownBoundary(AYLast: Integer; const AImage: TImage);
  begin
    Inc(AYLast, 10);
    if AYLast > AImage.Picture.Bitmap.Height then
      AImage.Picture.Bitmap.Height := AYLAST;

  end;

  procedure DrawRectangle(const AXStart, AXLast, AYStart, AYLast : Integer; const AImage: TImage);
  begin
    AdjustRightBoundary(AXLast, AImage);
    AdjustDownBoundary(AYLast, AImage);

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

  function GetTextHeight(const ACanvas: TCanvas; const AText: string): Integer;
  var
    Lines: TStringDynArray;
    i: Integer;
  begin
    Result := 0;
    Lines := SplitString(AText, sLineBreak);

    Inc(Result, ACanvas.TextHeight(Lines[0]));
    for i := 1 to High(Lines) do
    begin
      if Length(Lines[i]) > 0 then
        Inc(Result, ACanvas.TextHeight(Lines[i]))
      else if Length(Lines[i - 1]) = 0 then
        Inc(Result, ACanvas.Font.Size);
    end;

  end;

  function GetTextWidth(const FCanvas: TCanvas; const Text: string): Integer;
  var
    Lines: TStringDynArray;
    i: Integer;
  begin
    Result := 0;
    Lines := SplitString(Text, sLineBreak);

    for i := 0 to High(Lines) do
      Result := Max(Result, FCanvas.TextWidth(Lines[i]));
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