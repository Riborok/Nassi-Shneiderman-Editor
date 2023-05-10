unit uCommands;

interface
uses uAdditionalTypes, uBase, uStack, uCaseBranching;
type

  ICommand = interface
    procedure Execute;
    procedure Undo;
  end;

  { TCommnadChangeContent }
  TCommnadChangeContent = class(TInterfacedObject, ICommand)
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

  { TCommandAddStatement }
  TCommandAddStatement = class(TInterfacedObject, ICommand)
  private
    FNewStatement: TStatement;
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
  TCommandDelStatement = class(TInterfacedObject, ICommand)
  private
    FStatement: TStatement;
    FIndex : Integer;
  public
    constructor Create(const AStatement: TStatement);
    procedure Execute;
    procedure Undo;
  End;

  { TCommandAddBlock }
  TCommandAddBlock = class(TInterfacedObject, ICommand)
  private
    FInsertedBlock, FBaseBlock: TBlock;
    FIndex: Integer;
  public
    constructor Create(const ABaseBlock: TBlock; const AIndex : Integer;
                       const AInsertedBlock: TBlock);
    procedure Execute;
    procedure Undo;
    destructor Destroy; override;
  End;

  { TCommandCaseSort }
  TCommandCaseSort = class(TInterfacedObject, ICommand)
  private
    FCaseBranching : TCaseBranching;
    FSortNumber: Integer;
    FPrevConds: TStringArr;
    FPrevBlocks: TBlockArr;
  public
    constructor Create(const ACaseBranching: TCaseBranching; const ASortNumber : Integer);
    procedure Execute;
    procedure Undo;
  End;

  { TCommandTransferAnotherBlock }
  TCommandTransferAnotherBlock = class(TInterfacedObject, ICommand)
    private
      FCommandAddStatement : TCommandAddStatement;
      FCommandDelStatement : TCommandDelStatement;
      FOldBaseBlock : TBlock;
    public
      constructor Create(const AHoveredStatement : TStatement; const isAfter: Boolean;
                         const AStatement: TStatement);
    procedure Execute;
    procedure Undo;
  end;

