program Project;



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
  DetermineDimensions in 'Units\Image\DetermineDimensions.pas',
  DrawShapes in 'Units\Image\DrawShapes.pas',
  AdjustBorders in 'Units\Image\AdjustBorders.pas',
  Loop in 'Units\Statement\Loop.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TNassiShneiderman, NassiShneiderman);
  Application.CreateForm(TWriteAction, WriteAction);
  Application.Run;
end.
