unit uLocalSave;

interface
uses
  UBlockManager, uBase, System.JSON, System.Classes, uIfBranching, Vcl.Graphics,
  System.SysUtils, System.IOUtils, System.UITypes, uCaseBranching, uAdditionalTypes,
  uStatementConverter, System.Generics.Collections, Vcl.Dialogs, uDialogMessages;

  procedure SaveSchema(const ABlockManager: TBlockManager);
  procedure LoadSchema(const ABlockManager: TBlockManager);
implementation

  { Pen }

  // Load
  procedure JSONToPen(const AJSON: TJSONObject; const APen: TPen);
  begin
    with APen do
    begin
      Color := StringToColor(AJSON.GetValue('Color').Value);
      Width := AJSON.GetValue('Width').Value.ToInteger;
      Style := TPenStyle(AJSON.GetValue('Style').Value.ToInteger);
      Mode := TPenMode(AJSON.GetValue('Mode').Value.ToInteger);
    end;
  end;

  // Save
  function PenToJSON(const APen: TPen): TJSONObject;
  begin
    Result := TJSONObject.Create;
    with Result do
    begin
      AddPair('Color', ColorToString(APen.Color));
      AddPair('Width', TJSONNumber.Create(APen.Width));
      AddPair('Style', TJSONNumber.Create(Ord(APen.Style)));
      AddPair('Mode', TJSONNumber.Create(Ord(APen.Mode)));
    end;
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

  // Load
  procedure JSONToFont(const AJSON: TJSONObject; const AFont: TFont);
  begin
    with AFont do
    begin
      Size := AJSON.GetValue('Size').Value.ToInteger;
      Name := AJSON.GetValue('Name').Value;
      Color := StringToColor(AJSON.GetValue('Color').Value);
      Style := GetFontStyleFromOrd(AJSON.GetValue('Style').Value.ToInteger);
      Charset := AJSON.GetValue('Charset').Value.ToInteger;
    end;
  end;

  // Save
  function FontToJSON(const AFont: TFont): TJSONObject;
  begin
    Result := TJSONObject.Create;
    with Result do
    begin
      AddPair('Size', TJSONNumber.Create(AFont.Size));
      AddPair('Name', AFont.Name);
      AddPair('Color', ColorToString(AFont.Color));
      AddPair('Style', TJSONNumber.Create(GetOrdFontStyle(AFont.Style)));
      AddPair('Charset', TJSONNumber.Create(Ord(AFont.Charset)));
    end;
  end;

  { Statement }

  // Load
  function JSONToBlock(const JsonObject: TJSONObject; const ABaseOperator: TOperator;
                       const ACanvas: TCanvas): TBlock; forward;

  function JSONToStatement(const JsonObject: TJSONObject; const ACanvas: TCanvas): TStatement;
  var
    CurrOperator: TOperator;
    MyJSONArray: TJSONArray;
    I: Integer;
    StatementClass: TStatementClass;
  begin
    StatementClass := ConvertToStatementType(JsonObject.GetValue('StatementIndex').Value.ToInteger);

    if StatementClass = TCaseBranching then
    begin
      MyJSONArray := TJSONArray(JsonObject.GetValue('Conds'));
      var StringArr : TStringArr;
      SetLength(StringArr, MyJSONArray.Count);
      for I := 0 to MyJSONArray.Count - 1 do
        StringArr[I] := MyJSONArray.Items[I].Value;
      Result:= TCaseBranching.Create(JsonObject.GetValue('Action').Value, StringArr);
    end
    else
      Result:= StatementClass.Create(JsonObject.GetValue('Action').Value);

    Result.SetCoords(JsonObject.GetValue('YStart').Value.ToInteger,
                     JsonObject.GetValue('YLast').Value.ToInteger);

    if Result is TOperator then
    begin
      CurrOperator:= TOperator(Result);

      MyJSONArray := TJSONArray(JsonObject.GetValue('Blocks'));
      for I := 0 to MyJSONArray.Count - 1 do
        CurrOperator.Blocks[I] := JSONToBlock(TJSONObject(MyJSONArray.Items[I]), CurrOperator, ACanvas);
    end;
  end;

  // Save
  function BlockToJSON(const ABlock: TBlock): TJSONObject; forward;

  function StatementToJSON(const AStatement: TStatement): TJSONObject;
  var
    CurrOperator: TOperator;
    MyJSONArray: TJSONArray;
    I, StatementIndex: Integer;
  begin
    Result := TJSONObject.Create;
    StatementIndex := AStatement.GetSerialNumber;
    Result.AddPair('StatementIndex', TJSONNumber.Create(StatementIndex));

    if StatementIndex = 2 {2: TCaseBranching} then
    begin
      MyJSONArray := TJSONArray.Create;
      var StringArr : TStringArr := TCaseBranching(CurrOperator).Conds;
      for I := 0 to High(StringArr) do
        MyJSONArray.Add(StringArr[I]);
      Result.AddPair('Conds', MyJSONArray);
    end;

    Result.AddPair('Action', AStatement.Action);
    Result.AddPair('YStart', TJSONNumber.Create(AStatement.YStart));
    Result.AddPair('YLast', TJSONNumber.Create(AStatement.YLast));

    if AStatement is TOperator then
    begin
      CurrOperator:= TOperator(AStatement);

      MyJSONArray := TJSONArray.Create;
      for I := 0 to High(CurrOperator.Blocks) do
        MyJSONArray.AddElement(BlockToJSON(CurrOperator.Blocks[I]));
      Result.AddPair('Blocks', MyJSONArray);
    end;
  end;

  { Block }

  // Load
  function JSONToBlock(const JsonObject: TJSONObject; const ABaseOperator: TOperator;
                       const ACanvas: TCanvas): TBlock;
  var
    JsonArray: TJSONArray;
    I: Integer;
  begin
    Result := TBlock.Create(
              JsonObject.GetValue('XStart').Value.ToInteger,
              JsonObject.GetValue('XLast').Value.ToInteger,
              ABaseOperator,
              ACanvas);

    JsonArray := TJSONArray(JsonObject.GetValue('Statements'));
    for I := 0 to JsonArray.Count - 1 do
      Result.AddStatement(JSONToStatement(TJSONObject(JsonArray.Items[I]), ACanvas));
  end;

  // Save
  function BlockToJSON(const ABlock: TBlock): TJSONObject;
  var
    I: Integer;
    JsonArray: TJsonArray;
  begin
    Result := TJSONObject.Create;

    Result.AddPair('XStart', TJSONNumber.Create(ABlock.XStart));
    Result.AddPair('XLast', TJSONNumber.Create(ABlock.XLast));

    JsonArray := TJsonArray.Create;

    for I := 0 to ABlock.Statements.Count - 1 do
      JsonArray.AddElement(StatementToJSON(ABlock.Statements[I]));

    Result.AddPair('Statements', JsonArray);
  end;

  { Schema }

  // Save
  procedure SaveSchema(const ABlockManager: TBlockManager);
  var
    Json: TJSONObject;
  begin
    if ABlockManager.PathToFile <> '' then
    begin
      Json := TJSONObject.Create;
      try
        with Json do
        begin
          with ABlockManager do
          begin
            AddPair('Pen', PenToJSON(Pen));
            AddPair('Font', FontToJSON(Font));
            AddPair('MainBlock', BlockToJSON(MainBlock));
          end;
        end;
        TFile.WriteAllText(ABlockManager.PathToFile, Json.ToJSON, TEncoding.UTF8);
      finally
        Json.Destroy;
      end;
    end;
  end;

  // Load
  procedure LoadSchema(const ABlockManager: TBlockManager);
  var
    Json: TJSONObject;
  begin
    if TFile.Exists(ABlockManager.PathToFile) and
       SameText(TPath.GetExtension(ABlockManager.PathToFile), '.json') then
    begin
      Json := TJSONObject(TJSONObject.ParseJSONValue(TFile.ReadAllText(ABlockManager.PathToFile, TEncoding.UTF8)));
      try
        with Json do
        begin
          with ABlockManager do
          begin
            JSONToPen(TJSONObject(GetValue('Pen')), Pen);
            JSONToFont(TJSONObject(GetValue('Font')), Font);
            MainBlock := JSONToBlock(TJSONObject(GetValue('MainBlock')), nil, PaintBox.Canvas);
            TIfBranching.RedefineSizesForIfBranching(MainBlock);
          end;
        end;
      except
        ShowMessage(rsErrorFile);
      end;
      Json.Destroy;
    end;
  end;
end.
