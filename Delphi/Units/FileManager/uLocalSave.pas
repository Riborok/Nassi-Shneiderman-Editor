unit uLocalSave;

interface
uses
  UBlockManager, uBase, System.JSON, System.Classes, uIfBranching, Vcl.Graphics,
  System.SysUtils, System.IOUtils, System.UITypes;

  procedure SaveSchema(const ABlockManager: TBlockManager);
  procedure LoadSchema(const ABlockManager: TBlockManager);
implementation

  { Pen }
  procedure JSONToPen(const AJSON: TJSONObject; const APen: TPen);
  begin
    APen.Color := StringToColor(AJSON.GetValue('Color').Value);
    APen.Width := AJSON.GetValue('Width').Value.ToInteger;
    APen.Style := TPenStyle(AJSON.GetValue('Style').Value.ToInteger);
    APen.Mode := TPenMode(AJSON.GetValue('Mode').Value.ToInteger);
  end;

  function PenToJSON(const APen: TPen): TJSONObject;
  begin
    Result := TJSONObject.Create;
    Result.AddPair('Color', ColorToString(APen.Color));
    Result.AddPair('Width', TJSONNumber.Create(APen.Width));
    Result.AddPair('Style', TJSONNumber.Create(Ord(APen.Style)));
    Result.AddPair('Mode', TJSONNumber.Create(Ord(APen.Mode)));
  end;

  { Font }
  function GetOrdFontStyle(AFontStyles: TFontStyles): Integer;
  begin
    Result := Ord(fsBold in AFontStyles) shl 3 or
              Ord(fsItalic in AFontStyles) shl 2 or
              Ord(fsUnderline in AFontStyles) shl 1 or
              Ord(fsStrikeOut in AFontStyles);
  end;

  function GetFontStyleFromOrd(AOrd: Integer): TFontStyles;
  begin
    Result := [];
    if AOrd and $01 = $01 then
      Include(Result, fsStrikeOut);
    if AOrd and $02 = $02 then
      Include(Result, fsUnderline);
    if AOrd and $04 = $04 then
      Include(Result, fsItalic);
    if AOrd and $08 = $08 then
      Include(Result, fsBold);
  end;

  procedure JSONToFont(const AJSON: TJSONObject; const AFont: TFont);
  begin
    AFont.Size := AJSON.GetValue('Size').Value.ToInteger;
    AFont.Name := AJSON.GetValue('Name').Value;
    AFont.Color := StringToColor(AJSON.GetValue('Color').Value);
    AFont.Style := GetFontStyleFromOrd(AJSON.GetValue('Style').Value.ToInteger);
    AFont.Charset := AJSON.GetValue('Charset').Value.ToInteger;
  end;

  function FontToJSON(const AFont: TFont): TJSONObject;
  begin
    Result := TJSONObject.Create;
    Result.AddPair('Size', TJSONNumber.Create(AFont.Size));
    Result.AddPair('Name', AFont.Name);
    Result.AddPair('Color', ColorToString(AFont.Color));
    Result.AddPair('Style', TJSONNumber.Create(GetOrdFontStyle(AFont.Style)));
    Result.AddPair('Charset', TJSONNumber.Create(Ord(AFont.Charset)));
  end;

  { Save }

  procedure SaveSchema(const ABlockManager: TBlockManager);
  var
    Json: TJSONObject;
  begin
    Json := TJSONObject.Create;
    try
      with Json do
      begin
        with ABlockManager do
        begin
          AddPair('Pen', PenToJSON(Pen));
          AddPair('Font', FontToJSON(Font));
        end;
      end;
      TFile.WriteAllText('Temp.json', Json.ToJSON, TEncoding.UTF8);
    finally
      Json.Destroy;
    end;
  end;

  procedure LoadSchema(const ABlockManager: TBlockManager);
  var
    Json: TJSONObject;
  begin
    if TFile.Exists('Temp.json') then
    begin
      Json := TJSONObject.ParseJSONValue(TFile.ReadAllText('Temp.json', TEncoding.UTF8)) as TJSONObject;
      try
        with Json do
        begin
          with ABlockManager do
          begin
            JSONToPen(TJSONObject(GetValue('Pen')), Pen);
            JSONToFont(TJSONObject(GetValue('Font')), Font);
          end;
        end;
      finally
        Json.Destroy;
      end;
    end;
  end;
end.