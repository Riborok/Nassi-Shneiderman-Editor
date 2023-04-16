unit AdjustBorders;

interface
uses Vcl.ExtCtrls, Vcl.Forms, MinMaxInt;

procedure DefineBorders(AXLast, AYLast: Integer; const AImage: TImage);

implementation

  procedure DefineBorders(AXLast, AYLast: Integer; const AImage: TImage);
  begin
    Inc(AXLast, 10);
    Inc(AYLast, 10);
    AImage.Picture.Bitmap.Width := Max(AXLast, Screen.Width);
    AImage.Picture.Bitmap.Height := Max(AYLast, Screen.Height);
  end;

end.
