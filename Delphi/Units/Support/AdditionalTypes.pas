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
  end;

implementation

end.
