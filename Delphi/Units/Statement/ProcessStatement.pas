unit ProcessStatement;

interface
uses Base, vcl.graphics, DrawShapes;
type

  TProcessStatement = class(TStatement)
  protected
    function GetOptimalWidth: Integer; override;
    procedure SetInitiaWidth; override;
    function GetOptimalHeight: Integer; override;
  public
    constructor Create(const AYStart: Integer; const AAction: String;
                       const ABaseBlock: TBlock; const ACanvas: TCanvas);
    procedure Draw; override;
  end;

implementation

  constructor TProcessStatement.Create(const AYStart: Integer; const AAction: String;
                                       const ABaseBlock: TBlock; const ACanvas: TCanvas);
  begin
    inherited Create(AYStart, AAction, ABaseBlock, ACanvas);
  end;

  function TProcessStatement.GetOptimalWidth: Integer;
  begin
    result:= GetTextWidth(FImage, FAction) + 2 * XMinIndentText;
  end;

  procedure TProcessStatement.SetInitiaWidth;
  begin
    BaseBlock.SetOptimalXLastBlock;
  end;

  procedure TProcessStatement.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, FYStart, FYLast, FImage);

    DrawText(FImage, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) div 2)
      - (GetTextWidth(FImage, Action) div 2), FYStart + YIndentText, Action);
  end;

  function TProcessStatement.GetOptimalHeight: Integer;
  begin
    Result := FYStart + GetTextHeight(FImage, FAction) + 2 * YIndentText;
  end;

end.
