﻿unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus, uConstants,
  uBase, uFirstLoop, uIfBranching, uCaseBranching, uLastLoop, uProcessStatement,
  uStatementSearch, System.Actions, Vcl.ActnList, Vcl.ToolWin, Types, uBlockManager,
  Vcl.ComCtrls, uAdditionalTypes, frmPenSetting, System.ImageList, Vcl.ImgList,
  System.SysUtils, uGlobalSave, uLocalSave, frmHelp, uStatementConverter, uDialogMessages,
  frmGlobalSettings, System.UITypes, uExport, uStatistics, uArrayList,
  uZoomAndPositionTransfer, uMinMaxInt;

type
  TNassiShneiderman = class(TForm)
    tbMain: TToolBar;
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
    tbUserGuide: TToolButton;
    tbAbout: TToolButton;
    actExit: TAction;
    Exit1: TMenuItem;
    actSaveAs: TAction;
    actSave: TAction;
    actOpen: TAction;
    actNew: TAction;
    tbGlSettings: TToolButton;
    sep7: TToolButton;
    tbSaveAs: TToolButton;
    tbOpen: TToolButton;
    tbNew: TToolButton;
    mnStatistics: TMenuItem;
    mnCurrent: TMenuItem;
    mnOther: TMenuItem;
    actExpPNG: TAction;
    actExpBMP: TAction;
    actExpSVG: TAction;
    mnExpSVG: TMenuItem;
    mnExpBMP: TMenuItem;
    mnExpPNG: TMenuItem;
    tbarMenu: TToolBar;
    lblScale: TLabel;
    tbSelectScale: TTrackBar;
    lblScaleView: TLabel;
    sep8: TToolButton;
    cbMain: TComboBox;
    actClose: TAction;
    tbClose: TToolButton;
    actRename: TAction;
    tbRename: TToolButton;

    procedure FormCreate(Sender: TObject);

    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DblClick(Sender: TObject);

    procedure AddStatement(Sender: TObject);
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
    procedure actExportExecute(Sender: TObject);
    procedure tbSelectScaleChange(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure cbMainChange(Sender: TObject);
    procedure cbMainCloseUp(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actRenameExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private const
    OriginalName = 'Main';
  private type
    TFileMode = (fmJSON = 0, fmSvg, fmBmp, fmPng, fmStat, fmAll);
  private
    AmountPixelToMove : Integer;

    FPenDialog: TPenDialog;
    FGlobalSettingsDialog: TGlobalSettingsDialog;

    FPrevMousePos: TPoint;

    KeyKeysIsPressed: Boolean;

    FMayDrag, FWasDbClick: Boolean;

    FCurrPos: Integer;
    FBlockManagers: TArrayList<TBlockManager>;

    FUserInfo: TUserInfo;

    function GetVisibleImageScreen: TVisibleImageRect;
    procedure SetScrollPos(const AStatement: TStatement);

    function isDragging: Boolean; inline;

    procedure UpdateForDedicatedStatement;
    procedure UpdateForStack;

    procedure SetOpenFileMode(const AMode: TFileMode);
    procedure SetSaveFileMode(const AMode: TFileMode);

    procedure AddNewSchema(const AName: string);
    function HandleSaveSchemePrompt: Boolean;

    procedure ChangeScheme;

    procedure SetScaleView; inline;
    procedure UpdateAmountPixelToMove; inline;
  public
    destructor Destroy; override;
  end;

var
  NassiShneiderman: TNassiShneiderman;

implementation

  {$R *.dfm}

  { TNassiShneiderman }

  procedure TNassiShneiderman.FormClose(Sender: TObject; var Action: TCloseAction);
  var
    Answer, I: Integer;
  begin
    // Set the logout time for the user
    FUserInfo.LogoutTime := Now;

    // Save global settings
    SaveGlobalSettings;

    // Save statistics for the current user
    SaveStatistics(FUserInfo);


    // Check if the block manager has unsaved changes or if the default main block is being used
    for I := 0 to FBlockManagers.Count - 1 do
      if not (FBlockManagers[I].isSaved or FBlockManagers[I].isDefaultMainBlock) then
      begin
        // Display a warning message box with options to save, discard, or cancel
        Answer := MessageDlg(rsExitDlgPart1 + FBlockManagers[I].SchemeName + rsExitDlgPart2,
                  mtWarning, [mbYes, mbNo, mbCancel], 0);
        case Answer of
          mrYes:
          begin
            FCurrPos := I;

            // Set the save file mode to JSON
            SetSaveFileMode(fmJSON);

            // Show the save dialog to choose a file path
            if SaveDialog.Execute then
            begin
              // Set the path to the chosen file for the block manager
              FBlockManagers[I].PathToFile := SaveDialog.FileName;

              // Save the schema using the block manager
              SaveSchema(FBlockManagers[I]);

              // Free the form and close it
              Action := caFree;
            end
            else
              // If the user cancels the save dialog, do not close the form
              Action := caNone;
          end;
          mrNo:
            // Discard changes and free the form to close it
            Action := caFree;
          mrCancel:
            // Cancel the form close action and keep the form open
            Action := caNone;
        end;
      end;
  end;

  procedure TNassiShneiderman.FormCreate(Sender: TObject);
  const
    MinFormWidth = 900 + 42;
    MinFormHeight = 550 + 42;
  begin
    // Clear user information
    ClearUserInfo(FUserInfo);

    // Set the login time to the current time
    FUserInfo.LoginTime := Now;

    // Get the Windows user name and assign it to the user information
    FUserInfo.UserName := GetWindowsUserName;

    // Set titles for save and open dialogs
    SaveDialog.Title := 'Save As';
    OpenDialog.Title := 'Open';

    // Load global settings
    LoadGlobalSettings;

    // Set the default statement to TProcessStatement
    DefaultStatement := TProcessStatement;

    // Set the UI language to English (United States)
    SetThreadUILanguage(MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US));

    // Enable double buffering for smoother drawing
    Self.DoubleBuffered := True;

    // Initialize variables for mouse interaction
    KeyKeysIsPressed := False;
    FMayDrag := False;
    FWasDbClick := False;

    // Set minimum form width and height
    Constraints.MinWidth := MinFormWidth;
    Constraints.MinHeight := MinFormHeight;

    // Set shortcuts for actions
    actDelete.ShortCut := ShortCut(VK_DELETE, []);
    actChangeAction.ShortCut := ShortCut(VK_RETURN, []);
    actUndo.ShortCut := ShortCut(VK_Z, [ssCtrl]);
    actRedo.ShortCut := ShortCut(VK_Z, [ssCtrl, ssShift]);
    actChngFont.ShortCut := ShortCut(VK_F, [ssShift, ssCtrl]);
    actChngPen.ShortCut := ShortCut(VK_P, [ssShift, ssCtrl]);
    actChngGlSettings.ShortCut := ShortCut(VK_G, [ssCtrl, ssShift]);
    actSortAsc.ShortCut := ShortCut(VK_RIGHT, [ssCtrl, ssShift]);
    actSortDesc.ShortCut := ShortCut(VK_LEFT, [ssCtrl, ssShift]);

    // Create instances of dialog forms
    FPenDialog := TPenDialog.Create(Self, ColorDialog);
    FGlobalSettingsDialog := TGlobalSettingsDialog.Create(Self, ColorDialog);

    // Create a buffer block and assign it to the block manager
    TBlockManager.BufferBlock := TBlock.Create(0, PaintBox.Canvas);
    TBlockManager.BufferBlock.AddStatement(uBase.DefaultStatement.Create(
                                     DefaultAction, TBlockManager.BufferBlock));

    // Create an instance of the block manager and initialize the main block
    FBlockManagers := TArrayList<TBlockManager>.Create(17);
    AddNewSchema(OriginalName);
    UpdateAmountPixelToMove;
  end;

  procedure TNassiShneiderman.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    // Try to move the dedicated block based on the scroll position and the pressed key
    FBlockManagers[FCurrPos].TryMoveDedicated(SetScrollPos, Key);

    // Update the UI for the dedicated statement
    UpdateForDedicatedStatement;
  end;

  procedure TNassiShneiderman.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  begin
    // Set the flag indicating that no key is pressed
    KeyKeysIsPressed := False;
  end;

  procedure TNassiShneiderman.actExitExecute(Sender: TObject);
  begin
    // Close the form
    Close;
  end;

  procedure TNassiShneiderman.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  begin
    // If dragging is in progress, destroy the carry block
    if isDragging and (GetKeyState(VK_SHIFT) >= 0) then
      FBlockManagers[FCurrPos].DestroyCarryBlock;

    // Check if a key keys is already pressed
    if KeyKeysIsPressed then
      Handled := True
    else if GetKeyState(VK_CONTROL) < 0 then
      case Msg.CharCode of
        VK_UP:
        begin
          if FCurrPos <> 0 then
          begin
            Dec(FCurrPos);
            cbMain.ItemIndex := FCurrPos;
            ChangeScheme;
          end;
          Handled := True;
        end;
        VK_DOWN:
        begin
          if FBlockManagers.Count - 1 > FCurrPos then
          begin
            Inc(FCurrPos);
            cbMain.ItemIndex := FCurrPos;
            ChangeScheme;
          end;
          Handled := True;
        end;
        VK_Z, VK_X, VK_C, VK_V:
          KeyKeysIsPressed := True;
        VK_RIGHT, VK_LEFT:
        begin
          KeyKeysIsPressed := True;

          // Trigger FormKeyDown for specific keys only if CTRL or SHIFT is not pressed
          if (GetKeyState(VK_CONTROL) >= 0) or (GetKeyState(VK_SHIFT) >= 0) then
          begin
            FBlockManagers[FCurrPos].TryMoveDedicated(SetScrollPos, Msg.CharCode);
            UpdateForDedicatedStatement;
          end;
        end;
      end
    else if GetKeyState(VK_RETURN) < 0 then
      KeyKeysIsPressed := True;
  end;

  procedure TNassiShneiderman.PaintBoxPaint(Sender: TObject);
  begin
    // Draw the block manager content on the paint box
    FBlockManagers[FCurrPos].Draw(GetVisibleImageScreen);
  end;

  procedure TNassiShneiderman.ScrollBoxMouseWheel(Sender: TObject;
    Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
    var Handled: Boolean);
  const
    ScrollStep = 42 shl 1;
  begin
    if ssCtrl in Shift then
    begin
      if WheelDelta > 0 then
        tbSelectScale.Position:= tbSelectScale.Position + 1
      else
        tbSelectScale.Position:= tbSelectScale.Position - 1;
    end
    else if ssShift in Shift then
    begin
      // Scroll horizontally based on the WheelDelta value
      if WheelDelta > 0 then
        ScrollBox.HorzScrollBar.Position := ScrollBox.HorzScrollBar.Position - ScrollStep
      else
        ScrollBox.HorzScrollBar.Position := ScrollBox.HorzScrollBar.Position + ScrollStep;
    end
    else
    begin
      // Scroll vertically based on the WheelDelta value
      if WheelDelta > 0 then
        ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position - ScrollStep
      else
        ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position + ScrollStep;
    end;

    // Convert mouse position to client coordinates of PaintBox
    MousePos := PaintBox.ScreenToClient(Mouse.CursorPos);

    // Trigger MouseMove event with updated mouse position
    MouseMove(Sender, Shift, MousePos.X, MousePos.Y);

    Handled := True;
  end;

  procedure TNassiShneiderman.PopupMenuPopup(Sender: TObject);
  var
    bool : Boolean;
  begin
    // Check if the dedicated statement is a TCaseBranching
    bool := FBlockManagers[FCurrPos].DedicatedStatement is TCaseBranching;

    // Set the visibility of menu items based on the statement type
    MIAscSort.Visible:= bool;
    MIDescSort.Visible:= bool;

    // Check if there are undo actions in the undo stack
    bool := FBlockManagers[FCurrPos].UndoStack.Count <> 0;

    // Enable/disable menu items based on the availability of undo actions
    MIUndo.Enabled:= bool;
    MIRedo.Enabled:= bool;

    // Check if the dedicated statement is non-default
    bool := not isDefaultStatement(FBlockManagers[FCurrPos].DedicatedStatement);

    // Enable/disable menu items based on the dedicated statement type
    MIDelete.Enabled := bool;
    MICut.Enabled := bool;
    MICopy.Enabled := bool;
  end;

  procedure TNassiShneiderman.DblClick(Sender: TObject);
  begin
    // Try to change the dedicated text on double-click
    FBlockManagers[FCurrPos].TryChangeDedicatedText;
    FWasDbClick:= True;
  end;

  procedure TNassiShneiderman.MouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
    // Set the DedicatedStatement based on the coordinates (X, Y) using BinarySearchStatement
    FBlockManagers[FCurrPos].DedicatedStatement := BinarySearchStatement(X, Y,
                                            FBlockManagers[FCurrPos].MainBlock);

    if FBlockManagers[FCurrPos].DedicatedStatement <> nil then
    begin
      case Button of
        mbLeft:
        begin
          // Check if it's a left mouse button click
          FMayDrag := not FWasDbClick;
          FWasDbClick := False;
          FPrevMousePos := Point(X, Y);
        end;
        mbRight:
        begin
          // Check if it's a right mouse button click
          if isDragging then
            FBlockManagers[FCurrPos].DestroyCarryBlock;
          PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
        end;
      end;
    end;

    // Update the UI based on the DedicatedStatement
    UpdateForDedicatedStatement;
    UpdateForStack;
  end;

  procedure TNassiShneiderman.MouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
  begin
    if isDragging then
    begin
      // If dragging is in progress, update the hover position and move the carry block
      FBlockManagers[FCurrPos].DefineHover(X, Y);
      FBlockManagers[FCurrPos].MoveCarryBlock(X - FPrevMousePos.X, Y - FPrevMousePos.Y);

      FPrevMousePos := Point(X, Y);
    end
    else if FMayDrag and ((Abs(FPrevMousePos.X - X) > AmountPixelToMove) or
         (Abs(FPrevMousePos.Y - Y) > AmountPixelToMove)) and
         (FBlockManagers[FCurrPos].DedicatedStatement <> nil) then
    begin
      // If the mouse has moved a sufficient distance and dragging is allowed, create the carry block
      FMayDrag := False;
      if isDragging then
        FBlockManagers[FCurrPos].DestroyCarryBlock;

      FBlockManagers[FCurrPos].CreateCarryBlock;
    end;
  end;

  procedure TNassiShneiderman.MouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
  begin
    // Mouse button is released
    FMayDrag := False;
    if isDragging then
    begin
      // If dragging was in progress, take action, destroy the carry block, and update the interface
      FBlockManagers[FCurrPos].TryTakeAction;
      FBlockManagers[FCurrPos].DestroyCarryBlock;
    end;
  end;

  procedure TNassiShneiderman.MICopyClick(Sender: TObject);
  begin
    // Copy the dedicated statement
    FBlockManagers[FCurrPos].TryCopyDedicated;
    UpdateForStack;
  end;

  procedure TNassiShneiderman.MICutClick(Sender: TObject);
  begin
    // Cut the dedicated statement
    FBlockManagers[FCurrPos].TryCutDedicated;
    UpdateForStack;
    UpdateForDedicatedStatement;

    Inc(FUserInfo.DeleteStatementCount);
  end;

  procedure TNassiShneiderman.MIInsetClick(Sender: TObject);
  begin
    // Insert the buffer block
    FBlockManagers[FCurrPos].TryInsertBufferBlock;
    UpdateForStack;
    UpdateForDedicatedStatement;

    Inc(FUserInfo.AddStatementCount);
  end;

  procedure TNassiShneiderman.AddStatement(Sender: TObject);
  var
    Tag: Integer;
  begin
    // Extract the tag value from the sender component
    Tag := TComponent(Sender).Tag;

    // Try to add a new statement to the block manager
    FBlockManagers[FCurrPos].TryAddNewStatement(
                            ConvertToStatementType(Tag mod 5), (Tag div 5) = 0);

    // Update the interface to reflect the changes in the stack and dedicated statement
    UpdateForStack;
    UpdateForDedicatedStatement;

    Inc(FUserInfo.AddStatementCount);
  end;

  procedure TNassiShneiderman.cbMainChange(Sender: TObject);
  begin
    FCurrPos := cbMain.ItemIndex;
    ChangeScheme;
  end;

  procedure TNassiShneiderman.cbMainCloseUp(Sender: TObject);
  begin
    ActiveControl := nil;
  end;

  procedure TNassiShneiderman.Sort(Sender: TObject);
  begin
    // Try to sort the dedicated case based on the tag value of the sender component
    FBlockManagers[FCurrPos].TrySortDedicatedCase(TComponent(Sender).Tag);

    // Update the interface to reflect the changes in the stack
    UpdateForStack;
  end;

  procedure TNassiShneiderman.tbSelectScaleChange(Sender: TObject);
  begin
    // Reset focus
    ActiveControl := nil;

    // Set the zoom factor based on the selected position of tbSelectScale track bar
    FBlockManagers[FCurrPos].ZoomFactor := GetZoomFactor(tbSelectScale.Position);

    UpdateAmountPixelToMove;

    SetScaleView;

    FBlockManagers[FCurrPos].RecoverAfterZoom;

    // Redefine the main block to apply the new font settings
    FBlockManagers[FCurrPos].RedefineMainBlock;
  end;

  procedure TNassiShneiderman.actRedoExecute(Sender: TObject);
  begin
    // Try to redo the previous action in the block manager
    FBlockManagers[FCurrPos].TryRedo;

    // Update the interface to reflect the changes in the stack and dedicated statement
    UpdateForStack;
    UpdateForDedicatedStatement;
  end;

  procedure TNassiShneiderman.actOpenExecute(Sender: TObject);
  begin
    // Set the open file mode to JSON
    SetOpenFileMode(fmJSON);

    // Execute the open dialog
    if OpenDialog.Execute then
    begin
      // Creating a New Schema
      AddNewSchema('');

      // Set the path to the selected file in the block manager
      FBlockManagers[FCurrPos].PathToFile := OpenDialog.FileName;

      // Load the schema from the selected file
      LoadSchema(FBlockManagers[FCurrPos]);

      // Setting the schema name
      cbMain.Items[FCurrPos] := FBlockManagers[FCurrPos].SchemeName;
      cbMain.ItemIndex := FCurrPos;

      tbSelectScale.Position := GetPosition(FBlockManagers[FCurrPos].ZoomFactor);
      SetScaleView;

      UpdateForDedicatedStatement
    end;
  end;

  procedure TNassiShneiderman.actExportExecute(Sender: TObject);
  var
    FileMode: TFileMode;
  begin
    // Get the file mode from the tag value of the sender component
    FileMode := TFileMode(TComponent(Sender).Tag);

    // Set the save file mode based on the file mode
    SetSaveFileMode(FileMode);

    // Execute the save dialog
    if SaveDialog.Execute then
    begin
      // Save the block manager's content to the selected file based on the file mode
      case FileMode of
        fmSVG: SaveSVGFile(FBlockManagers[FCurrPos], SaveDialog.FileName);
        fmBMP: SaveBMPFile(FBlockManagers[FCurrPos], SaveDialog.FileName);
        fmPNG: SavePNGFile(FBlockManagers[FCurrPos], SaveDialog.FileName);
      end;
    end;
  end;

  procedure TNassiShneiderman.actSaveAsExecute(Sender: TObject);
  var
    FileName: string;
    FileExt: string;
  begin
    // Set the save file mode to all
    SetSaveFileMode(fmAll);

    // Execute the save dialog
    if SaveDialog.Execute then
    begin
      FileName := SaveDialog.FileName;
      FileExt := LowerCase(ExtractFileExt(FileName));

      if FileExt = constExtJSON then
      begin
        // Set the path to the selected file in the block manager
        FBlockManagers[FCurrPos].PathToFile := FileName;

        // Save the schema to the selected file
        SaveSchema(FBlockManagers[FCurrPos]);
      end
      else if FileExt = constExtSVG then
        SaveSVGFile(FBlockManagers[FCurrPos], FileName)
      else if FileExt = constExtBmp then
        SaveBMPFile(FBlockManagers[FCurrPos], FileName)
      else if FileExt = constExtPNG then
        SavePNGFile(FBlockManagers[FCurrPos], FileName);
    end;

    // Update the enabled state of the "Save As" toolbar button based on the block manager's save state
    tbSaveAs.Enabled := not FBlockManagers[FCurrPos].isSaved;
  end;

  procedure TNassiShneiderman.actSaveExecute(Sender: TObject);
  begin
    if FBlockManagers[FCurrPos].PathToFile <> '' then
    begin
      // Save the schema to the current file
      SaveSchema(FBlockManagers[FCurrPos]);
      FBlockManagers[FCurrPos].isSaved := True;
    end
    else
      actSaveAsExecute(Sender);

    // Update the enabled state of the "Save As" toolbar button based on the block manager's save state
    tbSaveAs.Enabled := not FBlockManagers[FCurrPos].isSaved;
  end;

  procedure TNassiShneiderman.actHelpExecute(Sender: TObject);
  var
    StartTime: TDateTime;
  begin
    StartTime := Now;

    // Retrieve the tag value from the sender component
    case TComponent(Sender).Tag of
      0: Help.Execute(rsUseGuide);
      1: Help.Execute(rsAbout);
      2: ShowMessage(FormatStatistics(Self.FUserInfo));
      3:
      begin
        SetOpenFileMode(fmStat);
        var FilePath: string := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + dirAppData;
        if DirectoryExists(FilePath) then
          OpenDialog.InitialDir := FilePath;
        if OpenDialog.Execute then
          ShowMessage(FormatStatistics(LoadStatistics(OpenDialog.FileName)));
        OpenDialog.InitialDir := '';
      end;
    end;

    // Update the help time by calculating the time difference between the current time and the start time
    Inc(FUserInfo.HelpTime, SecondsBetween(Now, StartTime));
  end;

  procedure TNassiShneiderman.actRenameExecute(Sender: TObject);
  var
    Name: string;
  begin
    Name := InputBox(rsNewSchemeName, rsNewSchemeContent, '');
    if Name <> '' then
    begin
      FBlockManagers[FCurrPos].SchemeName := Name;
      cbMain.Items[FCurrPos] := Name;
      cbMain.ItemIndex := FCurrPos;
    end;
  end;

  procedure TNassiShneiderman.actNewExecute(Sender: TObject);
  var
    Name: string;
  begin
    Name := InputBox(rsNewSchemeName, rsNewSchemeContent, '');
    if Name <> '' then
      AddNewSchema(Name);

    tbSelectScale.Position := GetPosition(FBlockManagers[FCurrPos].ZoomFactor);
    SetScaleView;

    UpdateForDedicatedStatement;
  end;

  procedure TNassiShneiderman.actUndoExecute(Sender: TObject);
  begin
    // Try to undo the previous action in the block manager
    FBlockManagers[FCurrPos].TryUndo;

    // Update the display for the block stack and the dedicated statement
    UpdateForStack;
    UpdateForDedicatedStatement;
  end;

  procedure TNassiShneiderman.DeleteStatement(Sender: TObject);
  begin
    // Try to delete the dedicated statement in the block manager
    FBlockManagers[FCurrPos].TryDeleteDedicated;

    // Update the display for the block stack and the dedicated statement
    UpdateForStack;
    UpdateForDedicatedStatement;

    Inc(FUserInfo.DeleteStatementCount);
  end;

  procedure TNassiShneiderman.actChangeActionExecute(Sender: TObject);
  begin
    // Try to change the text of the dedicated statement in the block manager
    FBlockManagers[FCurrPos].TryChangeDedicatedText;

    // Update the display for the block stack
    UpdateForStack;

    Inc(FUserInfo.ChangeActionCount);
  end;

  procedure TNassiShneiderman.actChngFontExecute(Sender: TObject);
  var
    StartTime: TDateTime;
  begin
    StartTime := Now;
    FBlockManagers[FCurrPos].Font.Height := FBlockManagers[FCurrPos].FontHeightWithoutZoom;

    // Initialize the font dialog with the current font settings
    FontDialog.Font := FBlockManagers[FCurrPos].Font;

    // Prompt the user to select a new font using the font dialog
    if FontDialog.Execute then
    begin
      // Update the font settings in the block manager with the selected font
      FBlockManagers[FCurrPos].Font.Assign(FontDialog.Font);
      FBlockManagers[FCurrPos].FontHeightWithoutZoom := FontDialog.Font.Height;

      FBlockManagers[FCurrPos].SetFontHeight;

      UpdateAmountPixelToMove;

      // Redefine the main block to apply the new font settings
      FBlockManagers[FCurrPos].RedefineMainBlock;
    end
    else
      FBlockManagers[FCurrPos].SetFontHeight;

    // Update the font setting time by calculating the time difference between the current time and the start time
    Inc(FUserInfo.FontSettingTime, SecondsBetween(Now, StartTime));
  end;

  procedure TNassiShneiderman.actChngPenExecute(Sender: TObject);
  var
    StartTime: TDateTime;
  begin
    StartTime := Now;
    FBlockManagers[FCurrPos].Pen.Width := FBlockManagers[FCurrPos].PenWidthWithoutZoom;

    // Initialize the pen dialog with the current pen settings
    FPenDialog.Pen := FBlockManagers[FCurrPos].Pen;

    // Prompt the user to select new pen settings using the pen dialog
    if FPenDialog.Execute then
    begin
      FBlockManagers[FCurrPos].PenWidthWithoutZoom := FBlockManagers[FCurrPos].Pen.Width;

      FBlockManagers[FCurrPos].SetPenWidth;

      // Update the pen settings in the block manager with the selected pen
      FBlockManagers[FCurrPos].RedefineMainBlock;
    end
    else
      FBlockManagers[FCurrPos].SetPenWidth;

    // Update the pen setting time by calculating the time difference between the current time and the start time
    Inc(FUserInfo.PenSettingTime, SecondsBetween(Now, StartTime));
  end;

  procedure TNassiShneiderman.actCloseExecute(Sender: TObject);
  begin
    // Check if the current scheme is saved or a default main block, or prompt for saving
    if FBlockManagers[FCurrPos].isSaved or
       FBlockManagers[FCurrPos].isDefaultMainBlock or HandleSaveSchemePrompt then
    begin
      // Destroy the current block manager
      FBlockManagers[FCurrPos].Destroy;
      FBlockManagers.Delete(FCurrPos);
      cbMain.Items.Delete(FCurrPos);

      if FBlockManagers.Count = 0 then
        AddNewSchema(OriginalName)
      else if FCurrPos = FBlockManagers.Count then
        Dec(FCurrPos);

      cbMain.ItemIndex := FCurrPos;

      FBlockManagers[FCurrPos].Activate;

      tbSelectScale.Position := GetPosition(FBlockManagers[FCurrPos].ZoomFactor);
      SetScaleView;

      UpdateForDedicatedStatement;
    end;
  end;

  procedure TNassiShneiderman.actChngGlSettingsExecute(Sender: TObject);
  var
    PrevDefaultAction: string;
    StartTime: TDateTime;
  begin
    StartTime := Now;

    // Store the previous default action
    PrevDefaultAction := DefaultAction;

    // Prompt the user to change global settings using the global settings dialog
    if FGlobalSettingsDialog.Execute then
    begin
      // Apply the changes in global settings to the block manager
      FBlockManagers[FCurrPos].ChangeGlobalSettings(PrevDefaultAction);
    end;

    // Update the global settings time by calculating the time difference
    // between the current time and the start time
    Inc(FUserInfo.GlobalSettingsTime, SecondsBetween(Now, StartTime));
  end;

  procedure TNassiShneiderman.mnDiagramClick(Sender: TObject);
  var
    bool: Boolean;
  begin
    bool:= FBlockManagers[FCurrPos].DedicatedStatement is TCaseBranching;
    mnSortAsc.Enabled := bool;
    mnSortDesc.Enabled := bool;

    bool := FBlockManagers[FCurrPos].DedicatedStatement <> nil;
    mnAdd.Enabled := bool;
    mnChangeAct.Enabled := bool;
    mnDelete.Enabled := bool and not isDefaultStatement(FBlockManagers[FCurrPos].DedicatedStatement);
  end;

  procedure TNassiShneiderman.mnEditClick(Sender: TObject);
  var
    bool: Boolean;
  begin
    mnUndo.Enabled:= FBlockManagers[FCurrPos].UndoStack.Count <> 0;
    mnRedo.Enabled:= FBlockManagers[FCurrPos].RedoStack.Count <> 0;

    bool := FBlockManagers[FCurrPos].DedicatedStatement <> nil;
    mnInsert.Enabled := bool;

    bool := bool and not isDefaultStatement(FBlockManagers[FCurrPos].DedicatedStatement);
    mnCut.Enabled := bool;
    mnCopy.Enabled := bool;
  end;

  { Private methods }
  destructor TNassiShneiderman.Destroy;
  var
    I: Integer;
  begin
    TBlockManager.BufferBlock.Destroy;
    if TBlockManager.CarryBlock <> nil then
      TBlockManager.CarryBlock.Destroy;

    for I := 0 to FBlockManagers.Count - 1 do
      FBlockManagers[I].Destroy;

    FBlockManagers.Destroy;

    FPenDialog.Destroy;
    FGlobalSettingsDialog.Destroy;

    inherited;
  end;

  procedure TNassiShneiderman.UpdateForStack;
  begin
    tbUndo.Enabled:= FBlockManagers[FCurrPos].UndoStack.Count <> 0;
    tbRedo.Enabled:= FBlockManagers[FCurrPos].RedoStack.Count <> 0;
  end;

  procedure TNassiShneiderman.SetOpenFileMode(const AMode: TFileMode);
  begin
    OpenDialog.FileName := '';
    case AMode of
      fmJSON:
      begin
        OpenDialog.DefaultExt := constExtJSON;
        OpenDialog.Filter := rsFMJSON;
      end;
      fmStat:
      begin
        OpenDialog.DefaultExt := constExtStat;
        OpenDialog.Filter := rsFMStat;
      end;
    end;
  end;

  procedure TNassiShneiderman.SetSaveFileMode(const AMode: TFileMode);
  begin
    SaveDialog.FileName := FBlockManagers[FCurrPos].SchemeName;
    case AMode of
      fmJSON:
      begin
        SaveDialog.DefaultExt := constExtJSON;
        SaveDialog.Filter := rsFMJSON;
      end;
      fmSvg:
      begin
        SaveDialog.DefaultExt := constExtSVG;
        SaveDialog.Filter := rsFMSVG;
      end;
      fmBmp:
      begin
        SaveDialog.DefaultExt := constExtBmp;
        SaveDialog.Filter := rsFMBmp;
      end;
      fmPng:
      begin
        SaveDialog.DefaultExt := constExtPng;
        SaveDialog.Filter := rsFMPng;
      end;
      fmAll:
      begin
        SaveDialog.DefaultExt := constExtJSON;
        SaveDialog.Filter := rsFMJSON + '|' + rsFMSVG + '|' + rsFMBmp + '|' + rsFMPng + '|' + rsFMAll;
      end;
    end;
  end;

  procedure TNassiShneiderman.UpdateForDedicatedStatement;
  var
    bool: Boolean;
  begin
    bool:= FBlockManagers[FCurrPos].DedicatedStatement is TCaseBranching;
    tbSortDesc.Enabled := bool;
    tbSortAsc.Enabled := bool;

    bool := FBlockManagers[FCurrPos].DedicatedStatement <> nil;
    tbInsert.Enabled := bool;
    tbAction.Enabled := bool;
    tbProcess.Enabled := bool;
    tbIfBranch.Enabled := bool;
    tbMultBranch.Enabled := bool;
    tbLoop.Enabled := bool;
    tbRevLoop.Enabled := bool;

    bool := bool and not isDefaultStatement(FBlockManagers[FCurrPos].DedicatedStatement);
    tbCut.Enabled := bool;
    tbCopy.Enabled := bool;
    tbDelete.Enabled := bool;

    tbSaveAs.Enabled := not FBlockManagers[FCurrPos].isSaved;
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

  procedure TNassiShneiderman.AddNewSchema(const AName: string);
  begin
    FBlockManagers.Add(TBlockManager.Create(PaintBox, AName));
    cbMain.AddItem(AName, nil);
    FCurrPos := FBlockManagers.Count - 1;
    cbMain.ItemIndex := FCurrPos;
  end;

  function TNassiShneiderman.HandleSaveSchemePrompt: Boolean;
  var
    Answer: Integer;
  begin
    // Prompt the user with a message dialog and store the user's answer
    Answer := MessageDlg(rsExitDlgPart1 + FBlockManagers[FCurrPos].SchemeName + rsExitDlgPart2,
              mtWarning, [mbYes, mbNo, mbCancel], 0);

    // Handle the user's answer
    case Answer of
      mrYes:
      begin
        // Set the save file mode to JSON
        SetSaveFileMode(fmJSON);

        // Prompt the user to select a file for saving the schema
        if SaveDialog.Execute then
        begin
          // Update the path to the file in the block manager
          FBlockManagers[FCurrPos].PathToFile := SaveDialog.FileName;

          // Save the schema using the block manager
          SaveSchema(FBlockManagers[FCurrPos]);

          // Return True indicating successful saving
          Result := True;
        end
        else
          // Return False indicating saving was canceled
          Result := False;
      end;
      mrNo:
        // Return True indicating no saving is required
        Result := True;
      mrCancel:
        // Return False indicating canceling the operation
        Result := False;
    end;
  end;

  procedure TNassiShneiderman.ChangeScheme;
  begin
    tbSelectScale.Position := GetPosition(FBlockManagers[FCurrPos].ZoomFactor);
    SetScaleView;
    FBlockManagers[FCurrPos].Activate;
    UpdateForDedicatedStatement;
    UpdateAmountPixelToMove;
  end;

  procedure TNassiShneiderman.SetScaleView;
  begin
    lblScaleView.Caption := ' ' + IntToStr(Trunc(
                            FBlockManagers[FCurrPos].ZoomFactor * 100)) + '% ';
  end;

  procedure TNassiShneiderman.UpdateAmountPixelToMove;
  const
    MaxValue = 342;
    MinValue = 7;
  begin
    AmountPixelToMove := Min(Round(FBlockManagers[FCurrPos].ZoomFactor *
                         FBlockManagers[FCurrPos].Font.Size) + MinValue, MaxValue);
  end;
end.
