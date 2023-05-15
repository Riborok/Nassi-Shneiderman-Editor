unit frmHelp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.OleCtrls, SHDocVw, ShellAPI;

type
  THelp = class(TForm)
    WebBrowser: TWebBrowser;
    pmHtmlMenu: TPopupMenu;
    pmiClose: TMenuItem;
    procedure pmiCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WebBrowserBeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
  private const
    MinFormWidth = 642;
    MinFormHeight = 342;
  private
    procedure WMMouseActivate(var Msg: TMessage); message WM_MOUSEACTIVATE;
    procedure OpenURL(const URL: string);
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

  procedure THelp.Execute(AName: WideString);
  var
    Flags, TargetFrameName, PostData, Headers: OleVariant;
  begin
    WebBrowser.Navigate('res://' + Application.ExeName + '/' + AName,
                        Flags, TargetFrameName, PostData, Headers);
    ShowModal;
  end;

  procedure THelp.OpenURL(const URL: string);
  begin
    ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
  end;

end.
