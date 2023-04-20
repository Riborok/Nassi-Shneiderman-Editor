unit DetermineDimensions;

interface
uses Vcl.graphics, System.StrUtils, System.Types, System.SysUtils, MinMaxInt;

function GetTextWidth(const ACanvas: TCanvas; const AText: string): Integer;
function GetTextHeight(const ACanvas: TCanvas; const AText: string): Integer;

implementation

  function GetTextHeight(const ACanvas: TCanvas; const AText: string): Integer;
  var
    Lines: TStringDynArray;
    i: Integer;
  begin
    if AText = '' then
      Result:= ACanvas.TextHeight(' ')
    else
    begin
      Result := 0;
      Lines := SplitString(AText, sLineBreak);

      Inc(Result, ACanvas.TextHeight(Lines[0]));
      for i := 1 to High(Lines) do
      begin
        if Length(Lines[i]) > 0 then
          Inc(Result, ACanvas.TextHeight(Lines[i]))
        else if Length(Lines[i - 1]) = 0 then
          Inc(Result, ACanvas.Font.Size);
      end;
    end;
  end;

  function GetTextWidth(const ACanvas: TCanvas; const AText: string): Integer;
  var
    Lines: TStringDynArray;
    i: Integer;
  begin
    if AText = '' then
      Result:= ACanvas.TextWidth(' ')
    else
    begin
      Result := 0;
      Lines := SplitString(AText, sLineBreak);

      for i := 0 to High(Lines) do
        Result := Max(Result, ACanvas.TextWidth(Lines[i]));
    end;
  end;
end.
