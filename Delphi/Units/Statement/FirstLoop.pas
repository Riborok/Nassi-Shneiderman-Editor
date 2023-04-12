unit FirstLoop;

interface
uses Base, Vcl.graphics, Vcl.ExtCtrls;
type

  TFirstLoop = class(TOperator)
  private const
      FAmountOfPixelCorrection = 10;
  private
      FXCorrection: Integer;
      FBlock: TBlock;
  public
    destructor Destroy; override;
    constructor Create(AYStart: Integer; const AAction: string;
                const ABaseBlock: TBlock; const AImage: TImage); virtual;
  end;

implementation

  destructor TFirstLoop.Destroy;
  begin

    FBlock.Destroy;

    inherited;
  end;

  constructor TFirstLoop.Create(AYStart: Integer; const AAction:
                         string; const ABaseBlock: TBlock; const AImage: TImage);
  begin
    inherited Create(AYStart, AAction, ABaseBlock, AImage);

    FXCorrection:= ABaseBlock.XStart + FAmountOfPixelCorrection;

    FBlock := TBlock.Create(FXCorrection, ABaseBlock.XLast, Self);
  end;

end.
