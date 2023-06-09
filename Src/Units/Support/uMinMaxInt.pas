unit uMinMaxInt;

interface

  function Max(const AFirst, ASecond: Integer): Integer; inline;
  function Min(const AFirst, ASecond: Integer): Integer; inline;

implementation

  function Max(const AFirst, ASecond: Integer): Integer;
  begin
    if AFirst > ASecond then
      Result := AFirst
    else
      Result := ASecond;
  end;

  function Min(const AFirst, ASecond: Integer): Integer;
  begin
    if AFirst < ASecond then
      Result := AFirst
    else
      Result := ASecond;
  end;

end.
