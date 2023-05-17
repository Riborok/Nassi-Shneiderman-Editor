﻿unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus, uConstants,
  uBase, uFirstLoop, uIfBranching, uCaseBranching, uLastLoop, uProcessStatement,
  uStatementSearch, System.Actions, Vcl.ActnList, Vcl.ToolWin, Types, uBlockManager,
  Vcl.ComCtrls, uAdditionalTypes, frmPenSetting, System.ImageList, Vcl.ImgList, frmGlobalSettings,
  System.SysUtils, uGlobalSave, uLocalSave, frmHelp, uStatementConverter, uDialogMessages;

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
    MIDelete: TMenuItem;
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
    sep1: TToolButton;
    tbFont: TToolButton;
    tbPen: TToolButton;
    sep2: TToolButton;
    tbDelete: TToolButton;
    tbAction: TToolButton;
    sep3: TToolButton;
    tbInsert: TToolButton;
    tbCopy: TToolButton;
    tbCut: TToolButton;
    tbUndo: TToolButton;
    tbRedo: TToolButton;
    sep4: TToolButton;
    tbSortDesc: TToolButton;
    tbSortAsc: TToolButton;
    sep5: TToolButton;
    actChngGlSettings: TAction;
    ToolButton1: TToolButton;
    Globalsettings1: TMenuItem;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    mnDiagram: TMenuItem;
    mnAdd: TMenuItem;
    mnAfter: TMenuItem;
    mnBefore: TMenuItem;
    mnAftProcess: TMenuItem;
    mnAftBranchingBlock: TMenuItem;
    mnAftMultBranchingBlock: TMenuItem;
    mnAftReversedLoop: TMenuItem;
    mnAftLoop: TMenuItem;
    actBefProcess: TMenuItem;
    mnBefBranchingBlock: TMenuItem;
    mnBefMultBranchingBlock: TMenuItem;
    mnBefLoop: TMenuItem;
    mnBefReversedLoop: TMenuItem;
    mnChangeAct: TMenuItem;
    mnDelete: TMenuItem;
    mnSortDesc: TMenuItem;
    mnSortAsc: TMenuItem;
    mnEdit: TMenuItem;
    N5: TMenuItem;
    mnUndo: TMenuItem;
    mnRedo: TMenuItem;
    N6: TMenuItem;
    mnCut: TMenuItem;
    mnCopy: TMenuItem;
    mnInsert: TMenuItem;
    mnHelp: TMenuItem;
    mnUserGuide: TMenuItem;
    mnAbout: TMenuItem;
    actUserGuide: TAction;
    actAbout: TAction;
    sep6: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    actExit: TAction;
    Exit1: TMenuItem;
    actSaveAs: TAction;
    actSave: TAction;
    actOpen: TAction;
    actNew: TAction;

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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actChngGlSettingsExecute(Sender: TObject);
    procedure mnDiagramClick(Sender: TObject);
    procedure mnEditClick(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
  private type
    TFileMode = (fmJSON, fmSvg, fmBmp, fmPng, fmAll);
  private
    FPenDialog: TPenDialog;
    FGlobalSettingsDialog: TGlobalSettingsDialog;

    FPrevMousePos: TPoint;

    FisPressed: Boolean;

    FMayDrag, FWasDbClick: Boolean;

    FBlockManager: TBlockManager;

    function GetVisibleImageScreen: TVisibleImageRect;
    procedure SetScrollPos(const AStatement: TStatement);

    function isDragging: Boolean; inline;

    procedure UpdateForDedicatedStatement;
    procedure UpdateForStack;

    procedure SetOpenFileMode(mode: TFileMode);
    procedure SetSaveFileMode(mode: TFileMode);
  public
    destructor Destroy;
  end;

var
  NassiShneiderman: TNassiShneiderman;

implementation

  {$R *.dfm}

  { TNassiShneiderman }

  procedure TNassiShneiderman.FormClose(Sender: TObject;
  var Action: TCloseAction);
  var
    Answer: integer;
  begin
    SaveGlobalSettings;
    if not (FBlockManager.isSaved or FBlockManager.isDefaultMainBlock) then
    begin
      Answer := MessageDlg(rsExitDlg, mtWarning, [mbYes,mbNo,mbCancel], 0);
      case Answer of
        mrYes:
        begin
          SetSaveFileMode(fmJSON);

          if SaveDialog.Execute then
          begin
            FBlockManager.PathToFile := SaveDialog.FileName;
            SaveSchema(FBlockManager);
            Action := caFree;
          end
          else
            Action := caNone;
        end;
        mrNo: Action := caFree;
        mrCancel: Action := caNone;
      end;
    end;
  end;

  procedure TNassiShneiderman.FormCreate(Sender: TObject);
  const
    MinFormWidth = 850;
    MinFormHeight = 600;
  begin
    SaveDialog.Title := 'Save As';
    OpenDialog.Title := 'Open';

    LoadGlobalSettings;
    DefaultStatement := TProcessStatement;

    SetThreadUILanguage(MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US));
    Self.DoubleBuffered := True;
    FisPressed:= False;
    FMayDrag:= False;
    FWasDbClick:= False;
    Constraints.MinWidth := MinFormWidth;
    Constraints.MinHeight := MinFormHeight;

    actDelete.ShortCut := ShortCut(VK_DELETE, []);
    actChangeAction.ShortCut := ShortCut(VK_RETURN, []);
    actUndo.ShortCut := ShortCut(VK_Z, [ssCtrl]);
    actRedo.ShortCut := ShortCut(VK_Z, [ssCtrl, ssShift]);
    actChngFont.ShortCut := ShortCut(VK_F, [ssShift, ssCtrl]);
    actChngPen.ShortCut := ShortCut(VK_P, [ssShift, ssCtrl]);
    actChngGlSettings.ShortCut := ShortCut(VK_G, [ssCtrl, ssShift]);
    actSortAsc.ShortCut := ShortCut(VK_RIGHT, [ssCtrl, ssShift]);
    actSortDesc.ShortCut := ShortCut(VK_LEFT, [ssCtrl, ssShift]);

    FPenDialog:= TPenDialog.Create(Self, ColorDialog);
    FGlobalSettingsDialog:= TGlobalSettingsDialog.Create(Self, ColorDialog);

    TBlockManager.BufferBlock := TBlock.Create(0, PaintBox.Canvas);
    TBlockManager.BufferBlock.AddStatement(uBase.DefaultStatement.Create(
                                     DefaultAction, TBlockManager.BufferBlock));

    FBlockManager:= TBlockManager.Create(PaintBox);
    FBlockManager.InitializeMainBlock;
  end;

  procedure TNassiShneiderman.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    FBlockManager.TryMoveDedicated(SetScrollPos, Key);
    UpdateForDedicatedStatement;
  end;

  procedure TNassiShneiderman.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    FisPressed:= False;
  end;

  procedure TNassiShneiderman.actExitExecute(Sender: TObject);
  begin
    Close;
  end;

  procedure TNassiShneiderman.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  begin
    if FisPressed then
      Handled:= True
    else if GetKeyState(VK_RETURN) < 0 then
      FisPressed:= True
    else case Msg.CharCode of
      VK_Z, VK_X, VK_C, VK_V:
        FisPressed:= True;
      VK_RIGHT, VK_Left:
      begin
        FisPressed:= True;
        if (GetKeyState(VK_CONTROL) >= 0) or (GetKeyState(VK_SHIFT) >= 0 ) then
          FormKeyDown(nil, Msg.CharCode, []);
      end;
    end

  end;

  procedure TNassiShneiderman.PaintBoxPaint(Sender: TObject);
  begin
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
    bool : Boolean;
  begin
    bool := FBlockManager.DedicatedStatement is TCaseBranching;
    MIAscSort.Visible:= bool;
    MIDescSort.Visible:= bool;

    bool := FBlockManager.UndoStack.Count <> 0;
    MIUndo.Enabled:= bool;
    MIRedo.Enabled:= bool;

    bool := not isDefaultStatement(FBlockManager.DedicatedStatement);
    MIDelete.Enabled := bool;
    MICut.Enabled := bool;
    MICopy.Enabled := bool;
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

    UpdateForDedicatedStatement;
    UpdateForStack;
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
    begin
      FBlockManager.TryTakeAction;
      FBlockManager.DestroyCarryBlock;
    end;
  end;

  procedure TNassiShneiderman.MICopyClick(Sender: TObject);
  begin
    FBlockManager.TryCopyDedicated;
    UpdateForStack;
  end;

  procedure TNassiShneiderman.MICutClick(Sender: TObject);
  begin
    FBlockManager.TryCutDedicated;
    UpdateForStack;
    UpdateForDedicatedStatement;
  end;

  procedure TNassiShneiderman.MIInsetClick(Sender: TObject);
  begin
    FBlockManager.TryInsertBufferBlock;
    UpdateForStack;
    UpdateForDedicatedStatement;
  end;

  procedure TNassiShneiderman.AddAfter(Sender: TObject);
  begin
    FBlockManager.TryAddNewStatement(ConvertToStatementType(TComponent(Sender).Tag), True);
    UpdateForStack;
    UpdateForDedicatedStatement;
  end;

  procedure TNassiShneiderman.AddBefore(Sender: TObject);
  begin
    FBlockManager.TryAddNewStatement(ConvertToStatementType(TComponent(Sender).Tag), False);
    UpdateForStack;
    UpdateForDedicatedStatement;
  end;

  procedure TNassiShneiderman.Sort(Sender: TObject);
  begin
    FBlockManager.TrySortDedicatedCase(TComponent(Sender).Tag);
    UpdateForStack;
  end;

  procedure TNassiShneiderman.actRedoExecute(Sender: TObject);
  begin
    FBlockManager.TryRedo;
    UpdateForStack;
    UpdateForDedicatedStatement;
  end;

  procedure TNassiShneiderman.actOpenExecute(Sender: TObject);
  begin
    SetOpenFileMode(fmAll);
    if OpenDialog.Execute then
    begin
      FBlockManager.PathToFile := OpenDialog.FileName;
      LoadSchema(FBlockManager);
    end;
  end;

  procedure TNassiShneiderman.actSaveAsExecute(Sender: TObject);
  begin
    SetSaveFileMode(fmAll);
    if SaveDialog.Execute then
    begin
      FBlockManager.PathToFile := SaveDialog.FileName;
      SaveSchema(FBlockManager);
    end;
  end;

  procedure TNassiShneiderman.actSaveExecute(Sender: TObject);
  begin
    if FBlockManager.PathToFile <> '' then
      SaveSchema(FBlockManager)
    else
      actSaveAsExecute(Sender);
  end;

  procedure TNassiShneiderman.actUndoExecute(Sender: TObject);
  begin
    FBlockManager.TryUndo;
    UpdateForStack;
    UpdateForDedicatedStatement;
  end;

  procedure TNassiShneiderman.DeleteStatement(Sender: TObject);
  begin
    FBlockManager.TryDeleteDedicated;
    UpdateForStack;
    UpdateForDedicatedStatement;
  end;

  procedure TNassiShneiderman.actHelpExecute(Sender: TObject);
  begin
    case TComponent(Sender).Tag of
      0: Help.Execute(rsUseGuide);
      1: Help.Execute(rsAbout);
    end;
  end;

  procedure TNassiShneiderman.actChangeActionExecute(Sender: TObject);
  begin
    FBlockManager.TryChangeDedicatedText;
    UpdateForStack;
  end;

  procedure TNassiShneiderman.actChngFontExecute(Sender: TObject);
  begin
    FontDialog.Font := FBlockManager.Font;
    if FontDialog.Execute then
    begin
      FBlockManager.Font.Assign(FontDialog.Font);
      FBlockManager.RedefineMainBlock;
    end;
  end;

  procedure TNassiShneiderman.actChngPenExecute(Sender: TObject);
  begin
    FPenDialog.Pen := FBlockManager.Pen;
    if FPenDialog.Execute then
      FBlockManager.RedefineMainBlock;
  end;

  procedure TNassiShneiderman.actChngGlSettingsExecute(Sender: TObject);
  var
    PrevDefaultAction : String;
  begin
    PrevDefaultAction := DefaultAction;
    if FGlobalSettingsDialog.Execute then
      FBlockManager.ChangeGlobalSettings(PrevDefaultAction);
  end;

  procedure TNassiShneiderman.mnDiagramClick(Sender: TObject);
  var
    bool: Boolean;
  begin
    bool:= FBlockManager.DedicatedStatement is TCaseBranching;
    mnSortAsc.Enabled := bool;
    mnSortDesc.Enabled := bool;

    bool := FBlockManager.DedicatedStatement <> nil;
    mnAdd.Enabled := bool;
    mnChangeAct.Enabled := bool;
    mnDelete.Enabled := bool and not isDefaultStatement(FBlockManager.DedicatedStatement);
  end;

  procedure TNassiShneiderman.mnEditClick(Sender: TObject);
  var
    bool: Boolean;
  begin
    mnUndo.Enabled:= FBlockManager.UndoStack.Count <> 0;
    mnRedo.Enabled:= FBlockManager.RedoStack.Count <> 0;

    bool := FBlockManager.DedicatedStatement <> nil;
    mnInsert.Enabled := bool;

    bool := bool and not isDefaultStatement(FBlockManager.DedicatedStatement);
    mnCut.Enabled := bool;
    mnCopy.Enabled := bool;
  end;

  { Private methods }
  destructor TNassiShneiderman.Destroy;
  begin
    TBlockManager.BufferBlock.Destroy;
    if TBlockManager.CarryBlock <> nil then
      TBlockManager.CarryBlock.Destroy;

    FBlockManager.Destroy;

    FPenDialog.Destroy;
    FGlobalSettingsDialog.Destroy;

    inherited;
  end;

  procedure TNassiShneiderman.UpdateForStack;
  begin
    tbUndo.Enabled:= FBlockManager.UndoStack.Count <> 0;
    tbRedo.Enabled:= FBlockManager.RedoStack.Count <> 0;
  end;

  procedure TNassiShneiderman.SetOpenFileMode(mode: TFileMode);
  begin
    case mode of
      fmAll:
      begin
        OpenDialog.DefaultExt := '.json';
        OpenDialog.Filter := rsFMJSON + '|' + rsFMSVG + '|' + rsFMBmp + '|' + rsFMPng + '|' + rsFMAll;
      end;
    end;
  end;

  procedure TNassiShneiderman.SetSaveFileMode(mode: TFileMode);
  begin
    case mode of
      fmJSON:
      begin
        SaveDialog.DefaultExt := '.json';
        SaveDialog.Filter := rsFMJSON;
      end;
      fmSvg:
      begin
        SaveDialog.DefaultExt := '.svg';
        SaveDialog.Filter := rsFMSVG;
      end;
      fmBmp:
      begin
        SaveDialog.DefaultExt := '.bmp';
        SaveDialog.Filter := rsFMBmp;
      end;
      fmPng:
      begin
        SaveDialog.DefaultExt := '.png';
        SaveDialog.Filter := rsFMPng;
      end;
      fmAll:
      begin
        SaveDialog.DefaultExt := '.json';
        SaveDialog.Filter := rsFMJSON + '|' + rsFMSVG + '|' + rsFMBmp + '|' + rsFMPng + '|' + rsFMAll;
      end;
    end;
  end;

  procedure TNassiShneiderman.UpdateForDedicatedStatement;
  var
    bool: Boolean;
  begin
    bool:= FBlockManager.DedicatedStatement is TCaseBranching;
    tbSortDesc.Enabled := bool;
    tbSortAsc.Enabled := bool;

    bool := FBlockManager.DedicatedStatement <> nil;
    tbInsert.Enabled := bool;
    tbAction.Enabled := bool;
    tbProcess.Enabled := bool;
    tbIfBranch.Enabled := bool;
    tbMultBranch.Enabled := bool;
    tbLoop.Enabled := bool;
    tbRevLoop.Enabled := bool;

    bool := bool and not isDefaultStatement(FBlockManager.DedicatedStatement);
    tbCut.Enabled := bool;
    tbCopy.Enabled := bool;
    tbDelete.Enabled := bool;
  end;

  function TNassiShneiderman.isDragging: Boolean;
  begin
    Result:= TBlockManager.CarryBlock <> nil;
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
