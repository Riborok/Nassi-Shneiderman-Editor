unit FirstLoop;

interface
uses Base, Vcl.graphics, Vcl.ExtCtrls, DrawShapes;
type

  TFirstLoop = class(TOperator)
  protected const
    FBlockCount = 1;
  protected
    FBlock: TBlockArr;
    function GetAmountOfPixelCorrection: Integer;

    procedure CreateBlock(const ABaseBlock: TBlock); override;
    procedure InitializeBlock; override;
    function GetOptimalXLast: Integer; override;
    procedure SetInitiaXLast; override;
    function GetOptimalYLast: Integer; override;
    function GetOptimalWidthForBlock(const ABlock: TBlock): Integer; override;
  public
    destructor Destroy; override;
    constructor Create(AYStart: Integer; const AAction: string;
                const ABaseBlock: TBlock; const AImage: TImage); virtual;
    function GetBlocks: TBlockArr; override;
    function GetBlockCount: Integer; override;
    procedure Draw; override;
    function IsPre�Operator: Boolean; override;

    function GetXLastStrip: Integer;
  end;

implementation

  function TFirstLoop.IsPre�Operator: Boolean;
  begin
    Result:= True;
  end;

  function TFirstLoop.GetAmountOfPixelCorrection: Integer;
  begin
    Result:= 2 * FImage.Canvas.Font.Size + 5;
  end;

  function TFirstLoop.GetXLastStrip: Integer;
  begin
    Result:= FBaseBlock.XStart + GetAmountOfPixelCorrection;
  end;

  function TFirstLoop.GetBlocks: TBlockArr;
  begin
    Result:= FBlock;
  end;

  function TFirstLoop.GetBlockCount: Integer;
  begin
    Result:= FBlockCount;
  end;

  destructor TFirstLoop.Destroy;
  begin

    FBlock[0].Destroy;

    inherited;
  end;

  constructor TFirstLoop.Create(AYStart: Integer; const AAction:
                         string; const ABaseBlock: TBlock; const AImage: TImage);
  begin
    inherited Create(AYStart, AAction, ABaseBlock, AImage);
  end;

  procedure TFirstLoop.CreateBlock(const ABaseBlock: TBlock);
  begin
    SetLength(FBlock, FBlockCount);
    FBlock[0] := TBlock.Create(GetXLastStrip, ABaseBlock.XLast, Self);
  end;

  procedure TFirstLoop.InitializeBlock;
  var
    NewStatement: TStatement;
  begin
    NewStatement:= DefaultBlock.CreateUncertainty(FYLast, FBlock[0], FImage);
    FBlock[0].Statements.Add(NewStatement);
    NewStatement.SetOptimalHeight;
  end;

  function TFirstLoop.GetOptimalXLast: Integer;
  begin
    Result := GetTextWidth(FImage.Canvas, FAction) + 2 * XMinIndentText;
  end;

  procedure TFirstLoop.SetInitiaXLast;
  begin
    FBlock[0].SetOptimalXLastBlock;
  end;

  function TFirstLoop.GetOptimalYLast: Integer;
  begin
    Result := FYStart + GetTextHeight(FImage.Canvas, FAction) + 2 * YIndentText;
  end;

  function TFirstLoop.GetOptimalWidthForBlock(const ABlock: TBlock): Integer;
  begin
    Result:= -1;

    if ABlock = FBlock[0] then
      Result:= BaseBlock.XLast - GetXLastStrip;
  end;

  procedure TFirstLoop.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, FImage);

    DrawRectangle(BaseBlock.XStart, GetXLastStrip, FYLast, GetYBottom, FImage);

    Erase(BaseBlock.XStart +  1, GetXLastStrip, FYLast, FYLast, FImage.Canvas);

    DrawText(FImage.Canvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) div 2)
      - (GetTextWidth(FImage.Canvas, Action) div 2), FYStart + YIndentText, Action);

    FBlock[0].DrawBlock;
  end;

end.