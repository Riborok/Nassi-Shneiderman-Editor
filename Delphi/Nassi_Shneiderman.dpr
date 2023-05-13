program Nassi_Shneiderman;



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
  frmGet�ase�onditions in 'Units\Forms\frmGet�ase�onditions.pas' {Write�ase�onditions},
  uAdditionalTypes in 'Units\Support\uAdditionalTypes.pas',
  uConstants in 'Units\Support\uConstants.pas',
  uCaseBlockSorting in 'Units\Support\uCaseBlockSorting.pas',
  uSwitchStatements in 'Units\Support\uSwitchStatements.pas',
  uDetermineDimensions in 'Units\Shapes\uDetermineDimensions.pas',
  uDrawShapes in 'Units\Shapes\uDrawShapes.pas',
  uCommands in 'Units\�ommand\uCommands.pas',
  uAutoClearStack in 'Units\DataStructures\uAutoClearStack.pas',
  frmPenSetting in 'Units\Forms\frmPenSetting.pas' {PenDialog},
  frmGlobalSettings in 'Units\Forms\frmGlobalSettings.pas' {GlobalSettingsDialog},
  uBlockManager in 'Units\BlockManager\uBlockManager.pas',
  uFileManager in 'Units\FileManager\uFileManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TNassiShneiderman, NassiShneiderman);
  Application.CreateForm(TWriteAction, WriteAction);
  Application.CreateForm(TWrite�ase�onditions, Write�ase�onditions);
  Application.Run;
end.
