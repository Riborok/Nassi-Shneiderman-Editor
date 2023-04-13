unit AdjustBorders;

interface
uses Vcl.ExtCtrls;

procedure AdjustRightBorder(AXLast: Integer; const AImage: TImage);
procedure AdjustDownBorder(AYLast: Integer; const AImage: TImage);

implementation

  procedure AdjustRightBorder(AXLast: Integer; const AImage: TImage);
  begin
    Inc(AXLast, 10);
    if AXLast > AImage.Picture.Bitmap.Width then
      AImage.Picture.Bitmap.Width := AXLast;

  end;

  procedure AdjustDownBorder(AYLast: Integer; const AImage: TImage);
  begin
    Inc(AYLast, 10);
    if AYLast > AImage.Picture.Bitmap.Height then
      AImage.Picture.Bitmap.Height := AYLast;

  end;

end.
