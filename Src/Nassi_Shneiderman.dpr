program Nassi_Shneiderman;



















{$R 'html.res' 'html.rc'}

uses
  Vcl.Forms,
  frmMain in 'Units\frmMain.pas' {NassiShneiderman},
  Vcl.Themes,
  Vcl.Styles,
  uBase in 'Units\Statement\uBase.pas',
  uProcessStatement in 'Units\Statement\uProcessStatement.pas',
  uIfBranching in 'Units\Statement\uIfBranching.pas',
  uCaseBranching in 'Units\Statement\uCaseBranching.pas',
  uFirstLoop in 'Units\Statement\uFirstLoop.pas',
  uLastLoop in 'Units\Statement\uLastLoop.pas',
  uArrayList in 'Units\DataStructures\uArrayList.pas',
  uStack in 'Units\DataStructures\uStack.pas',
  uStatementSearch in 'Units\Support\uStatementSearch.pas',
  uMinMaxInt in 'Units\Support\uMinMaxInt.pas',
  frmGetAction in 'Units\Forms\frmGetAction.pas' {WriteAction},
  uLoop in 'Units\Statement\uLoop.pas',
  frmGetCaseConditions in 'Units\Forms\frmGetCaseConditions.pas' {WriteCaseConditions},
  uAdditionalTypes in 'Units\Support\uAdditionalTypes.pas',
  uConstants in 'Units\Support\uConstants.pas',
  uCaseBlockSorting in 'Units\Support\uCaseBlockSorting.pas',
  uSwitchStatements in 'Units\Support\uSwitchStatements.pas',
  uDetermineDimensions in 'Units\Shapes\uDetermineDimensions.pas',
  uDrawShapes in 'Units\Shapes\uDrawShapes.pas',
  uCommands in 'Units\Ñommand\uCommands.pas',
  uAutoClearStack in 'Units\DataStructures\uAutoClearStack.pas',
  frmPenSetting in 'Units\Forms\frmPenSetting.pas' {PenDialog},
  frmGlobalSettings in 'Units\Forms\frmGlobalSettings.pas' {GlobalSettingsDialog},
  uBlockManager in 'Units\BlockManager\uBlockManager.pas',
  uGlobalSave in 'Units\FileManager\uGlobalSave.pas',
  uLocalSave in 'Units\FileManager\uLocalSave.pas',
  frmHelp in 'Units\Forms\frmHelp.pas' {Help},
  uStatementConverter in 'Units\Support\uStatementConverter.pas',
  uDialogMessages in 'Units\Support\uDialogMessages.pas',
  uExport in 'Units\FileManager\uExport.pas',
  uStatistics in 'Units\FileManager\uStatistics.pas',
  uZoomAndPositionTransfer in 'Units\Support\uZoomAndPositionTransfer.pas',
  uScaleControlUtils in 'Units\BlockManager\uScaleControlUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TNassiShneiderman, NassiShneiderman);
  Application.CreateForm(TWriteAction, WriteAction);
  Application.CreateForm(TWriteCaseConditions, WriteCaseConditions);
  Application.CreateForm(THelp, Help);
  Application.Run;
end.
