unit CaseBranching;

interface
uses Base, ConditionalOperator, ArrayList, vcl.graphics, Vcl.ExtCtrls, Types, CorrectAction,
     DrawShapes, DetermineDimensions;
type

  TCaseBranching = class(TConditionalOperator)
  private
    FCond: TStringArr;
  protected
    procedure CreateBlock; override;
    procedure InitializeBlock; override;
    function GetCondition(const Index: Integer): String; override;
  public
    constructor Create(const AAction : String;
        const ACond: TStringArr; const ABaseBlock: TBlock; const AImage: TImage);
    procedure Draw; override;
    function IsPreņOperator: Boolean; override;
  end;

implementation

  constructor TCaseBranching.Create(const AAction : String;
        const ACond: TStringArr; const ABaseBlock: TBlock; const AImage: TImage);
  var
    I: Integer;
  begin
    inherited Create(AAction, ABaseBlock, AImage);
    if Length(ACond) > 1 then
      FCond:= ACond;
  end;

  procedure TCaseBranching.CreateBlock;
  var
    I, BlockSpacing: Integer;
  begin
    SetLength(FBlocks, Length(FCond));

    BlockSpacing:= (BaseBlock.XLast - BaseBlock.XStart) div Length(FBlocks);

    FBlocks[0]:= TBlock.Create(FBaseBlock.XStart,
                       FBaseBlock.XStart + BlockSpacing, Self);

    for I := 1 to High(FBlocks) - 1 do
    begin
      FBlocks[I]:= TBlock.Create(FBlocks[I-1].XLast,
                         FBlocks[I-1].XLast + BlockSpacing, Self);
    end;

    FBlocks[High(FBlocks)]:= TBlock.Create(FBlocks[High(FBlocks) - 1].XLast, FBaseBlock.XLast, Self);
  end;

  procedure TCaseBranching.InitializeBlock;
  var
    NewStatement: TStatement;
    I: Integer;
  begin
    for I := 0 to High(FBlocks) - 1 do
    begin
      NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[I], FImage);
      FBlocks[I].AddLast(NewStatement, False);
    end;

    NewStatement:= DefaultBlock.CreateUncertainty(FBlocks[High(FBlocks)], FImage);
    FBlocks[High(FBlocks)].AddLast(NewStatement, True);
  end;

  function TCaseBranching.GetCondition(const Index: Integer): String;
  begin
    if (Index >= 0) and (Index <= High(FCond)) then
      Result := FCond[Index]
    else
      Result := '';
  end;

  function TCaseBranching.IsPreņOperator: Boolean;
  begin
    Result:= True;
  end;

  procedure TCaseBranching.Draw;
  var
    I: Integer;
    ActionWidth, ActionHeight: Integer;
  begin

    // Calculate the dimensions of the action
    ActionWidth := GetTextWidth(FImage.Canvas, FAction);
    ActionHeight := GetTextHeight(FImage.Canvas, FAction);

    // Drawing the main block
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, FImage);

    for I := 0 to High(FBlocks) do
      FBlocks[I].DrawBlock;
  end;

end.
