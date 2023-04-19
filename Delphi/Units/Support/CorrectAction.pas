unit CorrectAction;

interface
  function GetActionForStatement(const Astring: String): String;
  function GetActionForOutput(const Astring: String): String;
implementation

  function GetActionForStatement(const Astring: String): String;
  begin
    if Astring <> '' then
      Result := Astring
    else
      Result := ' ';
  end;

  function GetActionForOutput(const Astring: String): String;
  begin
    if Astring = ' ' then
      Result := ''
    else
      Result := Astring;
  end;

end.
