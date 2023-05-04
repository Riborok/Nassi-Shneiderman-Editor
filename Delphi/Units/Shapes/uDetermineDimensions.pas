unit uDetermineDimensions;

interface
uses Vcl.graphics, System.Types, System.SysUtils, uMinMaxInt, uConstants, uAdditionalTypes;

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
      Lines := AText.Split([sLineBreak]);

      Result.Width := 0;

      for I := 0 to High(Lines) do
        Result.Width := Max(Result.Width, ACanvas.TextWidth(Lines[I]));

      Result.Height:= ACanvas.TextHeight(Space) * Length(Lines);
    end;
  end;

end.
