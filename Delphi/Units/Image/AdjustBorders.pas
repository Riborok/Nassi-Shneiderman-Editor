unit AdjustBorders;

interface
uses Vcl.ExtCtrls;

procedure DefineBorders(const AXLast, AYLast: Integer; const AImage: TImage);

implementation

  procedure DefineBorders(const AXLast, AYLast: Integer; const AImage: TImage);
  begin
    AImage.Picture.Bitmap.Width := AXLast + 5;
    AImage.Picture.Bitmap.Height := AYLast + 5;
  end;

end.
