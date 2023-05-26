unit uStatementConverter;

interface
uses uBase, uCaseBranching, uFirstLoop, uIfBranching, uLastLoop, uProcessStatement;

function ConvertToStatementType(const AIndex: Integer): TStatementClass;
function ConvertToStatementIndex(const ABlockType: TStatementClass): Integer;

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

  function ConvertToStatementIndex(const ABlockType: TStatementClass): Integer;
  begin
    if ABlockType = TProcessStatement then
      Result := 0
    else if ABlockType = TIfBranching then
      Result := 1
    else if ABlockType = TCaseBranching then
      Result := 2
    else if ABlockType = TFirstLoop then
      Result := 3
    else if ABlockType = TLastLoop then
      Result := 4
    else
      Result := -1;
  end;
end.
