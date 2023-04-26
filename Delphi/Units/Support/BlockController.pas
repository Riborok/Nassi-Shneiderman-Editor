unit BlockController;

interface
uses Base, GetAction, Get�ase�onditions, AdditionalTypes, System.Classes, CaseBranching,
     FirstLoop, IfBranching, LastLoop, ProcessStatement, Vcl.Controls;

function ConvertToBlockType(const AIndex: Integer): TStatementClass;

function CreateStatement(const AStatementClass: TStatementClass;
         const ABaseBlock: TBlock; const AOwner: TComponent): TStatement;
procedure TryChangeContent(const AStatement: TStatement; const AOwner: TComponent);

implementation

  function TryGetCond(var AInitialStr: TStringArr; const AOwner: TComponent): Boolean;
  var
    Write�ase�onditions: TWrite�ase�onditions;
  begin
    Write�ase�onditions := TWrite�ase�onditions.Create(AOwner, AInitialStr);
    Write�ase�onditions.ShowModal;

    if Write�ase�onditions.ModalResult = mrOk then
    begin
      Result:= True;
      AInitialStr:= Write�ase�onditions.Get�ase�onditions;
    end
    else
      Result:= False;

    Write�ase�onditions.Destroy;
  end;

  function TryGetAction(var AAction: String; const AOwner: TComponent): Boolean;
  var
    WriteActionForm: TWriteAction;
  begin
    WriteActionForm := TWriteAction.Create(AOwner, AAction);
    WriteActionForm.ShowModal;

    if WriteActionForm.ModalResult = mrOk then
    begin
      Result:= True;
      AAction:= WriteActionForm.GetAction;
    end
    else
      Result:= False;

    WriteActionForm.Destroy;
  end;

  function ConvertToBlockType(const AIndex: Integer): TStatementClass;
  begin
    case AIndex of
      0 : Result:= TProcessStatement;
      1 : Result:= TIfBranching;
      2 : Result:= TCaseBranching;
      3 : Result:= TFirstLoop;
      4 : Result:= TLastLoop;
    end;
  end;

  function CreateStatement(const AStatementClass: TStatementClass;
                          const ABaseBlock: TBlock; const AOwner: TComponent): TStatement;
  var
    Action: String;
    Cond: TStringArr;
  begin
    Result:= nil;
    Action := '';

    if TryGetAction(Action, AOwner) then
    begin

      if AStatementClass = TCaseBranching then
      begin
        Cond:= nil;
        if TryGetCond(Cond, AOwner) then
          Result:= TCaseBranching.Create(Action, Cond, ABaseBlock);
      end
      else
        Result:= AStatementClass.Create(Action, ABaseBlock);
    end;
  end;

  procedure TryChangeContent(const AStatement: TStatement; const AOwner: TComponent);
  var
    Action: String;
    Cond: TStringArr;
    CaseBranching: TCaseBranching;
  begin
    Action := AStatement.Action;

    if TryGetAction(Action, AOwner) then
    begin
      if AStatement is TCaseBranching then
      begin
        CaseBranching:= TCaseBranching(AStatement);
        Cond:= CaseBranching.Conds;
        if TryGetCond(Cond, AOwner) then
          CaseBranching.ChangeActionWithConds(Action, Cond);
      end
      else
        AStatement.ChangeAction(Action);
    end;
  end;

end.
