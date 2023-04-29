unit Commands;

interface
uses AdditionalTypes, Base, Stack, CaseBranching;
type

  TCommand = interface
    procedure Execute;
    procedure Undo;
  end;

  { TCommnadChangeContent }
  TCommnadChangeContent = class(TInterfacedObject, TCommand)
  private
    FAction: string;
    FConds: TStringArr;
    FStatement: TStatement;
  public
    constructor Create(const AStatement: TStatement; const AAct: String;
                       const AConds: TStringArr);
    procedure Execute;
    procedure Undo;
  End;

  { TCommandCreate }
  TCommandAdd = class(TInterfacedObject, TCommand)
  private
    FNewStatement: TStatement;
    FBlocks: TBlockArr;
    FBaseBlock: TBlock;
    FIndex : Integer;
  public
    constructor Create(const ABaseBlock: TBlock; const AIndex : Integer;
                       const ANewStatement: TStatement);
    procedure Execute;
    procedure Undo;
    destructor Destroy; override;
  End;

  { TCommandDel }
  TCommandDel = class(TInterfacedObject, TCommand)
  private
    FStatement: TStatement;
    FIndex : Integer;
    FBlocks: TBlockArr;
  public
    constructor Create(const AStatement: TStatement);
    procedure Execute;
    procedure Undo;
  End;

implementation

  { TChangeContent }
  constructor TCommnadChangeContent.Create(const AStatement: TStatement; const AAct: String;
                       const AConds: TStringArr);
  var
    CaseBranching: TCaseBranching;
  begin
    FAction:= AAct;
    FConds:= AConds;
    FStatement:= AStatement;
  end;

  procedure TCommnadChangeContent.Execute;
  var
    PrevAction: string;
  begin
    PrevAction:= FStatement.Action;
    if FConds = nil then
      FStatement.ChangeAction(FAction)
    else
    begin
      var CaseBranching: TCaseBranching:= TCaseBranching(FStatement);
      var FPrevConds: TStringArr := CaseBranching.Conds;
      CaseBranching.ChangeActionWithConds(FAction, FConds);
      FConds:= FPrevConds;
    end;
    FAction:= PrevAction;
  end;

  procedure TCommnadChangeContent.Undo;
  begin
    Execute;
  end;

  { TCommandAdd }
  destructor TCommandAdd.Destroy;
  begin
    FNewStatement.Destroy;
    inherited;
  end;

  constructor TCommandAdd.Create(const ABaseBlock: TBlock; const AIndex : Integer;
                       const ANewStatement: TStatement);
  begin
    FNewStatement:= ANewStatement;
    FIndex:= AIndex;
    FBaseBlock:= ABaseBlock;
    if FNewStatement is TOperator then
      FBlocks := TOperator(FNewStatement).Blocks
    else
      FBlocks := nil;
  end;

  procedure TCommandAdd.Execute;
  begin
    if FBlocks <> nil then
      FBlocks[High(FBlocks)].ChangeXLastBlock(FBaseBlock.XLast);
    FBaseBlock.AddStatement(FIndex, FNewStatement);
  end;

  procedure TCommandAdd.Undo;
  begin
    FIndex:= FBaseBlock.ExtractWithResizing(FNewStatement);
  end;

  { TCommandDel }
  constructor TCommandDel.Create(const AStatement: TStatement);

  begin
    FStatement:= AStatement;
    if FStatement is TOperator then
      FBlocks := TOperator(FStatement).Blocks
    else
      FBlocks := nil;
  end;

  procedure TCommandDel.Execute;
  begin
    FIndex:= FStatement.BaseBlock.ExtractWithResizing(FStatement);
  end;

  procedure TCommandDel.Undo;
  begin
    if FBlocks <> nil then
      FBlocks[High(FBlocks)].ChangeXLastBlock(FStatement.BaseBlock.XLast);
    FStatement.BaseBlock.AddStatement(FIndex, FStatement);
  end;

end.
