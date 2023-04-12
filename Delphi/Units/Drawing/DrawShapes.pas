unit DrawShapes;

interface
uses Vcl.graphics, System.StrUtils, System.Types, System.SysUtils, MinMaxInt, Vcl.ExtCtrls;

procedure DrawRectangle(const AXStart, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);
procedure DrawInvertedTriangle(const AXStart, AXMiddle, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);
procedure DrawYellowRect(const ACanvas: TCanvas; const AXStart, AXLast, AYStart, AYLast: Integer);

function GetTextHeight(const ACanvas: TCanvas; const AText: string): Integer;
procedure DrawText(const ACanvas: TCanvas; const AX, AY: Integer; const AText: string);
function GetTextWidth(const FCanvas: TCanvas; const Text: string): Integer;

procedure DrawCoordinates(Canvas: TCanvas; Step: Integer);
procedure Clear(const ACanvas: TCanvas);
implementation

  procedure DrawRectangle(const AXStart, AXLast, AYStart, AYLast : Integer; const ACanvas: TCanvas);
  begin
    //AdjustImageSizeToFitCanvas(AXStart, AXLast, AYStart, AYLast);

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

  procedure DrawYellowRect(const ACanvas: TCanvas; const AXStart, AXLast, AYStart, AYLast: Integer);
  var
    SavedColor: TColor;
  begin
    SavedColor := ACanvas.Brush.Color;

    ACanvas.Brush.Color := clYellow;
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

  procedure AdjustImageSizeToFitCanvas(AImage: TImage; AXStart, AXLast,
                                        AYStart, AYLAST: Integer);
  var
    ImageWidth, ImageHeight: Integer;
  begin

    ImageWidth := Abs(AXLast - AXStart) + 1;
    ImageHeight := Abs(AYLAST - AYStart) + 1;

    if (ImageWidth > AImage.Width) or (ImageHeight > AImage.Height) then
    begin
      AImage.Width := Max(AImage.Width, ImageWidth);
      AImage.Height := Max(AImage.Height, ImageHeight);
    end;

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
