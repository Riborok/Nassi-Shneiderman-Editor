unit frmHelp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.OleCtrls, SHDocVw, ShellAPI, uConstants, System.IOUtils;

type
  THelp = class(TForm)
    WebBrowser: TWebBrowser;
    pmHtmlMenu: TPopupMenu;
    pmiClose: TMenuItem;
    pmLicense: TMenuItem;
    procedure pmiCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WebBrowserBeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure pmLicenseClick(Sender: TObject);
  private
    MinFormWidth, MinFormHeight : Integer;
    procedure WMMouseActivate(var Msg: TMessage); message WM_MOUSEACTIVATE;
  public
    procedure Execute(AName: WideString);
  end;

var
  Help: THelp;

implementation

{$R *.dfm}

  procedure THelp.WebBrowserBeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
  begin
    if Pos('github.com', URL) > 0 then
    begin
      ShellExecuteW(Handle, 'open', PWideChar(WideString(URL)), nil, nil, SW_SHOWNORMAL);
      Cancel := True;
    end;
  end;

procedure THelp.WMMouseActivate(var Msg: TMessage);
  begin
    try
      inherited;
      if Msg.LParamHi = 516 then
      pmHtmlMenu.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
      Msg.Result := 0;
    except
    end;
  end;

  procedure THelp.FormCreate(Sender: TObject);
  begin
    MinFormWidth := Round(Screen.Width / 2.7);
    MinFormHeight := Round(Screen.Height / 2.7);

    Constraints.MinWidth := MinFormWidth;
    Constraints.MinHeight := MinFormHeight;
  end;

  procedure THelp.FormShow(Sender: TObject);
  begin
    WindowState := wsNormal;

    Width := MinFormWidth;
    Height := MinFormHeight;

    Left := (Screen.Width - Width) shr 1;
    Top := (Screen.Height - Height) shr 1;
  end;

  procedure THelp.pmiCloseClick(Sender: TObject);
  begin
    Close;
  end;

  procedure THelp.pmLicenseClick(Sender: TObject);
  var
    FilePath: string;
  begin
    FilePath := IncludeTrailingPathDelimiter(
                ExtractFileDir(ExtractFileDir(ExtractFileDir(
                IncludeTrailingPathDelimiter(
                ExtractFileDir(ParamStr(0))))))) + PathToMITLicense;

    if FileExists(FilePath) then
      ShowMessage(TFile.ReadAllText(FilePath))
    else
      ShellExecuteW(Handle, 'open', PathToGitHubLicense, nil, nil, SW_SHOWNORMAL);
  end;

  procedure THelp.Execute(AName: WideString);
  var
    Flags, TargetFrameName, PostData, Headers: OleVariant;
  begin
    WebBrowser.Navigate('res://' + Application.ExeName + '/' + AName,
                         Flags, TargetFrameName, PostData, Headers);
    ShowModal;
  end;

end.
