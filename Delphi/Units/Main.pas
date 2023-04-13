﻿unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ProcessStatement,
  Base, FirstLoop, IfBranching, CaseBranching, LastLoop, StatementSearch, DrawShapes,
  Vcl.StdCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ToolWin,
  Vcl.ComCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, GetAction;

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
    { Private declarations }
  private
    function GetAction(AInitialStr: String = ''): String;
  private class
    function ConvertToBlockType(AIndex: Integer): TStatementClass;
  private const
    InitialIndent = 10;
    InitialFontSize = 24;
    InitialFont = 'Times New Roman';
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

  procedure TNassiShneiderman.FormCreate(Sender: TObject);
  begin

    Constraints.MinWidth := 600;
    Constraints.MinHeight := 400;

    Base.DefaultBlock:= TProcessStatement;

    Self.DoubleBuffered := true;

    Image.Canvas.Font.Size := InitialFontSize;

    Image.Canvas.Font.Name := InitialFont;

    HighlightColor:= clYellow;

    MainBlock:= TBlock.Create(InitialIndent, 0, nil);

    MainBlock.AddStatement(TProcessStatement.CreateUncertainty(InitialIndent,
                           MainBlock, Image));

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
    //DrawCoordinates(Image.Canvas, 50);
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

  procedure TNassiShneiderman.ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
    DedicatedStatement := BinarySearchStatement(X, Y, MainBlock);

    ClearAndRedraw;
  end;

  procedure TNassiShneiderman.ScrollBoxMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
    var Handled: Boolean);
  begin
    if WheelDelta > 0 then
      ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position - 15
    else
      ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position + 15;
  end;

function TNassiShneiderman.GetAction(AInitialStr: String = ''): String;
  var
    writeActionForm: TWriteAction;
  begin
    writeActionForm := TWriteAction.Create(Self, AInitialStr);
    writeActionForm.ShowModal;

    Result:= writeActionForm.MemoAction.Lines.Text;

    writeActionForm.Free;
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
  begin

    if (DedicatedStatement <> nil) and (Sender is TSpeedButton) then
      DedicatedStatement.BaseBlock.AddAfter(DedicatedStatement,
                    ConvertToBlockType(TSpeedButton(Sender).Tag), GetAction);

    ClearAndRedraw;
  end;

end.