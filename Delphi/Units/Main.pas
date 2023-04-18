﻿unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ProcessStatement,
  Base, FirstLoop, IfBranching, CaseBranching, LastLoop, StatementSearch, DrawShapes,
  Vcl.StdCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ToolWin, GetСaseСonditions,
  Vcl.ComCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, GetAction, ArrayList, Types,
  AdjustBorders;

type
  TNassiShneiderman = class(TForm)

    MainMenu: TMainMenu;
    mnFile: TMenuItem;
    mnNew: TMenuItem;
    mnOpen: TMenuItem;
    mnSave: TMenuItem;
    mnSaveAs: TMenuItem;
    mnExport: TMenuItem;

    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    tbSelectFigType: TToolBar;
    ILIcons: TImageList;
    spProcess: TSpeedButton;
    spLastLoop: TSpeedButton;
    spFirstLoop: TSpeedButton;
    spCaseBranch: TSpeedButton;
    spIfBranching: TSpeedButton;
    ScrollBox: TScrollBox;
    Image: TImage;
    PopupMenu: TPopupMenu;
    MIAdd: TMenuItem;
    MIAfter: TMenuItem;
    MIBefore: TMenuItem;
    MIAftProcess: TMenuItem;
    MIAftBranch: TMenuItem;
    MIAftMultBranch: TMenuItem;
    MIAftTestLoop: TMenuItem;
    MIAftRevTestLoop: TMenuItem;
    MIBefProcess: TMenuItem;
    MIBefBranch: TMenuItem;
    MIBefMultBranch: TMenuItem;
    MIBefTestLoop: TMenuItem;
    MIBefRevTestLoop: TMenuItem;
    MICut: TMenuItem;
    MICopy: TMenuItem;
    MIInset: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure ClearAndRedraw;

    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageDblClick(Sender: TObject);

    procedure AddBefore(Sender: TObject);
    procedure AddAfter(Sender: TObject);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MICopyClick(Sender: TObject);
    procedure MICutClick(Sender: TObject);
    procedure MIInsetClick(Sender: TObject);
    { Private declarations }
  private
    MainBlock : TBlock;
    DedicatedStatement: TStatement;

    HighlightColor: TColor;

    function TryGetAction(var AAction: String): Boolean;
    function TryGetCond(var AInitialStr: TStringArr): Boolean;
    function CreateStatement(const AStatementClass: TStatementClass): TStatement;
    class function ConvertToBlockType(const AIndex: Integer): TStatementClass;
  private const
    SchemeInitialIndent = 10;
    SchemeInitialFontSize = 24;
    SchemeInitialFont = 'Times New Roman';
  public
    { Public declarations }
  end;

var
  NassiShneiderman: TNassiShneiderman;
  BuferStatement: TStatement;

