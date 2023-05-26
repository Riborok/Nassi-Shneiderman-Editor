unit uStatistics;

interface
uses
  System.SysUtils, Windows, uConstants, System.IOUtils, Vcl.Dialogs, uDialogMessages;

type
  TUserInfo = record
    UserName: ShortString;
    LoginTime: TDateTime;
    LogoutTime: TDateTime;
    GlobalSettingsTime: Integer;
    HelpTime: Integer;
    FontSettingTime: Integer;
    PenSettingTime: Integer;
    ChangeActionCount: Integer;
    DeleteStatementCount: Integer;
    AddStatementCount: Integer;
  end;

procedure SaveStatistics(const AUserInfo: TUserInfo);
function LoadStatistics(const AFilePath: string): TUserInfo;

procedure ClearUserInfo(var UserInfo: TUserInfo);
function FormatStatistics(const AUserInfo: TUserInfo): string;

function SecondsBetween(const ANow, AThen: TDateTime): Integer;

function GetWindowsUserName: string;

implementation

  const
    constMaxCount = 142;
    constStatisticsName = 'Statistics';

  function SecondsBetween(const ANow, AThen: TDateTime): Integer;
  begin
    Result := Round((ANow - AThen) * 86400);
  end;

  function CountFilesWithExtension(const AFolderPath: string): Integer;
  var
    SearchRec: TSearchRec;
    ResultCode: Integer;
  begin
    Result := 0;
    ResultCode := FindFirst(AFolderPath + '\*' + constExtStat, faAnyFile, SearchRec);
    try
      while ResultCode = 0 do
      begin
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') and
           (SearchRec.Attr and faDirectory = 0) then
          Inc(Result);
        ResultCode := FindNext(SearchRec);
      end;
    finally
      FindClose(SearchRec.FindHandle);
    end;
  end;

  procedure DeleteFilesWithExtension(const AFolderPath: string);
  var
    SearchRec: TSearchRec;
    ResultCode: Integer;
  begin
    ResultCode := FindFirst(AFolderPath + '\*' + constExtStat, faAnyFile, SearchRec);
    try
      while ResultCode = 0 do
      begin
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') and
           (SearchRec.Attr and faDirectory = 0) then
          DeleteFile(PWideChar(AFolderPath + '\' + SearchRec.Name));
        ResultCode := FindNext(SearchRec);
      end;
    finally
      FindClose(SearchRec.FindHandle);
    end;
  end;

  procedure SaveStatistics(const AUserInfo: TUserInfo);
  var
    Count: Integer;
    UserInfoFile: file of TUserInfo;
    FilePath: string;
  begin
    FilePath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + dirAppData;

    Count:= CountFilesWithExtension(FilePath);

    if Count >= constMaxCount then
    begin
      DeleteFilesWithExtension(FilePath);
      Count:= 0;
    end;

    FilePath := TPath.Combine(FilePath, constStatisticsName +'_'+ IntToStr(Count) + constExtStat);

    AssignFile(UserInfoFile, FilePath);
    Rewrite(UserInfoFile);
    try
      Write(UserInfoFile, AUserInfo);
    finally
      CloseFile(UserInfoFile);
    end;
  end;

  function LoadStatistics(const AFilePath: string): TUserInfo;
  var
    UserInfoFile: file of TUserInfo;
  begin
    AssignFile(UserInfoFile, AFilePath);
    Reset(UserInfoFile);
    try
      Read(UserInfoFile, Result);
    except
      ShowMessage(rsErrorFile);
    end;
    CloseFile(UserInfoFile);
  end;

  function FormatStatistics(const AUserInfo: TUserInfo): string;
  begin
    Result := 'User Name: ' + AUserInfo.UserName + sLineBreak;

    if AUserInfo.LoginTime = 0 then
      Result := Result + 'Login Time: None' + sLineBreak
    else
      Result := Result + 'Login Time: ' + FormatDateTime('dd/MM/yyyy HH:mm:ss', AUserInfo.LoginTime) + sLineBreak;

    if AUserInfo.LogoutTime = 0 then
      Result := Result + 'Logout Time: None' + sLineBreak
    else
      Result := Result + 'Logout Time: ' + FormatDateTime('dd/MM/yyyy HH:mm:ss', AUserInfo.LogoutTime) + sLineBreak;

    Result := Result +
              'Global Settings Time: ' + IntToStr(AUserInfo.GlobalSettingsTime) + ' seconds' + sLineBreak +
              'Help Time: ' + IntToStr(AUserInfo.HelpTime) + ' seconds' + sLineBreak +
              'Font Setting Time: ' + IntToStr(AUserInfo.FontSettingTime) + ' seconds' + sLineBreak +
              'Pen Setting Time: ' + IntToStr(AUserInfo.PenSettingTime) + ' seconds' + sLineBreak +
              'Change Action Count: ' + IntToStr(AUserInfo.ChangeActionCount) + sLineBreak +
              'Delete Statement Count: ' + IntToStr(AUserInfo.DeleteStatementCount) + sLineBreak +
              'Add Statement Count: ' + IntToStr(AUserInfo.AddStatementCount);
  end;


  function GetWindowsUserName: string;
  var
    UserName: array[0..255] of Char;
    UserNameLen: DWORD;
  begin
    UserNameLen := SizeOf(UserName);
    if GetUserName(UserName, UserNameLen) then
      Result := UserName
    else
      Result := '';
  end;

  procedure ClearUserInfo(var UserInfo: TUserInfo);
  begin
    FillChar(UserInfo, SizeOf(UserInfo), 0);
  end;

end.
