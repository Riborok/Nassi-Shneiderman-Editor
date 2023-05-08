unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus, uConstants,
  uBase, uFirstLoop, uIfBranching, uCaseBranching, uLastLoop, uProcessStatement,
  uStatementSearch, System.Actions, Vcl.ActnList, Vcl.ToolWin, Types, uBlockManager,
  Vcl.ComCtrls, uAdditionalTypes, frmPenSetting, System.ImageList, Vcl.ImgList;

type
  TNassiShneiderman = class(TForm)
    tbSelectFigType: TToolBar;
    ilIcons: TImageList;
    ScrollBox: TScrollBox;
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
    alActions: TActionList;
    actAfterProcess: TAction;
    actAfterIfBranch: TAction;
    actAfterMultBranch: TAction;
    actAfterLoop: TAction;
    actAfterRevLoop: TAction;
    tbProcess: TToolButton;
    tbIfBranch: TToolButton;
    tbMultBranch: TToolButton;
    tbLoop: TToolButton;
    tbRevLoop: TToolButton;
    actBeforeProcess: TAction;
    actBeforeIfBranch: TAction;
    actBeforeMultBranch: TAction;
    actBeforeLoop: TAction;
    actBeforeRevLoop: TAction;
    actCopy: TAction;
    actInsert: TAction;
    actCut: TAction;
    N1: TMenuItem;
    N3: TMenuItem;
    actDelete: TAction;
    MIDel: TMenuItem;
    actSortAsc: TAction;
    actSortDesc: TAction;
    MIDescSort: TMenuItem;
    MIAscSort: TMenuItem;
    N2: TMenuItem;
    actChangeAction: TAction;
    MIChangeAction: TMenuItem;
    PaintBox: TPaintBox;
    actUndo: TAction;
    actRedo: TAction;
    N4: TMenuItem;
    MIUndo: TMenuItem;
    MIRedo: TMenuItem;
    MainMenu: TMainMenu;
    mnFile: TMenuItem;
    mnNew: TMenuItem;
    mnOpen: TMenuItem;
    mnSave: TMenuItem;
    mnSaveAs: TMenuItem;
    mnExport: TMenuItem;
    mnPrefer: TMenuItem;
    mnFont: TMenuItem;
    mnPen: TMenuItem;
    actChngFont: TAction;
    actChngPen: TAction;
    FontDialog: TFontDialog;
    ColorDialog: TColorDialog;

    procedure FormCreate(Sender: TObject);

    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DblClick(Sender: TObject);

    procedure AddBefore(Sender: TObject);
    procedure AddAfter(Sender: TObject);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure MICopyClick(Sender: TObject);
    procedure MICutClick(Sender: TObject);
    procedure MIInsetClick(Sender: TObject);
    procedure DeleteStatement(Sender: TObject);
    procedure Sort(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure actChangeActionExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PaintBoxPaint(Sender: TObject);
    procedure actUndoExecute(Sender: TObject);
    procedure actRedoExecute(Sender: TObject);
    procedure actChngFontExecute(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actChngPenExecute(Sender: TObject);
  private
    FPenDialog: TPenDialog;

    FPrevMousePos: TPoint;

    FPen: TPen;
    FFont: TFont;

    FisZXCVPressed: Boolean;

    FMayDrag, FWasDbClick: Boolean;

    FBlockManager: TBlockManager;

    class function ConvertToBlockType(const AIndex: Integer): TStatementClass;

    function GetVisibleImageScreen: TVisibleImageRect;
    procedure SetScrollPos(const AStatement: TStatement);

    function isDragging: Boolean; inline;
  private const
    SchemeInitialFontSize = 13;
    SchemeInitialFont = 'Courier new';
    SchemeInitialFontColor: TColor = clBlack;
    SchemeInitialFontStyles: TFontStyles = [];

    SchemeInitialPenColor: TColor = clBlack;
    SchemeInitialPenWidth = 1;
    SchemeInitialPenStyle: TPenStyle = psSolid;
    SchemeInitialPenMode: TPenMode = pmCopy;
  public
    destructor Destroy;
  end;

var
  NassiShneiderman: TNassiShneiderman;

implementation

  {$R *.dfm}

  { TNassiShneiderman }

  procedure TNassiShneiderman.FormCreate(Sender: TObject);
  const
    MinFormSize = 600;
  begin
    SetThreadUILanguage(MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US));
    Self.DoubleBuffered := True;
    FisZXCVPressed:= False;
    FMayDrag:= False;
    FWasDbClick:= False;
    Constraints.MinWidth := MinFormSize;
    Constraints.MinHeight := MinFormSize;

    actDelete.ShortCut := ShortCut(VK_DELETE, []);
    actChangeAction.ShortCut := ShortCut(VK_RETURN, []);
    actUndo.ShortCut := ShortCut(VK_Z, [ssCtrl]);
    actRedo.ShortCut := ShortCut(VK_Z, [ssCtrl, ssShift]);

    FPenDialog:= TPenDialog.Create(Self, ColorDialog);

    FPen:= FPenDialog.Pen;
    FFont:= FontDialog.Font;

    FFont.Size := SchemeInitialFontSize;
    FFont.Name := SchemeInitialFont;
    FFont.Color := SchemeInitialFontColor;
    FFont.Style := SchemeInitialFontStyles;

    FPen.Color := SchemeInitialPenColor;
    FPen.Width := SchemeInitialPenWidth;
    FPen.Style := SchemeInitialPenStyle;
    FPen.Mode := SchemeInitialPenMode;

    PaintBox.Canvas.Font := FFont;
    PaintBox.Canvas.Pen := FPen;

    uBase.DefaultStatement:= TProcessStatement;

    FBlockManager:= TBlockManager.Create(PaintBox, clYellow);

    PaintBox.Invalidate;
  end;

  procedure TNassiShneiderman.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    FBlockManager.TryMoveDedicated(SetScrollPos, Key);
  end;

  procedure TNassiShneiderman.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    FisZXCVPressed:= False;
  end;

  procedure TNassiShneiderman.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  begin
    if FisZXCVPressed then
      Handled:= True
    else case Msg.CharCode of
      VK_Z, VK_X, VK_C, VK_V:
        FisZXCVPressed:= True;
    end;
  end;

  procedure TNassiShneiderman.PaintBoxPaint(Sender: TObject);
  begin
    PaintBox.Canvas.Font := FFont;
    PaintBox.Canvas.Pen := FPen;

    FBlockManager.Draw(GetVisibleImageScreen);
  end;

  procedure TNassiShneiderman.ScrollBoxMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
    var Handled: Boolean);
  const
    ScrotStep = 42 shl 1;
  begin
    if ssShift in Shift then
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

    MousePos:= PaintBox.ScreenToClient(Mouse.CursorPos);
    MouseMove(Sender, Shift, MousePos.X, MousePos.Y);
  end;

  procedure TNassiShneiderman.PopupMenuPopup(Sender: TObject);
  var
    isCaseBranching: Boolean;
  begin
    isCaseBranching:= FBlockManager.DedicatedStatement is TCaseBranching;
    MIAscSort.Visible:= isCaseBranching;
    MIDescSort.Visible:= isCaseBranching;
    MIUndo.Enabled:= FBlockManager.UndoStack.Count <> 0;
    MIRedo.Enabled:= FBlockManager.RedoStack.Count <> 0;
  end;

  procedure TNassiShneiderman.DblClick(Sender: TObject);
  begin
    FBlockManager.TryChangeDedicatedText;
    FWasDbClick:= True;
  end;

  procedure TNassiShneiderman.MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
    FBlockManager.DedicatedStatement := BinarySearchStatement(X, Y, FBlockManager.MainBlock);

    if FBlockManager.DedicatedStatement <> nil then
    begin
      case Button of
        mbLeft:
        begin
          FMayDrag:= not FWasDbClick;
          FWasDbClick:= False;
          FPrevMousePos := Point(X, Y);
        end;
        mbRight:
          PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
      end;
    end;

  end;

  procedure TNassiShneiderman.MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
  const
    AmountPixelToMove = 42;
  begin
    if isDragging then
    begin
      FBlockManager.DefineHover(X, Y);
      FBlockManager.MoveCarryBlock(X - FPrevMousePos.X, Y - FPrevMousePos.Y);

      FPrevMousePos := Point(X, Y);
    end
    else if FMayDrag and ((Abs(FPrevMousePos.X - X) > AmountPixelToMove) or
                          (Abs(FPrevMousePos.Y - Y) > AmountPixelToMove)) then
    begin
      FMayDrag:= False;
      if isDragging then
        FBlockManager.DestroyCarryBlock;

      FBlockManager.CreateCarryBlock;
    end;
  end;

  procedure TNassiShneiderman.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
    FMayDrag:= False;
    if isDragging then
      FBlockManager.DestroyCarryBlock;
  end;

  procedure TNassiShneiderman.MICopyClick(Sender: TObject);
  begin
    FBlockManager.TryCopyDedicated;
  end;

  procedure TNassiShneiderman.MICutClick(Sender: TObject);
  begin
    FBlockManager.TryCutDedicated;
  end;

  procedure TNassiShneiderman.MIInsetClick(Sender: TObject);
  begin
    FBlockManager.TryInsertBufferBlock;
  end;

  procedure TNassiShneiderman.AddAfter(Sender: TObject);
  begin
    FBlockManager.TryAddNewStatement(ConvertToBlockType(TComponent(Sender).Tag), True);
  end;

  procedure TNassiShneiderman.AddBefore(Sender: TObject);
  begin
    FBlockManager.TryAddNewStatement(ConvertToBlockType(TComponent(Sender).Tag), False);
  end;

  procedure TNassiShneiderman.Sort(Sender: TObject);
  begin
    FBlockManager.SortDedicatedCase(TComponent(Sender).Tag);
  end;

  procedure TNassiShneiderman.actRedoExecute(Sender: TObject);
  begin
    FBlockManager.TryRedo;
  end;

  procedure TNassiShneiderman.actUndoExecute(Sender: TObject);
  begin
    FBlockManager.TryUndo;
  end;

  procedure TNassiShneiderman.DeleteStatement(Sender: TObject);
  begin
    FBlockManager.TryDeleteDedicated;
  end;

  procedure TNassiShneiderman.actChangeActionExecute(Sender: TObject);
  begin
    FBlockManager.TryChangeDedicatedText;
  end;

  procedure TNassiShneiderman.actChngFontExecute(Sender: TObject);
  begin
    if FontDialog.Execute then
    begin
      PaintBox.Canvas.Font:= FFont;
      FBlockManager.RedefineMainBlock;
    end;
  end;

  procedure TNassiShneiderman.actChngPenExecute(Sender: TObject);
  begin
    if FPenDialog.Execute then
    begin
      PaintBox.Canvas.Pen:= FPen;
      FBlockManager.RedefineMainBlock;
    end;
  end;

  { Private methods }
  destructor TNassiShneiderman.Destroy;
  begin
    FBlockManager.Destroy;

    FPenDialog.Destroy;

    inherited;
  end;

  function TNassiShneiderman.isDragging: Boolean;
  begin
    Result:= FBlockManager.CarryBlock <> nil;
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

  function TNassiShneiderman.GetVisibleImageScreen: TVisibleImageRect;
  begin
    Result.FTopLeft := PaintBox.ScreenToClient(ScrollBox.ClientToScreen(Point(0, 0)));
    Result.FBottomRight := PaintBox.ScreenToClient(
          ScrollBox.ClientToScreen(Point(ScrollBox.Width, ScrollBox.Height)));
  end;

  procedure TNassiShneiderman.SetScrollPos(const AStatement: TStatement);
  const
    Stock = 42;
  var
    VisibleImageScreen: TVisibleImageRect;
  begin
    VisibleImageScreen:= GetVisibleImageScreen;

    case AStatement.BaseBlock.GetMask(VisibleImageScreen) of
      $09 {1001}:
         ScrollBox.HorzScrollBar.Position:= ScrollBox.HorzScrollBar.Position +
         AStatement.BaseBlock.XLast - VisibleImageScreen.FBottomRight.X + Stock;
      $06 {1100}:
         ScrollBox.HorzScrollBar.Position:= AStatement.BaseBlock.XStart - Stock;
    end;

    case AStatement.GetMask(VisibleImageScreen, AStatement is TOperator) of
      $09 {1001}:
         ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position +
         AStatement.GetYBottom - VisibleImageScreen.FBottomRight.Y + Stock;
      $06 {1100}:
         ScrollBox.VertScrollBar.Position := AStatement.YStart - Stock;
    end;
  end;

end.
