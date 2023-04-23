unit AdditionalTypes;

interface
uses Types;
type
  TStringArr = array of String;

  TSize = record
    Width, Height: Integer;
  End;

  TSizeArr = array of TSize;

  TVisibleImageRect = record
    FTopLeft, FBottomRight: TPoint;
    procedure Expand(const AXExpand, AYExpand: Integer);
  end;

implementation

  procedure TVisibleImageRect.Expand(const AXExpand, AYExpand: Integer);
  begin
    Dec(FTopLeft.X, AXExpand);
    Dec(FTopLeft.Y, AYExpand);
    Inc(FBottomRight.X, AXExpand);
    Inc(FBottomRight.Y, AYExpand);
  end;

end.
