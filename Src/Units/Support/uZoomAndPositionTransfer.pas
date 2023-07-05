unit uZoomAndPositionTransfer;

interface

function GetZoomFactor(const APos: Integer): Single; inline;
function GetPosition(const AZoomFactor: Single): Integer; inline;

implementation

  function GetZoomFactor(const APos: Integer): Single;
  begin
    case APos of
      1: Result := 0.25;
      2: Result := 0.33;
      3: Result := 0.5;
      4: Result := 0.67;
      5: Result := 0.75;
      6: Result := 0.8;
      7: Result := 0.9;
      8: Result := 1;
      9: Result := 1.1;
      10: Result := 1.25;
      11: Result := 1.5;
      12: Result := 1.75;
      13: Result := 2;
      14: Result := 2.5;
      15: Result := 3;
      16: Result := 4;
      17: Result := 5;
    end;
  end;

  function GetPosition(const AZoomFactor: Single): Integer;
  begin
    if AZoomFactor <= 0.25 then
      Result := 1
    else if AZoomFactor <= 0.33 then
      Result := 2
    else if AZoomFactor <= 0.5 then
      Result := 3
    else if AZoomFactor <= 0.67 then
      Result := 4
    else if AZoomFactor <= 0.75 then
      Result := 5
    else if AZoomFactor <= 0.8 then
      Result := 6
    else if AZoomFactor <= 0.9 then
      Result := 7
    else if AZoomFactor <= 1.0 then
      Result := 8
    else if AZoomFactor <= 1.1 then
      Result := 9
    else if AZoomFactor <= 1.25 then
      Result := 10
    else if AZoomFactor <= 1.5 then
      Result := 11
    else if AZoomFactor <= 1.75 then
      Result := 12
    else if AZoomFactor <= 2.0 then
      Result := 13
    else if AZoomFactor <= 2.5 then
      Result := 14
    else if AZoomFactor <= 3.0 then
      Result := 15
    else if AZoomFactor <= 4.0 then
      Result := 16
    else
      Result := 17;
  end;

end.