implementation

  { TChangeContent }
  constructor TCommnadChangeContent.Create(const AStatement: TStatement; const AAct: String;
                       const AConds: TStringArr);
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
  destructor TCommandAddStatement.Destroy;
  begin
    FNewStatement.Destroy;
    inherited;
  end;

  constructor TCommandAddStatement.Create(const ABaseBlock: TBlock; const AIndex : Integer;
                       const ANewStatement: TStatement);
  begin
    FNewStatement:= ANewStatement;
    FIndex:= AIndex;
    FBaseBlock:= ABaseBlock;
  end;

  procedure TCommandAddStatement.Execute;
  begin
    FBaseBlock.InsertWithResizing(FIndex, FNewStatement);
  end;

  procedure TCommandAddStatement.Undo;
  var
    WasDefaultStatementRemoved: Boolean;
  begin
    WasDefaultStatementRemoved:= FIndex >= FBaseBlock.Statements.Count;
    Dec(FIndex, Ord(WasDefaultStatementRemoved));
    FBaseBlock.ExtractStatementAt(FIndex);
    FBaseBlock.Install(FIndex);
    Inc(FIndex, Ord(WasDefaultStatementRemoved));
  end;

  { TCommandDel }
  constructor TCommandDelStatement.Create(const AStatement: TStatement);
  begin
    FStatement:= AStatement;
  end;

  procedure TCommandDelStatement.Execute;
  begin
    FIndex:= FStatement.BaseBlock.Extract(FStatement);
    FStatement.BaseBlock.Install(FIndex);
  end;

  procedure TCommandDelStatement.Undo;
  begin
    FStatement.BaseBlock.InsertWithResizing(FIndex, FStatement);
  end;

  { TCommandAddBlock }
  destructor TCommandAddBlock.Destroy;
  begin
    FInsertedBlock.Destroy;
    inherited;
  end;

  constructor TCommandAddBlock.Create(const ABaseBlock: TBlock; const AIndex : Integer;
                     const AInsertedBlock: TBlock);
  begin
    FBaseBlock:= ABaseBlock;
    FIndex:= AIndex;
    FInsertedBlock:= AInsertedBlock;
  end;

  procedure TCommandAddBlock.Execute;
  begin
    FBaseBlock.InsertBlock(FIndex, FInsertedBlock);
  end;

  procedure TCommandAddBlock.Undo;
  var
    I: Integer;
    WasDefaultStatementRemoved: Boolean;
  begin
    WasDefaultStatementRemoved:= FIndex >= FBaseBlock.Statements.Count;
    Dec(FIndex, Ord(WasDefaultStatementRemoved));
    for I := 0 to FInsertedBlock.Statements.Count - 1 do
      FBaseBlock.ExtractStatementAt(FIndex + I);
    FBaseBlock.Install(FIndex);
    Inc(FIndex, Ord(WasDefaultStatementRemoved));
  end;

  { TCommandCaseSort }

  constructor TCommandCaseSort.Create(const ACaseBranching: TCaseBranching; const ASortNumber : Integer);
  begin
    FCaseBranching:= ACaseBranching;
    FSortNumber:= ASortNumber;
  end;

  procedure TCommandCaseSort.Execute;
  begin
    FPrevConds:= Copy(FCaseBranching.Conds);
    FPrevBlocks:= Copy(FCaseBranching.Blocks);

    FCaseBranching.SortConditions(FSortNumber);
  end;

  procedure TCommandCaseSort.Undo;
  begin
    FCaseBranching.RestoreŅonditions(FPrevConds, FPrevBlocks);
  end;

  { TCommandTransferAnotherBlock }
  constructor TCommandTransferAnotherBlock.Create(const AHoveredStatement : TStatement;
                  const isAfter: Boolean; const AStatement: TStatement);
  var
    NewIndex, OldIndex: Integer;
  begin
    NewIndex:= AHoveredStatement.BaseBlock.
                                   FindStatementIndex(AHoveredStatement.YStart);
    FOldBaseBlock:= AStatement.BaseBlock;
    OldIndex := FOldBaseBlock.FindStatementIndex(AStatement.YStart);

    if AHoveredStatement.BaseBlock = FOldBaseBlock then
      case isAfter of
        True:
          Inc(NewIndex, Ord(OldIndex - 1 >= NewIndex));
        False:
          Dec(NewIndex, Ord(OldIndex + 1 <= NewIndex));
      end
    else
      Inc(NewIndex, Ord(isAfter));

    FCommandAddStatement:= TCommandAddStatement.Create(AHoveredStatement.BaseBlock,
                                                       NewIndex, AStatement);
    FCommandDelStatement := TCommandDelStatement.Create(AStatement);
  end;

  procedure TCommandTransferAnotherBlock.Execute;
  begin
    FCommandDelStatement.Execute;
    if FCommandAddStatement.FNewStatement is TOperator then
    begin
      var CurrOperator: TOperator := TOperator(FCommandAddStatement.FNewStatement);
      CurrOperator.MoveRightChildrens(FCommandAddStatement.FBaseBlock.XStart -
                                      FOldBaseBlock.XStart);
      CurrOperator.SetXLastForChildrens(FCommandAddStatement.FBaseBlock.XLast);
    end;
    FCommandAddStatement.Execute;
  end;

  procedure TCommandTransferAnotherBlock.Undo;
  begin
    FCommandAddStatement.Undo;
    if FCommandAddStatement.FNewStatement is TOperator then
    begin
      var CurrOperator: TOperator := TOperator(FCommandAddStatement.FNewStatement);
      CurrOperator.MoveRightChildrens(FOldBaseBlock.XStart -
                                      FCommandAddStatement.FBaseBlock.XStart);
      CurrOperator.SetXLastForChildrens(FOldBaseBlock.XLast);
    end;
    FCommandDelStatement.FStatement.BaseBlock := FOldBaseBlock;
    FCommandDelStatement.Undo;
  end;

end.
