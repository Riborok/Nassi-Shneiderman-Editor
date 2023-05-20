unit uAdditionalTypes;

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
    procedure Expand(const AExpand: Integer);
  end;

implementation

  procedure TVisibleImageRect.Expand(const AExpand: Integer);
  begin
    Dec(FTopLeft.X, AExpand);
    Dec(FTopLeft.Y, AExpand);
    Inc(FBottomRight.X, AExpand);
    Inc(FBottomRight.Y, AExpand);
  end;

end.
