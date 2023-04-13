unit CaseBranching;

interface
uses Base, System.Generics.Collections, vcl.graphics, Vcl.ExtCtrls;
type

  TCaseBranching = class(TOperator)
  private
    FBlocks : TList<TBlock>;
  public
    destructor Destroy; override;
    constructor Create(AYStart, AmountCase: Integer;
                const AAction: string; const ABaseBlock: TBlock; const AImage: TImage);
  end;

implementation

  destructor TCaseBranching.Destroy;
  var
    I : Integer;
  begin

    for I := 0 to FBlocks.Count - 1 do
      FBlocks[i].Destroy;

    FBlocks.Free;

    inherited;
  end;

  constructor TCaseBranching.Create(AYStart, AmountCase: Integer;
              const AAction: string; const ABaseBlock: TBlock; const AImage: TImage);
  var
    I, BlockSize, BlockEnd, XStart: Integer;
  begin
    inherited Create(AYStart, AAction, ABaseBlock, AImage);

    FBlocks := TList<TBlock>.Create();

    BlockSize := (ABaseBlock.XLast - ABaseBlock.XStart) div AmountCase;

    XStart:= ABaseBlock.XStart;

    for I := 0 to AmountCase - 2 do
    begin
      BlockEnd := XStart + BlockSize;

      FBlocks.Add(TBlock.Create(XStart, BlockEnd, Self));
      XStart := BlockEnd;
    end;
    FBlocks.Add(TBlock.Create(XStart, ABaseBlock.XLast, Self));
  end;

end.