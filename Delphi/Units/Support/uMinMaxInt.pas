unit uMinMaxInt;

interface

  function Max(const AFirst, ASecond: Integer): Integer;
  function Min(const AFirst, ASecond: Integer): Integer;

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
