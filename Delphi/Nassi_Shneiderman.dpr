program Nassi_Shneiderman;



uses
  Vcl.Forms,
  Main in 'Units\Main.pas' {NassiShneiderman},
  Vcl.Themes,
  Vcl.Styles,
  Base in 'Units\Statement\Base.pas',
  ProcessStatement in 'Units\Statement\ProcessStatement.pas',
  IfBranching in 'Units\Statement\IfBranching.pas',
  CaseBranching in 'Units\Statement\CaseBranching.pas',
  FirstLoop in 'Units\Statement\FirstLoop.pas',
  LastLoop in 'Units\Statement\LastLoop.pas',
  ArrayList in 'Units\DataStructures\ArrayList.pas',
  Stack in 'Units\DataStructures\Stack.pas',
  StatementSearch in 'Units\Support\StatementSearch.pas',
  MinMaxInt in 'Units\Support\MinMaxInt.pas',
  GetAction in 'Units\Forms\GetAction.pas' {WriteAction},
  Loop in 'Units\Statement\Loop.pas',
  Get�ase�onditions in 'Units\Forms\Get�ase�onditions.pas' {Write�ase�onditions},
  AdditionalTypes in 'Units\Support\AdditionalTypes.pas',
  Constants in 'Units\Support\Constants.pas',
  CaseBlockSorting in 'Units\Support\CaseBlockSorting.pas',
  SwitchStatements in 'Units\Support\SwitchStatements.pas',
  DetermineDimensions in 'Units\Shapes\DetermineDimensions.pas',
  DrawShapes in 'Units\Shapes\DrawShapes.pas',
  Commands in 'Units\�ommand\Commands.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TNassiShneiderman, NassiShneiderman);
  Application.CreateForm(TWriteAction, WriteAction);
  Application.CreateForm(TWrite�ase�onditions, Write�ase�onditions);
  Application.Run;
end.