implementation

  {$R *.dfm}

  procedure TNassiShneiderman.FormClose(Sender: TObject;
  var Action: TCloseAction);
  begin
    MainBlock.Destroy;
  end;

  procedure TNassiShneiderman.FormCreate(Sender: TObject);
  begin

    DedicatedStatement:= nil;
    BuferStatement:= nil;

    Constraints.MinWidth := 600;
    Constraints.MinHeight := 400;

    Base.DefaultBlock:= TProcessStatement;

    Self.DoubleBuffered := true;

    Image.Canvas.Font.Size := SchemeInitialFontSize;

    Image.Canvas.Font.Name := SchemeInitialFont;

    HighlightColor:= clYellow;

    MainBlock:= TBlock.Create(SchemeInitialIndent, 0, nil, Image.Canvas);

    MainBlock.AddFirstStatement(TProcessStatement.CreateUncertainty, SchemeInitialIndent);

    MainBlock.RedefineSizes;

    // Пока так ( может и не пока, выглядит хайпово :) )
    Image.Picture.Bitmap.Width := Screen.Width;
    Image.Picture.Bitmap.Height := Screen.Height;

    ClearAndRedraw;
  end;

  procedure TNassiShneiderman.ClearAndRedraw;
  begin
    Clear(Image.Canvas);

    if DedicatedStatement <> nil then
      ColorizeRectangle(Image.Canvas, DedicatedStatement.BaseBlock.XStart, DedicatedStatement.BaseBlock.XLast,
                      DedicatedStatement.YStart, DedicatedStatement.GetYBottom, HighlightColor);

    MainBlock.DrawBlock;
    //DrawCoordinates(Image.Canvas, 50);
  end;

  procedure TNassiShneiderman.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin

    if Key = VK_DELETE then
    begin
      if DedicatedStatement <> nil then
      begin
        DedicatedStatement.BaseBlock.DeleteStatement(DedicatedStatement);
        DedicatedStatement:= nil;

        DefineBorders(MainBlock.XLast, MainBlock.Statements.GetLast.GetYBottom, Image);
      end;

      ClearAndRedraw;
    end
    else if ssCtrl in Shift then
      case Key of
        Ord('C'): MICopyClick(Self);
        Ord('V'): MIInsetClick(Self);
        Ord('X'): MICutClick(Self);
      end;

  end;

  procedure TNassiShneiderman.ScrollBoxMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
    var Handled: Boolean);
  const
    ScrotStep = 42;
  begin
    if ssCtrl in Shift then
    begin
      if WheelDelta > 0 then
        ScrollBox.HorzScrollBar.Position := ScrollBox.HorzScrollBar.Position - ScrotStep
      else
        ScrollBox.HorzScrollBar.Position := ScrollBox.HorzScrollBar.Position + ScrotStep;
    end
    else
    begin
      if WheelDelta > 0 then
        ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position - ScrotStep
      else
        ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position + ScrotStep;
    end;
  end;

  procedure TNassiShneiderman.ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
    DedicatedStatement := BinarySearchStatement(X, Y, MainBlock);

    ClearAndRedraw;

    if (Button = mbRight) and (DedicatedStatement <> nil) then
      PopupMenu.Popup(Image.Left + X + ScrollBox.Left, Image.Top + Y
                      + ScrollBox.Top);
  end;

  procedure TNassiShneiderman.MICopyClick(Sender: TObject);
  begin
    if DedicatedStatement <> nil then
    begin
      if BuferStatement <> nil then
        BuferStatement.Destroy;
      BuferStatement:= DedicatedStatement.Clone;
    end;
  end;

  procedure TNassiShneiderman.MICutClick(Sender: TObject);
  begin
    if DedicatedStatement <> nil then
    begin
      if BuferStatement <> nil then
        BuferStatement.Destroy;
      BuferStatement:= DedicatedStatement.Clone;
      DedicatedStatement.BaseBlock.DeleteStatement(DedicatedStatement);
      DedicatedStatement:= nil;
      ClearAndRedraw;
    end;
  end;

  procedure TNassiShneiderman.MIInsetClick(Sender: TObject);
  begin
    if (BuferStatement <> nil) and (DedicatedStatement <> nil) then
    begin
      DedicatedStatement.BaseBlock.AddAfter(DedicatedStatement, BuferStatement);
      BuferStatement:= BuferStatement.Clone;
      DefineBorders(MainBlock.XLast, MainBlock.Statements.GetLast.GetYBottom, Image);
      ClearAndRedraw;
    end;
  end;

  procedure TNassiShneiderman.AddBefore(Sender: TObject);
  var
    NewStatement: TStatement;
  begin

    if DedicatedStatement <> nil then
    begin
      NewStatement:= CreateStatement(ConvertToBlockType(TComponent(Sender).Tag));

      if NewStatement <> nil then
      begin
        DedicatedStatement.BaseBlock.AddBefore(DedicatedStatement, NewStatement);
        DefineBorders(MainBlock.XLast, MainBlock.Statements.GetLast.GetYBottom, Image);
      end;

      DedicatedStatement:= nil;
    end;

    ClearAndRedraw;
  end;

  procedure TNassiShneiderman.AddAfter(Sender: TObject);
  var
    NewStatement: TStatement;
  begin

    if DedicatedStatement <> nil then
    begin
      NewStatement:= CreateStatement(ConvertToBlockType(TComponent(Sender).Tag));

      if NewStatement <> nil then
      begin
        DedicatedStatement.BaseBlock.AddAfter(DedicatedStatement, NewStatement);
        DefineBorders(MainBlock.XLast, MainBlock.Statements.GetLast.GetYBottom, Image);
      end;

      DedicatedStatement:= nil;
    end;

    ClearAndRedraw;
  end;

  procedure TNassiShneiderman.ImageDblClick(Sender: TObject);
  var
    MousePos: TPoint;
    Statement: TStatement;
    Action: String;
    Cond: TStringArr;
    CaseBranching: TCaseBranching;
  begin
    MousePos := Image.ScreenToClient(Mouse.CursorPos);

    Statement := BinarySearchStatement(MousePos.X, MousePos.Y, MainBlock);

    if Statement <> nil then
    begin
      Action := Statement.Action;

      if TryGetAction(Action) then
      begin
        if Statement is TCaseBranching then
        begin
          CaseBranching:= TCaseBranching(Statement);
          Cond:= CaseBranching.Cond;
          if TryGetCond(Cond) then
            CaseBranching.ChangeActionWithCond(Action, Cond);
        end
        else
          Statement.ChangeAction(Action);

        DefineBorders(MainBlock.XLast, MainBlock.Statements.GetLast.GetYBottom, Image);
      end;
    end;

    ClearAndRedraw;
  end;

  class function TNassiShneiderman.ConvertToBlockType(const AIndex: Integer): TStatementClass;
  begin
    case AIndex of
      0 : Result:= TProcessStatement;
      1 : Result:= TIfBranching;
      2 : Result:= TCaseBranching;
      3 : Result:= TFirstLoop;
      4 : Result:= TLastLoop;
    end;
  end;

  function TNassiShneiderman.TryGetCond(var AInitialStr: TStringArr): Boolean;
  var
    WriteСaseСonditions: TWriteСaseСonditions;
    I : Integer;
  begin
    WriteСaseСonditions := TWriteСaseСonditions.Create(Self, AInitialStr);
    WriteСaseСonditions.ShowModal;

    if WriteСaseСonditions.ModalResult = mrOk then
    begin
      Result:= True;
      AInitialStr:= WriteСaseСonditions.GetСaseСonditions;
    end
    else
      Result:= False;

    WriteСaseСonditions.Destroy;
  end;

  function TNassiShneiderman.TryGetAction(var AAction: String): Boolean;
  var
    WriteActionForm: TWriteAction;
  begin
    WriteActionForm := TWriteAction.Create(Self, AAction);
    WriteActionForm.ShowModal;

    if WriteActionForm.ModalResult = mrOk then
    begin
      Result:= True;
      AAction:= WriteActionForm.GetAction;
    end
    else
      Result:= False;

    WriteActionForm.Destroy;
  end;

  function TNassiShneiderman.CreateStatement(const AStatementClass: TStatementClass): TStatement;
  var
    Action: String;
    Cond: TStringArr;
  begin
    Result:= nil;
    Action := '';

    if TryGetAction(Action) then
    begin

      if AStatementClass = TCaseBranching then
      begin
        Cond:= nil;
        if TryGetCond(Cond) then
          Result:= TCaseBranching.Create(Action, Cond, Image.Canvas);
      end
      else
        Result:= AStatementClass.Create(Action);
    end;
  end;

end.
