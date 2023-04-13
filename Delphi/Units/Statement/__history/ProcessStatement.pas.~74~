unit ProcessStatement;

interface
uses Base, vcl.graphics, DrawShapes, Vcl.ExtCtrls;
type

  TProcessStatement = class(TStatement)
  protected
    function GetOptimalXLast: Integer; override;
    procedure SetInitiaXLast; override;
    function GetOptimalYLast: Integer; override;
  public
    constructor Create(const AYStart: Integer; const AAction: String;
                       const ABaseBlock: TBlock; const AImage: TImage);
    procedure Draw; override;
  end;

implementation

  constructor TProcessStatement.Create(const AYStart: Integer; const AAction: String;
                                       const ABaseBlock: TBlock; const AImage: TImage);
  begin
    inherited Create(AYStart, AAction, ABaseBlock, AImage);
  end;

  function TProcessStatement.GetOptimalXLast: Integer;
  begin
    result:= GetTextWidth(FImage.Canvas, FAction) + 2 * XMinIndentText;
  end;

  procedure TProcessStatement.SetInitiaXLast;
  begin
    BaseBlock.SetOptimalXLastBlock;
  end;

  procedure TProcessStatement.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, FImage);

    DrawText(FImage.Canvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) div 2)
      - (GetTextWidth(FImage.Canvas, Action) div 2), FYStart + YIndentText, Action);
  end;

  function TProcessStatement.GetOptimalYLast: Integer;
  begin
    Result := FYStart + GetTextHeight(FImage.Canvas, FAction) + 2 * YIndentText;
  end;

end.
