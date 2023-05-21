unit uStatementConverter;

interface
uses
  uBase, uCaseBranching, uFirstLoop, uIfBranching, uLastLoop, uProcessStatement;

function ConvertToStatementType(const AIndex: Integer): TStatementClass;

implementation

  function ConvertToStatementType(const AIndex: Integer): TStatementClass;
  begin
    case AIndex of
      0 : Result:= TProcessStatement;
      1 : Result:= TIfBranching;
      2 : Result:= TCaseBranching;
      3 : Result:= TFirstLoop;
      4 : Result:= TLastLoop;
    end;
  end;

end.
