unit LastLoop;

interface
uses FirstLoop, Base, vcl.graphics, Vcl.ExtCtrls, DrawShapes;
type

  TLastLoop = class(TFirstLoop)
  private
    function GetBlockYBottom: Integer;
  protected
    procedure InitializeBlock; override;
    function GetOptimalYLast: Integer; override;
    function GetBlockYStart: Integer; override;
  public
    procedure Draw; override;
    function GetYBottom: Integer; override;
    function IsPre�Operator: Boolean; override;
  end;

implementation

  function TLastLoop.IsPre�Operator: Boolean;
  begin
    Result:= False;
  end;

  procedure TLastLoop.InitializeBlock;
  var
    NewStatement: TStatement;
  begin
    NewStatement:= DefaultBlock.CreateUncertainty(FYStart, FBlock[0], FImage);
    FBlock[0].Statements.Add(NewStatement);
    NewStatement.SetOptimalHeight;
  end;

  procedure TLastLoop.Draw;
  begin
    DrawRectangle(BaseBlock.XStart, BaseBlock.XLast, GetBlockYBottom, FYLast, FImage);

    DrawRectangle(BaseBlock.XStart, GetXLastStrip, FBlock[0].Statements[0].YStart,
                                                              GetBlockYBottom, FImage);

    Erase(BaseBlock.XStart +  1, GetXLastStrip, GetBlockYBottom, GetBlockYBottom, FImage.Canvas);

    DrawText(FImage.Canvas, BaseBlock.XStart + ((BaseBlock.XLast - BaseBlock.XStart) div 2)
      - (GetTextWidth(FImage.Canvas, Action) div 2), GetBlockYBottom + YIndentText, Action);

    FBlock[0].DrawBlock;
  end;

  function TLastLoop.GetBlockYStart: Integer;
  begin
    Result:= FYStart;
  end;

  function TLastLoop.GetOptimalYLast: Integer;
  begin
    Result := GetBlockYBottom + GetTextHeight(FImage.Canvas, FAction) + 2 * XMinIndentText;
  end;

  function TLastLoop.GetYBottom: Integer;
  begin
    Result:= FYLast;
  end;

  function TLastLoop.GetBlockYBottom: Integer;
  begin
    Result:= FBlock[0].Statements.GetLast.GetYBottom;
  end;

end.