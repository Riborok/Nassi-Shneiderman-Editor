unit uGlobalSave;

interface

uses
  UBlockManager, uBase, System.JSON, uIfBranching, Vcl.Graphics, System.SysUtils,
  System.IOUtils, uConstants;

  procedure ResetGlobalSettings;
  procedure LoadGlobalSettings;
  procedure SaveGlobalSettings;
implementation

  const
    constIfTrueCond = 'True';
    constIfFalseCond = 'False';
    constDefaultAction = '';
    constHighlightColor = clYellow;
    constArrowColor = clBlack;
    constOKColor = clGreen;
    constCancelColor = clRed;

    constGbSettingsNameWithExt = 'GlobalSettings' + constExtJSON;

  procedure ResetGlobalSettings;
  begin
    TIfBranching.TrueCond := constIfTrueCond;
    TIfBranching.FalseCond := constIfFalseCond;

    DefaultAction := constDefaultAction;

    with TBlockManager do
    begin
      HighlightColor := constHighlightColor;
      ArrowColor := constArrowColor;
      OKColor := constOKColor;
      CancelColor := constCancelColor;
    end;
  end;

  procedure LoadGlobalSettings;
  var
    Json: TJSONObject;
    AppDataPath: string;
  begin
    AppDataPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + dirAppData;
    AppDataPath := TPath.Combine(AppDataPath, constGbSettingsNameWithExt);

    if FileExists(AppDataPath) then
    begin
      Json := TJSONObject(TJSONObject.ParseJSONValue(TFile.ReadAllText(AppDataPath, TEncoding.UTF8)));
      try
        with Json do
        begin
          DefaultAction := GetValue('DefaultAction').Value;
          TIfBranching.TrueCond := GetValue('TrueCond').Value;
          TIfBranching.FalseCond := GetValue('FalseCond').Value;
          with TBlockManager do
          begin
            HighlightColor := StringToColor(GetValue('HighlightColor').Value);
            ArrowColor := StringToColor(GetValue('ArrowColor').Value);
            OKColor := StringToColor(GetValue('OKColor').Value);
            CancelColor := StringToColor(GetValue('CancelColor').Value);
          end;
        end;
      except
        ResetGlobalSettings;
      end;
      Json.Destroy;
    end
    else
      ResetGlobalSettings;
  end;

  procedure SaveGlobalSettings;
  var
    Json: TJSONObject;
    AppDataPath: string;
  begin
    Json := TJSONObject.Create;
    try
      with Json do
      begin
        AddPair('DefaultAction', DefaultAction);
        AddPair('TrueCond', TIfBranching.TrueCond);
        AddPair('FalseCond', TIfBranching.FalseCond);
        with TBlockManager do
        begin
          AddPair('HighlightColor', ColorToString(HighlightColor));
          AddPair('ArrowColor', ColorToString(ArrowColor));
          AddPair('OKColor', ColorToString(OKColor));
          AddPair('CancelColor', ColorToString(CancelColor));
        end;
      end;

      AppDataPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + dirAppData;

      if not TDirectory.Exists(AppDataPath) then
        TDirectory.CreateDirectory(AppDataPath);

      AppDataPath := TPath.Combine(AppDataPath, constGbSettingsNameWithExt);

      TFile.WriteAllText(AppDataPath, Json.ToJSON, TEncoding.UTF8);
    finally
      Json.Destroy;
    end;
  end;

end.
