unit DetermineDimensions;

interface
uses Vcl.graphics, System.Types, System.SysUtils, MinMaxInt, Constants, Types;

function GetTextSize(const ACanvas: TCanvas; const AText: string): TSize;
implementation

  function GetTextSize(const ACanvas: TCanvas; const AText: string): TSize;
  var
    Lines: TStringDynArray;
    I: Integer;
  begin
    if AText = '' then
    begin
      Result.Height:= ACanvas.TextHeight(Space);
      Result.Width:= ACanvas.TextWidth(Space);
    end
    else
    begin
      Result.Width := 0;
      Result.Height := 0;

      Lines := AText.Split([sLineBreak]);

      for I := 0 to High(Lines) do
      begin
        if Length(Lines[i]) > 0 then
          Inc(Result.Height, ACanvas.TextHeight(Lines[i]))
        else if Length(Lines[i - 1]) = 0 then
          Inc(Result.Height, ACanvas.Font.Size);

        Result.Width := Max(Result.Width, ACanvas.TextWidth(Lines[I]));
      end;
    end;
  end;

end.
