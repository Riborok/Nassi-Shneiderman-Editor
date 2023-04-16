﻿unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ProcessStatement,
  Base, FirstLoop, IfBranching, CaseBranching, LastLoop, StatementSearch, DrawShapes,
  Vcl.StdCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ToolWin, GetСaseСonditions,
  Vcl.ComCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, GetAction, ArrayList, Types,
  CorrectAction;

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
    ilBlocks: TImageList;
    spProcess: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    spIfBranching: TSpeedButton;
    ScrollBox: TScrollBox;
    Image: TImage;

    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure ClearAndRedraw;

    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageDblClick(Sender: TObject);

    procedure spStatementClick(Sender: TObject);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    { Private declarations }
  private
    function GetAction(AInitialStr: String = ''): String;
    function GetCond(AInitialStr: TStringArr = nil): TStringArr;
  private class
    function ConvertToBlockType(AIndex: Integer): TStatementClass;
  private const
    SchemeInitialIndent = 10;
    SchemeInitialFontSize = 24;
    SchemeInitialFont = 'Times New Roman';
  public
    { Public declarations }
    MainBlock : TBlock;
    DedicatedStatement: TStatement;

    HighlightColor: TColor;
  end;

var
  NassiShneiderman: TNassiShneiderman;

implementation

  {$R *.dfm}

  procedure TNassiShneiderman.FormClose(Sender: TObject;
  var Action: TCloseAction);
  begin
    MainBlock.Destroy;
  end;

  procedure TNassiShneiderman.FormCreate(Sender: TObject);
  begin

    Constraints.MinWidth := 600;
    Constraints.MinHeight := 400;

    Base.DefaultBlock:= TProcessStatement;

    Self.DoubleBuffered := true;

    Image.Canvas.Font.Size := SchemeInitialFontSize;

    Image.Canvas.Font.Name := SchemeInitialFont;

    HighlightColor:= clYellow;

    MainBlock:= TBlock.Create(SchemeInitialIndent, 0, nil);

    MainBlock.AddFirstStatement(TProcessStatement.CreateUncertainty(
                           MainBlock, Image), SchemeInitialIndent);

    MainBlock.RedefineSizes;

    // Пока так
    Image.Picture.Bitmap.Width := Screen.Width;
    Image.Picture.Bitmap.Height := Screen.Height;

    ClearAndRedraw;
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
      end;

      ClearAndRedraw;
    end;
  end;

  procedure TNassiShneiderman.ClearAndRedraw;
  begin
    Clear(Image.Canvas);

    if DedicatedStatement <> nil then
      ColorizeRectangle(Image.Canvas, DedicatedStatement.BaseBlock.XStart, DedicatedStatement.BaseBlock.XLast,
                      DedicatedStatement.YStart, DedicatedStatement.GetYBottom, HighlightColor);

    MainBlock.DrawBlock;
    DrawCoordinates(Image.Canvas, 50);
  end;

  procedure TNassiShneiderman.ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
    DedicatedStatement := BinarySearchStatement(X, Y, MainBlock);

    ClearAndRedraw;
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

  function TNassiShneiderman.GetCond(AInitialStr: TStringArr = nil): TStringArr;
  var
    WriteСaseСonditions: TWriteСaseСonditions;
    I : Integer;
  begin
    if AInitialStr = nil then
    begin
      SetLength(AInitialStr, 2);
      AInitialStr[0]:= '';
      AInitialStr[1]:= '';
    end;

    WriteСaseСonditions := TWriteСaseСonditions.Create(Self, AInitialStr);
    WriteСaseСonditions.ShowModal;

    SetLength(Result, WriteСaseСonditions.MemoList.Count);

    for I := 0 to WriteСaseСonditions.MemoList.Count - 1 do
      Result[I]:= GetCorrectAction(WriteСaseСonditions.MemoList[I].Lines.Text);

    WriteСaseСonditions.Destroy;
  end;

  function TNassiShneiderman.GetAction(AInitialStr: String = ''): String;
  var
    WriteActionForm: TWriteAction;
  begin
    WriteActionForm := TWriteAction.Create(Self, AInitialStr);
    WriteActionForm.ShowModal;

    Result:= GetCorrectAction(WriteActionForm.MemoAction.Lines.Text);

    WriteActionForm.Destroy;
  end;

  class function TNassiShneiderman.ConvertToBlockType(AIndex: Integer): TStatementClass;
  begin
    case AIndex of
      0 : Result:= TProcessStatement;
      1 : Result:= TIfBranching;
      2 : Result:= TCaseBranching;
      3 : Result:= TFirstLoop;
      4 : Result:= TLastLoop;
    end;
  end;

  procedure TNassiShneiderman.spStatementClick(Sender: TObject);
  var
    NewStatement: TStatement;
    StatementClass: TStatementClass;
    Action: String;
  begin

    if (DedicatedStatement <> nil) and (Sender is TSpeedButton) then
    begin
      StatementClass:= ConvertToBlockType(TSpeedButton(Sender).Tag);
      Action := GetAction;

      if StatementClass = TCaseBranching then
         NewStatement:= TCaseBranching.Create(Action, GetCond,
                            DedicatedStatement.BaseBlock, Image)
      else
        NewStatement:= StatementClass.Create(Action,
                            DedicatedStatement.BaseBlock, Image);

      DedicatedStatement.BaseBlock.AddAfter(DedicatedStatement, NewStatement);
    end;

    ClearAndRedraw;
  end;

  procedure TNassiShneiderman.ImageDblClick(Sender: TObject);
  var
    MousePos: TPoint;
    Statement: TStatement;
  begin
    MousePos := Image.ScreenToClient(Mouse.CursorPos);

    Statement := BinarySearchStatement(MousePos.X, MousePos.Y, MainBlock);

    if Statement <> nil then
      Statement.ChangeAction(GetAction(Statement.Action));

    ClearAndRedraw;
  end;

end.
