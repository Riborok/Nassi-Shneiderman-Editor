unit uZoomAndPositionTransfer;

interface

function GetZoomFactor(const APos: Integer): Single; inline;
function GetPosition(const AZoomFactor: Single): Integer; inline;

implementation

  function GetZoomFactor(const APos: Integer): Single;
  begin
    case APos of
      1: Result := 0.1;
      2: Result := 0.3;
      3: Result := 0.5;
      4: Result := 0.8;
      5: Result := 1;
      6: Result := 1.2;
      7: Result := 1.5;
      8: Result := 1.7;
      9: Result := 2;
      10: Result := 2.2;
      11: Result := 2.5;
      12: Result := 2.7;
      13: Result := 3;
      14: Result := 5;
      15: Result := 10;
      16: Result := 20;
    end;
  end;

  function GetPosition(const AZoomFactor: Single): Integer; inline;
  begin
    case Trunc(AZoomFactor * 10) of
      1: Result := 1;
      3: Result := 2;
      5: Result := 3;
      8: Result := 4;
      10: Result := 5;
      12: Result := 6;
      15: Result := 7;
      17: Result := 8;
      20: Result := 9;
      22: Result := 10;
      25: Result := 11;
      27: Result := 12;
      30: Result := 13;
      50: Result := 14;
      100: Result := 15;
      200: Result := 16;
    end;
  end;

end.
